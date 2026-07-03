package dal

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"math"
	"strconv"
	"strings"
	"time"

	"ovra/app/system/internal/dal/model"
	"ovra/toolkit/errx"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

// FbUserWalletDal 用户钱包写操作（加减款、流水），对齐 Java FbUserWalletsServiceImpl
type FbUserWalletDal struct {
	db *gorm.DB
}

func NewFbUserWalletDal(db *gorm.DB) *FbUserWalletDal {
	return &FbUserWalletDal{db: db}
}

// 管理端加款可选 flowType
var adminAddFlowTypes = map[string]struct{}{
	"ADD_AMOUNT":   {},
	"ADD_BONUS":    {},
	"ADD_DIVIDEND": {},
	"ADD_TRANSFER": {},
}

// 管理端减款可选 flowType
var adminSubtractFlowTypes = map[string]struct{}{
	"SUBTRACT_AMOUNT": {},
	"ADD_TRANSFER":    {},
}

// ParseWalletID 解析钱包主键 id
func ParseWalletID(id string) (int64, error) {
	if id == "" {
		return 0, errx.BizErr("钱包ID不能为空")
	}
	walletID, err := strconv.ParseInt(id, 10, 64)
	if err != nil || walletID <= 0 {
		return 0, errx.BizErr("钱包ID无效")
	}
	return walletID, nil
}

// NormalizeAddOrSubtractFlowType 校验并回填 flowType（加款默认 ADD_AMOUNT，减款默认 SUBTRACT_AMOUNT）
func NormalizeAddOrSubtractFlowType(isAdd bool, flowType string) (string, error) {
	if flowType == "" {
		if isAdd {
			return "ADD_AMOUNT", nil
		}
		return "SUBTRACT_AMOUNT", nil
	}
	if isAdd {
		if _, ok := adminAddFlowTypes[flowType]; !ok {
			return "", errx.BizErr("加款流水类型无效")
		}
		return flowType, nil
	}
	if _, ok := adminSubtractFlowTypes[flowType]; !ok {
		return "", errx.BizErr("减款流水类型无效")
	}
	return flowType, nil
}

// AddBalanceByUserID 按用户主钱包加款并写流水（对齐 Java addBalance(userId, businessNo, ...)）
func (d *FbUserWalletDal) AddBalanceByUserID(ctx context.Context, userID int64, amount float64, businessNo, remark, description, flowType string) error {
	amount = math.Abs(amount)
	if strings.TrimSpace(businessNo) == "" {
		return errx.BizErr("业务单号不能为空")
	}
	return d.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		return addBalanceByUserIDTx(tx, userID, amount, businessNo, remark, description, flowType)
	})
}

func addBalanceByUserIDTx(tx *gorm.DB, userID int64, amount float64, businessNo, remark, description, flowType string) error {
	var cnt int64
	if err := tx.Raw(`SELECT COUNT(*) FROM fb_account_flow_records WHERE business_no = ?`, businessNo).Scan(&cnt).Error; err != nil {
		return errx.GORMErr(err)
	}
	if cnt > 0 {
		return errx.BizErr("资金流水已存在")
	}
	var wallet model.FbUserWallet
	err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).
		Where("user_id = ? AND account_type = ? AND currency = ?", userID, "main", "USD").
		First(&wallet).Error
	if err != nil {
		return errx.GORMErrMsg(err, "用户钱包不存在")
	}
	before := wallet.Balance
	after := before + amount
	now := time.Now()
	if err := tx.Model(&model.FbUserWallet{}).Where("id = ?", wallet.ID).Updates(map[string]any{
		"balance":    after,
		"updated_at": now,
	}).Error; err != nil {
		return errx.GORMErr(err)
	}
	flow := &model.FbAccountFlowRecord{
		UserID:       wallet.UserID,
		AccountType:  wallet.AccountType,
		FlowType:     flowType,
		BeforeAmount: before,
		FlowAmount:   amount,
		AfterAmount:  after,
		BusinessNo:   businessNo,
		Remark:       remark,
		CreatedAt:    now,
		WalletID:     wallet.ID,
		Currency:     wallet.Currency,
		Description:  description,
		Status:       "SUCCESS",
	}
	if err := tx.Create(flow).Error; err != nil {
		return errx.BizErr("资金流水写入失败")
	}
	return nil
}

// AddBalance 按钱包 id 加款并写 fb_account_flow_records（对齐 addBalance(walletId, ...)）
func (d *FbUserWalletDal) AddBalance(ctx context.Context, walletID int64, amount float64, remark, flowType string) error {
	amount = math.Abs(amount)
	return d.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		wallet, err := d.lockWallet(tx, walletID)
		if err != nil {
			return err
		}
		before := wallet.Balance
		after := before + amount
		now := time.Now()
		if err := tx.Model(&model.FbUserWallet{}).Where("id = ?", walletID).Updates(map[string]any{
			"balance":    after,
			"updated_at": now,
		}).Error; err != nil {
			return errx.GORMErr(err)
		}
		flow := &model.FbAccountFlowRecord{
			UserID:       wallet.UserID,
			AccountType:  wallet.AccountType,
			FlowType:     flowType,
			BeforeAmount: before,
			FlowAmount:   amount,
			AfterAmount:  after,
			BusinessNo:   genWalletBusinessNo("ADD_AMOUNT"),
			Remark:       remark,
			CreatedAt:    now,
			WalletID:     wallet.ID,
			Currency:     wallet.Currency,
			Description:  "加款",
			Status:       "SUCCESS",
		}
		if err := tx.Create(flow).Error; err != nil {
			return errx.BizErr("资金流水写入失败")
		}
		return nil
	})
}

// ReduceBalance 按钱包 id 减款并写流水（对齐 reduceBalance(walletId, ...)）
func (d *FbUserWalletDal) ReduceBalance(ctx context.Context, walletID int64, amount float64, remark, flowType string) error {
	amount = math.Abs(amount)
	return d.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		wallet, err := d.lockWallet(tx, walletID)
		if err != nil {
			return err
		}
		before := wallet.Balance
		if before < amount {
			return errx.BizErr("余额不足")
		}
		after := before - amount
		now := time.Now()
		if err := tx.Model(&model.FbUserWallet{}).Where("id = ?", walletID).Updates(map[string]any{
			"balance":    after,
			"updated_at": now,
		}).Error; err != nil {
			return errx.GORMErr(err)
		}
		flow := &model.FbAccountFlowRecord{
			UserID:       wallet.UserID,
			AccountType:  wallet.AccountType,
			FlowType:     flowType,
			BeforeAmount: before,
			FlowAmount:   -amount,
			AfterAmount:  after,
			BusinessNo:   genWalletBusinessNo("SUBTRACT_AMOUNT"),
			Remark:       remark,
			CreatedAt:    now,
			WalletID:     wallet.ID,
			Currency:     wallet.Currency,
			Description:  "减款",
			Status:       "SUCCESS",
		}
		if err := tx.Create(flow).Error; err != nil {
			return errx.BizErr("资金流水写入失败")
		}
		return nil
	})
}

// lockWallet 行锁读取钱包，避免并发加减款覆盖
func (d *FbUserWalletDal) lockWallet(tx *gorm.DB, walletID int64) (*model.FbUserWallet, error) {
	var wallet model.FbUserWallet
	err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).
		Where("id = ?", walletID).
		First(&wallet).Error
	if err != nil {
		return nil, errx.GORMErrMsg(err, "用户钱包不存在")
	}
	return &wallet, nil
}

func genWalletBusinessNo(prefix string) string {
	buf := make([]byte, 4)
	_, _ = rand.Read(buf)
	return fmt.Sprintf("%s_%d%s", prefix, time.Now().UnixMilli(), hex.EncodeToString(buf))
}

// resolveDepositWalletCurrency 充值订单币种 → 入账钱包币种（对齐 Java resolveWalletCurrency）
func resolveDepositWalletCurrency(depositCurrency, accountType string) string {
	cur := strings.ToUpper(strings.TrimSpace(depositCurrency))
	if cur == "" {
		return "USD"
	}
	if accountType == "main" && cur == "USDT" {
		return "USD"
	}
	return cur
}

// resolveDepositCreditAmount 充值金额 → 钱包入账金额（USDT 主账户按 1:1 写入 USD）
func resolveDepositCreditAmount(amount float64, depositCurrency, walletCurrency string) float64 {
	if strings.EqualFold(depositCurrency, walletCurrency) {
		return amount
	}
	if strings.EqualFold(depositCurrency, "USDT") && strings.EqualFold(walletCurrency, "USD") {
		return amount
	}
	return amount
}

// depositCreditTx 充值批准入账：按目标账户+币种定位钱包，加款并写 DEPOSIT 流水
func depositCreditTx(tx *gorm.DB, userID int64, amount float64, businessNo, remark, currency, targetAccount string) error {
	amount = math.Abs(amount)
	if userID <= 0 || amount <= 0 {
		return errx.BizErr("充值入账参数无效")
	}
	if strings.TrimSpace(currency) == "" || strings.TrimSpace(targetAccount) == "" {
		return errx.BizErr("充值入账缺少币种或目标账户")
	}
	if strings.TrimSpace(businessNo) == "" {
		return errx.BizErr("业务单号不能为空")
	}
	var cnt int64
	if err := tx.Raw(`SELECT COUNT(*) FROM fb_account_flow_records WHERE business_no = ?`, businessNo).Scan(&cnt).Error; err != nil {
		return errx.GORMErr(err)
	}
	if cnt > 0 {
		return errx.BizErr("资金流水已存在")
	}
	accountType := mapTargetAccountType(targetAccount)
	walletCurrency := resolveDepositWalletCurrency(currency, accountType)
	creditAmount := resolveDepositCreditAmount(amount, currency, walletCurrency)

	wallet, err := lockWalletByUserAccount(tx, userID, accountType, walletCurrency)
	if err != nil {
		// 钱包不存在时自动补建（对齐 Java ensureWallet）
		wallet, err = createWalletTx(tx, userID, accountType, walletCurrency)
		if err != nil {
			return err
		}
	}
	if wallet.Frozen {
		return errx.BizErr("充值入账失败：钱包已冻结")
	}
	before := wallet.Balance
	after := before + creditAmount
	now := time.Now()
	if err := tx.Model(&model.FbUserWallet{}).Where("id = ?", wallet.ID).Updates(map[string]any{
		"balance":    after,
		"updated_at": now,
	}).Error; err != nil {
		return errx.GORMErr(err)
	}
	flow := &model.FbAccountFlowRecord{
		UserID:       wallet.UserID,
		AccountType:  wallet.AccountType,
		FlowType:     "DEPOSIT",
		BeforeAmount: before,
		FlowAmount:   creditAmount,
		AfterAmount:  after,
		BusinessNo:   businessNo,
		Remark:       remark,
		CreatedAt:    now,
		WalletID:     wallet.ID,
		Currency:     wallet.Currency,
		Description:  remark,
		Status:       "SUCCESS",
	}
	if err := tx.Create(flow).Error; err != nil {
		return errx.BizErr("资金流水写入失败")
	}
	return nil
}

func lockWalletByUserAccount(tx *gorm.DB, userID int64, accountType, currency string) (*model.FbUserWallet, error) {
	var wallet model.FbUserWallet
	err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).
		Where("user_id = ? AND account_type = ? AND currency = ?", userID, accountType, currency).
		First(&wallet).Error
	if err != nil {
		return nil, errx.GORMErrMsg(err, "用户钱包不存在")
	}
	return &wallet, nil
}

func createWalletTx(tx *gorm.DB, userID int64, accountType, currency string) (*model.FbUserWallet, error) {
	now := time.Now()
	wallet := &model.FbUserWallet{
		UserID:       userID,
		AccountType:  accountType,
		Currency:     currency,
		Balance:      0,
		FrozenAmount: 0,
		Frozen:       false,
		CreatedAt:    now,
		UpdatedAt:    now,
	}
	if err := tx.Create(wallet).Error; err != nil {
		return nil, errx.BizErr("创建钱包失败")
	}
	return wallet, nil
}

// DeleteByIds 按主键物理删除钱包（对齐 Java DELETE /fubang/fbuserwallets）
func (d *FbUserWalletDal) DeleteByIds(ctx context.Context, ids []int64) error {
	if len(ids) == 0 {
		return errx.BizErr("请选择要删除的钱包")
	}
	res := d.db.WithContext(ctx).Where("id IN ?", ids).Delete(&model.FbUserWallet{})
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("钱包不存在或已删除")
	}
	return nil
}
