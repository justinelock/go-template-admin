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

 Date: 03/07/2026 18:24:45
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

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL COMMENT '编号',
  `data_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '数据源名称',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表';

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表字段';

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

 Date: 03/07/2026 17:43:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_client
-- ----------------------------
DROP TABLE IF EXISTS `sys_client`;
CREATE TABLE `sys_client` (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `client_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端id',
  `client_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端key',
  `client_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端秘钥',
  `grant_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '授权类型',
  `device_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '设备类型',
  `active_timeout` int DEFAULT '1800' COMMENT 'token活跃超时时间',
  `timeout` int DEFAULT '604800' COMMENT 'token固定超时',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统授权表';

-- ----------------------------
-- Records of sys_client
-- ----------------------------
BEGIN;
INSERT INTO `sys_client` (`id`, `client_id`, `client_key`, `client_secret`, `grant_type`, `device_type`, `active_timeout`, `timeout`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1', 'e5cd7e4891bf95d1d19206ce24a7b32e', 'pc', 'pc123', 'password,social', 'pc', 1800, 604800, '0', '0', 103, 1, '2025-07-18 15:18:39', 1, '2025-07-18 15:18:39');
INSERT INTO `sys_client` (`id`, `client_id`, `client_key`, `client_secret`, `grant_type`, `device_type`, `active_timeout`, `timeout`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2', '428a8310cd442757ae699df5d894f051', 'app', 'app123', 'password,sms,social', 'android', 1800, 604800, '0', '0', 103, 1, '2025-07-18 15:18:39', 1, '2025-07-18 15:18:39');
COMMIT;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `config_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参数主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='参数配置表';

-- ----------------------------
-- Records of sys_config
-- ----------------------------
BEGIN;
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1', '000000', '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 103, 1, '2025-07-18 15:18:38', 1, '2026-06-24 17:15:54', '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('11', '000000', 'OSS预览列表资源开关', 'sys.oss.previewListResource', 'true', 'Y', 103, 1, '2025-07-18 15:18:38', NULL, NULL, 'true:开启, false:关闭');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2', '000000', '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '初始化密码 123456');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('3', '000000', '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('5', '000000', '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '是否开启注册用户功能（true开启，false关闭）');
COMMIT;

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `dept_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门id',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `parent_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '部门名称',
  `dept_category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '部门类别编码',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
BEGIN;
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `dept_category`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('100', '000000', '0', '0', '集团', '', 0, NULL, '13800138000', 'info@fubonplus.com', '0', '0', 103, 1, '2025-07-18 15:18:26', 1, '2026-06-24 19:02:10');
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `dept_category`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('101', '000000', '100', '0,100', '深圳总公司', NULL, 1, NULL, '15888888888', 'xxx@qq.com', '0', '0', 103, 1, '2025-07-18 15:18:26', NULL, NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `dept_category`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('103', '000000', '101', '0,100,101', '研发部门', NULL, 1, '1', '15888888888', 'xxx@qq.com', '0', '0', 103, 1, '2025-07-18 15:18:26', NULL, NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `dept_category`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('104', '000000', '101', '0,100,101', '市场部门', NULL, 2, NULL, '15888888888', 'xxx@qq.com', '0', '0', 103, 1, '2025-07-18 15:18:26', NULL, NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `dept_category`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('105', '000000', '101', '0,100,101', '测试部门', NULL, 3, NULL, '15888888888', 'xxx@qq.com', '0', '0', 103, 1, '2025-07-18 15:18:26', NULL, NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `dept_category`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('106', '000000', '101', '0,100,101', '财务部门', NULL, 4, NULL, '15888888888', 'xxx@qq.com', '0', '0', 103, 1, '2025-07-18 15:18:26', NULL, NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `dept_category`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('107', '000000', '101', '0,100,101', '运维部门', NULL, 5, NULL, '15888888888', 'xxx@qq.com', '0', '0', 103, 1, '2025-07-18 15:18:26', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
  `dict_code` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典编码',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据表';

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1', '000000', 1, '男', '0', 'sys_user_sex', '', '', 'Y', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '性别男');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('12', '000000', 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '系统默认是');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('13', '000000', 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '系统默认否');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('14', '000000', 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '通知');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('15', '000000', 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '公告');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('16', '000000', 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('17', '000000', 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '关闭状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('18', '000000', 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '新增操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('19', '000000', 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '修改操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2', '000000', 2, '女', '1', 'sys_user_sex', '', '', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '性别女');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('20', '000000', 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '删除操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('21', '000000', 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '授权操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('22', '000000', 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '导出操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('23', '000000', 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '导入操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('24', '000000', 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '强退操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('25', '000000', 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '生成操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('26', '000000', 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '清空操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('27', '000000', 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('28', '000000', 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('29', '000000', 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '其他操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('3', '000000', 3, '未知', '2', 'sys_user_sex', '', '', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '性别未知');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('30', '000000', 0, '密码认证', 'password', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '密码认证');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('31', '000000', 0, '短信认证', 'sms', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '短信认证');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('32', '000000', 0, '邮件认证', 'email', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '邮件认证');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('33', '000000', 0, '小程序认证', 'xcx', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '小程序认证');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('34', '000000', 0, '三方登录认证', 'social', 'sys_grant_type', 'el-check-tag', 'default', 'N', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '三方登录认证');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('35', '000000', 0, 'PC', 'pc', 'sys_device_type', '', 'default', 'N', 103, 1, '2025-07-18 15:18:38', NULL, NULL, 'PC');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('36', '000000', 0, '安卓', 'android', 'sys_device_type', '', 'default', 'N', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '安卓');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('37', '000000', 0, 'iOS', 'ios', 'sys_device_type', '', 'default', 'N', 103, 1, '2025-07-18 15:18:38', NULL, NULL, 'iOS');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('38', '000000', 0, '小程序', 'xcx', 'sys_device_type', '', 'default', 'N', 103, 1, '2025-07-18 15:18:38', NULL, NULL, '小程序');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('4', '000000', 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '显示菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('5', '000000', 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('6', '000000', 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('7', '000000', 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '停用状态');
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `dict_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '字典类型',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE KEY `tenant_id` (`tenant_id`,`dict_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1', '000000', '用户性别', 'sys_user_sex', 103, 1, '2025-07-18 15:18:36', NULL, NULL, '用户性别列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('10', '000000', '系统状态', 'sys_common_status', 103, 1, '2025-07-18 15:18:36', NULL, NULL, '登录状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('11', '000000', '授权类型', 'sys_grant_type', 103, 1, '2025-07-18 15:18:36', NULL, NULL, '认证授权类型');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('12', '000000', '设备类型', 'sys_device_type', 103, 1, '2025-07-18 15:18:37', NULL, NULL, '客户端设备类型');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2', '000000', '菜单状态', 'sys_show_hide', 103, 1, '2025-07-18 15:18:36', NULL, NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('3', '000000', '系统开关', 'sys_normal_disable', 103, 1, '2025-07-18 15:18:36', NULL, NULL, '系统开关列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('6', '000000', '系统是否', 'sys_yes_no', 103, 1, '2025-07-18 15:18:36', NULL, NULL, '系统是否列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('7', '000000', '通知类型', 'sys_notice_type', 103, 1, '2025-07-18 15:18:36', NULL, NULL, '通知类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('8', '000000', '通知状态', 'sys_notice_status', 103, 1, '2025-07-18 15:18:36', NULL, NULL, '通知状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('9', '000000', '操作类型', 'sys_oper_type', 103, 1, '2025-07-18 15:18:36', NULL, NULL, '操作类型列表');
COMMIT;

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor` (
  `info_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '访问ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '用户账号',
  `client_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '客户端',
  `device_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '设备类型',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  KEY `idx_sys_logininfor_s` (`status`) USING BTREE,
  KEY `idx_sys_logininfor_lt` (`login_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统访问记录';

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
BEGIN;
INSERT INTO `sys_logininfor` (`info_id`, `tenant_id`, `username`, `client_key`, `device_type`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES ('331274499649441792', '000000', 'admin', 'pc', 'PC', '内网IP', 'Unknown', 'Chrome', 'OSX', '0', '登录成功', '2026-07-03 11:26:36');
INSERT INTO `sys_logininfor` (`info_id`, `tenant_id`, `username`, `client_key`, `device_type`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES ('331279974164074496', '000000', 'admin', 'pc', 'PC', '内网IP', 'Unknown', 'Chrome', 'OSX', '1', 'rpc error: code = Unknown desc = Error 1054 (42S22): Unknown column \'sys_user.user_name\' in \'where clause\'', '2026-07-03 11:48:21');
INSERT INTO `sys_logininfor` (`info_id`, `tenant_id`, `username`, `client_key`, `device_type`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES ('331282101091438592', '000000', 'admin', 'pc', 'PC', '内网IP', 'Unknown', 'Chrome', 'OSX', '0', '登录成功', '2026-07-03 11:56:48');
INSERT INTO `sys_logininfor` (`info_id`, `tenant_id`, `username`, `client_key`, `device_type`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES ('331282301835022336', '000000', 'system', 'pc', 'PC', '内网IP', 'Unknown', 'Chrome', 'OSX', '0', '登录成功', '2026-07-03 11:57:36');
INSERT INTO `sys_logininfor` (`info_id`, `tenant_id`, `username`, `client_key`, `device_type`, `ipaddr`, `login_location`, `browser`, `os`, `status`, `msg`, `login_time`) VALUES ('331316588303093760', '000000', 'system', 'pc', 'PC', '内网IP', 'Unknown', 'Chrome', 'OSX', '0', '登录成功', '2026-07-03 14:13:50');
COMMIT;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `menu_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '组件路径',
  `query_param` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '路由参数',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '显示状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '#' COMMENT '菜单图标',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单权限表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1', '系统管理', '0', 11, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'eos-icons:system-group', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 22:24:02', '系统管理目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('100', '用户管理', '1', 2, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'ant-design:user-outlined', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 23:06:22', '用户管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1001', '用户查询', '100', 1, '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1002', '用户新增', '100', 2, '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1003', '用户修改', '100', 3, '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1004', '用户删除', '100', 4, '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1005', '用户导出', '100', 5, '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1006', '用户导入', '100', 6, '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1007', '重置密码', '100', 7, '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1008', '角色查询', '101', 1, '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1009', '角色新增', '101', 2, '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('101', '角色管理', '1', 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'eos-icons:role-binding-outlined', 103, 1, '2025-07-18 15:18:27', NULL, NULL, '角色管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1010', '角色修改', '101', 3, '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1011', '角色删除', '101', 4, '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1012', '角色导出', '101', 5, '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1013', '菜单查询', '102', 1, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1014', '菜单新增', '102', 2, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1015', '菜单修改', '102', 3, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1016', '菜单删除', '102', 4, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1017', '部门查询', '103', 1, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1018', '部门新增', '103', 2, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1019', '部门修改', '103', 3, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('102', '菜单管理', '1', 1, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'ic:sharp-menu', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 23:06:09', '菜单管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1020', '部门删除', '103', 4, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1021', '岗位查询', '104', 1, '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1022', '岗位新增', '104', 2, '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1023', '岗位修改', '104', 3, '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1024', '岗位删除', '104', 4, '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1025', '岗位导出', '104', 5, '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1026', '字典查询', '105', 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1027', '字典新增', '105', 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1028', '字典修改', '105', 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1029', '字典删除', '105', 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('103', '部门管理', '1', 4, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'mingcute:department-line', 103, 1, '2025-07-18 15:18:27', NULL, NULL, '部门管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1030', '字典导出', '105', 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1031', '参数查询', '106', 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1032', '参数新增', '106', 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1033', '参数修改', '106', 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1034', '参数删除', '106', 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1035', '参数导出', '106', 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1036', '公告查询', '107', 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1037', '公告新增', '107', 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 103, 1, '2025-07-18 15:18:29', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1038', '公告修改', '107', 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1039', '公告删除', '107', 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('104', '岗位管理', '1', 5, 'post', 'system/post/index', '', 1, 0, 'C', '0', '0', 'system:post:list', 'icon-park-outline:appointment', 103, 1, '2025-07-18 15:18:27', NULL, NULL, '岗位管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1040', '操作查询', '500', 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1041', '操作删除', '500', 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1042', '日志导出', '500', 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1043', '登录查询', '501', 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1044', '登录删除', '501', 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1045', '日志导出', '501', 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1046', '在线查询', '109', 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1047', '批量强退', '109', 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1048', '单条强退', '109', 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('105', '字典管理', '1', 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'fluent-mdl2:dictionary', 103, 1, '2025-07-18 15:18:27', NULL, NULL, '字典管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1050', '账户解锁', '501', 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1055', '生成查询', '115', 1, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1056', '生成修改', '115', 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1057', '生成删除', '115', 3, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1058', '导入代码', '115', 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1059', '预览代码', '115', 4, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('106', '参数设置', '1', 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '0', 'system:config:list', 'ant-design:setting-outlined', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '参数设置菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1060', '生成代码', '115', 5, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1061', '客户端管理查询', '123', 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:query', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1062', '客户端管理新增', '123', 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:add', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1063', '客户端管理修改', '123', 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:edit', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1064', '客户端管理删除', '123', 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:remove', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1065', '客户端管理导出', '123', 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:client:export', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('107', '通知公告', '1', 8, 'notice', 'system/notice/index', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'fe:notice-push', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '通知公告菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('108', '日志管理', '1', 9, 'log', '', '', 1, 0, 'M', '0', '0', '', 'material-symbols:logo-dev-outline', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '日志管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('109', '在线用户', '2', 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'material-symbols:generating-tokens-outline', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '在线用户菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('113', '缓存监控', '2', 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'devicon:redis-wordmark', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '缓存监控菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('115', '代码生成', '3', 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'tabler:code', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '代码生成菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('116', '修改生成配置', '3', 2, 'gen-edit/index/:tableId(\\d+)', 'tool/gen/editTable', '', 1, 1, 'C', '1', '0', 'tool:gen:edit', 'tabler:code', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('117', 'Admin监控', '2', 5, 'Admin', 'monitor/admin/index', '', 1, 0, 'C', '0', '1', 'monitor:admin:list', 'devicon:spring-wordmark', 103, 1, '2025-07-18 15:18:28', 1, NULL, 'Admin监控菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('118', '文件管理', '1', 10, 'oss', 'system/oss/index', '', 1, 0, 'C', '0', '0', 'system:oss:list', 'solar:folder-with-files-outline', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '文件管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('120', '任务调度中心', '2', 6, 'snailjob', 'monitor/snailjob/index', '', 1, 0, 'C', '0', '1', 'monitor:snailjob:list', 'svg:snail-job', 103, 1, '2025-07-18 15:18:28', 1, NULL, 'SnailJob控制台菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('121', '租户管理', '6', 2, 'tenant', 'system/tenant/index', '', 1, 0, 'C', '0', '0', 'system:tenant:list', 'ph:user-list', 103, 1, '2025-07-18 15:18:28', 1, '2026-07-03 14:24:37', '租户管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('122', '租户套餐管理', '6', 1, 'tenantPackage', 'system/tenantPackage/index', '', 1, 0, 'C', '0', '0', 'system:tenantPackage:list', 'bx:package', 103, 1, '2025-07-18 15:18:28', 1, '2026-07-03 14:24:28', '租户套餐管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('123', '客户端管理', '1', 11, 'client', 'system/client/index', '', 1, 0, 'C', '0', '0', 'system:client:list', 'solar:monitor-smartphone-outline', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '客户端管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('130', '分配用户', '1', 2, 'role-auth/user/:roleId(\\d+)', 'system/role/authUser', '', 1, 1, 'C', '1', '0', 'system:role:edit', 'eos-icons:role-binding-outlined', 103, 1, '2025-07-18 15:18:28', 1, '2026-06-24 18:47:53', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('131', '分配角色', '1', 3, 'user-auth/role/:userId(\\d+)', 'system/user/authRole', '', 1, 1, 'C', '1', '0', 'system:user:edit', '#', 103, 1, '2025-07-18 15:18:28', 1, '2026-06-24 23:06:29', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('132', '字典数据', '1', 6, 'dict-data/index/:dictId(\\d+)', 'system/dict/data', '', 1, 1, 'C', '1', '0', 'system:dict:list', '#', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('133', '文件配置管理', '1', 10, 'oss-config/index', 'system/oss/config', '', 1, 1, 'C', '1', '0', 'system:ossConfig:list', 'ant-design:setting-outlined', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1500', '测试单表', '5', 1, 'demo', 'demo/demo/index', '', 1, 0, 'C', '0', '0', 'demo:demo:list', 'lucide:table', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '测试单表菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1501', '测试单表查询', '1500', 1, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:query', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1502', '测试单表新增', '1500', 2, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:add', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1503', '测试单表修改', '1500', 3, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:edit', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1504', '测试单表删除', '1500', 4, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:remove', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1505', '测试单表导出', '1500', 5, '#', '', '', 1, 0, 'F', '0', '0', 'demo:demo:export', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1506', '测试树表', '5', 1, 'tree', 'demo/tree/index', '', 1, 0, 'C', '0', '0', 'demo:tree:list', 'emojione:evergreen-tree', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '测试树表菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1507', '测试树表查询', '1506', 1, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:query', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1508', '测试树表新增', '1506', 2, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:add', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1509', '测试树表修改', '1506', 3, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:edit', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1510', '测试树表删除', '1506', 4, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:remove', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1511', '测试树表导出', '1506', 5, '#', '', '', 1, 0, 'F', '0', '0', 'demo:tree:export', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1600', '文件查询', '118', 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:oss:query', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1601', '文件上传', '118', 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:oss:upload', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1602', '文件下载', '118', 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:oss:download', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1603', '文件删除', '118', 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:oss:remove', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1606', '租户查询', '121', 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:query', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1607', '租户新增', '121', 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:add', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1608', '租户修改', '121', 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:edit', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1609', '租户删除', '121', 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:remove', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1610', '租户导出', '121', 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenant:export', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1611', '租户套餐查询', '122', 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:query', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1612', '租户套餐新增', '122', 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:add', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1613', '租户套餐修改', '122', 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:edit', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1614', '租户套餐删除', '122', 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:remove', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1615', '租户套餐导出', '122', 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:tenantPackage:export', '#', 103, 1, '2025-07-18 15:18:31', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1620', '配置列表', '118', 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:ossConfig:list', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1621', '配置添加', '118', 6, '#', '', '', 1, 0, 'F', '0', '0', 'system:ossConfig:add', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1622', '配置编辑', '118', 6, '#', '', '', 1, 0, 'F', '0', '0', 'system:ossConfig:edit', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1623', '配置删除', '118', 6, '#', '', '', 1, 0, 'F', '0', '0', 'system:ossConfig:remove', '#', 103, 1, '2025-07-18 15:18:30', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1710', '表单示例', '7', 1, 'form', '演示使用自行删除/form/index', '', 1, 0, 'C', '0', '0', 'devref:form:list', 'lucide:file-input', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1711', '查询示例', '7', 2, 'query', '演示使用自行删除/query/index', '', 1, 0, 'C', '0', '0', 'devref:query:list', 'lucide:search', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1712', '字典示例', '7', 3, 'dict', '演示使用自行删除/dict/index', '', 1, 0, 'C', '0', '0', 'devref:dict:list', 'fluent-mdl2:dictionary', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1713', '菜单示例', '7', 4, 'menu', '演示使用自行删除/menu/index', '', 1, 0, 'C', '0', '0', 'devref:menu:list', 'ic:sharp-menu', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1714', 'Vxe表格', '7', 5, 'vxe', '演示使用自行删除/vxe/index', '', 1, 0, 'C', '0', '0', 'devref:vxe:list', 'lucide:table', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1715', '富文本', '7', 6, 'tinymce', '演示使用自行删除/tinymce/index', '', 1, 0, 'C', '0', '0', 'devref:tinymce:list', 'lucide:type', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1716', '文件上传', '7', 7, 'upload', '演示使用自行删除/upload/index', '', 1, 0, 'C', '0', '0', 'devref:upload:list', 'lucide:upload', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1717', 'SSE推送', '7', 8, 'sse', '演示使用自行删除/sse/index', '', 1, 0, 'C', '0', '0', 'devref:sse:list', 'lucide:radio', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1718', 'API加解密', '7', 9, 'encrypt', '演示使用自行删除/other/encrypt', '', 1, 0, 'C', '0', '0', 'devref:encrypt:list', 'lucide:lock', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1719', '微信示例', '7', 10, 'wechat', '演示使用自行删除/wechat/index', '', 1, 0, 'C', '0', '0', 'devref:wechat:list', 'mdi:wechat', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1720', '更新记录', '7', 11, 'changelog', '演示使用自行删除/changelog/index', '', 1, 0, 'C', '0', '0', 'devref:changelog:list', 'lucide:scroll-text', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1721', 'SSE查询', '1717', 1, '#', '', '', 1, 0, 'F', '0', '0', 'devref:sse:query', '#', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1722', 'SSE发送', '1717', 2, '#', '', '', 1, 0, 'F', '0', '0', 'devref:sse:send', '#', 103, 1, '2026-06-24 22:57:42', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2', '系统监控', '0', 13, 'monitor', NULL, '', 1, 0, 'M', '0', '0', '', 'solar:monitor-camera-outline', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 22:24:14', '系统监控目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2000', '用户管理', '0', 1, 'member', NULL, '', 1, 0, 'M', '0', '0', '', 'ant-design:user-outlined', 103, 1, '2026-06-24 23:21:21', 1, '2026-06-24 23:40:17', '业务用户中心');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2001', '用户列表', '2000', 1, 'list', 'member/list/index', '', 1, 0, 'C', '0', '0', 'member:list:list', 'ant-design:user-outlined', 103, 1, '2026-06-24 23:21:21', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2002', '实名认证', '2000', 2, 'kyc', 'member/kyc/index', '', 1, 0, 'C', '0', '0', 'member:kyc:list', 'mdi:card-account-details-outline', 103, 1, '2026-06-24 23:21:21', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2003', '钱包管理', '2000', 3, 'wallet', 'member/wallet/index', '', 1, 0, 'C', '0', '0', 'member:wallet:list', 'ant-design:wallet-outlined', 103, 1, '2026-06-24 23:21:21', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2004', '用户报表', '2000', 4, 'report', 'member/report/index', '', 1, 0, 'C', '0', '0', 'member:report:list', 'mdi:chart-bar', 103, 1, '2026-06-24 23:21:21', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2005', '团队管理', '2000', 5, 'team', 'member/team/index', '', 1, 0, 'C', '0', '0', 'member:team:list', 'mdi:account-group-outline', 103, 1, '2026-06-24 23:21:21', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2006', '登录记录', '2000', 6, 'login-log', 'member/loginLog/index', '', 1, 0, 'C', '0', '0', 'member:loginLog:list', 'mdi:login', 103, 1, '2026-06-24 23:21:21', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2100', '资金管理', '0', 2, 'fund', NULL, '', 1, 0, 'M', '0', '0', '', 'mdi:shield-check-outline', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-24 23:40:30', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2101', '钱包申请', '2100', 1, 'wallet-apply', 'biz/fund/walletApply/index', '', 1, 0, 'C', '0', '0', 'fund:walletApply:list', 'mdi:file-document-outline', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2102', '账户流水', '2100', 2, 'statement', 'biz/fund/statement/index', '', 1, 0, 'C', '0', '0', 'fund:statement:list', 'fluent:money-hand-20-filled', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-25 00:15:56', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2103', '提现管理', '2100', 3, 'withdraw', 'biz/fund/withdraw/index', '', 1, 0, 'C', '0', '0', 'fund:withdraw:list', 'mdi:cash-minus', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2104', '充值管理', '2100', 4, 'recharge', 'biz/fund/recharge/index', '', 1, 0, 'C', '0', '0', 'fund:recharge:list', 'mdi:cash-plus', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2200', '订单管理', '0', 3, 'trade', NULL, '', 1, 0, 'M', '0', '0', '', 'mdi:database', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-24 23:40:36', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2201', '合约订单', '2200', 1, 'contract', 'biz/trade/contract/index', '', 1, 0, 'C', '0', '0', 'trade:contract:list', 'mdi:printer', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2202', '委托订单', '2200', 2, 'entrust', 'biz/trade/entrust/index', '', 1, 0, 'C', '0', '0', 'trade:entrust:list', 'mdi:cloud-download-outline', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2203', '成交订单', '2200', 3, 'deal', 'biz/trade/deal/index', '', 1, 0, 'C', '0', '0', 'trade:deal:list', 'mdi:cloud-check-outline', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2300', '投信管理', '0', 4, 'invest', NULL, '', 1, 0, 'M', '0', '0', '', 'mdi:view-grid-outline', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-24 23:40:41', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2301', '持仓订单', '2300', 1, 'position', 'biz/invest/position/index', '', 1, 0, 'C', '0', '0', 'invest:position:list', 'mdi:gold', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2302', '投信列表', '2300', 2, 'list', 'biz/invest/list/index', '', 1, 0, 'C', '0', '0', 'invest:list:list', 'mdi:view-list', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2400', '产品管理', '0', 7, 'product', NULL, '', 1, 0, 'M', '0', '0', '', 'mdi:flag-outline', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-25 00:29:45', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2401', '产品配置', '2400', 1, 'config', 'biz/product/config/index', '', 1, 0, 'C', '0', '0', 'product:config:list', 'mdi:book-open-outline', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2402', '产品实时数据', '2400', 2, 'realtime', 'biz/product/realtime/index', '', 1, 0, 'C', '0', '0', 'product:realtime:list', 'mdi:calendar-clock', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2403', '产品历史数据', '2400', 3, 'history', 'biz/product/history/index', '', 1, 0, 'C', '0', '0', 'product:history:list', 'mdi:code-brackets', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2500', '通知管理', '0', 8, 'notify', NULL, '', 1, 0, 'M', '0', '0', '', 'mdi:cloud-outline', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-25 00:30:04', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2501', '市场新闻', '2500', 1, 'news', 'biz/notify/news/index', '', 1, 0, 'C', '0', '0', 'notify:news:list', 'mdi:file-search-outline', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2502', '通知发布', '2500', 2, 'publish', 'biz/notify/publish/index', '', 1, 0, 'C', '0', '0', 'notify:publish:list', 'mdi:bullhorn-outline', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2600', 'K线管理', '0', 5, 'kline', NULL, '', 1, 0, 'M', '0', '0', '', 'mdi:chart-line', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-24 23:40:54', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2601', 'K线管理', '2600', 1, 'main', 'biz/kline/main/index', '', 1, 0, 'C', '0', '0', 'kline:main:list', 'mdi:chart-line', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2700', '在线客服', '0', 6, 'cs', NULL, '', 1, 0, 'M', '0', '0', '', 'mdi:chat-processing-outline', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-24 23:41:03', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2701', '在线客服', '2700', 1, 'main', 'biz/cs/main/index', '', 1, 0, 'C', '0', '0', 'cs:main:list', 'mdi:chat-processing-outline', 103, 1, '2026-06-24 23:27:45', NULL, NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2801', 'App品牌资源', '328198489278255104', 1, 'brand', 'biz/appBrand/main/index', '', 1, 0, 'C', '0', '0', 'appBrand:main:list', 'mdi:earth', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-24 23:44:41', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2901', 'App版本管理', '328198489278255104', 2, 'version', 'biz/appVersion/main/index', '', 1, 0, 'C', '0', '0', 'appVersion:main:list', 'mdi:view-grid', 103, 1, '2026-06-24 23:27:45', 1, '2026-06-24 23:44:50', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('3', '系统工具', '0', 14, 'tool', NULL, '', 1, 0, 'M', '0', '0', '', 'ant-design:tool-outlined', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 22:24:19', '系统工具目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('328198489278255104', 'APP管理', '0', 9, 'app', '', '', 1, 0, 'M', '0', '0', '', 'fluent:apps-16-regular', 0, 1, '2026-06-24 23:43:37', 1, '2026-06-25 00:30:11', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('5', '测试菜单', '0', 15, 'demo', NULL, '', 1, 0, 'M', '0', '0', '', 'devicon:vscode', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 22:24:23', '测试菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('500', '操作日志', '108', 1, 'operlog', 'monitor/operlog/index', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'arcticons:one-hand-operation', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '操作日志菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('501', '登录日志', '108', 2, 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'streamline:interface-login-dial-pad-finger-password-dial-pad-dot-finger', 103, 1, '2025-07-18 15:18:28', NULL, NULL, '登录日志菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('6', '租户管理', '0', 12, 'tenant', NULL, '', 1, 0, 'M', '0', '0', '', 'ph:users-light', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 22:24:09', '租户管理目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('7', '开发参考', '0', 17, 'dev-ref', NULL, '', 1, 0, 'M', '0', '0', '', 'lucide:book-open', 103, 1, '2026-06-24 22:57:42', 1, '2026-06-24 23:00:15', 'Vben 组件与能力演示，上线前可删');
COMMIT;

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
  `notice_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
BEGIN;
INSERT INTO `sys_notice` (`notice_id`, `tenant_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1', '000000', '温馨提醒：2026-07-01 新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 103, 1, '2025-07-18 15:18:38', 1, '2026-06-24 16:31:05', '管理员');
INSERT INTO `sys_notice` (`notice_id`, `tenant_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2', '000000', '维护通知：2026-07-01 系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 103, 1, '2025-07-18 15:18:38', 1, '2026-06-24 16:30:58', '管理员');
COMMIT;

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log` (
  `oper_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日志主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  KEY `idx_sys_oper_log_bt` (`business_type`) USING BTREE,
  KEY `idx_sys_oper_log_s` (`status`) USING BTREE,
  KEY `idx_sys_oper_log_ot` (`oper_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_oss
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss`;
CREATE TABLE `sys_oss` (
  `oss_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '对象存储主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文件名',
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '原名',
  `file_suffix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文件后缀名',
  `url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'URL地址',
  `ext1` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '扩展字段',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint DEFAULT NULL COMMENT '上传人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `service` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'minio' COMMENT '服务商',
  PRIMARY KEY (`oss_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OSS对象存储表';

-- ----------------------------
-- Records of sys_oss
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_oss_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss_config`;
CREATE TABLE `sys_oss_config` (
  `oss_config_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `config_key` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '配置key',
  `access_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT 'accessKey',
  `secret_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '秘钥',
  `bucket_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '桶名称',
  `prefix` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '前缀',
  `endpoint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '访问站点',
  `domain` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '自定义域名',
  `is_https` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'N' COMMENT '是否https（Y=是,N=否）',
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '域',
  `access_policy` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1' COMMENT '桶权限类型(0=private 1=public 2=custom)',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '1' COMMENT '是否默认（0=是,1=否）',
  `ext1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '扩展字段',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`oss_config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对象存储配置表';

-- ----------------------------
-- Records of sys_oss_config
-- ----------------------------
BEGIN;
INSERT INTO `sys_oss_config` (`oss_config_id`, `tenant_id`, `config_key`, `access_key`, `secret_key`, `bucket_name`, `prefix`, `endpoint`, `domain`, `is_https`, `region`, `access_policy`, `status`, `ext1`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1', '000000', 'minio', 'ruoyi', 'ruoyi123', 'ruoyi', '', '127.0.0.1:9000', '', 'N', '', '1', '1', '', 103, 1, '2025-07-18 15:18:39', 1, '2025-07-18 15:18:39', NULL);
INSERT INTO `sys_oss_config` (`oss_config_id`, `tenant_id`, `config_key`, `access_key`, `secret_key`, `bucket_name`, `prefix`, `endpoint`, `domain`, `is_https`, `region`, `access_policy`, `status`, `ext1`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2', '000000', 'qiniu', 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXX', 'ruoyi', '', 's3-cn-north-1.qiniucs.com', '', 'N', '', '1', '1', '', 103, 1, '2025-07-18 15:18:39', 1, '2025-07-18 15:18:39', NULL);
INSERT INTO `sys_oss_config` (`oss_config_id`, `tenant_id`, `config_key`, `access_key`, `secret_key`, `bucket_name`, `prefix`, `endpoint`, `domain`, `is_https`, `region`, `access_policy`, `status`, `ext1`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('3', '000000', 'aliyun', 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXX', 'ruoyi', '', 'oss-cn-beijing.aliyuncs.com', '', 'N', '', '1', '0', '', 103, 1, '2025-07-18 15:18:39', 1, '2025-07-18 15:18:39', NULL);
INSERT INTO `sys_oss_config` (`oss_config_id`, `tenant_id`, `config_key`, `access_key`, `secret_key`, `bucket_name`, `prefix`, `endpoint`, `domain`, `is_https`, `region`, `access_policy`, `status`, `ext1`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('4', '000000', 'qcloud', 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXX', 'ruoyi-1240000000', '', 'cos.ap-beijing.myqcloud.com', '', 'N', 'ap-beijing', '1', '1', '', 103, 1, '2025-07-18 15:18:39', 1, '2025-07-18 15:18:39', NULL);
INSERT INTO `sys_oss_config` (`oss_config_id`, `tenant_id`, `config_key`, `access_key`, `secret_key`, `bucket_name`, `prefix`, `endpoint`, `domain`, `is_https`, `region`, `access_policy`, `status`, `ext1`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('5', '000000', 'image', 'ruoyi', 'ruoyi123', 'ruoyi', 'image', '127.0.0.1:9000', '', 'N', '', '1', '1', '', 103, 1, '2025-07-18 15:18:39', 1, '2025-07-18 15:18:39', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post` (
  `post_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `dept_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门id',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '岗位类别编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位信息表';

-- ----------------------------
-- Records of sys_post
-- ----------------------------
BEGIN;
INSERT INTO `sys_post` (`post_id`, `tenant_id`, `dept_id`, `post_code`, `post_category`, `post_name`, `post_sort`, `status`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1', '000000', '103', 'ceo', NULL, '董事长', 1, '0', 103, 1, '2025-07-18 15:18:27', NULL, NULL, '');
INSERT INTO `sys_post` (`post_id`, `tenant_id`, `dept_id`, `post_code`, `post_category`, `post_name`, `post_sort`, `status`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('2', '000000', '100', 'se', NULL, '项目经理', 2, '0', 103, 1, '2025-07-18 15:18:27', NULL, NULL, '');
INSERT INTO `sys_post` (`post_id`, `tenant_id`, `dept_id`, `post_code`, `post_category`, `post_name`, `post_sort`, `status`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('3', '000000', '100', 'hr', NULL, '人力资源', 3, '0', 103, 1, '2025-07-18 15:18:27', NULL, NULL, '');
INSERT INTO `sys_post` (`post_id`, `tenant_id`, `dept_id`, `post_code`, `post_category`, `post_name`, `post_sort`, `status`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('4', '000000', '100', 'user', NULL, '普通员工', 4, '0', 103, 1, '2025-07-18 15:18:27', NULL, NULL, '');
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限 5：仅本人数据权限 6：部门及以下或本人数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色信息表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1', '000000', '超级管理员', 'superadmin', 1, '1', 1, 1, '0', '0', 103, 1, '2025-07-18 15:18:27', 1, NULL, '超级管理员');
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('228333863670124544', '269795', '系统管理员', 'admin', 2, '1', 1, 0, '0', '0', 0, 1, '2025-09-22 09:57:15', 1, '2026-06-24 18:54:11', '测试');
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('3', '000000', '本部门及以下', 'dept', 3, '4', 1, 0, '0', '0', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 18:54:37', '');
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('4', '000000', '仅本人', 'self', 4, '5', 1, 0, '0', '0', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 18:54:46', '');
COMMIT;

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept` (
  `role_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色ID',
  `dept_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和部门关联表';

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色ID',
  `menu_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和菜单关联表';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '100');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1001');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1002');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1003');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1004');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1005');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1006');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1007');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1008');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1009');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '101');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1010');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1011');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1012');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1013');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1014');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1015');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1016');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1017');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1018');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1019');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '102');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1020');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1021');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1022');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1023');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1024');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1025');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1026');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1027');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1028');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1029');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '103');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1030');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1031');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1032');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1033');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1034');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1035');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1036');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1037');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1038');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1039');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '104');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1040');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1041');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1042');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1043');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1044');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1045');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '105');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1050');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '106');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1061');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1062');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1063');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1064');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1065');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '107');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '108');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '118');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '123');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '130');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '131');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '132');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '133');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1600');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1601');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1602');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1603');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1620');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1621');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1622');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1623');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1710');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1711');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1712');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1713');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1714');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1715');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1716');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1717');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1718');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1719');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1720');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1721');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '1722');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2000');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2001');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2002');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2003');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2004');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2005');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2006');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2100');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2101');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2102');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2103');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2104');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2200');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2201');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2202');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2203');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2300');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2301');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2302');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2400');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2401');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2402');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2403');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2500');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2501');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2502');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2600');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2601');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2700');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2701');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2801');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '2901');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '500');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '501');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('228333863670124544', '7');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '100');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1001');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1002');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1003');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1004');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1005');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1006');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1007');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1008');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1009');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '101');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1010');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1011');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1012');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1013');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1014');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1015');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1016');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1017');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1018');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1019');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '102');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1020');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1021');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1022');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1023');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1024');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1025');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1026');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1027');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1028');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1029');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '103');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1030');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1031');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1032');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1033');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1034');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1035');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1036');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1037');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1038');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1039');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '104');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1040');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1041');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1042');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1043');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1044');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1045');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '105');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1050');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '106');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1061');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1062');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1063');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1064');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1065');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '107');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '108');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '118');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '123');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '130');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '131');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '132');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '133');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1500');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1501');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1502');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1503');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1504');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1505');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1506');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1507');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1508');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1509');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1510');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1511');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1600');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1601');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1602');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1603');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1620');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1621');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1622');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '1623');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '5');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '500');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('3', '501');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1500');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1501');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1502');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1503');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1504');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1505');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1506');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1507');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1508');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1509');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1510');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '1511');
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES ('4', '5');
COMMIT;

-- ----------------------------
-- Table structure for sys_social
-- ----------------------------
DROP TABLE IF EXISTS `sys_social`;
CREATE TABLE `sys_social` (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户id',
  `auth_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '平台+平台唯一id',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户来源',
  `open_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '平台编号唯一id',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '用户昵称',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '用户邮箱',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '头像地址',
  `access_token` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户的授权令牌',
  `expire_in` int DEFAULT NULL COMMENT '用户的授权令牌的有效期，部分平台可能没有',
  `refresh_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '刷新令牌，部分平台可能没有',
  `access_code` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '平台的授权信息，部分平台可能没有',
  `union_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户的 unionid',
  `scope` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '授予的权限，部分平台可能没有',
  `token_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '个别平台的授权信息，部分平台可能没有',
  `id_token` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'id token，部分平台可能没有',
  `mac_algorithm` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '小米平台用户的附带属性，部分平台可能没有',
  `mac_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '小米平台用户的附带属性，部分平台可能没有',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户的授权code，部分平台可能没有',
  `oauth_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Twitter平台用户的附带属性，部分平台可能没有',
  `oauth_token_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Twitter平台用户的附带属性，部分平台可能没有',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社会化关系表';

-- ----------------------------
-- Records of sys_social
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_tenant
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant`;
CREATE TABLE `sys_tenant` (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'id',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '租户编号',
  `contact_username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `company_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业名称',
  `license_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '统一社会信用代码',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '地址',
  `intro` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业简介',
  `domain` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '域名',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `package_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '套餐ID',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `account_count` int DEFAULT '-1' COMMENT '用户数量（-1不限制）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '租户状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户表';

-- ----------------------------
-- Records of sys_tenant
-- ----------------------------
BEGIN;
INSERT INTO `sys_tenant` (`id`, `tenant_id`, `contact_username`, `contact_phone`, `company_name`, `license_number`, `address`, `intro`, `domain`, `remark`, `package_id`, `expire_time`, `account_count`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1', '000000', '管理组', '15888888888', '集团', NULL, NULL, '多租户通用后台管理管理系统', NULL, NULL, NULL, NULL, -1, '0', '0', 103, 1, '2025-07-18 15:18:26', NULL, NULL);
INSERT INTO `sys_tenant` (`id`, `tenant_id`, `contact_username`, `contact_phone`, `company_name`, `license_number`, `address`, `intro`, `domain`, `remark`, `package_id`, `expire_time`, `account_count`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('228333863653347328', '269795', 'fubon', '15313658277', 'Fubon', '', '', '', '', '', '228333672376307712', '2026-09-22 08:00:00', -1, '0', '0', 0, 1, '2025-09-22 09:57:15', 1, '2026-06-24 16:25:17');
INSERT INTO `sys_tenant` (`id`, `tenant_id`, `contact_username`, `contact_phone`, `company_name`, `license_number`, `address`, `intro`, `domain`, `remark`, `package_id`, `expire_time`, `account_count`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('230873346168852480', '873624', 'test', '18366667777', 'test', '', '', '', '', '', '228333672376307712', '2025-09-30 18:08:09', -1, '0', '0', 0, 1, '2025-09-29 10:08:15', 1, '2025-09-29 10:08:15');
COMMIT;

-- ----------------------------
-- Table structure for sys_tenant_package
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant_package`;
CREATE TABLE `sys_tenant_package` (
  `package_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '租户套餐id',
  `package_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '套餐名称',
  `menu_ids` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关联菜单id',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`package_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户套餐表';

-- ----------------------------
-- Records of sys_tenant_package
-- ----------------------------
BEGIN;
INSERT INTO `sys_tenant_package` (`package_id`, `package_name`, `menu_ids`, `remark`, `menu_check_strictly`, `status`, `del_flag`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('228333672376307712', 'Plan A', '1,100,101,102,103,104,105,106,107,108,118,123,500,501,131,1001,1002,1003,1004,1005,1006,1007,130,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,132,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1050,1600,1601,1602,1603,1620,1621,1622,1623,133,1061,1062,1063,1064,1065', '免维护费', 1, '0', '0', 0, 1, '2025-09-22 09:56:30', 1, '2026-06-24 16:28:34');
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户ID',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `dept_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '部门ID',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'sys_user' COMMENT '用户类型（sys_user系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `username`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('1', '000000', '103', 'system', '超级管理员', 'sys_user', 'info@fubonplus.com', '', '1', NULL, '$2a$10$TNu76d50DIF2C/Ab64nX3esqL5sWgQEn./1uKV32nCnB7TLhFjaX2', '0', '0', '121.207.204.73', '2025-12-20 10:12:35', 103, 1, '2025-07-18 15:18:27', NULL, NULL, '管理员');
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `username`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('3', '000000', '108', 'test', '本部门及以下 密码666666', 'sys_user', '', '', '0', NULL, '$2a$10$b8yUzN0C71sbz.PhNOCgJe.Tu1yWC3RNrTyjSQ8p1W0.aaUXUJ.Ne', '0', '0', '49.7.58.170', '2025-09-22 09:52:54', 103, 1, '2025-07-18 15:18:27', 3, '2025-07-18 15:18:27', NULL);
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `username`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('328126980086042624', '000000', '100', 'admin', '系统管理员', '00', '', '', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '', '2026-06-24 18:59:28', 0, 1, '2026-06-24 18:59:28', 1, '2026-06-24 19:05:25', '管理员');
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `username`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES ('4', '000000', '100', 'test1', '仅本人 密码666666', 'sys_user', '', '', '0', NULL, '$2a$10$b8yUzN0C71sbz.PhNOCgJe.Tu1yWC3RNrTyjSQ8p1W0.aaUXUJ.Ne', '0', '0', '49.7.58.170', '2025-09-22 09:54:15', 103, 1, '2025-07-18 15:18:27', 1, '2026-06-24 19:04:23', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post` (
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户ID',
  `post_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户与岗位关联表';

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_post` (`user_id`, `post_id`) VALUES ('1', '1');
COMMIT;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户ID',
  `role_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户和角色关联表';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES ('1', '1');
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES ('228333863724650496', '228333863670124544');
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES ('3', '3');
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES ('328126980086042624', '228333863670124544');
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES ('4', '4');
COMMIT;

-- ----------------------------
-- Table structure for test_demo
-- ----------------------------
DROP TABLE IF EXISTS `test_demo`;
CREATE TABLE `test_demo` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint DEFAULT NULL COMMENT '部门id',
  `user_id` bigint DEFAULT NULL COMMENT '用户id',
  `order_num` int DEFAULT '0' COMMENT '排序号',
  `test_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'key键',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '值',
  `version` int DEFAULT '0' COMMENT '版本',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `del_flag` int DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='测试单表';

-- ----------------------------
-- Records of test_demo
-- ----------------------------
BEGIN;
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (1, '000000', 102, 4, 1, '测试数据权限', '测试', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (2, '000000', 102, 3, 2, '子节点1', '111', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (3, '000000', 102, 3, 3, '子节点2', '222', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (4, '000000', 108, 4, 4, '测试数据', 'demo', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (5, '000000', 108, 3, 13, '子节点11', '1111', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (6, '000000', 108, 3, 12, '子节点22', '2222', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (7, '000000', 108, 3, 11, '子节点33', '3333', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (8, '000000', 108, 3, 10, '子节点44', '4444', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (9, '000000', 108, 3, 9, '子节点55', '5555', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (10, '000000', 108, 3, 8, '子节点66', '6666', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (11, '000000', 108, 3, 7, '子节点77', '7777', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (12, '000000', 108, 3, 6, '子节点88', '8888', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_demo` (`id`, `tenant_id`, `dept_id`, `user_id`, `order_num`, `test_key`, `value`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (13, '000000', 108, 3, 5, '子节点99', '9999', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
COMMIT;

-- ----------------------------
-- Table structure for test_tree
-- ----------------------------
DROP TABLE IF EXISTS `test_tree`;
CREATE TABLE `test_tree` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '000000' COMMENT '租户编号',
  `parent_id` bigint DEFAULT '0' COMMENT '父id',
  `dept_id` bigint DEFAULT NULL COMMENT '部门id',
  `user_id` bigint DEFAULT NULL COMMENT '用户id',
  `tree_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '值',
  `version` int DEFAULT '0' COMMENT '版本',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `del_flag` int DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='测试树表';

-- ----------------------------
-- Records of test_tree
-- ----------------------------
BEGIN;
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (1, '000000', 0, 102, 4, '测试数据权限', 0, 103, '2025-07-18 15:18:39', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (2, '000000', 1, 102, 3, '子节点1', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (3, '000000', 2, 102, 3, '子节点2', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (4, '000000', 0, 108, 4, '测试树1', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (5, '000000', 4, 108, 3, '子节点11', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (6, '000000', 4, 108, 3, '子节点22', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (7, '000000', 4, 108, 3, '子节点33', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (8, '000000', 5, 108, 3, '子节点44', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (9, '000000', 6, 108, 3, '子节点55', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (10, '000000', 7, 108, 3, '子节点66', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (11, '000000', 7, 108, 3, '子节点77', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (12, '000000', 10, 108, 3, '子节点88', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `dept_id`, `user_id`, `tree_name`, `version`, `create_dept`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (13, '000000', 10, 108, 3, '子节点99', 0, 103, '2025-07-18 15:18:40', 1, NULL, NULL, 0);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;


SET FOREIGN_KEY_CHECKS = 1;
