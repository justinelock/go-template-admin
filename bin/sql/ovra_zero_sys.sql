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
