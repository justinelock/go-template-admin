package dal

import (
	"context"
	"math"
	"time"

	"ovra/toolkit/errx"
)

// 实名/钱包状态键（对齐 Java VerificationState）
const (
	VerifyStatusPending  = "PENDING"
	VerifyStatusApproved = "APPROVED"
	VerifyStatusVerified = "VERIFIED"
	VerifyStatusRejected = "REJECTED"
)

// 充提状态键（对齐 Java FundPurchaseStatus）
const (
	fundStatusPending = "PENDING"
	fundStatusSuccess = "SUCCESS"
)

type statusCountRow struct {
	Status string
	Cnt    int64
}

type fundAggRow struct {
	PendingCount int64
	SuccessSum   float64
}

// ResolveStatisticsType 解析时间维度；0~2 合法，缺省或非法回退 1（本周）
func ResolveStatisticsType(raw int) int {
	if raw < 0 || raw > 2 {
		return 1
	}
	return raw
}

// ResolveDateRange 按 type 计算 [start, end]（本地时区，含当天结束时刻）
func ResolveDateRange(statType int) (start, end time.Time) {
	now := time.Now()
	loc := now.Location()
	today := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, loc)
	end = time.Date(now.Year(), now.Month(), now.Day(), 23, 59, 59, int(time.Second-time.Nanosecond), loc)

	switch statType {
	case 0:
		// 当天 00:00 ~ 今天结束
		start = today
	case 2:
		// 本月 1 号 00:00 ~ 今天结束
		start = time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, loc)
	default:
		// 本周：周一 00:00 ~ 今天结束（与 Java DayOfWeek.MONDAY 一致）
		weekday := int(today.Weekday())
		if weekday == 0 {
			weekday = 7
		}
		mondayOffset := weekday - int(time.Monday)
		start = today.AddDate(0, 0, -mondayOffset)
	}
	return start, end
}

// CountIdentityVerifyByStatus 实名认证：时间范围内按 status 计数
func (d *FbMemberDal) CountIdentityVerifyByStatus(ctx context.Context, start, end time.Time) (map[string]int64, error) {
	var rows []statusCountRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT status, COUNT(*) AS cnt
		FROM fb_identity_verify
		WHERE created_at >= ? AND created_at <= ?
		GROUP BY status`, start, end).Scan(&rows).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	out := make(map[string]int64, len(rows))
	for _, r := range rows {
		out[r.Status] = r.Cnt
	}
	return out, nil
}

// CountWalletApplyDistinctUserByStatus 钱包申请：按 status 统计去重 user_id（对齐 Java distinct userId）
func (d *FbMemberDal) CountWalletApplyDistinctUserByStatus(ctx context.Context, start, end time.Time) (map[string]int64, error) {
	var rows []statusCountRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT status, COUNT(DISTINCT user_id) AS cnt
		FROM fb_account_application
		WHERE created_at >= ? AND created_at <= ?
		  AND user_id IS NOT NULL
		  AND created_at IS NOT NULL
		GROUP BY status`, start, end).Scan(&rows).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	out := make(map[string]int64, len(rows))
	for _, r := range rows {
		out[r.Status] = r.Cnt
	}
	return out, nil
}

// AggregateDeposits 充值：PENDING 条数 + SUCCESS 且 payment_status=SUCCESS 金额（四舍五入取整）
func (d *FbMemberDal) AggregateDeposits(ctx context.Context, start, end time.Time) (*fundAggRow, error) {
	var row fundAggRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT
			SUM(CASE WHEN status = ? THEN 1 ELSE 0 END) AS pending_count,
			COALESCE(SUM(CASE
				WHEN status = ? AND payment_status = ? AND amount IS NOT NULL THEN amount
				ELSE 0
			END), 0) AS success_sum
		FROM fb_deposits
		WHERE created_at >= ? AND created_at <= ?
		  AND user_id IS NOT NULL
		  AND amount IS NOT NULL`,
		fundStatusPending, fundStatusSuccess, fundStatusSuccess, start, end).Scan(&row).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	return &row, nil
}

// AggregateWithdraws 提现：口径与充值一致
func (d *FbMemberDal) AggregateWithdraws(ctx context.Context, start, end time.Time) (*fundAggRow, error) {
	var row fundAggRow
	err := d.db.WithContext(ctx).Raw(`
		SELECT
			SUM(CASE WHEN status = ? THEN 1 ELSE 0 END) AS pending_count,
			COALESCE(SUM(CASE
				WHEN status = ? AND payment_status = ? AND amount IS NOT NULL THEN amount
				ELSE 0
			END), 0) AS success_sum
		FROM fb_withdraws
		WHERE created_at >= ? AND created_at <= ?
		  AND user_id IS NOT NULL
		  AND amount IS NOT NULL`,
		fundStatusPending, fundStatusSuccess, fundStatusSuccess, start, end).Scan(&row).Error
	if err != nil {
		return nil, errx.GORMErr(err)
	}
	return &row, nil
}

// RoundFundSum 金额四舍五入取整（对齐 Java setScale(0, HALF_UP)）
func RoundFundSum(amount float64) int64 {
	return int64(math.Round(amount))
}

// MapCountOrZero 从分组 map 取计数，缺省 0
func MapCountOrZero(m map[string]int64, key string) int64 {
	if m == nil {
		return 0
	}
	return m[key]
}
