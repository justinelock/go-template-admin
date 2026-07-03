package dal

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"ovra/toolkit/errx"

	"gorm.io/gorm"
)

const (
	contractStatusPosition = 1
	controlTypeWin         = 1
	controlTypeLose        = 2
)

// ContractOrderPageQuery 合约订单列表筛选（对齐 Java getWrapper）
type ContractOrderPageQuery struct {
	Keyword       string
	Status        string
	ControlResult string
	BeginTime     string
	EndTime       string
	PageNum       int64
	PageSize      int64
}

type contractOrderRow struct {
	ID                         int64
	UserID                     int64
	Account                    string
	RealName                   sql.NullString
	CoinType                   string
	Market                     string
	Direction                  int
	TradePair                  string
	PairName                   sql.NullString
	Amount                     float64
	ProfitRatio                float64
	Seconds                    int
	OpeningPrice               float64
	ClosingPrice               sql.NullFloat64
	OpeningTime                time.Time
	ClosingTime                sql.NullTime
	ExpectedProfit             sql.NullFloat64
	ActualProfit               sql.NullFloat64
	WalletBalanceAfterSettle   sql.NullFloat64
	Status                     int
	ControlType                sql.NullInt64
	ControlResult              sql.NullInt64
	Remark                     sql.NullString
	CreateTime                 time.Time
	UpdateTime                 time.Time
	Version                    int
	UserControl                sql.NullInt64
	GlobalControlStateSnapshot sql.NullString
	GlobalControlApplied       sql.NullInt64
}

// ContractOrderVO 列表行（对齐 Java FbContractOrdersVO，含 getRecords 填充字段）
type ContractOrderVO struct {
	ID                         int64
	UserID                     int64
	Username                   string
	Mobile                     string
	RealName                   string
	Account                    string
	CoinType                   string
	Market                     string
	Direction                  int
	TradePair                  string
	PairName                   string
	ProductName                string
	Amount                     float64
	ProfitRatio                float64
	Seconds                    int
	OpeningPrice               float64
	ClosingPrice               float64
	ClosingPriceSet            bool
	OpeningTime                time.Time
	ClosingTime                time.Time
	ClosingTimeSet             bool
	ExpectedProfit             float64
	ExpectedProfitSet          bool
	ActualProfit               float64
	ActualProfitSet            bool
	Balance                    float64
	WalletBalanceAfterSettle   float64
	WalletBalanceAfterSettleSet bool
	Status                     int
	ControlType                int
	ControlTypeSet             bool
	ControlResult              int
	ControlResultSet           bool
	Remark                     string
	CreateTime                 time.Time
	UpdateTime                 time.Time
	Version                    int
	UserControl                int
	UserControlSet             bool
	GlobalControlStateSnapshot string
	GlobalControlApplied       int
	GlobalControlAppliedSet    bool
	HasBoughtFund              int
}

// PageContractOrders 分页查 fb_crypto_contract_orders 并组装 VO
func (d *FbMemberDal) PageContractOrders(ctx context.Context, q ContractOrderPageQuery) (rows []ContractOrderVO, total int64, err error) {
	rawRows, total, err := d.queryContractOrderRows(ctx, q)
	if err != nil {
		return nil, 0, err
	}
	rows, err = enrichContractOrders(ctx, d.db, rawRows)
	if err != nil {
		return nil, 0, err
	}
	return rows, total, nil
}

// queryContractOrderRows 分页查原始订单行（列表与批量控单共用）
func (d *FbMemberDal) queryContractOrderRows(ctx context.Context, q ContractOrderPageQuery) ([]contractOrderRow, int64, error) {
	where, args, err := d.contractOrderWhere(ctx, q)
	if err != nil {
		return nil, 0, err
	}
	w := strings.Join(where, " AND ")
	base := `FROM fb_crypto_contract_orders o WHERE ` + w
	var total int64
	if err = d.db.WithContext(ctx).Raw("SELECT COUNT(*) "+base, args...).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if q.PageSize <= 0 {
		q.PageSize = 10
	}
	if q.PageNum <= 0 {
		q.PageNum = 1
	}
	offset := (q.PageNum - 1) * q.PageSize
	listSQL := `SELECT o.id, o.user_id, o.account, o.real_name, o.coin_type, o.market, o.direction,
		o.trade_pair, o.pair_name, o.amount, o.profit_ratio, o.seconds, o.opening_price, o.closing_price,
		o.opening_time, o.closing_time, o.expected_profit, o.actual_profit, o.wallet_balance_after_settle,
		o.status, o.control_type, o.control_result, o.remark, o.create_time, o.update_time, o.version,
		o.user_control, o.global_control_state_snapshot, o.global_control_applied ` +
		base + ` ORDER BY o.create_time DESC LIMIT ? OFFSET ?`
	listArgs := append(append([]any{}, args...), q.PageSize, offset)
	var rawRows []contractOrderRow
	if err = d.db.WithContext(ctx).Raw(listSQL, listArgs...).Scan(&rawRows).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	return rawRows, total, nil
}

func (d *FbMemberDal) contractOrderWhere(ctx context.Context, q ContractOrderPageQuery) ([]string, []any, error) {
	where := []string{"1=1"}
	var args []any
	if s := strings.TrimSpace(q.Status); s != "" {
		where = append(where, "o.status = ?")
		args = append(args, s)
	}
  if cr := strings.TrimSpace(q.ControlResult); cr != "" {
		switch cr {
		case "1", "2":
			where = append(where, "o.control_result = ?")
			args = append(args, cr)
		case "3":
			// 自然：未强制控单（control_type 为空或 3）
			where = append(where, "(o.control_type IS NULL OR o.control_type = 3)")
		}
	}
	if q.BeginTime != "" && q.EndTime != "" {
		where = append(where, "o.create_time BETWEEN ? AND ?")
		args = append(args, q.BeginTime, q.EndTime)
	}
	if kw := strings.TrimSpace(q.Keyword); kw != "" {
		userIDs, err := d.UserIdsByKeyword(ctx, kw)
		if err != nil {
			return nil, nil, err
		}
		if len(userIDs) == 1 {
			where = append(where, "o.user_id = ?")
			args = append(args, userIDs[0])
		} else if len(userIDs) > 1 {
			where = append(where, fmt.Sprintf("o.user_id IN (%s)", placeholders(len(userIDs))))
			for _, id := range userIDs {
				args = append(args, id)
			}
		}
	}
	return where, args, nil
}

// UpdateContractControl 单行控单（对齐 Java updateControl，仅 control_type 为 NULL 可写）
func (d *FbMemberDal) UpdateContractControl(ctx context.Context, id int64, controlType int) error {
	if id <= 0 {
		return errx.BizErr("订单不存在")
	}
	if controlType != controlTypeWin && controlType != controlTypeLose {
		return errx.BizErr("控单类型无效")
	}
	res := d.db.WithContext(ctx).Exec(`
		UPDATE fb_crypto_contract_orders SET control_type = ?, update_time = ?
		WHERE id = ? AND control_type IS NULL`, controlType, time.Now(), id)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("订单已控单或不存在")
	}
	return nil
}

// UpdateContractDirection 修改交易方向（对齐 Java updateDirection）
func (d *FbMemberDal) UpdateContractDirection(ctx context.Context, id int64, direction int) error {
	if id <= 0 {
		return errx.BizErr("订单不存在")
	}
	if direction != 1 && direction != 2 {
		return errx.BizErr("控单交易方向异常")
	}
	res := d.db.WithContext(ctx).Exec(`
		UPDATE fb_crypto_contract_orders SET direction = ?, update_time = ?
		WHERE id = ?`, direction, time.Now(), id)
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("订单不存在")
	}
	return nil
}

// BatchControlCurrentPageDirectional 本页四态批量控单（对齐 Java updateControlBatchByCurrentPageDirectional）
func (d *FbMemberDal) BatchControlCurrentPageDirectional(ctx context.Context, q ContractOrderPageQuery, controlState string) (int, error) {
	code := strings.ToUpper(strings.TrimSpace(controlState))
	if code == "" || code == "RANDOM" {
		return 0, errx.BizErr("控盘状态不能为空")
	}
	rawRows, _, err := d.queryContractOrderRows(ctx, q)
	if err != nil {
		return 0, err
	}
	count := 0
	now := time.Now()
	for _, row := range rawRows {
		if row.Status != contractStatusPosition || row.ControlType.Valid {
			continue
		}
		ct, ok := resolveContractControlState(code, row.Direction)
		if !ok {
			return count, errx.BizErr("不支持的控盘状态: " + controlState)
		}
		res := d.db.WithContext(ctx).Exec(`
			UPDATE fb_crypto_contract_orders SET control_type = ?, update_time = ?
			WHERE id = ? AND status = ? AND control_type IS NULL`,
			ct, now, row.ID, contractStatusPosition)
		if res.Error != nil {
			return count, errx.GORMErr(res.Error)
		}
		if res.RowsAffected > 0 {
			count++
		}
	}
	return count, nil
}

// resolveContractControlState 对齐 Java ContractGlobalControlState.resolveResult
func resolveContractControlState(controlState string, direction int) (int, bool) {
	isLong := direction == 1
	switch strings.ToUpper(strings.TrimSpace(controlState)) {
	case "LONG_WIN", "SHORT_LOSE":
		if direction != 1 && direction != 2 {
			return 0, false
		}
		if isLong {
			return controlTypeWin, true
		}
		return controlTypeLose, true
	case "LONG_LOSE", "SHORT_WIN":
		if direction != 1 && direction != 2 {
			return 0, false
		}
		if isLong {
			return controlTypeLose, true
		}
		return controlTypeWin, true
	default:
		return 0, false
	}
}

// UserIdsByKeyword 按用户名/手机/姓名/身份证模糊查用户 id（对齐 Java getUserIds）
func (d *FbMemberDal) UserIdsByKeyword(ctx context.Context, keyword string) ([]int64, error) {
	kw := strings.TrimSpace(keyword)
	if kw == "" {
		return nil, nil
	}
	var ids []int64
	like := "%" + kw + "%"
	err := d.db.WithContext(ctx).Raw(`
		SELECT DISTINCT u.id FROM fb_users u
		WHERE (u.flag = 0 OR u.flag IS NULL)
		  AND (u.username LIKE ? OR u.mobile LIKE ? OR u.real_name LIKE ? OR u.id_card LIKE ?)`,
		like, like, like, like).Scan(&ids).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	return ids, nil
}

func enrichContractOrders(ctx context.Context, db *gorm.DB, rawRows []contractOrderRow) ([]ContractOrderVO, error) {
	if len(rawRows) == 0 {
		return []ContractOrderVO{}, nil
	}
	userIDSet := make(map[int64]struct{}, len(rawRows))
	for _, r := range rawRows {
		userIDSet[r.UserID] = struct{}{}
	}
	userIDs := make([]int64, 0, len(userIDSet))
	for id := range userIDSet {
		userIDs = append(userIDs, id)
	}

	userMap, err := mapUsersByIDs(ctx, db, userIDs)
	if err != nil {
		return nil, err
	}
	balanceMap, err := sumUsdBalanceByUserIDs(ctx, db, userIDs)
	if err != nil {
		return nil, err
	}
	hasFundMap, err := batchHasBoughtFund(ctx, db, userIDs)
	if err != nil {
		return nil, err
	}
	productNameByCode, err := fundProductNameByCode(ctx, db)
	if err != nil {
		return nil, err
	}

	rows := make([]ContractOrderVO, 0, len(rawRows))
	for _, r := range rawRows {
		vo := ContractOrderVO{
			ID:           r.ID,
			UserID:       r.UserID,
			Account:      r.Account,
			CoinType:     r.CoinType,
			Market:       r.Market,
			Direction:    r.Direction,
			TradePair:    r.TradePair,
			Amount:       r.Amount,
			ProfitRatio:  r.ProfitRatio,
			Seconds:      r.Seconds,
			OpeningPrice: r.OpeningPrice,
			OpeningTime:  r.OpeningTime,
			Status:       r.Status,
			CreateTime:   r.CreateTime,
			UpdateTime:   r.UpdateTime,
			Version:      r.Version,
		}
		if r.RealName.Valid {
			vo.RealName = r.RealName.String
		}
		if r.PairName.Valid {
			vo.PairName = r.PairName.String
		}
		if r.ClosingPrice.Valid {
			vo.ClosingPrice = r.ClosingPrice.Float64
			vo.ClosingPriceSet = true
		}
		if r.ClosingTime.Valid {
			vo.ClosingTime = r.ClosingTime.Time
			vo.ClosingTimeSet = true
		}
		if r.ExpectedProfit.Valid {
			vo.ExpectedProfit = r.ExpectedProfit.Float64
			vo.ExpectedProfitSet = true
		}
		if r.ActualProfit.Valid {
			vo.ActualProfit = r.ActualProfit.Float64
			vo.ActualProfitSet = true
		}
		if r.WalletBalanceAfterSettle.Valid {
			vo.WalletBalanceAfterSettle = r.WalletBalanceAfterSettle.Float64
			vo.WalletBalanceAfterSettleSet = true
		}
		if r.ControlType.Valid {
			vo.ControlType = int(r.ControlType.Int64)
			vo.ControlTypeSet = true
		}
		if r.ControlResult.Valid {
			vo.ControlResult = int(r.ControlResult.Int64)
			vo.ControlResultSet = true
		}
		if r.Remark.Valid {
			vo.Remark = r.Remark.String
		}
		if r.UserControl.Valid {
			vo.UserControl = int(r.UserControl.Int64)
			vo.UserControlSet = true
		}
		if r.GlobalControlStateSnapshot.Valid {
			vo.GlobalControlStateSnapshot = r.GlobalControlStateSnapshot.String
		}
		if r.GlobalControlApplied.Valid {
			vo.GlobalControlApplied = int(r.GlobalControlApplied.Int64)
			vo.GlobalControlAppliedSet = true
		}

		if u, ok := userMap[r.UserID]; ok {
			vo.Username = u.Username
			vo.Mobile = u.Mobile
			if vo.RealName == "" {
				vo.RealName = u.RealName
			}
		}
		// 已结算且有快照用快照，否则用当前 USD 汇总余额
		if vo.WalletBalanceAfterSettleSet {
			vo.Balance = vo.WalletBalanceAfterSettle
		} else {
			vo.Balance = balanceMap[r.UserID]
		}
		vo.HasBoughtFund = hasFundMap[r.UserID]

		if vo.PairName == "" && vo.CoinType != "" {
			if name := productNameByCode[strings.ToUpper(strings.TrimSpace(vo.CoinType))]; name != "" {
				vo.ProductName = name
			}
		} else if vo.PairName != "" {
			vo.ProductName = vo.PairName
		}
		rows = append(rows, vo)
	}
	return rows, nil
}

type contractUserBrief struct {
	ID       int64
	Username string
	Mobile   string
	RealName string
}

func mapUsersByIDs(ctx context.Context, db *gorm.DB, userIDs []int64) (map[int64]contractUserBrief, error) {
	out := make(map[int64]contractUserBrief)
	if len(userIDs) == 0 {
		return out, nil
	}
	var users []contractUserBrief
	err := db.WithContext(ctx).Raw(fmt.Sprintf(`
		SELECT id, COALESCE(username,'') AS username, COALESCE(mobile,'') AS mobile, COALESCE(real_name,'') AS real_name
		FROM fb_users WHERE id IN (%s)`, placeholders(len(userIDs))), int64SliceToAny(userIDs)...).Scan(&users).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	for _, u := range users {
		out[u.ID] = u
	}
	return out, nil
}

func sumUsdBalanceByUserIDs(ctx context.Context, db *gorm.DB, userIDs []int64) (map[int64]float64, error) {
	out := make(map[int64]float64)
	if len(userIDs) == 0 {
		return out, nil
	}
	type balanceRow struct {
		UserID  int64
		Balance float64
	}
	var rows []balanceRow
	err := db.WithContext(ctx).Raw(fmt.Sprintf(`
		SELECT user_id, SUM(balance) AS balance FROM fb_user_wallets
		WHERE currency = 'USD' AND balance > 0 AND user_id IN (%s)
		GROUP BY user_id`, placeholders(len(userIDs))), int64SliceToAny(userIDs)...).Scan(&rows).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	for _, r := range rows {
		out[r.UserID] = r.Balance
	}
	return out, nil
}

// batchHasBoughtFund 是否持有进行中投信（对齐 Java FundHoldingUserService，直查 DB）
func batchHasBoughtFund(ctx context.Context, db *gorm.DB, userIDs []int64) (map[int64]int, error) {
	out := make(map[int64]int, len(userIDs))
	for _, id := range userIDs {
		out[id] = 0
	}
	if len(userIDs) == 0 {
		return out, nil
	}
	type fundRow struct {
		UserID int64
	}
	var rows []fundRow
	err := db.WithContext(ctx).Raw(fmt.Sprintf(`
		SELECT DISTINCT user_id FROM fb_fund_position
		WHERE state = 'PENDING' AND status = 1 AND user_id IN (%s)`, placeholders(len(userIDs))), int64SliceToAny(userIDs)...).Scan(&rows).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	for _, r := range rows {
		out[r.UserID] = 1
	}
	return out, nil
}

func fundProductNameByCode(ctx context.Context, db *gorm.DB) (map[string]string, error) {
	type productRow struct {
		Code string
		Name string
	}
	var products []productRow
	err := db.WithContext(ctx).Raw(`
		SELECT code, name FROM fb_fund_product WHERE status = 1 AND code IS NOT NULL AND name IS NOT NULL`).Scan(&products).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	out := make(map[string]string, len(products))
	for _, p := range products {
		code := strings.ToUpper(strings.TrimSpace(p.Code))
		if code == "" || strings.TrimSpace(p.Name) == "" {
			continue
		}
		if _, ok := out[code]; !ok {
			out[code] = strings.TrimSpace(p.Name)
		}
	}
	return out, nil
}

func placeholders(n int) string {
	if n <= 0 {
		return ""
	}
	parts := make([]string, n)
	for i := range parts {
		parts[i] = "?"
	}
	return strings.Join(parts, ",")
}

// ContractSettlementDetailRow fb_crypto_contract_orders_detail 结算日志行
type ContractSettlementDetailRow struct {
	ID      int64
	OrderID int64
	UserID  int64
	Remark  string
}

// GetContractOrderSettlementDetail 按合约订单 id 查结算日志（对齐 Java fbcontractordersdetail/{orderId}）
func (d *FbMemberDal) GetContractOrderSettlementDetail(ctx context.Context, orderID int64) (*ContractSettlementDetailRow, error) {
	if orderID <= 0 {
		return nil, errx.BizErr("订单不存在")
	}
	var row ContractSettlementDetailRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT id, order_id, user_id, COALESCE(remark, '') AS remark
		FROM fb_crypto_contract_orders_detail
		WHERE order_id = ?
		LIMIT 1`, orderID).Scan(&row).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	if row.ID == 0 {
		return nil, errx.BizErr("结算日志不存在")
	}
	remark := strings.TrimSpace(row.Remark)
	if remark == "" {
		return nil, errx.BizErr("结算日志为空")
	}
	if !json.Valid([]byte(remark)) {
		return nil, errx.BizErr("结算日志格式异常")
	}
	row.Remark = remark
	return &row, nil
}
