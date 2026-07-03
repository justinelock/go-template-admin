package dal

import (
	"context"
	"fmt"
	"strings"
	"time"

	"ovra/toolkit/errx"
)

type teamDetailRow struct {
	ID            int64
	Username      string
	AgentLevel    int32
	WalletCount   int64
	TotalAssets   float64
	TotalDeposit  float64
	TotalWithdraw float64
	CreatedAt     time.Time
}

type teamMemberBaseRow struct {
	ID       int64
	Username string
	Level    int32 // 相对选中用户的层级 1～5
}

type teamMemberRow struct {
	Level          int32
	Username       string
	TotalAssets    float64
	TotalDeposit   float64
	TotalInvest    float64
	TotalWithdraw  float64
}

const teamMemberMaxDepth = 5

// TeamStatsRow 团队树各级人数（对齐 Java TeamStatsVO）
type TeamStatsRow struct {
	Level1Members int64
	Level2Members int64
	Level3Members int64
	Level4Members int64
	Level5Members int64
	TotalMembers  int64
}

// NormalizeTeamAgentLevel 对齐 Java FbUsersServiceImpl.normalizeTeamQueryAgentLevel
func NormalizeTeamAgentLevel(raw int32) int {
	if raw <= 3 {
		return 3
	}
	if raw >= 5 {
		return 5
	}
	return 4
}

// teamTreeCTESQL 递归查下级；maxDepth 为根用户 agent_level 归一化后的最大展开层级
func teamTreeCTESQL(maxDepth int) string {
	if maxDepth < 1 {
		maxDepth = 3
	}
	if maxDepth > teamMemberMaxDepth {
		maxDepth = teamMemberMaxDepth
	}
	return fmt.Sprintf(`
WITH RECURSIVE team_tree AS (
	SELECT id, username, 1 AS rel_level
	FROM fb_users
	WHERE parent_id = ? AND flag = 0
	UNION ALL
	SELECT u.id, u.username, tt.rel_level + 1
	FROM fb_users u
	INNER JOIN team_tree tt ON u.parent_id = tt.id
	WHERE u.flag = 0 AND tt.rel_level < %d
)`, maxDepth)
}

// ResolveStatsRootUserID 按 keyword 模糊匹配定位统计根用户（对齐 Java getTeamStatsAll(String keyword)）
func (d *FbMemberDal) ResolveStatsRootUserID(ctx context.Context, keyword string) (int64, error) {
	keyword = strings.TrimSpace(keyword)
	if keyword == "" {
		return 0, nil
	}
	kw := "%" + keyword + "%"
	var userID int64
	// LIKE 四字段，LIMIT 1；无匹配返回 0 走全局统计
	err := d.db.WithContext(ctx).Raw(`
		SELECT id FROM fb_users
		WHERE flag = 0 AND (
			username LIKE ? OR mobile LIKE ? OR id_card LIKE ? OR real_name LIKE ?
		)
		LIMIT 1`, kw, kw, kw, kw).Scan(&userID).Error
	if err != nil {
		return 0, errx.GORMErr(err)
	}
	return userID, nil
}

// GetGlobalTeamStats 全平台团队树统计：顶层用户 parent_id IS NULL（对齐 usersDao.getTeamStats(null)）
func (d *FbMemberDal) GetGlobalTeamStats(ctx context.Context) (*TeamStatsRow, error) {
	sql := `
		SELECT
			COUNT(DISTINCT u.id) AS level1_members,
			COUNT(DISTINCT l2.id) AS level2_members,
			COUNT(DISTINCT l3.id) AS level3_members,
			COUNT(DISTINCT l4.id) AS level4_members,
			COUNT(DISTINCT l5.id) AS level5_members,
			(
				COUNT(DISTINCT u.id) + COUNT(DISTINCT l2.id) + COUNT(DISTINCT l3.id) +
				COUNT(DISTINCT l4.id) + COUNT(DISTINCT l5.id)
			) AS total_members
		FROM fb_users u
		LEFT JOIN fb_users l2 ON l2.parent_id = u.id AND l2.flag = 0
		LEFT JOIN fb_users l3 ON l3.parent_id = l2.id AND l3.flag = 0
		LEFT JOIN fb_users l4 ON l4.parent_id = l3.id AND l4.flag = 0
		LEFT JOIN fb_users l5 ON l5.parent_id = l4.id AND l5.flag = 0
		WHERE u.flag = 0 AND u.parent_id IS NULL`
	var row TeamStatsRow
	if err := d.db.WithContext(ctx).Raw(sql).Scan(&row).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	return &row, nil
}

// GetTeamStatsByUserID 以指定用户为根的子树各级人数（对齐 usersDao.getTeamStatsByUserId）
func (d *FbMemberDal) GetTeamStatsByUserID(ctx context.Context, userID int64) (*TeamStatsRow, error) {
	if userID <= 0 {
		return &TeamStatsRow{}, nil
	}
	sql := `
		SELECT
			COUNT(DISTINCT l2.id) AS level1_members,
			COUNT(DISTINCT l3.id) AS level2_members,
			COUNT(DISTINCT l4.id) AS level3_members,
			COUNT(DISTINCT l5.id) AS level4_members,
			COUNT(DISTINCT l6.id) AS level5_members,
			(
				COUNT(DISTINCT l2.id) + COUNT(DISTINCT l3.id) + COUNT(DISTINCT l4.id) +
				COUNT(DISTINCT l5.id) + COUNT(DISTINCT l6.id)
			) AS total_members
		FROM fb_users u
		LEFT JOIN fb_users l2 ON l2.parent_id = u.id AND l2.flag = 0
		LEFT JOIN fb_users l3 ON l3.parent_id = l2.id AND l3.flag = 0
		LEFT JOIN fb_users l4 ON l4.parent_id = l3.id AND l4.flag = 0
		LEFT JOIN fb_users l5 ON l5.parent_id = l4.id AND l5.flag = 0
		LEFT JOIN fb_users l6 ON l6.parent_id = l5.id AND l6.flag = 0
		WHERE u.id = ?
		GROUP BY u.id`
	var row TeamStatsRow
	if err := d.db.WithContext(ctx).Raw(sql, userID).Scan(&row).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	return &row, nil
}

// ApplyTeamStatsAgentLevelCap 按 agent_level 截断 level4/5 并重算 totalMembers（对齐 applyAgentLevelCap）
func ApplyTeamStatsAgentLevelCap(stats *TeamStatsRow, agentLevel int) {
	if stats == nil {
		return
	}
	if agentLevel < 4 {
		stats.Level4Members = 0
	}
	if agentLevel < 5 {
		stats.Level5Members = 0
	}
	stats.TotalMembers = stats.Level1Members + stats.Level2Members + stats.Level3Members +
		stats.Level4Members + stats.Level5Members
}

// CollectTeamDescendantIDs 收集根用户 agent_level 深度内的全部下级 ID（对齐 getMyUserAgents，CTE 去重）
func (d *FbMemberDal) CollectTeamDescendantIDs(ctx context.Context, rootUserID int64, maxDepth int) ([]int64, error) {
	if rootUserID <= 0 {
		return nil, nil
	}
	sql := teamTreeCTESQL(maxDepth) + ` SELECT id FROM team_tree`
	var ids []int64
	if err := d.db.WithContext(ctx).Raw(sql, rootUserID).Scan(&ids).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	return ids, nil
}

// SumAllWalletBalance 全库钱包余额总和（对齐 walletService.getTotalUserBalance）
func (d *FbMemberDal) SumAllWalletBalance(ctx context.Context) (float64, error) {
	var total float64
	if err := d.db.WithContext(ctx).Raw(
		`SELECT COALESCE(SUM(balance), 0) FROM fb_user_wallets`,
	).Scan(&total).Error; err != nil {
		return 0, errx.GORMErr(err)
	}
	return total, nil
}

// SumWalletBalanceByUserIDs 指定用户列表钱包余额总和（对齐 walletService.getUserBalance）
func (d *FbMemberDal) SumWalletBalanceByUserIDs(ctx context.Context, userIDs []int64) (float64, error) {
	if len(userIDs) == 0 {
		return 0, nil
	}
	balanceMap, err := d.sumBalanceByUserIds(ctx, userIDs)
	if err != nil {
		return 0, err
	}
	var total float64
	for _, v := range balanceMap {
		total += v
	}
	return total, nil
}

// GetTeamUserAgentLevel 读取用户 agent_level，不存在返回 0
func (d *FbMemberDal) GetTeamUserAgentLevel(ctx context.Context, userID int64) (int32, error) {
	var agentLevel int32
	if err := d.db.WithContext(ctx).Raw(
		`SELECT agent_level FROM fb_users WHERE id = ? AND flag = 0`, userID,
	).Scan(&agentLevel).Error; err != nil {
		return 0, errx.GORMErr(err)
	}
	return agentLevel, nil
}

// GetTeamDetail 团队详情：钱包数/总资产/充提汇总
func (d *FbMemberDal) GetTeamDetail(ctx context.Context, userID int64) (*teamDetailRow, error) {
	if userID <= 0 {
		return nil, errx.BizErr("用户不存在")
	}
	sql := `SELECT u.id, u.username, u.agent_level, u.created_at,
		COALESCE(wc.cnt, 0) AS wallet_count,
		COALESCE(w.bal, 0) AS total_assets,
		COALESCE(dep.total, 0) AS total_deposit,
		COALESCE(wd.total, 0) AS total_withdraw
	FROM fb_users u
	LEFT JOIN (SELECT user_id, COUNT(*) AS cnt FROM fb_user_wallets GROUP BY user_id) wc ON wc.user_id = u.id
	LEFT JOIN (SELECT user_id, SUM(balance) AS bal FROM fb_user_wallets GROUP BY user_id) w ON w.user_id = u.id
	LEFT JOIN (
		SELECT user_id, SUM(amount) AS total FROM fb_deposits
		WHERE status = 'SUCCESS' GROUP BY user_id
	) dep ON dep.user_id = u.id
	LEFT JOIN (
		SELECT user_id, SUM(amount) AS total FROM fb_withdraws
		WHERE status = 'SUCCESS' GROUP BY user_id
	) wd ON wd.user_id = u.id
	WHERE u.id = ? AND u.flag = 0`
	var row teamDetailRow
	if err := d.db.WithContext(ctx).Raw(sql, userID).Scan(&row).Error; err != nil {
		return nil, errx.GORMErr(err)
	}
	if row.ID == 0 {
		return nil, errx.BizErr("用户不存在")
	}
	return &row, nil
}

// PageTeamMembers 分页查下级团队成员；深度受根用户 agent_level 限制（对齐 getSubTeamByUserIdPage）
func (d *FbMemberDal) PageTeamMembers(ctx context.Context, rootUserID int64, pageNum, pageSize int64) (rows []teamMemberRow, total int64, err error) {
	if rootUserID <= 0 {
		return nil, 0, errx.BizErr("用户不存在")
	}
	var root struct {
		ID         int64
		AgentLevel int32
	}
	if err = d.db.WithContext(ctx).Raw(
		`SELECT id, agent_level FROM fb_users WHERE id = ? AND flag = 0`, rootUserID,
	).Scan(&root).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if root.ID == 0 {
		return nil, 0, errx.BizErr("用户不存在")
	}
	maxDepth := NormalizeTeamAgentLevel(root.AgentLevel)
	treeCTE := teamTreeCTESQL(maxDepth)
	if pageSize <= 0 {
		pageSize = 10
	}
	if pageNum <= 0 {
		pageNum = 1
	}
	countSQL := treeCTE + ` SELECT COUNT(*) FROM team_tree`
	if err = d.db.WithContext(ctx).Raw(countSQL, rootUserID).Scan(&total).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	if total == 0 {
		return []teamMemberRow{}, 0, nil
	}
	offset := (pageNum - 1) * pageSize
	listSQL := treeCTE + ` SELECT id, username, rel_level AS level
		FROM team_tree ORDER BY rel_level, username LIMIT ? OFFSET ?`
	var bases []teamMemberBaseRow
	if err = d.db.WithContext(ctx).Raw(listSQL, rootUserID, pageSize, offset).Scan(&bases).Error; err != nil {
		return nil, 0, errx.GORMErr(err)
	}
	userIDs := make([]int64, 0, len(bases))
	for _, b := range bases {
		userIDs = append(userIDs, b.ID)
	}
	balanceMap, err := d.sumBalanceByUserIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}
	depositMap, err := d.sumDepositByUserIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}
	withdrawMap, err := d.sumWithdrawByUserIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}
	investMap, err := d.sumFundInvestByUserIds(ctx, userIDs)
	if err != nil {
		return nil, 0, err
	}
	rows = make([]teamMemberRow, 0, len(bases))
	for _, b := range bases {
		rows = append(rows, teamMemberRow{
			Level:         b.Level,
			Username:      b.Username,
			TotalAssets:   balanceMap[b.ID],
			TotalDeposit:  depositMap[b.ID],
			TotalInvest:   investMap[b.ID],
			TotalWithdraw: withdrawMap[b.ID],
		})
	}
	return rows, total, nil
}

// sumFundInvestByUserIds PENDING 投信本金汇总（对齐用户列表 fund_position_amount）
func (d *FbMemberDal) sumFundInvestByUserIds(ctx context.Context, userIDs []int64) (map[int64]float64, error) {
	return d.sumAmountByUserIds(ctx, userIDs, `
		SELECT user_id, SUM(amount) AS total
		FROM fb_fund_position
		WHERE state = 'PENDING' AND status = 1 AND user_id IN (%s)
		GROUP BY user_id`)
}

// ChangeTeamParentByUsername 按上级用户名更换 parent_id（对齐 Java changeAgent）；username 空则清空上级
func (d *FbMemberDal) ChangeTeamParentByUsername(ctx context.Context, userID int64, parentUsername string) (parentID int64, resolvedUsername string, err error) {
	if userID <= 0 {
		return 0, "", errx.BizErr("用户不存在")
	}
	var userExists int64
	if err = d.db.WithContext(ctx).Raw(
		`SELECT COUNT(*) FROM fb_users WHERE id = ? AND flag = 0`, userID,
	).Scan(&userExists).Error; err != nil {
		return 0, "", errx.GORMErr(err)
	}
	if userExists == 0 {
		return 0, "", errx.BizErr("用户不存在")
	}

	parentUsername = strings.TrimSpace(parentUsername)
	if parentUsername == "" {
		return 0, "", errx.BizErr("上级代理用户名不能为空")
	}

	var parent struct {
		ID       int64
		Username string
	}
	if err = d.db.WithContext(ctx).Raw(
		`SELECT id, username FROM fb_users WHERE username = ? AND flag = 0`, parentUsername,
	).Scan(&parent).Error; err != nil {
		return 0, "", errx.GORMErr(err)
	}
	if parent.ID == 0 {
		return 0, "", errx.BizErr("用户不存在")
	}
	if parent.ID == userID {
		return 0, "", errx.BizErr("不能将自己设为上级")
	}
	inSubtree, err := d.isUserInSubtree(ctx, userID, parent.ID)
	if err != nil {
		return 0, "", err
	}
	if inSubtree {
		return 0, "", errx.BizErr("不能将下级设为上级")
	}
	res := d.db.WithContext(ctx).Table("fb_users").
		Where("id = ? AND flag = 0", userID).
		Updates(map[string]any{
			"parent_id":  parent.ID,
			"updated_at": time.Now(),
		})
	if res.Error != nil {
		return 0, "", errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return 0, "", errx.BizErr("用户不存在")
	}
	return parent.ID, parent.Username, nil
}

// UpdateTeamAgentLevel 更新 fb_users.agent_level（对齐 Java FbUsersServiceImpl.updateAgentLevel）
func (d *FbMemberDal) UpdateTeamAgentLevel(ctx context.Context, userID int64, agentLevel int64) error {
	if userID <= 0 {
		return errx.BizErr("用户ID不能为空")
	}
	if agentLevel != 3 && agentLevel != 4 && agentLevel != 5 {
		return errx.BizErr("代理层级必须为 3、4 或 5")
	}
	res := d.db.WithContext(ctx).Table("fb_users").
		Where("id = ? AND flag = 0", userID).
		Updates(map[string]any{
			"agent_level": agentLevel,
			"updated_at":  time.Now(),
		})
	if res.Error != nil {
		return errx.GORMErr(res.Error)
	}
	if res.RowsAffected == 0 {
		return errx.BizErr("用户不存在")
	}
	return nil
}

// isUserInSubtree 判断 targetID 是否在 rootID 的下级树中（防环校验用全深度 5）
func (d *FbMemberDal) isUserInSubtree(ctx context.Context, rootID, targetID int64) (bool, error) {
	sql := teamTreeCTESQL(teamMemberMaxDepth) + ` SELECT COUNT(*) FROM team_tree WHERE id = ?`
	var cnt int64
	if err := d.db.WithContext(ctx).Raw(sql, rootID, targetID).Scan(&cnt).Error; err != nil {
		return false, errx.GORMErr(err)
	}
	return cnt > 0, nil
}
