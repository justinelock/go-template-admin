/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80100 (8.1.0)
 Source Host           : localhost:3306
 Source Schema         : ovra_zero

 Target Server Type    : MySQL
 Target Server Version : 80100 (8.1.0)
 File Encoding         : 65001

 Date: 03/07/2026 18:19:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for app_branding_config
-- ----------------------------
DROP TABLE IF EXISTS `app_branding_config`;
CREATE TABLE `app_branding_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `revision` varchar(32) NOT NULL COMMENT '配置版本号，变更后客户端刷新缓存',
  `splash_url` varchar(512) DEFAULT NULL COMMENT '启动页图片 URL（相对或绝对）',
  `splash_enabled` tinyint(1) DEFAULT '1' COMMENT '1=启用远程启动图',
  `home_banner_url` varchar(512) DEFAULT NULL COMMENT '首页横幅 URL',
  `home_banner_enabled` tinyint(1) DEFAULT '1' COMMENT '1=启用远程横幅',
  `profile_poster_url` varchar(512) DEFAULT NULL COMMENT '「我的」顶部海报 URL（相对或绝对）',
  `profile_poster_enabled` tinyint(1) DEFAULT '0' COMMENT '1=启用远程「我的」顶部海报',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` varchar(64) DEFAULT NULL COMMENT '最后修改人',
  PRIMARY KEY (`id`),
  KEY `idx_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='App 品牌展示资源配置';

-- ----------------------------
-- Table structure for app_release_versions
-- ----------------------------
DROP TABLE IF EXISTS `app_release_versions`;
CREATE TABLE `app_release_versions` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '对外版本号',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '更新说明',
  `download_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '安装包或商店地址',
  `apk_file_url` varchar(1024) DEFAULT NULL COMMENT 'APK 文件直链（本地上传）',
  `ios_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'ios下载地址',
  `ipa_file_url` varchar(1024) DEFAULT NULL COMMENT 'IPA 文件直链（本地上传）',
  `is_force` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否强更：0-否 1-是',
  `is_hot_update` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否热更新：0-否 1-是',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_app_release_versions_created_at` (`created_at` DESC) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='App版本发布记录';

-- ----------------------------
-- Table structure for cs_message
-- ----------------------------
DROP TABLE IF EXISTS `cs_message`;
CREATE TABLE `cs_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `session_id` bigint NOT NULL COMMENT '会话ID',
  `sender_type` varchar(16) NOT NULL COMMENT 'USER/AGENT',
  `sender_id` bigint NOT NULL COMMENT '发送者ID',
  `content_type` varchar(16) NOT NULL DEFAULT 'TEXT' COMMENT 'TEXT/IMAGE',
  `content` text NOT NULL COMMENT '文本或图片URL',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_cs_message_session_date` (`session_id`,`create_date`)
) ENGINE=InnoDB AUTO_INCREMENT=2068594902793007106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='客服消息';

-- ----------------------------
-- Table structure for cs_session
-- ----------------------------
DROP TABLE IF EXISTS `cs_session`;
CREATE TABLE `cs_session` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT 'H5用户ID',
  `status` varchar(16) NOT NULL DEFAULT 'OPEN' COMMENT 'OPEN/CLOSED',
  `last_message_at` datetime DEFAULT NULL COMMENT '最后消息时间',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_cs_session_user_status` (`user_id`,`status`),
  KEY `idx_cs_session_last_message` (`last_message_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2070345839089889282 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='客服会话';

-- ----------------------------
-- Table structure for fb_account_application
-- ----------------------------
DROP TABLE IF EXISTS `fb_account_application`;
CREATE TABLE `fb_account_application` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `account_type` varchar(20) NOT NULL COMMENT '账户类型',
  `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING-待审核，APPROVED-已通过，REJECTED-已拒绝',
  `state` varchar(20) DEFAULT NULL COMMENT '状态：PENDING-待审核，APPROVED-已通过，REJECTED-已拒绝',
  `risk_assessment_score` int DEFAULT NULL COMMENT '风险评估得分',
  `reject_reason` varchar(200) DEFAULT NULL COMMENT '拒绝原因',
  `apply_time` datetime NOT NULL COMMENT '申请时间',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `audit_user_id` bigint DEFAULT NULL COMMENT '审核人ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_type` (`user_id`,`account_type`),
  KEY `idx_status` (`status`),
  KEY `idx_apply_time` (`apply_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2072730057803640834 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='开户申请表';

-- ----------------------------
-- Table structure for fb_account_flow_records
-- ----------------------------
DROP TABLE IF EXISTS `fb_account_flow_records`;
CREATE TABLE `fb_account_flow_records` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `account_type` varchar(20) NOT NULL DEFAULT 'main' COMMENT '账户类型',
  `flow_type` varchar(20) DEFAULT NULL COMMENT '交易类型',
  `before_amount` decimal(20,2) DEFAULT NULL COMMENT '交易前余额',
  `flow_amount` decimal(20,2) NOT NULL COMMENT '变动金额',
  `after_amount` decimal(20,2) DEFAULT NULL COMMENT '交易后余额',
  `business_no` varchar(120) DEFAULT NULL COMMENT '业务编号',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `wallet_id` bigint DEFAULT NULL COMMENT '钱包ID',
  `currency` varchar(10) NOT NULL DEFAULT 'CNY' COMMENT '货币单位',
  `description` varchar(255) DEFAULT NULL COMMENT '交易描述',
  `status` varchar(20) NOT NULL DEFAULT 'SUCCESS' COMMENT '交易状态',
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_business_no` (`business_no`) USING BTREE,
  KEY `idx_user_id` (`user_id`),
  KEY `idx_flow_user_type_created` (`user_id`,`flow_type`,`created_at`),
  KEY `idx_flow_user_created` (`user_id`,`created_at`),
  CONSTRAINT `fb_account_flow_records_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `fb_users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2072726075194552323 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='账户流水记录表';

-- ----------------------------
-- Table structure for fb_act_red_packet_activity
-- ----------------------------
DROP TABLE IF EXISTS `fb_act_red_packet_activity`;
CREATE TABLE `fb_act_red_packet_activity` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `code` varchar(64) NOT NULL COMMENT '活动编码, 如 SPRING_RP_2026',
  `name` varchar(128) NOT NULL COMMENT '活动名称',
  `start_time` datetime NOT NULL COMMENT '活动开始时间',
  `end_time` datetime NOT NULL COMMENT '活动结束时间',
  `total_days` int NOT NULL COMMENT '活动持续天数n',
  `timezone` varchar(64) NOT NULL DEFAULT 'Asia/Shanghai' COMMENT '活动时区',
  `min_deposit_amt` decimal(16,4) NOT NULL DEFAULT '188.0000' COMMENT '单笔充值门槛(U)',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态:0-未启用,1-启用,2-结束',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `created_by` bigint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_by` bigint DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_rp_activity_status_time` (`status`,`start_time`,`end_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='红包活动主表';

-- ----------------------------
-- Table structure for fb_act_red_packet_closed
-- ----------------------------
DROP TABLE IF EXISTS `fb_act_red_packet_closed`;
CREATE TABLE `fb_act_red_packet_closed` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `activity_id` bigint NOT NULL COMMENT '活动ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `day_index` int NOT NULL COMMENT '活动第几天',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_activity_user_day` (`activity_id`,`user_id`,`day_index`),
  KEY `idx_activity_day` (`activity_id`,`day_index`)
) ENGINE=InnoDB AUTO_INCREMENT=2024868375242559491 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='红包关闭弹窗记录';

-- ----------------------------
-- Table structure for fb_act_red_packet_day_config
-- ----------------------------
DROP TABLE IF EXISTS `fb_act_red_packet_day_config`;
CREATE TABLE `fb_act_red_packet_day_config` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` bigint unsigned NOT NULL COMMENT '活动ID',
  `day_index` int NOT NULL COMMENT '活动第几天(从1开始)',
  `day_date` date NOT NULL COMMENT '自然日日期(按活动时区计算)',
  `top_prize_amount` decimal(16,4) NOT NULL COMMENT '当日最高红包金额, 如18U',
  `top_prize_quota` int NOT NULL COMMENT '最高红包人数, 如10人',
  `normal_type` tinyint NOT NULL DEFAULT '2' COMMENT '普通红包类型:1-固定,2-随机区间',
  `normal_fixed_amount` decimal(16,4) DEFAULT NULL COMMENT '普通红包固定金额, normal_type=1时生效',
  `normal_random_min` decimal(16,4) DEFAULT NULL COMMENT '普通红包随机最小值',
  `normal_random_max` decimal(16,4) DEFAULT NULL COMMENT '普通红包随机最大值',
  `enabled` tinyint NOT NULL DEFAULT '1' COMMENT '是否启用该天配置',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_act_day` (`activity_id`,`day_index`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='红包每日配置表';

-- ----------------------------
-- Table structure for fb_act_red_packet_day_stat
-- ----------------------------
DROP TABLE IF EXISTS `fb_act_red_packet_day_stat`;
CREATE TABLE `fb_act_red_packet_day_stat` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` bigint unsigned NOT NULL,
  `day_index` int NOT NULL,
  `send_top_count` int NOT NULL DEFAULT '0',
  `send_top_amount` decimal(16,4) NOT NULL DEFAULT '0.0000',
  `send_normal_count` int NOT NULL DEFAULT '0',
  `send_normal_amount` decimal(16,4) NOT NULL DEFAULT '0.0000',
  `last_update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_act_day` (`activity_id`,`day_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='红包每日统计表';

-- ----------------------------
-- Table structure for fb_act_red_packet_lock
-- ----------------------------
DROP TABLE IF EXISTS `fb_act_red_packet_lock`;
CREATE TABLE `fb_act_red_packet_lock` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `activity_id` bigint NOT NULL COMMENT '活动ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_activity_user` (`activity_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='红包领取锁';

-- ----------------------------
-- Table structure for fb_act_red_packet_qualify
-- ----------------------------
DROP TABLE IF EXISTS `fb_act_red_packet_qualify`;
CREATE TABLE `fb_act_red_packet_qualify` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `qualify_time` datetime NOT NULL COMMENT '达标时间',
  `qualify_day_index` int NOT NULL COMMENT '达标所在活动第几天',
  `order_id` bigint unsigned NOT NULL COMMENT '达标充值订单ID',
  `deposit_amount` decimal(16,4) NOT NULL COMMENT '该笔充值金额',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态:1-有效,0-无效(风控可置0)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_act_user` (`activity_id`,`user_id`),
  KEY `idx_act_day` (`activity_id`,`qualify_day_index`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2024815762400694275 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='红包用户达标资格表';

-- ----------------------------
-- Table structure for fb_act_red_packet_receive
-- ----------------------------
DROP TABLE IF EXISTS `fb_act_red_packet_receive`;
CREATE TABLE `fb_act_red_packet_receive` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `day_index` int NOT NULL COMMENT '活动第几天',
  `day_date` date NOT NULL COMMENT '日期',
  `amount` decimal(16,4) NOT NULL COMMENT '领取金额',
  `prize_type` tinyint NOT NULL COMMENT '1-最高红包,2-普通红包',
  `receive_time` datetime NOT NULL COMMENT '领取时间',
  `client_ip` varchar(64) DEFAULT NULL COMMENT '领取IP',
  `device_id` varchar(128) DEFAULT NULL COMMENT '设备标识(前端透传)',
  `ua` varchar(255) DEFAULT NULL COMMENT 'User-Agent简化信息',
  `ext` json DEFAULT NULL COMMENT '扩展字段',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_act_user_day` (`activity_id`,`user_id`,`day_index`),
  KEY `idx_act_day` (`activity_id`,`day_index`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2024834391208972290 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='红包用户每日领取记录表';

-- ----------------------------
-- Table structure for fb_api_key_record
-- ----------------------------
DROP TABLE IF EXISTS `fb_api_key_record`;
CREATE TABLE `fb_api_key_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `api_key` varchar(32) NOT NULL COMMENT 'API Key',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_use_time` datetime DEFAULT NULL COMMENT '最后使用时间',
  `daily_use_count` int DEFAULT '0' COMMENT '当日使用次数',
  `count_date` datetime DEFAULT NULL COMMENT '计数日期',
  `email` varchar(100) NOT NULL COMMENT '申请邮箱',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-可用，1-已达上限，2-已失效',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_api_key` (`api_key`),
  KEY `idx_count_date` (`count_date`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='API Key记录表';

-- ----------------------------
-- Table structure for fb_bank_cards
-- ----------------------------
DROP TABLE IF EXISTS `fb_bank_cards`;
CREATE TABLE `fb_bank_cards` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `bank_code` varchar(32) NOT NULL COMMENT '银行代码',
  `bank_name` varchar(64) NOT NULL COMMENT '银行名称',
  `card_number` varchar(32) NOT NULL COMMENT '银行卡号',
  `masked_number` varchar(32) NOT NULL COMMENT '掩码卡号',
  `card_holder` varchar(64) NOT NULL COMMENT '持卡人姓名',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否默认卡',
  `status` varchar(32) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE-正常，FROZEN-冻结，DELETED-已删除',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_card_number` (`card_number`),
  KEY `idx_bankcard_user_status` (`user_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='银行卡信息表';

-- ----------------------------
-- Table structure for fb_contract_control_daily
-- ----------------------------
DROP TABLE IF EXISTS `fb_contract_control_daily`;
CREATE TABLE `fb_contract_control_daily` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `biz_date` date NOT NULL COMMENT '生效日期(Asia/Shanghai)',
  `control_state` varchar(32) NOT NULL DEFAULT 'RANDOM' COMMENT 'RANDOM/LONG_WIN/LONG_LOSE/SHORT_WIN/SHORT_LOSE',
  `enabled` tinyint NOT NULL DEFAULT '1' COMMENT '0禁用 1启用',
  `kill_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '历史字段；杀率以小数[-1,1]存，见 fb_contract_kill_rate',
  `start_time` datetime DEFAULT NULL COMMENT '生效开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '生效结束时间',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_fb_contract_control_daily_biz_date` (`biz_date`)
) ENGINE=InnoDB AUTO_INCREMENT=2072717943016849410 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='每日全局合约控盘配置';

-- ----------------------------
-- Table structure for fb_contract_kill_rate
-- ----------------------------
DROP TABLE IF EXISTS `fb_contract_kill_rate`;
CREATE TABLE `fb_contract_kill_rate` (
  `id` bigint NOT NULL COMMENT '固定为1，全局唯一',
  `kill_rate` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '杀率小数[-1,1]；如 0.05=前端5%；正数=客户平均亏损比例倾向，负数=盈利倾向；长期有效直至后台修改',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='合约全局杀率（非按日失效）';

-- ----------------------------
-- Table structure for fb_crypto_contract_orders
-- ----------------------------
DROP TABLE IF EXISTS `fb_crypto_contract_orders`;
CREATE TABLE `fb_crypto_contract_orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '订单唯一ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `account` varchar(100) NOT NULL COMMENT '用户账号',
  `real_name` varchar(100) DEFAULT NULL COMMENT '用户真实姓名',
  `coin_type` varchar(20) NOT NULL COMMENT '币种类型(例如: BTC, ETH)',
  `market` varchar(20) NOT NULL COMMENT '市场(例如: FOREX_US)',
  `direction` tinyint(1) NOT NULL COMMENT '交易方向 (1: 买入, 2: 卖出)',
  `trade_pair` varchar(20) NOT NULL COMMENT '交易对 (例如: BTC/USDT)',
  `pair_name` varchar(20) DEFAULT NULL COMMENT '交易对名',
  `amount` decimal(20,2) NOT NULL COMMENT '交易金额',
  `profit_ratio` decimal(10,2) NOT NULL COMMENT '收益比例',
  `seconds` int NOT NULL COMMENT '合约时长(秒)',
  `opening_price` decimal(20,8) NOT NULL COMMENT '开仓价格',
  `closing_price` decimal(20,8) DEFAULT NULL COMMENT '平仓价格',
  `opening_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开仓时间',
  `expire_at` timestamp GENERATED ALWAYS AS ((`opening_time` + interval `seconds` second)) STORED NULL COMMENT '到期时间=开仓时间+合约秒数',
  `closing_time` timestamp NULL DEFAULT NULL COMMENT '平仓时间',
  `expected_profit` decimal(20,2) DEFAULT NULL COMMENT '预期收益',
  `actual_profit` decimal(20,2) DEFAULT NULL COMMENT '实际收益',
  `wallet_balance_after_settle` decimal(20,8) DEFAULT NULL COMMENT '结算后主钱包USD余额快照',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态(1:持仓中, 2:已取消, 3:已结算)',
  `control_type` tinyint(1) DEFAULT NULL COMMENT '控单类型(1:必赢, 2:必输, 3:自然)',
  `control_result` tinyint(1) DEFAULT NULL COMMENT '控单结果(1:赢, 2:输)',
  `remark` text COMMENT '备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `version` int DEFAULT '0' COMMENT '版本号',
  `user_control` int DEFAULT '3' COMMENT '用户控单 1 = 赢  2 = 输  3 = 自然',
  `global_control_state_snapshot` varchar(255) DEFAULT NULL COMMENT '当日全局控盘快照',
  `global_control_applied` tinyint(1) DEFAULT '0' COMMENT '当日全局控盘是否生效：0否 1是',
  `client_request_id` varchar(64) DEFAULT NULL COMMENT '客户端幂等键(UUID)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_biz_dedup` (`user_id`,`opening_time`,`amount`,`market`,`direction`,`seconds`),
  UNIQUE KEY `uk_user_client_request` (`user_id`,`client_request_id`),
  KEY `idx_uid` (`user_id`),
  KEY `idx_createtime` (`create_time` DESC),
  KEY `idx_userid_createtime` (`user_id`,`create_time`),
  KEY `idx_status_create_time_id` (`status`,`create_time`,`id`),
  KEY `idx_user_create_time` (`user_id`,`create_time`),
  KEY `idx_user_status_update_time` (`user_id`,`status`,`update_time`),
  KEY `idx_user_status_closing_time` (`user_id`,`status`,`closing_time`),
  KEY `idx_status_update_time` (`status`,`update_time`),
  KEY `idx_contract_status_expire_at` (`status`,`expire_at`,`id`),
  KEY `idx_contract_status_create_expire` (`status`,`create_time`,`expire_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2072669205121544194 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='加密货币合约交易表';

-- ----------------------------
-- Table structure for fb_crypto_contract_orders_detail
-- ----------------------------
DROP TABLE IF EXISTS `fb_crypto_contract_orders_detail`;
CREATE TABLE `fb_crypto_contract_orders_detail` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '订单唯一ID',
  `order_id` bigint NOT NULL COMMENT '合约订单ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `remark` text COMMENT '备注',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `id_order_id` (`order_id`) USING BTREE,
  KEY `id_uid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2072669329210028035 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='加密货币合约交易表';

-- ----------------------------
-- Table structure for fb_daily_base_balance
-- ----------------------------
DROP TABLE IF EXISTS `fb_daily_base_balance`;
CREATE TABLE `fb_daily_base_balance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `stat_date` date NOT NULL,
  `base_balance` decimal(24,8) NOT NULL DEFAULT '0.00000000',
  `source` varchar(32) NOT NULL DEFAULT 'before-first-order',
  `environment` varchar(32) NOT NULL DEFAULT 'simulation',
  `version` varchar(16) NOT NULL DEFAULT 'v5',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_stat_date` (`user_id`,`stat_date`),
  KEY `idx_stat_date` (`stat_date`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='杀率V5日基准余额B0';

-- ----------------------------
-- Table structure for fb_deposit_receipt
-- ----------------------------
DROP TABLE IF EXISTS `fb_deposit_receipt`;
CREATE TABLE `fb_deposit_receipt` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) NOT NULL COMMENT '订单号',
  `screenshot` mediumtext COMMENT '充值截图文件路径或ID',
  PRIMARY KEY (`id`),
  KEY `uk_order_no` (`order_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='充值记录截图表';

-- ----------------------------
-- Table structure for fb_deposits
-- ----------------------------
DROP TABLE IF EXISTS `fb_deposits`;
CREATE TABLE `fb_deposits` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `order_no` varchar(48) NOT NULL COMMENT '订单号',
  `amount` decimal(20,2) NOT NULL COMMENT '充值金额',
  `status` varchar(20) NOT NULL COMMENT '状态',
  `payment_method` varchar(20) NOT NULL COMMENT '支付方式',
  `payment_status` varchar(20) NOT NULL COMMENT '支付状态',
  `payment_no` varchar(64) DEFAULT NULL COMMENT '第三方支付单号',
  `payment_time` datetime DEFAULT NULL COMMENT '支付时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `currency` varchar(10) NOT NULL DEFAULT 'CNY' COMMENT '货币类型(CNY或USDT)',
  `target_account` varchar(20) NOT NULL DEFAULT 'MAIN' COMMENT '目标账户类型(MAIN普通钱包或FOREX外汇账户)',
  `screenshot` mediumtext COMMENT '充值截图文件路径或ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_deposits_user_status_created` (`user_id`,`status`,`created_at`),
  KEY `idx_deposits_user_paytime` (`user_id`,`payment_status`,`status`,`payment_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2072674230690459650 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='充值记录表';

-- ----------------------------
-- Table structure for fb_device_login_log
-- ----------------------------
DROP TABLE IF EXISTS `fb_device_login_log`;
CREATE TABLE `fb_device_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL DEFAULT '0' COMMENT '用户ID，0表示未登录用户',
  `device_id` varchar(64) NOT NULL COMMENT '设备唯一标识',
  `login_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
  `login_ip` varchar(50) NOT NULL COMMENT '登录IP',
  `login_location` varchar(100) DEFAULT NULL COMMENT '登录地点',
  `login_type` varchar(20) NOT NULL COMMENT '登录方式：PASSWORD/SMS/OTHER',
  `login_result` varchar(20) NOT NULL COMMENT '登录结果：SUCCESS/FAIL',
  `fail_reason` varchar(100) DEFAULT NULL COMMENT '失败原因',
  `risk_level` varchar(20) DEFAULT 'LOW' COMMENT '风险等级：LOW/MEDIUM/HIGH',
  `risk_detail` varchar(200) DEFAULT NULL COMMENT '风险详情',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_login_time` (`login_time`),
  KEY `idx_uid_logtime` (`user_id`,`login_time`),
  KEY `idx_fb_device_login_log_time_ip_user` (`login_time`,`login_ip`,`user_id`),
  KEY `idx_ip` (`login_ip`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2072766095204888578 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='设备登录日志表';

-- ----------------------------
-- Table structure for fb_fund
-- ----------------------------
DROP TABLE IF EXISTS `fb_fund`;
CREATE TABLE `fb_fund` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(16) NOT NULL COMMENT '基金代码',
  `symbol` varchar(16) DEFAULT NULL COMMENT '符号',
  `name` varchar(100) NOT NULL COMMENT '基金名称',
  `company` varchar(64) DEFAULT NULL COMMENT '公司',
  `ev` varchar(255) DEFAULT NULL COMMENT '估值estimated valuation',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '基金价格',
  `currency` varchar(20) DEFAULT NULL COMMENT '币种',
  `description` varchar(500) DEFAULT NULL COMMENT '产品描述',
  `poster` varchar(255) DEFAULT NULL COMMENT '海报图URL',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `sold_out` tinyint NOT NULL DEFAULT '0' COMMENT '0进行中 1已售罄',
  `sort` int DEFAULT '0',
  `rate_min` decimal(10,2) DEFAULT '0.00' COMMENT '最低收益率',
  `rate_max` decimal(10,2) DEFAULT '0.00' COMMENT '最高收益率',
  `rate` decimal(10,2) DEFAULT '0.00' COMMENT '收益率',
  `min_amount` decimal(10,2) DEFAULT '0.00' COMMENT '最小可投入金额',
  `min_append_amount` decimal(10,2) NOT NULL DEFAULT '100.00' COMMENT '最低追加金额',
  `max_amount` decimal(10,2) DEFAULT '0.00' COMMENT '最大可投入金额',
  `period` int NOT NULL DEFAULT '0' COMMENT '周期',
  `rate_mode` varchar(16) DEFAULT NULL COMMENT '收益率类型: RANGE,FIXED',
  `latest_amount_raised` decimal(20,2) DEFAULT '0.00' COMMENT '最近一次融资金额',
  `lastest_funding_date` datetime DEFAULT NULL COMMENT '最近一次融资日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2057058124767494147 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='投信产品表';

-- ----------------------------
-- Table structure for fb_fund_nav
-- ----------------------------
DROP TABLE IF EXISTS `fb_fund_nav`;
CREATE TABLE `fb_fund_nav` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `fund_code` varchar(150) NOT NULL COMMENT '基金代码',
  `nav` decimal(20,4) NOT NULL COMMENT '单位净值',
  `acc_nav` decimal(20,4) NOT NULL COMMENT '累计净值',
  `daily_growth` decimal(20,4) NOT NULL DEFAULT '0.0000' COMMENT '日涨幅(%)',
  `week_growth` decimal(20,4) DEFAULT '0.0000' COMMENT '周涨幅(%)',
  `month_growth` decimal(20,4) DEFAULT '0.0000' COMMENT '月涨幅(%)',
  `year_growth` decimal(20,4) DEFAULT '0.0000' COMMENT '年涨幅(%)',
  `nav_date` date NOT NULL COMMENT '净值日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code_date` (`fund_code`,`nav_date`),
  KEY `idx_nav_date` (`nav_date`)
) ENGINE=InnoDB AUTO_INCREMENT=2045038606313070594 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='基金净值表';

-- ----------------------------
-- Table structure for fb_fund_order
-- ----------------------------
DROP TABLE IF EXISTS `fb_fund_order`;
CREATE TABLE `fb_fund_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `position_id` bigint NOT NULL COMMENT '持仓ID',
  `fund_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `amount` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '购买金额',
  `start_date` date NOT NULL COMMENT '投入日期',
  `end_date` date DEFAULT NULL COMMENT '到期日期',
  `remaining_days` int DEFAULT '0' COMMENT '剩余天数',
  `status` tinyint DEFAULT '0' COMMENT '0-计息中 1-已到期',
  `rate` decimal(10,2) DEFAULT '0.00' COMMENT '收益率',
  `profit` decimal(10,2) DEFAULT '0.00' COMMENT '每日收益',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `last_profit_date` date DEFAULT NULL COMMENT '该订单最后一次收益计算日期',
  PRIMARY KEY (`id`),
  KEY `idex_poid` (`position_id`),
  KEY `idx_fund_order_position_start` (`position_id`,`start_date`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2072726075160997891 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='投信购买订单表';

-- ----------------------------
-- Table structure for fb_fund_position
-- ----------------------------
DROP TABLE IF EXISTS `fb_fund_position`;
CREATE TABLE `fb_fund_position` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `fund_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '基金代码',
  `amount` decimal(20,4) NOT NULL DEFAULT '0.0000' COMMENT '投入持仓金额',
  `buy_date` date NOT NULL COMMENT '买入日期',
  `start_date` date DEFAULT NULL COMMENT '开始计息日',
  `end_date` date DEFAULT NULL COMMENT '到期日',
  `period` int DEFAULT '0' COMMENT '投资周期(天)',
  `rate` decimal(10,2) DEFAULT '0.00' COMMENT '收益率',
  `profit` decimal(10,2) DEFAULT '0.00' COMMENT '每天收益(预估)',
  `state` enum('ACTIVE','FINISHED','REDEEMED','HOLDING','PENDING','COMPLETED','ONGOING','NONE') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING' COMMENT '进行中-ONGOING, 未投入-NONE',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-结束，1-进行中',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `last_profit_date` date DEFAULT NULL COMMENT '该持仓最后一次收益计算日期(冗余字段)',
  PRIMARY KEY (`id`),
  KEY `idx_uid` (`user_id`),
  KEY `idx_code` (`fund_code`),
  KEY `idx_fund_pos_user_state` (`user_id`,`state`),
  KEY `idx_fund_pos_user_fund_state` (`user_id`,`fund_code`,`state`),
  KEY `idx_fund_pos_state_user` (`state`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2072677165562408962 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='投信用户持仓表';

-- ----------------------------
-- Table structure for fb_fund_product
-- ----------------------------
DROP TABLE IF EXISTS `fb_fund_product`;
CREATE TABLE `fb_fund_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(16) NOT NULL COMMENT '产品代码',
  `alias` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '产品代码别名',
  `trade_pair` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '交易对',
  `name` varchar(100) NOT NULL COMMENT '产品名称',
  `type` varchar(20) NOT NULL COMMENT '产品类型：STOCK-股票, FOREX-外汇, INDEX-指数',
  `market` varchar(20) NOT NULL COMMENT '市场：US-美股, HK-港股',
  `trading_hours` varchar(500) DEFAULT NULL COMMENT '交易时间',
  `description` varchar(500) DEFAULT NULL COMMENT '产品描述',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `dividend_ratio` decimal(10,6) DEFAULT '0.000000' COMMENT '分红比例',
  `odds` decimal(10,6) DEFAULT '2.000000' COMMENT '赔率',
  `currency` varchar(20) DEFAULT NULL COMMENT '币种',
  `period` int DEFAULT '1' COMMENT '周期',
  `total_dividend_rate` decimal(10,6) DEFAULT '0.000000' COMMENT '1.5%',
  `daily_dividend_rate` decimal(10,6) DEFAULT '0.000000' COMMENT '0.015/ period',
  `dividend_end_date` date DEFAULT NULL COMMENT '分红截止日期',
  `dividend_str_date` date DEFAULT NULL COMMENT '分红开始日期',
  `is_locked` int NOT NULL DEFAULT '0' COMMENT '1 封锁。封锁期间不可以卖出',
  `limitBuyCount` int DEFAULT '3' COMMENT '限制购买次数',
  `limitSellDays` int DEFAULT '5' COMMENT '限制卖出时间 购买之日算起（天）',
  `limitBuyAmount` int DEFAULT '10000' COMMENT '限制买入金额',
  `limit_buy_count` int DEFAULT '3' COMMENT '限制购买次数',
  `limit_sell_days` int DEFAULT '5' COMMENT '限制卖出时间 购买之日算起（天）',
  `limit_buy_amount` int DEFAULT '10000' COMMENT '限制买入金额',
  `sort` int DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_type` (`type`),
  KEY `idx_market` (`market`),
  KEY `idx_fund_product_market_status` (`market`,`status`,`code`),
  KEY `idx_fund_product_type_status` (`type`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2011407001287958531 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='产品配置表';

-- ----------------------------
-- Table structure for fb_fund_profit_log
-- ----------------------------
DROP TABLE IF EXISTS `fb_fund_profit_log`;
CREATE TABLE `fb_fund_profit_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `position_id` bigint NOT NULL COMMENT '持仓ID',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `fund_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '基金代码',
  `profit_date` date NOT NULL COMMENT '收益日期',
  `profit_datetime` datetime DEFAULT NULL COMMENT '收益计提精确时间',
  `profit_amount` decimal(20,4) NOT NULL DEFAULT '0.0000' COMMENT '当日收益金额',
  `cumulative_profit` decimal(20,4) NOT NULL DEFAULT '0.0000' COMMENT '累计收益金额',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-无效，1-有效',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_position_profit_date` (`position_id`,`profit_date`),
  KEY `idx_user` (`user_id`) USING BTREE,
  KEY `idx_position` (`position_id`) USING BTREE,
  KEY `idx_order` (`order_id`) USING BTREE,
  KEY `idx_fund_date` (`fund_code`,`profit_date`) USING BTREE,
  KEY `idx_fpl_user_profit_date` (`user_id`,`profit_date`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2072714427323445251 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='投信每日收益记录表';

-- ----------------------------
-- Table structure for fb_identity_verify
-- ----------------------------
DROP TABLE IF EXISTS `fb_identity_verify`;
CREATE TABLE `fb_identity_verify` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `real_name` varchar(50) NOT NULL COMMENT '真实姓名',
  `id_card_no` varchar(18) NOT NULL COMMENT '身份证号',
  `id_card_front` mediumtext COMMENT '身份证正面照片',
  `id_card_back` mediumtext COMMENT '身份证反面照片',
  `status` varchar(20) NOT NULL COMMENT '认证状态：PENDING-待审核 VERIFIED-已通过 REJECTED-已拒绝',
  `reject_reason` varchar(255) DEFAULT NULL COMMENT '拒绝原因',
  `verified_at` datetime DEFAULT NULL COMMENT '认证通过/拒绝时间',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_id_card_no` (`id_card_no`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_identity_user_created` (`user_id`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2072721113320337410 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实名认证表';

-- ----------------------------
-- Table structure for fb_identity_verify_photo
-- ----------------------------
DROP TABLE IF EXISTS `fb_identity_verify_photo`;
CREATE TABLE `fb_identity_verify_photo` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `id_card_front` mediumtext COMMENT '身份证正面照片',
  `id_card_back` mediumtext COMMENT '身份证反面照片',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实名认证表';

-- ----------------------------
-- Table structure for fb_kill_rate_v6_audit
-- ----------------------------
DROP TABLE IF EXISTS `fb_kill_rate_v6_audit`;
CREATE TABLE `fb_kill_rate_v6_audit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `stat_date` date NOT NULL,
  `audit_type` varchar(32) NOT NULL,
  `base_balance` decimal(24,8) DEFAULT NULL,
  `daily_pnl` decimal(24,8) DEFAULT NULL,
  `target_pnl` decimal(24,8) DEFAULT NULL,
  `tolerance` decimal(24,8) DEFAULT NULL,
  `kill_rate` decimal(10,8) DEFAULT NULL,
  `symbol` varchar(32) DEFAULT NULL,
  `direction` tinyint DEFAULT NULL,
  `open_price` decimal(24,8) DEFAULT NULL,
  `suggested_result` varchar(20) DEFAULT NULL,
  `natural_close_price` decimal(24,8) DEFAULT NULL,
  `adjusted_close_price` decimal(24,8) DEFAULT NULL,
  `old_state` varchar(32) DEFAULT NULL,
  `new_state` varchar(32) DEFAULT NULL,
  `reason` varchar(512) DEFAULT NULL,
  `environment` varchar(32) DEFAULT NULL,
  `version` varchar(16) DEFAULT NULL,
  `trace_id` varchar(64) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_date` (`user_id`,`stat_date`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_audit_type` (`audit_type`),
  KEY `idx_created_at` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=44190 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='杀率V6审计';

-- ----------------------------
-- Table structure for fb_kill_rate_v6_base_balance
-- ----------------------------
DROP TABLE IF EXISTS `fb_kill_rate_v6_base_balance`;
CREATE TABLE `fb_kill_rate_v6_base_balance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `stat_date` date NOT NULL,
  `base_balance` decimal(24,8) NOT NULL DEFAULT '0.00000000',
  `source` varchar(32) NOT NULL DEFAULT 'before-first-order',
  `environment` varchar(32) NOT NULL DEFAULT 'simulation',
  `version` varchar(16) NOT NULL DEFAULT 'v6',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_stat_date` (`user_id`,`stat_date`),
  KEY `idx_stat_date` (`stat_date`)
) ENGINE=InnoDB AUTO_INCREMENT=6488 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='杀率V6日基准余额B0';

-- ----------------------------
-- Table structure for fb_kill_rate_v6_daily_state
-- ----------------------------
DROP TABLE IF EXISTS `fb_kill_rate_v6_daily_state`;
CREATE TABLE `fb_kill_rate_v6_daily_state` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `stat_date` date NOT NULL,
  `base_balance_usdt` decimal(24,8) NOT NULL DEFAULT '0.00000000',
  `day_pnl` decimal(24,8) NOT NULL DEFAULT '0.00000000',
  `effective_kill_rate` decimal(10,8) DEFAULT NULL,
  `target_pnl` decimal(24,8) DEFAULT NULL,
  `tolerance` decimal(24,8) DEFAULT NULL,
  `state` varchar(32) NOT NULL DEFAULT 'INIT',
  `b1` decimal(24,8) DEFAULT NULL,
  `pattern_index` int NOT NULL DEFAULT '0',
  `consecutive_count` bigint NOT NULL DEFAULT '0',
  `last_result` varchar(16) DEFAULT 'NONE',
  `target_reached_at` datetime DEFAULT NULL,
  `version` bigint NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_stat_date` (`user_id`,`stat_date`)
) ENGINE=InnoDB AUTO_INCREMENT=334 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='杀率V6日状态';

-- ----------------------------
-- Table structure for fb_lucky_draw_records
-- ----------------------------
DROP TABLE IF EXISTS `fb_lucky_draw_records`;
CREATE TABLE `fb_lucky_draw_records` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `prize_type` varchar(32) NOT NULL COMMENT '奖品类型(CASH:现金, COUPON:优惠券, NONE:未中奖)',
  `amount` decimal(10,2) DEFAULT NULL COMMENT '奖励金额',
  `prize_desc` varchar(64) NOT NULL COMMENT '奖品描述',
  `status` varchar(32) NOT NULL COMMENT '状态(PENDING:待领取, RECEIVED:已领取)',
  `draw_time` datetime NOT NULL COMMENT '抽奖时间',
  `receive_time` datetime DEFAULT NULL COMMENT '领取时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_draw_time` (`draw_time`),
  KEY `idx_prize_type` (`prize_type`),
  KEY `idx_lucky_user_created` (`user_id`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2000253324112293891 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='抽奖记录表';

-- ----------------------------
-- Table structure for fb_market_data
-- ----------------------------
DROP TABLE IF EXISTS `fb_market_data`;
CREATE TABLE `fb_market_data` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `symbol` varchar(20) NOT NULL COMMENT '交易代码',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `type` varchar(10) NOT NULL COMMENT '类型：STOCK/FUND/FOREX/BOND',
  `price` decimal(20,4) NOT NULL COMMENT '当前价格',
  `change` decimal(20,4) NOT NULL COMMENT '涨跌额',
  `change_percent` decimal(10,4) NOT NULL COMMENT '涨跌幅',
  `open` decimal(20,4) DEFAULT NULL COMMENT '开盘价',
  `high` decimal(20,4) DEFAULT NULL COMMENT '最高价',
  `low` decimal(20,4) DEFAULT NULL COMMENT '最低价',
  `volume` decimal(20,4) NOT NULL COMMENT '成交量',
  `amount` decimal(20,4) NOT NULL COMMENT '成交额',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `code` varchar(100) DEFAULT NULL COMMENT '产品代码',
  `trade_date` datetime DEFAULT NULL COMMENT '交易时间',
  `direction` int DEFAULT NULL COMMENT '交易方向：0-买，1-卖',
  `seq` varchar(32) DEFAULT NULL COMMENT '序列号',
  PRIMARY KEY (`id`),
  KEY `idx_symbol` (`symbol`),
  KEY `idx_type` (`type`),
  KEY `idx_update_time` (`update_time`),
  KEY `idx_seq` (`seq`),
  KEY `idx_direction` (`direction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='市场数据';

-- ----------------------------
-- Table structure for fb_market_data_latest
-- ----------------------------
DROP TABLE IF EXISTS `fb_market_data_latest`;
CREATE TABLE `fb_market_data_latest` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(32) NOT NULL COMMENT '产品代码',
  `alias` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '产品代码别名',
  `symbol` varchar(32) NOT NULL COMMENT '交易代码',
  `name` varchar(100) NOT NULL COMMENT '名称',
  `type` varchar(20) NOT NULL COMMENT '类型：STOCK/FUND/FOREX/BOND',
  `price` decimal(20,4) NOT NULL COMMENT '当前价格',
  `change` decimal(20,4) NOT NULL COMMENT '涨跌额',
  `change_percent` decimal(10,2) NOT NULL COMMENT '涨跌幅',
  `open` decimal(20,4) DEFAULT NULL COMMENT '开盘价',
  `high` decimal(20,4) DEFAULT NULL COMMENT '最高价',
  `low` decimal(20,4) DEFAULT NULL COMMENT '最低价',
  `volume` decimal(20,4) NOT NULL COMMENT '成交量',
  `amount` decimal(20,4) NOT NULL COMMENT '成交额',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `trade_date` datetime DEFAULT NULL COMMENT '交易时间',
  `direction` int DEFAULT NULL COMMENT '交易方向：0-买，1-卖',
  `seq` varchar(32) DEFAULT NULL COMMENT '序列号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_type` (`type`),
  KEY `idx_update_time` (`update_time`),
  KEY `idx_seq` (`seq`),
  KEY `idx_direction` (`direction`),
  KEY `idx_market_latest_type_updatetime` (`type`,`update_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2033487641424461826 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='最新交易数据表';

-- ----------------------------
-- Table structure for fb_market_kline_data
-- ----------------------------
DROP TABLE IF EXISTS `fb_market_kline_data`;
CREATE TABLE `fb_market_kline_data` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(32) NOT NULL COMMENT '产品代码',
  `symbol` varchar(32) NOT NULL COMMENT '产品符号',
  `kline_type` int NOT NULL COMMENT 'K线类型：1-1分钟，2-5分钟，3-15分钟，4-30分钟，5-1小时，6-2小时，7-4小时，8-日K，9-周K，10-月K',
  `timestamp` bigint NOT NULL COMMENT 'K线时间戳',
  `open_price` decimal(20,6) NOT NULL COMMENT '开盘价',
  `close_price` decimal(20,6) NOT NULL COMMENT '收盘价',
  `high_price` decimal(20,6) NOT NULL COMMENT '最高价',
  `low_price` decimal(20,6) NOT NULL COMMENT '最低价',
  `volume` decimal(20,6) NOT NULL COMMENT '成交量',
  `turnover` decimal(20,6) NOT NULL COMMENT '成交额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code_type_time` (`code`,`kline_type`,`timestamp`),
  KEY `idx_code` (`code`),
  KEY `idx_type` (`kline_type`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=324348 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='市场K线数据表';

-- ----------------------------
-- Table structure for fb_market_news
-- ----------------------------
DROP TABLE IF EXISTS `fb_market_news`;
CREATE TABLE `fb_market_news` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT '新闻标题',
  `summary` text COMMENT '新闻摘要',
  `content` longtext COMMENT '新闻内容',
  `source` varchar(150) DEFAULT NULL COMMENT '新闻来源',
  `category` varchar(350) DEFAULT NULL COMMENT '新闻分类',
  `url` varchar(255) DEFAULT NULL COMMENT '新闻链接',
  `image_url` varchar(255) DEFAULT NULL COMMENT '新闻图片',
  `view_count` int DEFAULT '0' COMMENT '浏览次数',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_title` (`title`),
  KEY `idx_publish_time` (`publish_time`) USING BTREE,
  KEY `idx_category` (`category`) USING BTREE,
  KEY `idx_news_created_at` (`created_at`),
  KEY `idx_news_category_publish` (`category`,`publish_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2072688728617316355 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='市场新闻表';

-- ----------------------------
-- Table structure for fb_market_trade_data
-- ----------------------------
DROP TABLE IF EXISTS `fb_market_trade_data`;
CREATE TABLE `fb_market_trade_data` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(32) NOT NULL COMMENT '产品代码',
  `symbol` varchar(32) DEFAULT NULL COMMENT '产品符号',
  `type` varchar(32) DEFAULT NULL COMMENT '产品类型',
  `price` decimal(20,8) NOT NULL COMMENT '成交价格',
  `volume` decimal(20,8) NOT NULL COMMENT '成交量',
  `amount` decimal(20,8) DEFAULT NULL COMMENT '成交额',
  `direction` int NOT NULL COMMENT '交易方向，0为默认值，1为BUY，2为SELL',
  `change_price` decimal(20,8) DEFAULT NULL COMMENT '涨跌额',
  `change_percent` decimal(10,4) DEFAULT NULL COMMENT '涨跌幅(%)',
  `trade_time` bigint NOT NULL COMMENT '成交时间戳',
  `seq` varchar(32) NOT NULL COMMENT '成交序列号',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_code` (`code`),
  KEY `idx_type` (`type`),
  KEY `idx_trade_time` (`trade_time`),
  KEY `idx_seq` (`seq`),
  KEY `idx_direction` (`direction`),
  KEY `idx_code_time` (`code`,`trade_time`),
  KEY `idx_code_seq` (`code`,`seq`)
) ENGINE=InnoDB AUTO_INCREMENT=2069184514 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实时交易数据表';

-- ----------------------------
-- Table structure for fb_notification
-- ----------------------------
DROP TABLE IF EXISTS `fb_notification`;
CREATE TABLE `fb_notification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint DEFAULT NULL COMMENT '接收用户ID',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '通知标题',
  `content` text NOT NULL COMMENT '通知内容',
  `type` tinyint NOT NULL DEFAULT '1' COMMENT '通知类型 1=系统通知 2=交易提醒 3=账户变动 4=活动通知',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '阅读状态 0=未读 1=已读',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '删除标记 0=正常 1=删除',
  `send_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_status` (`user_id`,`status`),
  KEY `idx_send_time` (`send_time`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2025505642797699074 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户通知表';

-- ----------------------------
-- Table structure for fb_pay_password_error_log
-- ----------------------------
DROP TABLE IF EXISTS `fb_pay_password_error_log`;
CREATE TABLE `fb_pay_password_error_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `error_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '错误时间',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `device_info` varchar(200) DEFAULT NULL COMMENT '设备信息',
  `operation_type` varchar(20) NOT NULL COMMENT '操作类型：WITHDRAW-提现 TRANSFER-转账等',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_error_time` (`error_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='交易密码错误记录';

-- ----------------------------
-- Table structure for fb_pay_password_history
-- ----------------------------
DROP TABLE IF EXISTS `fb_pay_password_history`;
CREATE TABLE `fb_pay_password_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `old_password` varchar(32) DEFAULT NULL COMMENT '旧密码(MD5加密)',
  `new_password` varchar(32) NOT NULL COMMENT '新密码(MD5加密)',
  `change_type` varchar(20) NOT NULL COMMENT '修改类型：SET-首次设置 RESET-重置 CHANGE-修改',
  `change_reason` varchar(50) DEFAULT NULL COMMENT '修改原因',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `device_info` varchar(200) DEFAULT NULL COMMENT '设备信息',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `created_by` bigint NOT NULL COMMENT '创建人ID',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='交易密码修改记录';

-- ----------------------------
-- Table structure for fb_pay_password_verify_log
-- ----------------------------
DROP TABLE IF EXISTS `fb_pay_password_verify_log`;
CREATE TABLE `fb_pay_password_verify_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `verify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '验证时间',
  `verify_result` tinyint(1) NOT NULL COMMENT '验证结果：0-失败 1-成功',
  `operation_type` varchar(20) NOT NULL COMMENT '操作类型：WITHDRAW-提现 TRANSFER-转账等',
  `operation_amount` decimal(20,2) DEFAULT NULL COMMENT '操作金额',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `device_info` varchar(200) DEFAULT NULL COMMENT '设备信息',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_verify_time` (`verify_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='交易密码验证记录';

-- ----------------------------
-- Table structure for fb_prize_config
-- ----------------------------
DROP TABLE IF EXISTS `fb_prize_config`;
CREATE TABLE `fb_prize_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '奖品名称',
  `type` varchar(20) NOT NULL COMMENT '奖品类型：CASH(现金), COUPON(优惠券), TICKET(抽奖券)',
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '奖品金额/数量',
  `probability` decimal(5,2) NOT NULL COMMENT '中奖概率(%)',
  `daily_limit` int NOT NULL DEFAULT '0' COMMENT '每日限制数量',
  `total_limit` int NOT NULL DEFAULT '0' COMMENT '总限制数量',
  `remaining` int NOT NULL DEFAULT '0' COMMENT '剩余数量',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE(生效), INACTIVE(未生效), EXPIRED(已过期)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_prize_status_time` (`status`,`start_time`,`end_time`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COMMENT='奖品配置表';

-- ----------------------------
-- Table structure for fb_product_config
-- ----------------------------
DROP TABLE IF EXISTS `fb_product_config`;
CREATE TABLE `fb_product_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(32) NOT NULL COMMENT '产品代码',
  `name` varchar(100) NOT NULL COMMENT '产品名称',
  `type` varchar(20) NOT NULL COMMENT '产品类型：STOCK-股票, FOREX-外汇, INDEX-指数',
  `market` varchar(20) NOT NULL COMMENT '市场：US-美股, HK-港股',
  `trading_hours` varchar(500) DEFAULT NULL COMMENT '交易时间',
  `description` varchar(500) DEFAULT NULL COMMENT '产品描述',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `dividend_ratio` decimal(10,6) DEFAULT '0.000000' COMMENT '分红比例',
  `currency` varchar(20) DEFAULT NULL COMMENT '币种',
  `period` int DEFAULT '1' COMMENT '周期',
  `total_dividend_rate` decimal(10,6) NOT NULL COMMENT '1.5%',
  `daily_dividend_rate` decimal(10,6) NOT NULL COMMENT '0.015/ period',
  `dividend_end_date` date DEFAULT NULL COMMENT '分红截止日期',
  `dividend_str_date` date DEFAULT NULL COMMENT '分红开始日期',
  `is_locked` int NOT NULL DEFAULT '0' COMMENT '1 封锁。封锁期间不可以卖出',
  `limitBuyCount` int DEFAULT '3' COMMENT '限制购买次数',
  `limitSellDays` int DEFAULT '5' COMMENT '限制卖出时间 购买之日算起（天）',
  `limitBuyAmount` int DEFAULT '10000' COMMENT '限制买入金额',
  `limit_buy_count` int DEFAULT '3' COMMENT '限制购买次数',
  `limit_sell_days` int DEFAULT '5' COMMENT '限制卖出时间 购买之日算起（天）',
  `limit_buy_amount` int DEFAULT '10000' COMMENT '限制买入金额',
  `sort` int DEFAULT '0',
  `odds` decimal(10,6) DEFAULT '2.000000' COMMENT '赔率',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_type` (`type`),
  KEY `idx_market` (`market`)
) ENGINE=InnoDB AUTO_INCREMENT=2002707777839034371 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='产品配置表';

-- ----------------------------
-- Table structure for fb_profit_records
-- ----------------------------
DROP TABLE IF EXISTS `fb_profit_records`;
CREATE TABLE `fb_profit_records` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `amount` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '盈亏金额',
  `trade_count` int NOT NULL DEFAULT '0' COMMENT '交易笔数',
  `record_time` datetime NOT NULL COMMENT '记录时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_time` (`user_id`,`record_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2062188809138737154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='盈亏记录表';

-- ----------------------------
-- Table structure for fb_sign_in_records
-- ----------------------------
DROP TABLE IF EXISTS `fb_sign_in_records`;
CREATE TABLE `fb_sign_in_records` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `sign_in_time` datetime NOT NULL COMMENT '签到时间',
  `continuous_days` int NOT NULL DEFAULT '1' COMMENT '连续签到天数',
  `reward` varchar(32) NOT NULL COMMENT '签到奖励',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_sign_in_time` (`sign_in_time`),
  KEY `idx_signin_user_time` (`user_id`,`sign_in_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2062164324541046786 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='签到记录表';

-- ----------------------------
-- Table structure for fb_trade_deal
-- ----------------------------
DROP TABLE IF EXISTS `fb_trade_deal`;
CREATE TABLE `fb_trade_deal` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '成交ID',
  `deal_no` varchar(32) NOT NULL COMMENT '成交编号',
  `order_id` bigint NOT NULL COMMENT '委托订单ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `market` varchar(16) NOT NULL COMMENT '市场代码',
  `stock_code` varchar(16) NOT NULL COMMENT '股票代码',
  `deal_type` tinyint NOT NULL COMMENT '成交类型：1买入 2卖出',
  `price` decimal(10,2) NOT NULL COMMENT '成交价格',
  `volume` int NOT NULL COMMENT '成交数量',
  `amount` decimal(16,2) NOT NULL COMMENT '成交金额',
  `fee` decimal(10,2) NOT NULL COMMENT '手续费',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '成交时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_market_code` (`market`,`stock_code`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2011304292064964610 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='成交记录表';

-- ----------------------------
-- Table structure for fb_trade_order
-- ----------------------------
DROP TABLE IF EXISTS `fb_trade_order`;
CREATE TABLE `fb_trade_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(32) NOT NULL COMMENT '订单编号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `market` varchar(16) NOT NULL COMMENT '市场代码',
  `stock_code` varchar(16) NOT NULL COMMENT '股票代码',
  `order_type` tinyint NOT NULL COMMENT '订单类型：1买入 2卖出',
  `price` decimal(10,2) NOT NULL COMMENT '委托价格',
  `volume` int NOT NULL COMMENT '委托数量',
  `amount` decimal(20,4) DEFAULT '0.0000' COMMENT '金额',
  `deal_volume` int DEFAULT '0' COMMENT '成交数量',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '订单状态：0未成交 1部分成交 2全部成交 3已撤单 4已拒绝',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `stop_price` decimal(20,4) DEFAULT NULL COMMENT '止损价格',
  `price_type` varchar(20) DEFAULT NULL COMMENT '价格类型',
  `price_float` decimal(10,4) DEFAULT NULL COMMENT '价格浮动范围',
  `expiry` varchar(10) DEFAULT NULL COMMENT '委托有效期',
  `fee` decimal(20,4) DEFAULT NULL COMMENT '手续费',
  `direction` int DEFAULT NULL COMMENT '交易方向 1买入 2卖出',
  `limit_price` decimal(20,4) DEFAULT NULL COMMENT '限价',
  `deal_type` tinyint(1) DEFAULT NULL COMMENT '1买入 2卖出',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_market_code` (`market`,`stock_code`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2011304272710385666 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='委托订单表';

-- ----------------------------
-- Table structure for fb_trade_position
-- ----------------------------
DROP TABLE IF EXISTS `fb_trade_position`;
CREATE TABLE `fb_trade_position` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '持仓ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `market` varchar(16) NOT NULL COMMENT '市场代码',
  `stock_code` varchar(16) NOT NULL COMMENT '股票代码',
  `total_volume` int NOT NULL DEFAULT '0' COMMENT '总持仓数量',
  `available_volume` int NOT NULL DEFAULT '0' COMMENT '可用数量',
  `frozen_volume` int NOT NULL DEFAULT '0' COMMENT '冻结数量',
  `avg_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '持仓均价',
  `market_value` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT '市值',
  `profit_loss` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT '浮动盈亏',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_stock` (`user_id`,`market`,`stock_code`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_market_code` (`market`,`stock_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2011304292174016515 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='持仓表';

-- ----------------------------
-- Table structure for fb_usdt_addresses
-- ----------------------------
DROP TABLE IF EXISTS `fb_usdt_addresses`;
CREATE TABLE `fb_usdt_addresses` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `address` varchar(100) NOT NULL COMMENT 'USDT地址',
  `masked_address` varchar(50) NOT NULL COMMENT '掩码处理后的地址',
  `network` varchar(20) NOT NULL COMMENT '网络类型(TRC20,ERC20)',
  `address_name` varchar(50) DEFAULT NULL COMMENT '地址备注名称',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否默认地址',
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态(ACTIVE,DELETED)',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_is_default` (`is_default`),
  KEY `idx_usdt_user_status` (`user_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2072579020534919171 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='USDT提款地址表';

-- ----------------------------
-- Table structure for fb_user_devices
-- ----------------------------
DROP TABLE IF EXISTS `fb_user_devices`;
CREATE TABLE `fb_user_devices` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `device_id` varchar(64) NOT NULL COMMENT '设备唯一标识',
  `device_name` varchar(100) NOT NULL COMMENT '设备名称',
  `device_type` varchar(100) NOT NULL COMMENT '设备类型：ANDROID/IOS/WEB',
  `device_model` varchar(100) DEFAULT NULL COMMENT '设备型号',
  `os_version` varchar(100) DEFAULT NULL COMMENT '操作系统版本',
  `app_version` varchar(100) DEFAULT NULL COMMENT 'APP版本',
  `last_login_ip` varchar(50) DEFAULT NULL COMMENT '最后登录IP',
  `last_login_location` varchar(100) DEFAULT NULL COMMENT '最后登录地点',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `is_current` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否当前设备',
  `is_trusted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否受信任设备',
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE-正常 BLOCKED-已禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '首次登录时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_device` (`user_id`,`device_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_last_login_time` (`last_login_time`),
  KEY `idx_user_devices_user_status` (`user_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2072761193909006338 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户设备记录表';

-- ----------------------------
-- Table structure for fb_user_wallets
-- ----------------------------
DROP TABLE IF EXISTS `fb_user_wallets`;
CREATE TABLE `fb_user_wallets` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '钱包ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `account_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'STOCK' COMMENT '账户类型：STOCK-股票账户，FOREX-外汇账户，FUTURES-期货账户',
  `balance` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
  `frozen_amount` decimal(20,2) NOT NULL DEFAULT '0.00' COMMENT '冻结金额',
  `frozen` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否冻结',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `version` bigint NOT NULL DEFAULT '0' COMMENT '版本号',
  `currency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'CNY' COMMENT '种类',
  `draw_ticket` int NOT NULL DEFAULT '0' COMMENT '抽奖券数量',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_uid_at_c` (`user_id`,`account_type`,`currency`) USING BTREE,
  KEY `idx_uid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2072715960387186690 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户钱包表';

-- ----------------------------
-- Table structure for fb_users
-- ----------------------------
DROP TABLE IF EXISTS `fb_users`;
CREATE TABLE `fb_users` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(120) DEFAULT NULL COMMENT '手机号',
  `phone` varchar(120) DEFAULT NULL COMMENT '手机号',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `id_card` varchar(108) DEFAULT NULL COMMENT '身份证号',
  `verification_status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '实名认证状态',
  `credit_score` int DEFAULT '100' COMMENT '信用分数',
  `security_question` varchar(200) DEFAULT NULL COMMENT '密保问题',
  `security_answer` varchar(200) DEFAULT NULL COMMENT '密保答案',
  `role` varchar(20) NOT NULL DEFAULT 'USER' COMMENT '用户角色',
  `account_locked` tinyint(1) NOT NULL DEFAULT '0' COMMENT '账户是否锁定',
  `failed_attempts` int NOT NULL DEFAULT '0' COMMENT '登录失败次数',
  `last_login` datetime DEFAULT NULL COMMENT '最后登录时间',
  `parent_id` bigint DEFAULT NULL COMMENT '上级代理ID',
  `level` int NOT NULL DEFAULT '0' COMMENT '代理等级',
  `agent_level` tinyint NOT NULL DEFAULT '3' COMMENT '团队代理层级：3=仅三级；4=含四级；5=含五级',
  `invite_code` varchar(20) DEFAULT NULL COMMENT '邀请码',
  `commission_rate` decimal(5,2) DEFAULT '0.00' COMMENT '佣金比例',
  `total_commission` decimal(20,2) DEFAULT '0.00' COMMENT '累计佣金',
  `team_size` int DEFAULT '0' COMMENT '团队规模',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  `status` varchar(20) DEFAULT NULL COMMENT '用户状态',
  `verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已实名认证：0-未认证 1-已认证',
  `pay_password` varchar(32) DEFAULT NULL COMMENT '交易密码(MD5加密)',
  `pay_password_updated_at` datetime DEFAULT NULL COMMENT '交易密码最后更新时间',
  `pay_password_error_count` int DEFAULT '0' COMMENT '交易密码错误次数',
  `pay_password_locked_until` datetime DEFAULT NULL COMMENT '交易密码锁定截止时间',
  `avatar` text COMMENT '用户头像(base64)',
  `contract_control` int DEFAULT '3' COMMENT '合约控制 1 = 赢  2 = 输  3 = 自然',
  `is_online` varchar(10) NOT NULL DEFAULT '0',
  `remark` varchar(100) DEFAULT NULL COMMENT '说明',
  `flag` tinyint NOT NULL DEFAULT '0' COMMENT '0正常1删除',
  `is_test` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否测试账号：0-正式 1-测试',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  UNIQUE KEY `uk_phone` (`mobile`),
  UNIQUE KEY `uk_invite_code` (`invite_code`),
  UNIQUE KEY `id_id_card` (`id_card`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_users_parent_flag` (`parent_id`,`flag`),
  KEY `idx_users_real_name_id_card` (`real_name`,`id_card`),
  KEY `idx_users_created_at` (`created_at`),
  KEY `idx_users_real` (`flag`,`is_test`),
  CONSTRAINT `fb_users_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `fb_users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2072715959128895491 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';

-- ----------------------------
-- Table structure for fb_weekly_rewards
-- ----------------------------
DROP TABLE IF EXISTS `fb_weekly_rewards`;
CREATE TABLE `fb_weekly_rewards` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `week_start` date NOT NULL COMMENT '周开始日期',
  `week_end` date NOT NULL COMMENT '周结束日期',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态(0:未达成 1:可领取 2:已领取)',
  `reward` varchar(32) DEFAULT NULL COMMENT '奖励内容',
  `receive_time` datetime DEFAULT NULL COMMENT '领取时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_week` (`user_id`,`week_start`),
  KEY `idx_week_start` (`week_start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='周礼包记录表';

-- ----------------------------
-- Table structure for fb_withdraws
-- ----------------------------
DROP TABLE IF EXISTS `fb_withdraws`;
CREATE TABLE `fb_withdraws` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `order_no` varchar(48) NOT NULL COMMENT '订单号',
  `amount` decimal(20,2) NOT NULL COMMENT '提现金额',
  `status` varchar(20) NOT NULL COMMENT '状态',
  `bank_name` varchar(50) NOT NULL COMMENT '银行名称',
  `bank_card_no` varchar(100) NOT NULL COMMENT '银行卡号',
  `account_name` varchar(50) NOT NULL COMMENT '开户名',
  `payment_status` varchar(20) NOT NULL COMMENT '支付状态',
  `payment_no` varchar(64) DEFAULT NULL COMMENT '银行转账流水号',
  `payment_time` datetime DEFAULT NULL COMMENT '支付时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `reject_reason` varchar(255) DEFAULT NULL COMMENT '拒绝原因',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `withdraw_type` varchar(10) NOT NULL DEFAULT 'CNY',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_withdraws_user_status_created` (`user_id`,`status`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2072619230060687362 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='提现记录表';

SET FOREIGN_KEY_CHECKS = 1;
