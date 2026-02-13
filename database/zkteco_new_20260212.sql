/*
Navicat MySQL Data Transfer

Source Server         : AWS QAS
Source Server Version : 80407
Source Host           : database-2.cuvemijsyaky.us-east-2.rds.amazonaws.com:3306
Source Database       : zkteco_new

Target Server Type    : MYSQL
Target Server Version : 80407
File Encoding         : 65001

Date: 2026-02-12 16:25:55
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for device_access_logs
-- ----------------------------
DROP TABLE IF EXISTS `device_access_logs`;
CREATE TABLE `device_access_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Device serial number',
  `card_no` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Card number (original format)',
  `card_decimal` bigint DEFAULT NULL COMMENT 'Card number converted to decimal',
  `door_no` int NOT NULL COMMENT 'Door number',
  `access_result` enum('granted','denied') COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Access granted or denied',
  `denial_reason` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Reason if access denied (time_expired, no_access, etc)',
  `event_code` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Final event code (200, 29, etc)',
  `original_event_code` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Original event code from device',
  `user_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'User PIN if available',
  `event_time` timestamp NOT NULL COMMENT 'Time of the access attempt',
  `in_out_status` int DEFAULT NULL COMMENT 'In/Out status from device',
  `verify_type` int DEFAULT NULL COMMENT 'Verification type',
  `room_id` int DEFAULT NULL COMMENT 'Room/Sala ID if access was found',
  `is_visitor` tinyint(1) DEFAULT '0' COMMENT 'Whether this was a visitor access',
  `visitor_deleted` tinyint(1) DEFAULT '0' COMMENT 'Whether visitor access was deleted after use',
  `access_start_time` timestamp NULL DEFAULT NULL COMMENT 'Start time of access window',
  `access_end_time` timestamp NULL DEFAULT NULL COMMENT 'End time of access window',
  `server_time` timestamp NULL DEFAULT NULL COMMENT 'Server time when access was validated',
  `device_ip` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'IP address of the device',
  `event_data` json DEFAULT NULL COMMENT 'Full event data from device',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sn_event_time` (`sn`,`event_time`),
  KEY `idx_card_decimal` (`card_decimal`),
  KEY `idx_card_no` (`card_no`),
  KEY `idx_access_result` (`access_result`),
  KEY `idx_event_time` (`event_time`),
  KEY `idx_door_no` (`door_no`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of device_access_logs
-- ----------------------------
INSERT INTO `device_access_logs` VALUES ('1', 'MWA5244600020', '825698453', '825698453', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:29:05', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:29:05\", \"event\": \"29\", \"index\": \"3523\", \"cardno\": \"825698453\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:34:09.855Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:34:09');
INSERT INTO `device_access_logs` VALUES ('2', 'MWA5244600020', '825698453', '825698453', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:29:08', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:29:08\", \"event\": \"29\", \"index\": \"3524\", \"cardno\": \"825698453\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:34:12.377Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:34:12');
INSERT INTO `device_access_logs` VALUES ('3', 'MWA5244600020', '914277544', '914277544', '1', 'granted', null, '200', '27', '0', '2026-02-12 01:33:21', '1', '4', '3', '0', '0', '2026-02-11 14:36:00', '2026-02-11 23:59:00', '2026-02-11 14:38:48', '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:33:21\", \"event\": \"200\", \"index\": \"3525\", \"cardno\": \"914277544\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:38:47.914Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:38:48');
INSERT INTO `device_access_logs` VALUES ('4', 'MWA5244600020', '914277544', '914277544', '1', 'granted', null, '200', '27', '0', '2026-02-12 01:34:28', '1', '4', '3', '0', '0', '2026-02-11 14:36:00', '2026-02-11 23:59:00', '2026-02-11 14:39:32', '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:34:28\", \"event\": \"200\", \"index\": \"3526\", \"cardno\": \"914277544\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:39:32.239Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:39:32');
INSERT INTO `device_access_logs` VALUES ('5', 'MWA5244600020', '2981743655', '2981743655', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:35:30', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:30\", \"event\": \"29\", \"index\": \"3528\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:40:34.078Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:40:34');
INSERT INTO `device_access_logs` VALUES ('6', 'MWA5244600020', '2981743655', '2981743655', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:35:35', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:35\", \"event\": \"29\", \"index\": \"3529\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:40:38.949Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:40:39');
INSERT INTO `device_access_logs` VALUES ('7', 'MWA5244600020', '2981743655', '2981743655', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:35:38', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:38\", \"event\": \"29\", \"index\": \"3530\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:40:42.679Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:40:42');
INSERT INTO `device_access_logs` VALUES ('8', 'MWA5244600020', '2981743655', '2981743655', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:35:54', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:54\", \"event\": \"29\", \"index\": \"3532\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:40:58.632Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:40:58');
INSERT INTO `device_access_logs` VALUES ('9', 'MWA5244600020', '2981743655', '2981743655', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:35:57', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:57\", \"event\": \"29\", \"index\": \"3533\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:41:00.816Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:41:00');
INSERT INTO `device_access_logs` VALUES ('10', 'MWA5244600020', '914277544', '914277544', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:36:03', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:36:03\", \"event\": \"29\", \"index\": \"3534\", \"cardno\": \"914277544\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:41:07.778Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:41:07');
INSERT INTO `device_access_logs` VALUES ('11', 'MWA5244600020', '2981743655', '2981743655', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:36:21', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:36:21\", \"event\": \"29\", \"index\": \"3536\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:41:24.763Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:41:24');
INSERT INTO `device_access_logs` VALUES ('12', 'MWA5244600020', '3455470023', '3455470023', '1', 'granted', null, '200', '27', '0', '2026-02-12 01:37:58', '1', '4', '3', '0', '0', '2026-02-11 14:36:00', '2026-02-11 23:59:00', '2026-02-11 14:43:02', '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:37:58\", \"event\": \"200\", \"index\": \"3537\", \"cardno\": \"3455470023\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:43:02.125Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:43:02');
INSERT INTO `device_access_logs` VALUES ('13', 'MWA5244600020', '124578539', '124578539', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:41:50', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:41:50\", \"event\": \"29\", \"index\": \"3540\", \"cardno\": \"124578539\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:46:54.010Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:46:54');
INSERT INTO `device_access_logs` VALUES ('14', 'MWA5244600020', '124578539', '124578539', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:41:55', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:41:55\", \"event\": \"29\", \"index\": \"3541\", \"cardno\": \"124578539\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:46:58.960Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:46:59');
INSERT INTO `device_access_logs` VALUES ('15', 'MWA5244600020', '124578539', '124578539', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:41:59', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:41:59\", \"event\": \"29\", \"index\": \"3542\", \"cardno\": \"124578539\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:47:03.505Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:47:03');
INSERT INTO `device_access_logs` VALUES ('16', 'MWA5244600020', '124578539', '124578539', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:42:05', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:42:05\", \"event\": \"29\", \"index\": \"3543\", \"cardno\": \"124578539\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:47:08.872Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 17:47:08');
INSERT INTO `device_access_logs` VALUES ('17', 'MWA5244600020', '2992186431', '2992186431', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:55:34', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:55:34\", \"event\": \"29\", \"index\": \"3554\", \"cardno\": \"2992186431\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T18:10:11.536Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 18:10:11');
INSERT INTO `device_access_logs` VALUES ('18', 'MWA5244600020', '2992186431', '2992186431', '1', 'denied', 'no_matching_access', '29', '27', '0', '2026-02-12 01:55:40', '1', '4', null, '0', '0', null, null, null, '::ffff:192.168.8.134', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:55:40\", \"event\": \"29\", \"index\": \"3555\", \"cardno\": \"2992186431\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T18:10:19.788Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '2026-02-11 18:10:19');

-- ----------------------------
-- Table structure for device_command_queue
-- ----------------------------
DROP TABLE IF EXISTS `device_command_queue`;
CREATE TABLE `device_command_queue` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `command_id` int NOT NULL,
  `command` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('pending','sent','executed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
  `result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sent_at` timestamp NULL DEFAULT NULL,
  `executed_at` timestamp NULL DEFAULT NULL,
  `priority` int NOT NULL DEFAULT '0',
  `retry_count` int NOT NULL DEFAULT '0',
  `max_retries` int NOT NULL DEFAULT '3',
  PRIMARY KEY (`id`),
  KEY `idx_sn_status` (`sn`,`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_command_id` (`command_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of device_command_queue
-- ----------------------------
INSERT INTO `device_command_queue` VALUES ('1', 'MWA5244600020', '0', 'C:0:CONTROL DEVICE 01010106', 'sent', null, '2026-02-04 17:56:29', '2026-02-04 17:56:34', null, '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('2', 'MWA5244600020', '2', 'C:2:CONTROL DEVICE 01020106', 'failed', '0', '2026-02-04 17:56:52', null, '2026-02-11 17:39:33', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('3', 'MWA5244600020', '4', 'C:4:CONTROL DEVICE 01020106', 'failed', '0', '2026-02-04 17:57:06', null, '2026-02-11 17:43:03', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('4', 'MWA5244600020', '6', 'C:6:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 17:57:20', null, '2026-02-04 19:42:34', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('5', 'MWA5244600020', '8', 'C:8:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 18:02:45', null, '2026-02-04 19:42:49', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('6', 'MWA5244600020', '10', 'C:10:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 18:10:56', null, '2026-02-04 19:43:22', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('7', 'MWA5244600020', '12', 'C:12:CONTROL DEVICE 01020106', 'failed', '0', '2026-02-04 18:11:05', null, '2026-02-04 19:43:52', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('8', 'MWA5244600020', '14', 'C:14:CONTROL DEVICE 01020106', 'failed', '0', '2026-02-04 18:11:59', null, '2026-02-04 19:44:25', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('9', 'MWA5244600020', '16', 'C:16:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 18:18:39', null, '2026-02-04 19:45:01', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('10', 'MWA5244600020', '18', 'C:18:CONTROL DEVICE 01020106', 'failed', '0', '2026-02-04 18:18:50', null, '2026-02-04 20:01:46', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('11', 'MWA5244600020', '20', 'C:20:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 19:07:24', null, '2026-02-04 20:02:02', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('12', 'MWA5244600020', '0', 'C:0:CONTROL DEVICE 01020106', 'sent', null, '2026-02-04 19:13:07', '2026-02-04 19:13:10', null, '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('13', 'MWA5244600020', '0', 'C:0:CONTROL DEVICE 01010106', 'sent', null, '2026-02-04 19:29:25', '2026-02-04 19:29:39', null, '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('14', 'MWA5244600020', '2', 'C:2:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 19:33:19', '2026-02-04 19:34:15', '2026-02-11 17:39:33', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('15', 'MWA5244600020', '4', 'C:4:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 19:40:53', null, '2026-02-11 17:43:03', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('16', 'MWA5244600020', '6', 'C:6:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 19:42:33', null, '2026-02-04 19:42:34', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('17', 'MWA5244600020', '8', 'C:8:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 19:42:46', null, '2026-02-04 19:42:49', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('18', 'MWA5244600020', '10', 'C:10:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 19:43:20', null, '2026-02-04 19:43:22', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('19', 'MWA5244600020', '12', 'C:12:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 19:43:49', null, '2026-02-04 19:43:52', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('20', 'MWA5244600020', '14', 'C:14:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 19:44:23', null, '2026-02-04 19:44:25', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('21', 'MWA5244600020', '16', 'C:16:CONTROL DEVICE 01020106', 'failed', '0', '2026-02-04 19:44:59', null, '2026-02-04 19:45:01', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('22', 'MWA5244600020', '18', 'C:18:CONTROL DEVICE 01020106', 'failed', '0', '2026-02-04 20:01:43', null, '2026-02-04 20:01:46', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('23', 'MWA5244600020', '20', 'C:20:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 20:02:00', null, '2026-02-04 20:02:02', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('24', 'MWA5244600020', '22', 'C:22:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 20:02:20', null, '2026-02-04 20:02:23', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('25', 'MWA5244600020', '24', 'C:24:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 20:02:36', null, '2026-02-04 20:02:38', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('26', 'MWA5244600020', '26', 'C:26:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-04 20:02:56', null, '2026-02-04 20:02:57', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('27', 'MWA5244600020', '28', 'C:28:CONTROL DEVICE 01020106', 'failed', '0', '2026-02-04 20:03:12', null, '2026-02-04 20:03:13', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('28', 'MWA5244600020', '30', 'C:30:CONTROL DEVICE 01020106', 'failed', '0', '2026-02-04 20:04:27', null, '2026-02-04 20:04:28', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('29', 'MWA5244600020', '0', 'C:0:CONTROL DEVICE 01020106', 'sent', null, '2026-02-04 20:14:59', '2026-02-04 20:15:04', null, '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('30', 'MWA5244600020', '0', 'C:0:CONTROL DEVICE 01010106', 'sent', null, '2026-02-11 17:38:47', '2026-02-11 17:38:48', null, '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('31', 'MWA5244600020', '2', 'C:2:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-11 17:39:32', null, '2026-02-11 17:39:33', '0', '0', '3');
INSERT INTO `device_command_queue` VALUES ('32', 'MWA5244600020', '4', 'C:4:CONTROL DEVICE 01010106', 'failed', '0', '2026-02-11 17:43:02', null, '2026-02-11 17:43:03', '0', '0', '3');

-- ----------------------------
-- Table structure for device_connection_log
-- ----------------------------
DROP TABLE IF EXISTS `device_connection_log`;
CREATE TABLE `device_connection_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `event_type` enum('connect','disconnect','registry','heartbeat','error') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sn_created` (`sn`,`created_at`),
  KEY `idx_event_type` (`event_type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of device_connection_log
-- ----------------------------
INSERT INTO `device_connection_log` VALUES ('1', 'MWA5244600020', 'registry', '::ffff:192.168.8.134', '{\"sn\":\"MWA5244600020\",\"model\":\"inbio260 Pro\",\"firmware\":\"AC Ver 5.7.8.3033 Aug 14 2023\",\"mac\":null,\"pushVersion\":\"3.2.3.003\",\"ip\":\"192.168.8.134\",\"deviceType\":\"acc\",\"commType\":\"ethernet\",\"maxPackageSize\":2048000,\"lockCount\":2,\"readerCount\":4,\"auxInCount\":2,\"auxOutCount\":2,\"machineType\":\"9\",\"maxUserCount\":600,\"maxAttLogCount\":10,\"maxFingerCount\":200,\"maxUserFingerCount\":10,\"netmask\":\"255.255.255.0\",\"gateway\":\"192.168.8.1\",\"zkfpVersion\":\"10\",\"verifyStyles\":\"FB1E\",\"eventTypes\":\"FF3FF07FF036018003060000606300000000000000000000007743F07E270080\",\"features\":{\"~REXInputFunOn\":\"1\",\"~CardFormatFunOn\":\"1\",\"~SupAuthrizeFunOn\":\"1\",\"~ReaderCFGFunOn\":\"1\",\"~ReaderLinkageFunOn\":\"1\",\"~RelayStateFunOn\":\"1\",\"~Ext485ReaderFunOn\":\"1\",\"~TimeAPBFunOn\":\"1\",\"~CtlAllRelayFunOn\":\"1\",\"~LossCardFunOn\":\"1\",\"DisableUserFunOn\":\"1\",\"DeleteAndFunOn\":\"1\",\"LogIDFunOn\":\"1\",\"DateFmtFunOn\":\"1\",\"AutoServerFunOn\":\"1\",\"DelAllLossCardFunOn\":\"1\",\"DelayOpenDoorFunOn\":\"1\",\"UserOpenDoorDelayFunOn\":\"1\",\"MultiCardInterTimeFunOn\":\"1\",\"CardSiteCodeFunOn\":\"1\",\"OutRelaySetFunOn\":\"1\",\"MulCardUserFunOn\":\"1\",\"MachineTZFunOn\":\"1\",\"UserNameFunOn\":\"1\",\"StringPinFunOn\":\"1\",\"DSTFunOn\":\"1\"},\"capabilities\":{\"AccSupportFunList\":\"11100111111110000000000000000000010000000000000111000000000000000000000000000000000000000000000\",\"QRCodeDecryptFunList\":\"010\"}}', '2026-02-04 17:51:32');
INSERT INTO `device_connection_log` VALUES ('2', 'MWA5244600020', 'registry', '::ffff:192.168.8.134', '{\"sn\":\"MWA5244600020\",\"model\":\"inbio260 Pro\",\"firmware\":\"AC Ver 5.7.8.3033 Aug 14 2023\",\"mac\":null,\"pushVersion\":\"3.2.3.003\",\"ip\":\"192.168.8.134\",\"deviceType\":\"acc\",\"commType\":\"ethernet\",\"maxPackageSize\":2048000,\"lockCount\":2,\"readerCount\":4,\"auxInCount\":2,\"auxOutCount\":2,\"machineType\":\"9\",\"maxUserCount\":600,\"maxAttLogCount\":10,\"maxFingerCount\":200,\"maxUserFingerCount\":10,\"netmask\":\"255.255.255.0\",\"gateway\":\"192.168.8.1\",\"zkfpVersion\":\"10\",\"verifyStyles\":\"FB1E\",\"eventTypes\":\"FF3FF07FF036018003060000606300000000000000000000007743F07E270080\",\"features\":{\"~REXInputFunOn\":\"1\",\"~CardFormatFunOn\":\"1\",\"~SupAuthrizeFunOn\":\"1\",\"~ReaderCFGFunOn\":\"1\",\"~ReaderLinkageFunOn\":\"1\",\"~RelayStateFunOn\":\"1\",\"~Ext485ReaderFunOn\":\"1\",\"~TimeAPBFunOn\":\"1\",\"~CtlAllRelayFunOn\":\"1\",\"~LossCardFunOn\":\"1\",\"DisableUserFunOn\":\"1\",\"DeleteAndFunOn\":\"1\",\"LogIDFunOn\":\"1\",\"DateFmtFunOn\":\"1\",\"AutoServerFunOn\":\"1\",\"DelAllLossCardFunOn\":\"1\",\"DelayOpenDoorFunOn\":\"1\",\"UserOpenDoorDelayFunOn\":\"1\",\"MultiCardInterTimeFunOn\":\"1\",\"CardSiteCodeFunOn\":\"1\",\"OutRelaySetFunOn\":\"1\",\"MulCardUserFunOn\":\"1\",\"MachineTZFunOn\":\"1\",\"UserNameFunOn\":\"1\",\"StringPinFunOn\":\"1\",\"DSTFunOn\":\"1\"},\"capabilities\":{\"AccSupportFunList\":\"11100111111110000000000000000000010000000000000111000000000000000000000000000000000000000000000\",\"QRCodeDecryptFunList\":\"010\"}}', '2026-02-04 19:29:39');
INSERT INTO `device_connection_log` VALUES ('3', 'MWA5244600020', 'registry', '::ffff:192.168.8.134', '{\"sn\":\"MWA5244600020\",\"model\":\"inbio260 Pro\",\"firmware\":\"AC Ver 5.7.8.3033 Aug 14 2023\",\"mac\":null,\"pushVersion\":\"3.2.3.003\",\"ip\":\"192.168.8.134\",\"deviceType\":\"acc\",\"commType\":\"ethernet\",\"maxPackageSize\":2048000,\"lockCount\":2,\"readerCount\":4,\"auxInCount\":2,\"auxOutCount\":2,\"machineType\":\"9\",\"maxUserCount\":600,\"maxAttLogCount\":10,\"maxFingerCount\":200,\"maxUserFingerCount\":10,\"netmask\":\"255.255.255.0\",\"gateway\":\"192.168.8.1\",\"zkfpVersion\":\"10\",\"verifyStyles\":\"FB1E\",\"eventTypes\":\"FF3FF07FF036018003060000606300000000000000000000007743F07E270080\",\"features\":{\"~REXInputFunOn\":\"1\",\"~CardFormatFunOn\":\"1\",\"~SupAuthrizeFunOn\":\"1\",\"~ReaderCFGFunOn\":\"1\",\"~ReaderLinkageFunOn\":\"1\",\"~RelayStateFunOn\":\"1\",\"~Ext485ReaderFunOn\":\"1\",\"~TimeAPBFunOn\":\"1\",\"~CtlAllRelayFunOn\":\"1\",\"~LossCardFunOn\":\"1\",\"DisableUserFunOn\":\"1\",\"DeleteAndFunOn\":\"1\",\"LogIDFunOn\":\"1\",\"DateFmtFunOn\":\"1\",\"AutoServerFunOn\":\"1\",\"DelAllLossCardFunOn\":\"1\",\"DelayOpenDoorFunOn\":\"1\",\"UserOpenDoorDelayFunOn\":\"1\",\"MultiCardInterTimeFunOn\":\"1\",\"CardSiteCodeFunOn\":\"1\",\"OutRelaySetFunOn\":\"1\",\"MulCardUserFunOn\":\"1\",\"MachineTZFunOn\":\"1\",\"UserNameFunOn\":\"1\",\"StringPinFunOn\":\"1\",\"DSTFunOn\":\"1\"},\"capabilities\":{\"AccSupportFunList\":\"11100111111110000000000000000000010000000000000111000000000000000000000000000000000000000000000\",\"QRCodeDecryptFunList\":\"010\"}}', '2026-02-04 19:34:14');

-- ----------------------------
-- Table structure for device_realtime_events
-- ----------------------------
DROP TABLE IF EXISTS `device_realtime_events`;
CREATE TABLE `device_realtime_events` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `event_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `event_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `card_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `door_no` int DEFAULT NULL,
  `event_time` timestamp NOT NULL,
  `in_out_status` int DEFAULT NULL,
  `verify_type` int DEFAULT NULL,
  `event_data` json DEFAULT NULL,
  `processed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_sn_event_time` (`sn`,`event_time`),
  KEY `idx_event_type` (`event_type`),
  KEY `idx_processed` (`processed`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=389 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of device_realtime_events
-- ----------------------------
INSERT INTO `device_realtime_events` VALUES ('1', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:51:33', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 00:55:59\", \"alarm\": \"00000000\", \"relay\": \"03\", \"sensor\": \"00\"}', '0', '2026-02-04 17:51:34');
INSERT INTO `device_realtime_events` VALUES ('2', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:51:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 01:12:26\", \"alarm\": \"00000000\", \"relay\": \"02\", \"sensor\": \"00\"}', '0', '2026-02-04 17:51:36');
INSERT INTO `device_realtime_events` VALUES ('3', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:51:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 01:12:46\", \"alarm\": \"00000000\", \"relay\": \"02\", \"sensor\": \"00\"}', '0', '2026-02-04 17:51:39');
INSERT INTO `device_realtime_events` VALUES ('4', 'MWA5244600020', 'rtlog', '29', '0', '0', null, '2026-02-05 01:46:41', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-05 01:46:41\", \"event\": \"29\", \"index\": \"3032\", \"cardno\": \"0\", \"eventaddr\": \"0\", \"verifytype\": \"200\", \"inoutstatus\": \"2\"}', '0', '2026-02-04 17:51:43');
INSERT INTO `device_realtime_events` VALUES ('5', 'MWA5244600020', 'rtlog', '29', '0', '0', null, '2026-02-05 01:46:45', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-05 01:46:45\", \"event\": \"29\", \"index\": \"3034\", \"cardno\": \"0\", \"eventaddr\": \"0\", \"verifytype\": \"200\", \"inoutstatus\": \"2\"}', '0', '2026-02-04 17:51:45');
INSERT INTO `device_realtime_events` VALUES ('6', 'MWA5244600020', 'rtlog', '29', '0', '0', null, '2026-02-05 01:46:47', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-05 01:46:47\", \"event\": \"29\", \"index\": \"3036\", \"cardno\": \"0\", \"eventaddr\": \"0\", \"verifytype\": \"200\", \"inoutstatus\": \"2\"}', '0', '2026-02-04 17:51:48');
INSERT INTO `device_realtime_events` VALUES ('7', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:51:49', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 01:46:49\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 17:51:50');
INSERT INTO `device_realtime_events` VALUES ('8', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:51:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 01:47:00\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 17:51:57');
INSERT INTO `device_realtime_events` VALUES ('9', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:52:06', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 01:47:09\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 17:52:06');
INSERT INTO `device_realtime_events` VALUES ('10', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:52:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 01:47:18\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 17:52:15');
INSERT INTO `device_realtime_events` VALUES ('11', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:52:24', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 01:47:27\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 17:52:24');
INSERT INTO `device_realtime_events` VALUES ('12', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:52:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 01:47:36\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 17:52:33');
INSERT INTO `device_realtime_events` VALUES ('13', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 14:52:42', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 01:47:45\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 17:52:42');
INSERT INTO `device_realtime_events` VALUES ('14', 'MWA5244600020', 'rtlog', '29', '0', '0', '1', '2026-02-05 01:51:00', null, '1', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-05 01:51:00\", \"event\": \"29\", \"index\": \"3045\", \"cardno\": \"0\", \"eventaddr\": \"1\", \"verifytype\": \"1\", \"inoutstatus\": \"0\"}', '0', '2026-02-04 17:55:57');
INSERT INTO `device_realtime_events` VALUES ('15', 'MWA5244600020', 'rtlog', '29', '0', '0', null, '2026-02-05 03:24:41', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-05 03:24:41\", \"event\": \"29\", \"index\": \"3058\", \"cardno\": \"0\", \"eventaddr\": \"0\", \"verifytype\": \"200\", \"inoutstatus\": \"2\"}', '0', '2026-02-04 19:29:41');
INSERT INTO `device_realtime_events` VALUES ('16', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:29:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:24:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:29:47');
INSERT INTO `device_realtime_events` VALUES ('17', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:33:19', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:25:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:33:19');
INSERT INTO `device_realtime_events` VALUES ('18', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:34:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:25:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:34:15');
INSERT INTO `device_realtime_events` VALUES ('19', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:34:16', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:29:18\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 19:34:16');
INSERT INTO `device_realtime_events` VALUES ('20', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:34:18', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:29:20\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 19:34:19');
INSERT INTO `device_realtime_events` VALUES ('21', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:34:21', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:29:23\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 19:34:21');
INSERT INTO `device_realtime_events` VALUES ('22', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:34:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:29:25\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 19:34:23');
INSERT INTO `device_realtime_events` VALUES ('23', 'MWA5244600020', 'rtlog', '29', '0', '0', null, '2026-02-05 03:29:26', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-05 03:29:26\", \"event\": \"29\", \"index\": \"3084\", \"cardno\": \"0\", \"eventaddr\": \"0\", \"verifytype\": \"200\", \"inoutstatus\": \"2\"}', '0', '2026-02-04 19:34:26');
INSERT INTO `device_realtime_events` VALUES ('24', 'MWA5244600020', 'rtlog', '29', '0', '0', null, '2026-02-05 03:29:29', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-05 03:29:29\", \"event\": \"29\", \"index\": \"3089\", \"cardno\": \"0\", \"eventaddr\": \"0\", \"verifytype\": \"200\", \"inoutstatus\": \"2\"}', '0', '2026-02-04 19:34:31');
INSERT INTO `device_realtime_events` VALUES ('25', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:34:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:29:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:34:36');
INSERT INTO `device_realtime_events` VALUES ('26', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:34:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:29:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:34:45');
INSERT INTO `device_realtime_events` VALUES ('27', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:34:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:29:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:34:53');
INSERT INTO `device_realtime_events` VALUES ('28', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:35:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:30:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:35:03');
INSERT INTO `device_realtime_events` VALUES ('29', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:35:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:30:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:35:11');
INSERT INTO `device_realtime_events` VALUES ('30', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:35:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:30:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:35:21');
INSERT INTO `device_realtime_events` VALUES ('31', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:35:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:30:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:35:30');
INSERT INTO `device_realtime_events` VALUES ('32', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:35:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:30:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:35:39');
INSERT INTO `device_realtime_events` VALUES ('33', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:35:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:30:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:35:47');
INSERT INTO `device_realtime_events` VALUES ('34', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:35:57', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:30:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:35:57');
INSERT INTO `device_realtime_events` VALUES ('35', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:36:06', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:31:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:36:06');
INSERT INTO `device_realtime_events` VALUES ('36', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:36:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:31:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:36:15');
INSERT INTO `device_realtime_events` VALUES ('37', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:36:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:31:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:36:24');
INSERT INTO `device_realtime_events` VALUES ('38', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:36:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:31:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:36:33');
INSERT INTO `device_realtime_events` VALUES ('39', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:36:42', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:31:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:36:42');
INSERT INTO `device_realtime_events` VALUES ('40', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:36:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:31:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:36:51');
INSERT INTO `device_realtime_events` VALUES ('41', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:36:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:32:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:37:00');
INSERT INTO `device_realtime_events` VALUES ('42', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:37:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:32:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:37:09');
INSERT INTO `device_realtime_events` VALUES ('43', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:37:18', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:32:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:37:18');
INSERT INTO `device_realtime_events` VALUES ('44', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:37:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:32:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:37:27');
INSERT INTO `device_realtime_events` VALUES ('45', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:37:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:32:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:37:36');
INSERT INTO `device_realtime_events` VALUES ('46', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:37:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:32:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:37:45');
INSERT INTO `device_realtime_events` VALUES ('47', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:37:54', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:32:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:37:54');
INSERT INTO `device_realtime_events` VALUES ('48', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:38:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:33:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:38:03');
INSERT INTO `device_realtime_events` VALUES ('49', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:38:12', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:33:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:38:12');
INSERT INTO `device_realtime_events` VALUES ('50', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:38:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:33:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:38:21');
INSERT INTO `device_realtime_events` VALUES ('51', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:38:30', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:33:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:38:30');
INSERT INTO `device_realtime_events` VALUES ('52', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:38:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:33:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:38:39');
INSERT INTO `device_realtime_events` VALUES ('53', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:38:48', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:33:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:38:48');
INSERT INTO `device_realtime_events` VALUES ('54', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:38:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:33:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:38:57');
INSERT INTO `device_realtime_events` VALUES ('55', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:39:06', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:34:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:39:06');
INSERT INTO `device_realtime_events` VALUES ('56', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:39:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:34:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:39:15');
INSERT INTO `device_realtime_events` VALUES ('57', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:39:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:34:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:39:24');
INSERT INTO `device_realtime_events` VALUES ('58', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:39:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:34:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:39:33');
INSERT INTO `device_realtime_events` VALUES ('59', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:39:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:34:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:39:42');
INSERT INTO `device_realtime_events` VALUES ('60', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:39:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:34:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:39:51');
INSERT INTO `device_realtime_events` VALUES ('61', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:40:00', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:35:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:40:00');
INSERT INTO `device_realtime_events` VALUES ('62', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:40:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:35:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:40:09');
INSERT INTO `device_realtime_events` VALUES ('63', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:40:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:35:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:40:54');
INSERT INTO `device_realtime_events` VALUES ('64', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:41:00', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:36:03\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:41:01');
INSERT INTO `device_realtime_events` VALUES ('65', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:41:10', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:36:12\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:41:10');
INSERT INTO `device_realtime_events` VALUES ('66', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:41:18', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:36:21\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:41:19');
INSERT INTO `device_realtime_events` VALUES ('67', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:41:28', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:36:30\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:41:28');
INSERT INTO `device_realtime_events` VALUES ('68', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:41:36', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:36:39\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:41:37');
INSERT INTO `device_realtime_events` VALUES ('69', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:41:46', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:36:48\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:41:46');
INSERT INTO `device_realtime_events` VALUES ('70', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:41:54', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:36:57\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:41:55');
INSERT INTO `device_realtime_events` VALUES ('71', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:42:03', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:37:06\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:42:04');
INSERT INTO `device_realtime_events` VALUES ('72', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:42:12', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:37:15\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:42:13');
INSERT INTO `device_realtime_events` VALUES ('73', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:42:21', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:37:24\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:42:22');
INSERT INTO `device_realtime_events` VALUES ('74', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:42:30', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:37:33\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:42:31');
INSERT INTO `device_realtime_events` VALUES ('75', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:42:34', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:37:36\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 19:42:34');
INSERT INTO `device_realtime_events` VALUES ('76', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:42:42', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:37:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:42:42');
INSERT INTO `device_realtime_events` VALUES ('77', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:42:49', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:37:51\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 19:42:49');
INSERT INTO `device_realtime_events` VALUES ('78', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:42:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:37:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:42:57');
INSERT INTO `device_realtime_events` VALUES ('79', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:43:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:38:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:43:06');
INSERT INTO `device_realtime_events` VALUES ('80', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:43:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:38:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:43:15');
INSERT INTO `device_realtime_events` VALUES ('81', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:43:22', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:38:24\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 19:43:22');
INSERT INTO `device_realtime_events` VALUES ('82', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:43:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:38:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:43:30');
INSERT INTO `device_realtime_events` VALUES ('83', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:43:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:38:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:43:39');
INSERT INTO `device_realtime_events` VALUES ('84', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:43:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:38:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:43:48');
INSERT INTO `device_realtime_events` VALUES ('85', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:43:52', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:38:54\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 19:43:52');
INSERT INTO `device_realtime_events` VALUES ('86', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:44:00', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:39:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:44:00');
INSERT INTO `device_realtime_events` VALUES ('87', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:44:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:39:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:44:09');
INSERT INTO `device_realtime_events` VALUES ('88', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:44:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:39:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:44:18');
INSERT INTO `device_realtime_events` VALUES ('89', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:44:25', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:39:27\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 19:44:25');
INSERT INTO `device_realtime_events` VALUES ('90', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:44:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:39:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:44:33');
INSERT INTO `device_realtime_events` VALUES ('91', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:44:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:39:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:44:42');
INSERT INTO `device_realtime_events` VALUES ('92', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:44:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:39:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:44:51');
INSERT INTO `device_realtime_events` VALUES ('93', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:44:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:40:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:45:00');
INSERT INTO `device_realtime_events` VALUES ('94', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:45:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:40:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:45:09');
INSERT INTO `device_realtime_events` VALUES ('95', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:45:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:40:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:45:18');
INSERT INTO `device_realtime_events` VALUES ('96', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:45:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:40:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:45:27');
INSERT INTO `device_realtime_events` VALUES ('97', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:45:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:40:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:45:36');
INSERT INTO `device_realtime_events` VALUES ('98', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:45:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:40:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:45:45');
INSERT INTO `device_realtime_events` VALUES ('99', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:45:54', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:40:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:45:54');
INSERT INTO `device_realtime_events` VALUES ('100', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:46:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:41:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:46:03');
INSERT INTO `device_realtime_events` VALUES ('101', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:46:12', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:41:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:46:12');
INSERT INTO `device_realtime_events` VALUES ('102', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:46:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:41:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:46:21');
INSERT INTO `device_realtime_events` VALUES ('103', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:46:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:41:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:46:30');
INSERT INTO `device_realtime_events` VALUES ('104', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:46:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:41:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:46:39');
INSERT INTO `device_realtime_events` VALUES ('105', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:46:48', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:41:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:46:48');
INSERT INTO `device_realtime_events` VALUES ('106', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:46:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:41:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:46:57');
INSERT INTO `device_realtime_events` VALUES ('107', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:47:06', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:42:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:47:06');
INSERT INTO `device_realtime_events` VALUES ('108', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:47:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:42:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:47:15');
INSERT INTO `device_realtime_events` VALUES ('109', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:47:24', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:42:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:47:24');
INSERT INTO `device_realtime_events` VALUES ('110', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:47:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:42:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:47:33');
INSERT INTO `device_realtime_events` VALUES ('111', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:47:42', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:42:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:47:42');
INSERT INTO `device_realtime_events` VALUES ('112', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:47:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:42:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:47:51');
INSERT INTO `device_realtime_events` VALUES ('113', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:48:00', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:43:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:48:00');
INSERT INTO `device_realtime_events` VALUES ('114', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:48:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:43:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:48:09');
INSERT INTO `device_realtime_events` VALUES ('115', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:48:18', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:43:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:48:18');
INSERT INTO `device_realtime_events` VALUES ('116', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:48:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:43:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:48:27');
INSERT INTO `device_realtime_events` VALUES ('117', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:48:36', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:43:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:48:36');
INSERT INTO `device_realtime_events` VALUES ('118', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:48:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:43:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:48:45');
INSERT INTO `device_realtime_events` VALUES ('119', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:48:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:43:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:48:54');
INSERT INTO `device_realtime_events` VALUES ('120', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:49:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:44:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:49:03');
INSERT INTO `device_realtime_events` VALUES ('121', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:49:12', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:44:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:49:12');
INSERT INTO `device_realtime_events` VALUES ('122', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:49:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:44:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:49:21');
INSERT INTO `device_realtime_events` VALUES ('123', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:49:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:44:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:49:30');
INSERT INTO `device_realtime_events` VALUES ('124', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:49:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:44:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:49:39');
INSERT INTO `device_realtime_events` VALUES ('125', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:49:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:44:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:49:48');
INSERT INTO `device_realtime_events` VALUES ('126', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:49:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:44:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:49:57');
INSERT INTO `device_realtime_events` VALUES ('127', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:50:06', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:45:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:50:06');
INSERT INTO `device_realtime_events` VALUES ('128', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:50:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:45:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:50:15');
INSERT INTO `device_realtime_events` VALUES ('129', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:50:24', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:45:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:50:24');
INSERT INTO `device_realtime_events` VALUES ('130', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:50:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:45:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:50:33');
INSERT INTO `device_realtime_events` VALUES ('131', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:50:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:45:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:50:42');
INSERT INTO `device_realtime_events` VALUES ('132', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:50:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:45:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:50:51');
INSERT INTO `device_realtime_events` VALUES ('133', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:50:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:46:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:51:00');
INSERT INTO `device_realtime_events` VALUES ('134', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:51:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:46:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:51:09');
INSERT INTO `device_realtime_events` VALUES ('135', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:51:18', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:46:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:51:18');
INSERT INTO `device_realtime_events` VALUES ('136', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:51:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:46:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:51:27');
INSERT INTO `device_realtime_events` VALUES ('137', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:51:36', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:46:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:51:36');
INSERT INTO `device_realtime_events` VALUES ('138', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:51:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:46:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:51:45');
INSERT INTO `device_realtime_events` VALUES ('139', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:51:54', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:46:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:51:54');
INSERT INTO `device_realtime_events` VALUES ('140', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:52:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:47:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:52:03');
INSERT INTO `device_realtime_events` VALUES ('141', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:52:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:47:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:52:12');
INSERT INTO `device_realtime_events` VALUES ('142', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:52:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:47:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:52:21');
INSERT INTO `device_realtime_events` VALUES ('143', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:52:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:47:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:52:30');
INSERT INTO `device_realtime_events` VALUES ('144', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:52:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:47:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:52:39');
INSERT INTO `device_realtime_events` VALUES ('145', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:52:48', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:47:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:52:48');
INSERT INTO `device_realtime_events` VALUES ('146', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:52:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:47:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:52:57');
INSERT INTO `device_realtime_events` VALUES ('147', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:53:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:48:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:53:06');
INSERT INTO `device_realtime_events` VALUES ('148', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:53:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:48:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:53:15');
INSERT INTO `device_realtime_events` VALUES ('149', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:53:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:48:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:53:24');
INSERT INTO `device_realtime_events` VALUES ('150', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:53:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:48:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:53:33');
INSERT INTO `device_realtime_events` VALUES ('151', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:53:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:48:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:53:42');
INSERT INTO `device_realtime_events` VALUES ('152', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:53:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:48:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:53:51');
INSERT INTO `device_realtime_events` VALUES ('153', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:54:00', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:49:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:54:00');
INSERT INTO `device_realtime_events` VALUES ('154', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:54:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:49:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:54:09');
INSERT INTO `device_realtime_events` VALUES ('155', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:54:18', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:49:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:54:18');
INSERT INTO `device_realtime_events` VALUES ('156', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:54:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:49:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:54:27');
INSERT INTO `device_realtime_events` VALUES ('157', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:54:36', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:49:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:54:36');
INSERT INTO `device_realtime_events` VALUES ('158', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:54:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:49:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:54:45');
INSERT INTO `device_realtime_events` VALUES ('159', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:54:54', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:49:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:54:54');
INSERT INTO `device_realtime_events` VALUES ('160', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:55:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:50:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:55:03');
INSERT INTO `device_realtime_events` VALUES ('161', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:55:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:50:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:55:12');
INSERT INTO `device_realtime_events` VALUES ('162', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:55:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:50:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:55:21');
INSERT INTO `device_realtime_events` VALUES ('163', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:55:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:50:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:55:30');
INSERT INTO `device_realtime_events` VALUES ('164', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:55:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:50:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:55:39');
INSERT INTO `device_realtime_events` VALUES ('165', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:55:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:50:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:55:48');
INSERT INTO `device_realtime_events` VALUES ('166', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:55:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:50:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:55:57');
INSERT INTO `device_realtime_events` VALUES ('167', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:56:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:51:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:56:06');
INSERT INTO `device_realtime_events` VALUES ('168', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:56:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:51:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:56:15');
INSERT INTO `device_realtime_events` VALUES ('169', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:56:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:51:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:56:24');
INSERT INTO `device_realtime_events` VALUES ('170', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:56:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:51:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:56:33');
INSERT INTO `device_realtime_events` VALUES ('171', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:56:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:51:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:56:42');
INSERT INTO `device_realtime_events` VALUES ('172', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:56:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:51:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:56:51');
INSERT INTO `device_realtime_events` VALUES ('173', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:57:00', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:52:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:57:00');
INSERT INTO `device_realtime_events` VALUES ('174', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:57:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:52:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:57:09');
INSERT INTO `device_realtime_events` VALUES ('175', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:57:18', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:52:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:57:18');
INSERT INTO `device_realtime_events` VALUES ('176', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:57:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:52:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:57:27');
INSERT INTO `device_realtime_events` VALUES ('177', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:57:36', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:52:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:57:36');
INSERT INTO `device_realtime_events` VALUES ('178', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:57:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:52:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:57:45');
INSERT INTO `device_realtime_events` VALUES ('179', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:57:54', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:52:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:57:54');
INSERT INTO `device_realtime_events` VALUES ('180', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:58:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:53:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:58:03');
INSERT INTO `device_realtime_events` VALUES ('181', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:58:12', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:53:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:58:12');
INSERT INTO `device_realtime_events` VALUES ('182', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:58:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:53:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:58:21');
INSERT INTO `device_realtime_events` VALUES ('183', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:58:30', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:53:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:58:30');
INSERT INTO `device_realtime_events` VALUES ('184', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:58:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:53:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:58:39');
INSERT INTO `device_realtime_events` VALUES ('185', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:58:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:53:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:58:48');
INSERT INTO `device_realtime_events` VALUES ('186', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:58:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:53:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:58:57');
INSERT INTO `device_realtime_events` VALUES ('187', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:59:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:54:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:59:06');
INSERT INTO `device_realtime_events` VALUES ('188', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:59:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:54:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:59:15');
INSERT INTO `device_realtime_events` VALUES ('189', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:59:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:54:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:59:24');
INSERT INTO `device_realtime_events` VALUES ('190', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:59:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:54:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:59:33');
INSERT INTO `device_realtime_events` VALUES ('191', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:59:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:54:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:59:42');
INSERT INTO `device_realtime_events` VALUES ('192', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:59:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:54:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 19:59:51');
INSERT INTO `device_realtime_events` VALUES ('193', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 16:59:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:55:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:00:00');
INSERT INTO `device_realtime_events` VALUES ('194', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:00:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:55:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:00:09');
INSERT INTO `device_realtime_events` VALUES ('195', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:00:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:55:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:00:18');
INSERT INTO `device_realtime_events` VALUES ('196', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:00:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:55:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:00:27');
INSERT INTO `device_realtime_events` VALUES ('197', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:00:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:55:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:00:36');
INSERT INTO `device_realtime_events` VALUES ('198', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:00:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:55:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:00:45');
INSERT INTO `device_realtime_events` VALUES ('199', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:00:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:55:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:00:54');
INSERT INTO `device_realtime_events` VALUES ('200', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:01:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:56:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:01:03');
INSERT INTO `device_realtime_events` VALUES ('201', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:01:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:56:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:01:12');
INSERT INTO `device_realtime_events` VALUES ('202', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:01:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:56:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:01:21');
INSERT INTO `device_realtime_events` VALUES ('203', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:01:30', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:56:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:01:30');
INSERT INTO `device_realtime_events` VALUES ('204', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:01:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:56:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:01:39');
INSERT INTO `device_realtime_events` VALUES ('205', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:01:46', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:56:48\", \"alarm\": \"00000000\", \"relay\": \"02\", \"sensor\": \"00\"}', '0', '2026-02-04 20:01:47');
INSERT INTO `device_realtime_events` VALUES ('206', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:01:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:56:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:01:54');
INSERT INTO `device_realtime_events` VALUES ('207', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:02:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:57:04\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 20:02:02');
INSERT INTO `device_realtime_events` VALUES ('208', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:02:10', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:57:12\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:02:10');
INSERT INTO `device_realtime_events` VALUES ('209', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:02:18', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:57:21\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:02:19');
INSERT INTO `device_realtime_events` VALUES ('210', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:02:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:57:25\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 20:02:23');
INSERT INTO `device_realtime_events` VALUES ('211', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:02:30', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:57:33\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:02:31');
INSERT INTO `device_realtime_events` VALUES ('212', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:02:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:57:40\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 20:02:38');
INSERT INTO `device_realtime_events` VALUES ('213', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:02:46', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:57:48\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:02:46');
INSERT INTO `device_realtime_events` VALUES ('214', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:02:54', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:57:57\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:02:55');
INSERT INTO `device_realtime_events` VALUES ('215', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:02:57', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:57:59\", \"alarm\": \"00000000\", \"relay\": \"01\", \"sensor\": \"00\"}', '0', '2026-02-04 20:02:57');
INSERT INTO `device_realtime_events` VALUES ('216', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:03:04', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:58:07\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:03:05');
INSERT INTO `device_realtime_events` VALUES ('217', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:03:13', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:58:15\", \"alarm\": \"00000000\", \"relay\": \"02\", \"sensor\": \"00\"}', '0', '2026-02-04 20:03:13');
INSERT INTO `device_realtime_events` VALUES ('218', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:03:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:58:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:03:21');
INSERT INTO `device_realtime_events` VALUES ('219', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:03:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:58:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:03:30');
INSERT INTO `device_realtime_events` VALUES ('220', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:03:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:58:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:03:39');
INSERT INTO `device_realtime_events` VALUES ('221', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:03:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:58:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:03:48');
INSERT INTO `device_realtime_events` VALUES ('222', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:03:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:58:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:03:57');
INSERT INTO `device_realtime_events` VALUES ('223', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:04:06', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:59:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:04:06');
INSERT INTO `device_realtime_events` VALUES ('224', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:04:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:59:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:04:15');
INSERT INTO `device_realtime_events` VALUES ('225', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:04:24', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:59:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:04:24');
INSERT INTO `device_realtime_events` VALUES ('226', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:04:28', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:59:30\", \"alarm\": \"00000000\", \"relay\": \"02\", \"sensor\": \"00\"}', '0', '2026-02-04 20:04:28');
INSERT INTO `device_realtime_events` VALUES ('227', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:04:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:59:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:04:36');
INSERT INTO `device_realtime_events` VALUES ('228', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:04:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:59:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:04:45');
INSERT INTO `device_realtime_events` VALUES ('229', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:04:54', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 03:59:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:04:54');
INSERT INTO `device_realtime_events` VALUES ('230', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:05:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:00:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:05:03');
INSERT INTO `device_realtime_events` VALUES ('231', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:05:12', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:00:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:05:12');
INSERT INTO `device_realtime_events` VALUES ('232', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:05:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:00:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:05:21');
INSERT INTO `device_realtime_events` VALUES ('233', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:05:30', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:00:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:05:30');
INSERT INTO `device_realtime_events` VALUES ('234', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:05:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:00:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:05:39');
INSERT INTO `device_realtime_events` VALUES ('235', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:05:48', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:00:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:05:48');
INSERT INTO `device_realtime_events` VALUES ('236', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:05:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:00:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:05:57');
INSERT INTO `device_realtime_events` VALUES ('237', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:06:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:01:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:06:06');
INSERT INTO `device_realtime_events` VALUES ('238', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:06:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:01:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:06:15');
INSERT INTO `device_realtime_events` VALUES ('239', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:06:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:01:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:06:24');
INSERT INTO `device_realtime_events` VALUES ('240', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:06:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:01:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:06:33');
INSERT INTO `device_realtime_events` VALUES ('241', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:06:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:01:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:06:42');
INSERT INTO `device_realtime_events` VALUES ('242', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:06:51', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:01:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:06:51');
INSERT INTO `device_realtime_events` VALUES ('243', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:06:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:02:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:07:00');
INSERT INTO `device_realtime_events` VALUES ('244', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:07:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:02:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:07:09');
INSERT INTO `device_realtime_events` VALUES ('245', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:07:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:02:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:07:18');
INSERT INTO `device_realtime_events` VALUES ('246', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:07:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:02:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:07:27');
INSERT INTO `device_realtime_events` VALUES ('247', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:07:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:02:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:07:36');
INSERT INTO `device_realtime_events` VALUES ('248', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:07:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:02:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:07:45');
INSERT INTO `device_realtime_events` VALUES ('249', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:07:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:02:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:07:54');
INSERT INTO `device_realtime_events` VALUES ('250', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:08:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:03:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:08:03');
INSERT INTO `device_realtime_events` VALUES ('251', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:08:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:03:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:08:12');
INSERT INTO `device_realtime_events` VALUES ('252', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:08:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:03:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:08:21');
INSERT INTO `device_realtime_events` VALUES ('253', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:08:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:03:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:08:30');
INSERT INTO `device_realtime_events` VALUES ('254', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:08:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:03:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:08:39');
INSERT INTO `device_realtime_events` VALUES ('255', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:08:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:03:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:08:48');
INSERT INTO `device_realtime_events` VALUES ('256', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:08:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:03:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:08:57');
INSERT INTO `device_realtime_events` VALUES ('257', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:09:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:04:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:09:06');
INSERT INTO `device_realtime_events` VALUES ('258', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:09:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:04:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:09:15');
INSERT INTO `device_realtime_events` VALUES ('259', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:09:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:04:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:09:24');
INSERT INTO `device_realtime_events` VALUES ('260', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:09:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:04:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:09:33');
INSERT INTO `device_realtime_events` VALUES ('261', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:09:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:04:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:09:42');
INSERT INTO `device_realtime_events` VALUES ('262', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:09:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:04:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:09:51');
INSERT INTO `device_realtime_events` VALUES ('263', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:09:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:05:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:10:00');
INSERT INTO `device_realtime_events` VALUES ('264', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:10:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:05:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:10:09');
INSERT INTO `device_realtime_events` VALUES ('265', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:10:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:05:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:10:18');
INSERT INTO `device_realtime_events` VALUES ('266', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:10:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:05:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:10:27');
INSERT INTO `device_realtime_events` VALUES ('267', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:10:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:05:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:10:36');
INSERT INTO `device_realtime_events` VALUES ('268', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:10:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:05:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:10:45');
INSERT INTO `device_realtime_events` VALUES ('269', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:10:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:05:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:10:54');
INSERT INTO `device_realtime_events` VALUES ('270', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:11:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:06:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:11:03');
INSERT INTO `device_realtime_events` VALUES ('271', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:11:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:06:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:11:12');
INSERT INTO `device_realtime_events` VALUES ('272', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:11:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:06:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:11:21');
INSERT INTO `device_realtime_events` VALUES ('273', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:11:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:06:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:11:30');
INSERT INTO `device_realtime_events` VALUES ('274', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:11:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:06:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:11:39');
INSERT INTO `device_realtime_events` VALUES ('275', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:11:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:06:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:11:48');
INSERT INTO `device_realtime_events` VALUES ('276', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:11:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:06:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:11:57');
INSERT INTO `device_realtime_events` VALUES ('277', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:12:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:07:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:12:06');
INSERT INTO `device_realtime_events` VALUES ('278', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:12:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:07:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:12:15');
INSERT INTO `device_realtime_events` VALUES ('279', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:12:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:07:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:12:24');
INSERT INTO `device_realtime_events` VALUES ('280', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:12:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:07:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:12:33');
INSERT INTO `device_realtime_events` VALUES ('281', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:12:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:07:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:12:42');
INSERT INTO `device_realtime_events` VALUES ('282', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:12:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:07:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:12:51');
INSERT INTO `device_realtime_events` VALUES ('283', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:12:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:08:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:13:00');
INSERT INTO `device_realtime_events` VALUES ('284', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:13:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:08:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:13:09');
INSERT INTO `device_realtime_events` VALUES ('285', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:13:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:08:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:13:18');
INSERT INTO `device_realtime_events` VALUES ('286', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:13:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:08:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:13:27');
INSERT INTO `device_realtime_events` VALUES ('287', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:13:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:08:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:13:36');
INSERT INTO `device_realtime_events` VALUES ('288', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:13:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:08:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:13:45');
INSERT INTO `device_realtime_events` VALUES ('289', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:13:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:08:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:13:54');
INSERT INTO `device_realtime_events` VALUES ('290', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:14:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:09:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:14:03');
INSERT INTO `device_realtime_events` VALUES ('291', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 17:14:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 04:09:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 20:14:12');
INSERT INTO `device_realtime_events` VALUES ('292', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:22:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:17:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:22:23');
INSERT INTO `device_realtime_events` VALUES ('293', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:22:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:17:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:22:32');
INSERT INTO `device_realtime_events` VALUES ('294', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:22:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:17:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:22:41');
INSERT INTO `device_realtime_events` VALUES ('295', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:22:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:17:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:22:50');
INSERT INTO `device_realtime_events` VALUES ('296', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:22:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:18:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:22:59');
INSERT INTO `device_realtime_events` VALUES ('297', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:23:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:18:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:23:08');
INSERT INTO `device_realtime_events` VALUES ('298', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:23:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:18:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:23:17');
INSERT INTO `device_realtime_events` VALUES ('299', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:23:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:18:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:23:26');
INSERT INTO `device_realtime_events` VALUES ('300', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:23:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:18:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:23:35');
INSERT INTO `device_realtime_events` VALUES ('301', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:23:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:18:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:23:44');
INSERT INTO `device_realtime_events` VALUES ('302', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:23:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:18:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:23:53');
INSERT INTO `device_realtime_events` VALUES ('303', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:24:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:19:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:24:02');
INSERT INTO `device_realtime_events` VALUES ('304', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:24:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:19:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:24:11');
INSERT INTO `device_realtime_events` VALUES ('305', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:24:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:19:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:24:20');
INSERT INTO `device_realtime_events` VALUES ('306', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:24:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:19:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:24:29');
INSERT INTO `device_realtime_events` VALUES ('307', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:24:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:19:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:24:38');
INSERT INTO `device_realtime_events` VALUES ('308', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:24:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:19:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:24:47');
INSERT INTO `device_realtime_events` VALUES ('309', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:24:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:19:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:24:56');
INSERT INTO `device_realtime_events` VALUES ('310', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:25:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:20:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:25:05');
INSERT INTO `device_realtime_events` VALUES ('311', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:25:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:20:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:25:14');
INSERT INTO `device_realtime_events` VALUES ('312', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:25:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:20:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:25:23');
INSERT INTO `device_realtime_events` VALUES ('313', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:25:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:20:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:25:32');
INSERT INTO `device_realtime_events` VALUES ('314', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:25:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:20:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:25:41');
INSERT INTO `device_realtime_events` VALUES ('315', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:25:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:20:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:25:50');
INSERT INTO `device_realtime_events` VALUES ('316', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:25:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:21:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:25:59');
INSERT INTO `device_realtime_events` VALUES ('317', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:26:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:21:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:26:08');
INSERT INTO `device_realtime_events` VALUES ('318', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:26:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:21:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:26:17');
INSERT INTO `device_realtime_events` VALUES ('319', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:26:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:21:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:26:26');
INSERT INTO `device_realtime_events` VALUES ('320', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:26:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:21:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:26:35');
INSERT INTO `device_realtime_events` VALUES ('321', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:26:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:21:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:26:44');
INSERT INTO `device_realtime_events` VALUES ('322', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:26:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:21:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:26:53');
INSERT INTO `device_realtime_events` VALUES ('323', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:27:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:22:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:27:02');
INSERT INTO `device_realtime_events` VALUES ('324', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:27:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:22:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:27:11');
INSERT INTO `device_realtime_events` VALUES ('325', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:27:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:22:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:27:20');
INSERT INTO `device_realtime_events` VALUES ('326', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:27:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:22:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:27:29');
INSERT INTO `device_realtime_events` VALUES ('327', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:27:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:22:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:27:38');
INSERT INTO `device_realtime_events` VALUES ('328', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:27:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:22:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:27:47');
INSERT INTO `device_realtime_events` VALUES ('329', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:27:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:22:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:27:56');
INSERT INTO `device_realtime_events` VALUES ('330', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:28:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:23:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:28:05');
INSERT INTO `device_realtime_events` VALUES ('331', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:28:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:23:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:28:14');
INSERT INTO `device_realtime_events` VALUES ('332', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:28:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:23:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:28:23');
INSERT INTO `device_realtime_events` VALUES ('333', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:28:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:23:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:28:32');
INSERT INTO `device_realtime_events` VALUES ('334', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:28:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:23:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:28:41');
INSERT INTO `device_realtime_events` VALUES ('335', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:28:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:23:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:28:50');
INSERT INTO `device_realtime_events` VALUES ('336', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:28:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:24:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:28:59');
INSERT INTO `device_realtime_events` VALUES ('337', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:29:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:24:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:29:08');
INSERT INTO `device_realtime_events` VALUES ('338', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:29:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:24:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:29:17');
INSERT INTO `device_realtime_events` VALUES ('339', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:29:26', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:24:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:29:26');
INSERT INTO `device_realtime_events` VALUES ('340', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:29:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:24:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:29:35');
INSERT INTO `device_realtime_events` VALUES ('341', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:29:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:24:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:29:44');
INSERT INTO `device_realtime_events` VALUES ('342', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:29:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:24:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:29:53');
INSERT INTO `device_realtime_events` VALUES ('343', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:30:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:25:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:30:02');
INSERT INTO `device_realtime_events` VALUES ('344', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:30:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:25:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:30:11');
INSERT INTO `device_realtime_events` VALUES ('345', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:30:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:25:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:30:20');
INSERT INTO `device_realtime_events` VALUES ('346', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:30:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:25:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:30:29');
INSERT INTO `device_realtime_events` VALUES ('347', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:30:38', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:25:41\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:30:38');
INSERT INTO `device_realtime_events` VALUES ('348', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:30:47', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:25:50\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:30:47');
INSERT INTO `device_realtime_events` VALUES ('349', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:30:56', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:25:59\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:30:56');
INSERT INTO `device_realtime_events` VALUES ('350', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:31:05', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:26:08\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:31:05');
INSERT INTO `device_realtime_events` VALUES ('351', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:31:14', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:26:17\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:31:14');
INSERT INTO `device_realtime_events` VALUES ('352', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:31:23', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:26:26\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:31:23');
INSERT INTO `device_realtime_events` VALUES ('353', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:31:32', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:26:35\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:31:32');
INSERT INTO `device_realtime_events` VALUES ('354', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:31:41', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:26:44\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:31:41');
INSERT INTO `device_realtime_events` VALUES ('355', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:31:50', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:26:53\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:31:50');
INSERT INTO `device_realtime_events` VALUES ('356', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:31:59', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:27:02\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:31:59');
INSERT INTO `device_realtime_events` VALUES ('357', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:32:08', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:27:11\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:32:08');
INSERT INTO `device_realtime_events` VALUES ('358', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:32:17', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:27:20\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:32:17');
INSERT INTO `device_realtime_events` VALUES ('359', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:32:27', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:27:29\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:32:27');
INSERT INTO `device_realtime_events` VALUES ('360', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:32:35', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:27:38\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:32:35');
INSERT INTO `device_realtime_events` VALUES ('361', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:32:44', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:27:47\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:32:44');
INSERT INTO `device_realtime_events` VALUES ('362', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:32:53', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:27:56\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:32:53');
INSERT INTO `device_realtime_events` VALUES ('363', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:33:02', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:28:05\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:33:02');
INSERT INTO `device_realtime_events` VALUES ('364', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:33:11', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:28:14\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:33:11');
INSERT INTO `device_realtime_events` VALUES ('365', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:33:20', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:28:23\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:33:20');
INSERT INTO `device_realtime_events` VALUES ('366', 'MWA5244600020', 'rtstate', null, null, null, null, '2026-02-04 18:33:29', null, null, '{\"door\": \"0101\", \"time\": \"2026-02-05 05:28:32\", \"alarm\": \"00000000\", \"relay\": \"00\", \"sensor\": \"00\"}', '0', '2026-02-04 21:33:29');
INSERT INTO `device_realtime_events` VALUES ('367', 'MWA5244600020', 'rtlog', '214', '0', '0', null, '2026-02-12 01:27:25', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:27:25\", \"event\": \"214\", \"index\": \"3520\", \"cardno\": \"0\", \"eventaddr\": \"0\", \"verifytype\": \"200\", \"inoutstatus\": \"2\", \"processedAt\": \"2026-02-11T17:32:29.024Z\", \"originalEvent\": \"214\", \"accessControlApplied\": false}', '0', '2026-02-11 17:32:29');
INSERT INTO `device_realtime_events` VALUES ('368', 'MWA5244600020', 'rtlog', '214', '0', '0', null, '2026-02-12 01:27:29', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:27:29\", \"event\": \"214\", \"index\": \"3522\", \"cardno\": \"0\", \"eventaddr\": \"0\", \"verifytype\": \"200\", \"inoutstatus\": \"2\", \"processedAt\": \"2026-02-11T17:32:32.781Z\", \"originalEvent\": \"214\", \"accessControlApplied\": false}', '0', '2026-02-11 17:32:33');
INSERT INTO `device_realtime_events` VALUES ('369', 'MWA5244600020', 'rtlog', '29', '0', '825698453', '1', '2026-02-12 01:29:05', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:29:05\", \"event\": \"29\", \"index\": \"3523\", \"cardno\": \"825698453\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:34:10.050Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:34:10');
INSERT INTO `device_realtime_events` VALUES ('370', 'MWA5244600020', 'rtlog', '29', '0', '825698453', '1', '2026-02-12 01:29:08', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:29:08\", \"event\": \"29\", \"index\": \"3524\", \"cardno\": \"825698453\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:34:12.550Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:34:12');
INSERT INTO `device_realtime_events` VALUES ('371', 'MWA5244600020', 'rtlog', '200', '0', '914277544', '1', '2026-02-12 01:33:21', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:33:21\", \"event\": \"200\", \"index\": \"3525\", \"cardno\": \"914277544\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:38:48.238Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:38:48');
INSERT INTO `device_realtime_events` VALUES ('372', 'MWA5244600020', 'rtlog', '200', '0', '914277544', '1', '2026-02-12 01:34:28', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:34:28\", \"event\": \"200\", \"index\": \"3526\", \"cardno\": \"914277544\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:39:32.415Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:39:32');
INSERT INTO `device_realtime_events` VALUES ('373', 'MWA5244600020', 'rtlog', '8', '0', '0', '1', '2026-02-12 01:34:30', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:34:30\", \"event\": \"8\", \"index\": \"3527\", \"cardno\": \"0\", \"eventaddr\": \"1\", \"verifytype\": \"200\", \"inoutstatus\": \"2\", \"processedAt\": \"2026-02-11T17:39:33.836Z\", \"originalEvent\": \"8\", \"accessControlApplied\": false}', '0', '2026-02-11 17:39:33');
INSERT INTO `device_realtime_events` VALUES ('374', 'MWA5244600020', 'rtlog', '29', '0', '2981743655', '1', '2026-02-12 01:35:30', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:30\", \"event\": \"29\", \"index\": \"3528\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:40:34.287Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:40:34');
INSERT INTO `device_realtime_events` VALUES ('375', 'MWA5244600020', 'rtlog', '29', '0', '2981743655', '1', '2026-02-12 01:35:35', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:35\", \"event\": \"29\", \"index\": \"3529\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:40:39.134Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:40:39');
INSERT INTO `device_realtime_events` VALUES ('376', 'MWA5244600020', 'rtlog', '29', '0', '2981743655', '1', '2026-02-12 01:35:38', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:38\", \"event\": \"29\", \"index\": \"3530\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:40:42.866Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:40:42');
INSERT INTO `device_realtime_events` VALUES ('377', 'MWA5244600020', 'rtlog', '29', '0', '2981743655', '1', '2026-02-12 01:35:54', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:54\", \"event\": \"29\", \"index\": \"3532\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:40:58.809Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:40:58');
INSERT INTO `device_realtime_events` VALUES ('378', 'MWA5244600020', 'rtlog', '29', '0', '2981743655', '1', '2026-02-12 01:35:57', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:35:57\", \"event\": \"29\", \"index\": \"3533\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:41:00.993Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:41:01');
INSERT INTO `device_realtime_events` VALUES ('379', 'MWA5244600020', 'rtlog', '29', '0', '914277544', '1', '2026-02-12 01:36:03', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:36:03\", \"event\": \"29\", \"index\": \"3534\", \"cardno\": \"914277544\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:41:07.956Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:41:08');
INSERT INTO `device_realtime_events` VALUES ('380', 'MWA5244600020', 'rtlog', '29', '0', '2981743655', '1', '2026-02-12 01:36:21', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:36:21\", \"event\": \"29\", \"index\": \"3536\", \"cardno\": \"2981743655\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:41:24.965Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:41:25');
INSERT INTO `device_realtime_events` VALUES ('381', 'MWA5244600020', 'rtlog', '200', '0', '3455470023', '1', '2026-02-12 01:37:58', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:37:58\", \"event\": \"200\", \"index\": \"3537\", \"cardno\": \"3455470023\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:43:02.304Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:43:02');
INSERT INTO `device_realtime_events` VALUES ('382', 'MWA5244600020', 'rtlog', '29', '0', '124578539', '1', '2026-02-12 01:41:50', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:41:50\", \"event\": \"29\", \"index\": \"3540\", \"cardno\": \"124578539\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:46:54.187Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:46:54');
INSERT INTO `device_realtime_events` VALUES ('383', 'MWA5244600020', 'rtlog', '29', '0', '124578539', '1', '2026-02-12 01:41:55', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:41:55\", \"event\": \"29\", \"index\": \"3541\", \"cardno\": \"124578539\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:46:59.132Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:46:59');
INSERT INTO `device_realtime_events` VALUES ('384', 'MWA5244600020', 'rtlog', '29', '0', '124578539', '1', '2026-02-12 01:41:59', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:41:59\", \"event\": \"29\", \"index\": \"3542\", \"cardno\": \"124578539\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:47:03.692Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:47:03');
INSERT INTO `device_realtime_events` VALUES ('385', 'MWA5244600020', 'rtlog', '29', '0', '124578539', '1', '2026-02-12 01:42:05', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:42:05\", \"event\": \"29\", \"index\": \"3543\", \"cardno\": \"124578539\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T17:47:09.062Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 17:47:09');
INSERT INTO `device_realtime_events` VALUES ('386', 'MWA5244600020', 'rtlog', '214', '0', '0', null, '2026-02-12 01:52:04', '2', '200', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:52:04\", \"event\": \"214\", \"index\": \"3547\", \"cardno\": \"0\", \"eventaddr\": \"0\", \"verifytype\": \"200\", \"inoutstatus\": \"2\", \"processedAt\": \"2026-02-11T17:57:07.753Z\", \"originalEvent\": \"214\", \"accessControlApplied\": false}', '0', '2026-02-11 17:57:07');
INSERT INTO `device_realtime_events` VALUES ('387', 'MWA5244600020', 'rtlog', '29', '0', '2992186431', '1', '2026-02-12 01:55:34', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:55:34\", \"event\": \"29\", \"index\": \"3554\", \"cardno\": \"2992186431\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T18:10:11.796Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 18:10:14');
INSERT INTO `device_realtime_events` VALUES ('388', 'MWA5244600020', 'rtlog', '29', '0', '2992186431', '1', '2026-02-12 01:55:40', '1', '4', '{\"sn\": \"MWA5244600020\", \"pin\": \"0\", \"time\": \"2026-02-12 01:55:40\", \"event\": \"29\", \"index\": \"3555\", \"cardno\": \"2992186431\", \"eventaddr\": \"1\", \"verifytype\": \"4\", \"inoutstatus\": \"1\", \"processedAt\": \"2026-02-11T18:10:19.983Z\", \"originalEvent\": \"27\", \"accessControlApplied\": true}', '0', '2026-02-11 18:10:20');

-- ----------------------------
-- Table structure for device_registry
-- ----------------------------
DROP TABLE IF EXISTS `device_registry`;
CREATE TABLE `device_registry` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `registry_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `device_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `firmware_version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mac_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `push_version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '3.1.2',
  `server_version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '3.1.1',
  `last_seen` timestamp NULL DEFAULT NULL,
  `registered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `session_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `device_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `comm_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `max_package_size` int DEFAULT NULL,
  `lock_count` int DEFAULT NULL,
  `reader_count` int DEFAULT NULL,
  `aux_in_count` int DEFAULT NULL,
  `aux_out_count` int DEFAULT NULL,
  `machine_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `max_user_count` int DEFAULT NULL,
  `max_attlog_count` int DEFAULT NULL,
  `max_finger_count` int DEFAULT NULL,
  `max_user_finger_count` int DEFAULT NULL,
  `netmask` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `gateway` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `zkfp_version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `verify_styles` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `event_types` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `features` json DEFAULT NULL COMMENT 'Store all FunOn features',
  `capabilities` json DEFAULT NULL COMMENT 'Store device capabilities',
  `raw_data` json DEFAULT NULL COMMENT 'Store complete registration data',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sn` (`sn`),
  KEY `idx_sn` (`sn`),
  KEY `idx_registry_code` (`registry_code`),
  KEY `idx_last_seen` (`last_seen`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of device_registry
-- ----------------------------
INSERT INTO `device_registry` VALUES ('1', 'MWA5244600020', '2DCML8BQQQ9AE', 'inbio260 Pro', 'AC Ver 5.7.8.3033 Aug 14 2023', null, '192.168.8.134', 'inbio260 Pro', '3.2.3.003', '3.1.1', '2026-02-11 18:12:29', '2026-02-04 17:51:32', '2026-02-11 18:12:29', '1', 'MIsjzwtRGT2cWnkg7xXmF4grOeWgfs9E', 'acc', 'ethernet', '2048000', '2', '4', '2', '2', '9', '600', '10', '200', '10', '255.255.255.0', '192.168.8.1', '10', 'FB1E', 'FF3FF07FF036018003060000606300000000000000000000007743F07E270080', '{\"DSTFunOn\": \"1\", \"LogIDFunOn\": \"1\", \"DateFmtFunOn\": \"1\", \"UserNameFunOn\": \"1\", \"~TimeAPBFunOn\": \"1\", \"DeleteAndFunOn\": \"1\", \"MachineTZFunOn\": \"1\", \"StringPinFunOn\": \"1\", \"~LossCardFunOn\": \"1\", \"~REXInputFunOn\": \"1\", \"AutoServerFunOn\": \"1\", \"~ReaderCFGFunOn\": \"1\", \"DisableUserFunOn\": \"1\", \"MulCardUserFunOn\": \"1\", \"OutRelaySetFunOn\": \"1\", \"~CardFormatFunOn\": \"1\", \"~RelayStateFunOn\": \"1\", \"CardSiteCodeFunOn\": \"1\", \"~CtlAllRelayFunOn\": \"1\", \"~SupAuthrizeFunOn\": \"1\", \"DelayOpenDoorFunOn\": \"1\", \"~Ext485ReaderFunOn\": \"1\", \"DelAllLossCardFunOn\": \"1\", \"~ReaderLinkageFunOn\": \"1\", \"UserOpenDoorDelayFunOn\": \"1\", \"MultiCardInterTimeFunOn\": \"1\"}', '{\"AccSupportFunList\": \"11100111111110000000000000000000010000000000000111000000000000000000000000000000000000000000000\", \"QRCodeDecryptFunList\": \"010\"}', '{\"FirmVer\": \"AC Ver 5.7.8.3033 Aug 14 2023\", \"NetMask\": \"255.255.255.0\", \"authKey\": \"\", \"CommType\": \"ethernet\", \"DSTFunOn\": \"1\", \"IPAddress\": \"192.168.8.134\", \"LockCount\": \"2\", \"AuxInCount\": \"2\", \"DeviceType\": \"acc\", \"EventTypes\": \"FF3FF07FF036018003060000606300000000000000000000007743F07E270080\", \"LogIDFunOn\": \"1\", \"MThreshold\": \"55\", \"AuxOutCount\": \"2\", \"MachineType\": \"9\", \"PushVersion\": \"3.2.3.003\", \"ReaderCount\": \"4\", \"~DeviceName\": \"inbio260 Pro\", \"DateFmtFunOn\": \"1\", \"VerifyStyles\": \"FB1E\", \"~ZKFPVersion\": \"10\", \"GATEIPAddress\": \"192.168.8.1\", \"UserNameFunOn\": \"1\", \"~MaxUserCount\": \"600\", \"~TimeAPBFunOn\": \"1\", \"DeleteAndFunOn\": \"1\", \"MachineTZFunOn\": \"1\", \"MaxMCUCardBits\": \"66\", \"MaxPackageSize\": \"2048000\", \"StringPinFunOn\": \"1\", \"~LossCardFunOn\": \"1\", \"~REXInputFunOn\": \"1\", \"AutoServerFunOn\": \"1\", \"SimpleEventType\": \"1\", \"~MaxAttLogCount\": \"10\", \"~MaxFingerCount\": \"200\", \"~ReaderCFGFunOn\": \"1\", \"DisableUserFunOn\": \"1\", \"MulCardUserFunOn\": \"1\", \"OutRelaySetFunOn\": \"1\", \"~CardFormatFunOn\": \"1\", \"~IsOnlyRFMachine\": \"0\", \"~RelayStateFunOn\": \"1\", \"AccSupportFunList\": \"11100111111110000000000000000000010000000000000111000000000000000000000000000000000000000000000\", \"CardSiteCodeFunOn\": \"1\", \"~CtlAllRelayFunOn\": \"1\", \"~SupAuthrizeFunOn\": \"1\", \"DelayOpenDoorFunOn\": \"1\", \"~Ext485ReaderFunOn\": \"1\", \"DelAllLossCardFunOn\": \"1\", \"~MaxUserFingerCount\": \"10\", \"~ReaderLinkageFunOn\": \"1\", \"QRCodeDecryptFunList\": \"010\", \"UserOpenDoorDelayFunOn\": \"1\", \"MultiCardInterTimeFunOn\": \"1\"}');

-- ----------------------------
-- Table structure for DeviceLogs
-- ----------------------------
DROP TABLE IF EXISTS `DeviceLogs`;
CREATE TABLE `DeviceLogs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `numero_serie` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `timestamp` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `numero_serie` (`numero_serie`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of DeviceLogs
-- ----------------------------
INSERT INTO `DeviceLogs` VALUES ('1', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('2', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('3', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('4', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('5', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('6', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('7', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('8', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('9', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('10', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('11', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('12', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('13', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('14', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('15', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('16', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('17', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('18', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('19', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('20', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('21', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('22', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('23', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('24', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('25', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('26', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('27', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('28', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('29', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('30', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('31', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('32', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('33', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('34', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('35', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('36', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('37', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('38', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('39', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('40', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('41', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('42', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('43', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('44', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('45', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('46', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('47', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('48', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('49', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('50', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('51', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('52', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('53', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('54', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('55', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('56', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('57', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('58', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('59', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('60', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('61', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('62', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('63', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('64', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('65', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('66', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('67', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('68', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('69', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('70', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('71', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('72', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('73', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('74', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('75', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('76', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('77', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('78', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('79', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('80', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('81', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('82', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('83', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('84', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('85', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('86', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('87', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('88', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('89', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('90', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('91', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('92', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('93', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('94', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('95', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('96', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('97', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('98', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('99', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('100', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('101', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('102', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('103', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('104', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('105', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('106', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('107', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('108', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('109', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('110', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('111', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('112', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('113', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('114', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('115', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('116', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('117', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('118', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('119', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('120', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('121', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('122', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('123', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('124', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('125', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('126', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('127', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('128', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('129', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('130', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('131', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('132', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('133', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('134', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:02 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('135', 'AN88Y662', '1', 'Sun Jan 18 2026 16:10:17 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('136', 'AN88Y662', '2', 'Sun Jan 18 2026 16:10:25 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('137', 'AN88Y662', '1', 'Mon Jan 19 2026 15:34:04 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('138', 'AN88Y662', '1', 'Mon Jan 19 2026 15:46:14 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('139', 'AN88Y662', '2', 'Mon Jan 19 2026 15:46:21 GMT+0545 (Nepal Time)', 'access granted');
INSERT INTO `DeviceLogs` VALUES ('140', 'AN88Y662', '1', 'Mon Jan 19 2026 15:47:09 GMT+0545 (Nepal Time)', 'access granted');

-- ----------------------------
-- Table structure for Dispositivos
-- ----------------------------
DROP TABLE IF EXISTS `Dispositivos`;
CREATE TABLE `Dispositivos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `numero_serie` varchar(20) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `codigo_registro` varchar(20) NOT NULL,
  `version_firmware` varchar(100) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `building` varchar(50) NOT NULL,
  `door` varchar(50) NOT NULL,
  `deteccion_mascara` tinyint(1) NOT NULL DEFAULT '0',
  `deteccion_infrarrojo` tinyint(1) NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '0',
  `creado_en` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `actualizado_en` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_serie` (`numero_serie`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of Dispositivos
-- ----------------------------
INSERT INTO `Dispositivos` VALUES ('2', 'MWA5244600020', 'inbio-1', 'reg12', '1.2', '192.168.8.108', '101', '1', '0', '0', '0', '2026-01-22 18:33:00', '2026-02-03 19:44:18');
INSERT INTO `Dispositivos` VALUES ('3', 'AJYX233160037', 'inbio-2', 'reg13', '1.2', '192.168.8.120', '102', '1', '0', '0', '0', '2026-01-23 14:03:21', '2026-01-28 13:45:10');
INSERT INTO `Dispositivos` VALUES ('4', 'AN88Y662', 'test device', '11aedd234222', '1.2', '192.168.1.202', 'margintop', '100', '0', '0', '0', '2026-01-24 04:04:41', '2026-01-26 13:45:08');

-- ----------------------------
-- Table structure for push_protocol_config
-- ----------------------------
DROP TABLE IF EXISTS `push_protocol_config`;
CREATE TABLE `push_protocol_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of push_protocol_config
-- ----------------------------
INSERT INTO `push_protocol_config` VALUES ('1', 'SERVER_VERSION', '3.1.1', 'Server version for ADMS push protocol', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('2', 'PUSH_PROTOCOL_VERSION', '3.1.2', 'Push protocol version', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('3', 'ERROR_DELAY', '60', 'Error delay in seconds', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('4', 'REQUEST_DELAY', '3', 'Request delay in seconds', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('5', 'TRANS_TIMES', '00:05;06:00;12:00;18:00', 'Transaction times', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('6', 'TRANS_INTERVAL', '1', 'Transaction interval in minutes', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('7', 'TRANS_TABLES', 'UserTransaction', 'Tables to sync', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('8', 'TIMEOUT_SEC', '30', 'Timeout in seconds', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('9', 'REALTIME', '1', 'Enable real-time data push', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('10', 'SERVER_NAME', 'NodePushServer', 'Server name', '2026-02-04 17:29:45');
INSERT INTO `push_protocol_config` VALUES ('11', 'MAX_COMMAND_QUEUE_SIZE', '100', 'Maximum commands per device queue', '2026-02-04 17:29:45');

-- ----------------------------
-- Table structure for tbl_acceso
-- ----------------------------
DROP TABLE IF EXISTS `tbl_acceso`;
CREATE TABLE `tbl_acceso` (
  `IDAcceso` bigint NOT NULL,
  `IDUsuario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Payload` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`IDAcceso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_acceso
-- ----------------------------
INSERT INTO `tbl_acceso` VALUES ('1234', '8.666.092-K', '{\"codigo\":\"1234\",\"fechaInicio\":\"2025-10-30T09:16\",\"fechaFin\":\"2025-10-30T09:18\",\"sala\":\"1\",\"isCard\":true}');
INSERT INTO `tbl_acceso` VALUES ('47554209', '12.345.678-5', '{\"codigo\":\"0047554209\",\"fechaInicio\":\"2025-09-05 10:00:07\",\"fechaFin\":\"2025-09-07 10:00:07\",\"sala\":3,\"isCard\":false,\"isVisit\":true}');
INSERT INTO `tbl_acceso` VALUES ('57703940', '24.223.544-4', '{\"codigo\":\"0057703940\",\"fechaInicio\":\"2025-10-24 11:31:54\",\"fechaFin\":\"2025-10-26 11:31:54\",\"sala\":1,\"isCard\":false,\"isVisit\":true}');
INSERT INTO `tbl_acceso` VALUES ('443284807', '789.456.123-2', '{\"codigo\":\"0443284807\",\"fechaInicio\":\"2026-01-13 13:57:00\",\"fechaFin\":\"2026-01-16 13:57:00\",\"sala\":1,\"isCard\":false,\"isVisit\":true}');
INSERT INTO `tbl_acceso` VALUES ('857170382', '13.443.663-8', '{\"codigo\":\"0857170382\",\"fechaInicio\":\"2026-02-02 14:23:34\",\"fechaFin\":\"2026-02-04 14:23:34\",\"sala\":1,\"isCard\":false,\"isVisit\":true}');
INSERT INTO `tbl_acceso` VALUES ('2837737570', '8.666.092-K', '{\"codigo\":\"2837737570\",\"fechaInicio\":\"2025-10-30T09:19\",\"fechaFin\":\"2026-10-30T09:19\",\"sala\":\"2\",\"isCard\":true}');
INSERT INTO `tbl_acceso` VALUES ('2992186431', '10.645.780-8', '{\"codigo\":\"2992186431\",\"fechaInicio\":\"2026-02-11 14:36:00\",\"fechaFin\":\"2026-02-11 23:59:00\",\"sala\":4,\"isCard\":false,\"isVisit\":false}');
INSERT INTO `tbl_acceso` VALUES ('3401741890', '741.085.296-3', '{\"codigo\":\"3401741890\",\"fechaInicio\":\"2025-12-31T00:00:00\",\"fechaFin\":\"2026-07-04T00:00:00\",\"sala\":2,\"isCard\":false}');
INSERT INTO `tbl_acceso` VALUES ('6483615888', '963.852.741-0', '{\"codigo\":\"6483615888\",\"fechaInicio\":\"2026-01-19 14:33:00\",\"fechaFin\":\"2026-01-14 14:33:00\",\"sala\":3,\"isCard\":false,\"isVisit\":true}');
INSERT INTO `tbl_acceso` VALUES ('8754120990', '410.520.637-8', '{\"codigo\":\"8754120990\",\"fechaInicio\":\"2026-01-13 14:11:00\",\"fechaFin\":\"2026-01-15 14:11:00\",\"sala\":2,\"isCard\":false,\"isVisit\":true}');
INSERT INTO `tbl_acceso` VALUES ('9449682348', '8.666.092-K', '{\"codigo\":\"9449682348\",\"fechaInicio\":\"2025-10-30T09:19\",\"fechaFin\":\"2026-10-30T09:19\",\"sala\":\"3\",\"isCard\":true}');

-- ----------------------------
-- Table structure for tbl_area_estacionamiento
-- ----------------------------
DROP TABLE IF EXISTS `tbl_area_estacionamiento`;
CREATE TABLE `tbl_area_estacionamiento` (
  `IDArea` int NOT NULL AUTO_INCREMENT,
  `Area` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `RegionArea` int NOT NULL,
  `Puestos` int NOT NULL,
  `Notas` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`IDArea`,`Area`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_area_estacionamiento
-- ----------------------------
INSERT INTO `tbl_area_estacionamiento` VALUES ('1', 'A-1', '1', '12', null);
INSERT INTO `tbl_area_estacionamiento` VALUES ('4', 'A-2', '2', '35', 'Nota.');
INSERT INTO `tbl_area_estacionamiento` VALUES ('5', 'A-1', '1', '15', '');

-- ----------------------------
-- Table structure for tbl_caseta_estacionamiento
-- ----------------------------
DROP TABLE IF EXISTS `tbl_caseta_estacionamiento`;
CREATE TABLE `tbl_caseta_estacionamiento` (
  `IDCaseta` int NOT NULL AUTO_INCREMENT,
  `Caseta` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `IDArea` int NOT NULL,
  `Equipo` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `Pase` int DEFAULT NULL,
  PRIMARY KEY (`IDCaseta`,`Caseta`,`IDArea`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_caseta_estacionamiento
-- ----------------------------
INSERT INTO `tbl_caseta_estacionamiento` VALUES ('5', 'CAS-1', '4', '192.168.8.100', '1');

-- ----------------------------
-- Table structure for tbl_edificio
-- ----------------------------
DROP TABLE IF EXISTS `tbl_edificio`;
CREATE TABLE `tbl_edificio` (
  `IDEdificio` int NOT NULL AUTO_INCREMENT,
  `Edificio` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`IDEdificio`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_edificio
-- ----------------------------
INSERT INTO `tbl_edificio` VALUES ('1', 'A');
INSERT INTO `tbl_edificio` VALUES ('2', 'H');

-- ----------------------------
-- Table structure for tbl_edificio_piso
-- ----------------------------
DROP TABLE IF EXISTS `tbl_edificio_piso`;
CREATE TABLE `tbl_edificio_piso` (
  `IDEdificioPiso` int NOT NULL AUTO_INCREMENT,
  `IDEdificio` int DEFAULT NULL,
  `Piso` int DEFAULT NULL,
  PRIMARY KEY (`IDEdificioPiso`) USING BTREE,
  KEY `FK_EDIFICIO_PISO` (`IDEdificio`),
  CONSTRAINT `FK_EDIFICIO_PISO` FOREIGN KEY (`IDEdificio`) REFERENCES `tbl_edificio` (`IDEdificio`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_edificio_piso
-- ----------------------------
INSERT INTO `tbl_edificio_piso` VALUES ('1', '1', '5');
INSERT INTO `tbl_edificio_piso` VALUES ('2', '2', '3');

-- ----------------------------
-- Table structure for tbl_emp
-- ----------------------------
DROP TABLE IF EXISTS `tbl_emp`;
CREATE TABLE `tbl_emp` (
  `IDUsuario` int NOT NULL,
  `Nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `NumeroTarjeta` int DEFAULT NULL,
  `Password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `TiempoInicio` datetime DEFAULT NULL,
  `TiempoFinal` datetime DEFAULT NULL,
  `SuperUser` bit(1) DEFAULT NULL,
  PRIMARY KEY (`IDUsuario`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tbl_emp
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_huella
-- ----------------------------
DROP TABLE IF EXISTS `tbl_huella`;
CREATE TABLE `tbl_huella` (
  `IDUsuario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IDDedo` int DEFAULT NULL,
  `DatoHuella` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_huella
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_huella_copy
-- ----------------------------
DROP TABLE IF EXISTS `tbl_huella_copy`;
CREATE TABLE `tbl_huella_copy` (
  `IDUsuario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IDDedo` int DEFAULT NULL,
  `DatoHuella` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_huella_copy
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_piso
-- ----------------------------
DROP TABLE IF EXISTS `tbl_piso`;
CREATE TABLE `tbl_piso` (
  `IDPiso` int NOT NULL AUTO_INCREMENT,
  `IDEdificio` int DEFAULT NULL,
  `Piso` int DEFAULT NULL,
  PRIMARY KEY (`IDPiso`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_piso
-- ----------------------------
INSERT INTO `tbl_piso` VALUES ('1', '1', '1');
INSERT INTO `tbl_piso` VALUES ('2', '1', '2');

-- ----------------------------
-- Table structure for tbl_region_estacionamiento
-- ----------------------------
DROP TABLE IF EXISTS `tbl_region_estacionamiento`;
CREATE TABLE `tbl_region_estacionamiento` (
  `IDRegion` int NOT NULL,
  `Region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`IDRegion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_region_estacionamiento
-- ----------------------------
INSERT INTO `tbl_region_estacionamiento` VALUES ('1', 'AREA PRINCIPAL');
INSERT INTO `tbl_region_estacionamiento` VALUES ('2', 'AREA PEQUEÑA');

-- ----------------------------
-- Table structure for tbl_rol
-- ----------------------------
DROP TABLE IF EXISTS `tbl_rol`;
CREATE TABLE `tbl_rol` (
  `IDRol` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Relacionados a EF'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tbl_rol
-- ----------------------------
INSERT INTO `tbl_rol` VALUES ('SAD', 'Super Administrador');
INSERT INTO `tbl_rol` VALUES ('ADM', 'Administrador');
INSERT INTO `tbl_rol` VALUES ('PRO', 'Propietario');
INSERT INTO `tbl_rol` VALUES ('ENC', 'Encargado');
INSERT INTO `tbl_rol` VALUES ('OFC', 'Oficinista');
INSERT INTO `tbl_rol` VALUES ('RES', 'Residente');
INSERT INTO `tbl_rol` VALUES ('VIS', 'Visita');

-- ----------------------------
-- Table structure for tbl_rol_restriccion
-- ----------------------------
DROP TABLE IF EXISTS `tbl_rol_restriccion`;
CREATE TABLE `tbl_rol_restriccion` (
  `IDRolRestriccion` int NOT NULL AUTO_INCREMENT,
  `Rol` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Restriccion` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Tipo` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`IDRolRestriccion`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tbl_rol_restriccion
-- ----------------------------
INSERT INTO `tbl_rol_restriccion` VALUES ('1', 'ENC', 'OFC', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('2', 'ENC', 'VIS', 'V');
INSERT INTO `tbl_rol_restriccion` VALUES ('3', 'RES', 'VIS', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('4', 'OFC', 'VIS', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('5', 'PRO', 'ENC', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('6', 'PRO', 'OFC', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('7', 'PRO', 'RES', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('8', 'PRO', 'VIS', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('9', 'ADM', 'PRO', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('10', 'ADM', 'ENC', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('11', 'ADM', 'OFC', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('12', 'ADM', 'RES', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('13', 'ADM', 'VIS', 'V');
INSERT INTO `tbl_rol_restriccion` VALUES ('14', 'SAD', 'ADM', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('15', 'SAD', 'PRO', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('16', 'SAD', 'ENC', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('17', 'SAD', 'OFC', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('18', 'SAD', 'RES', 'C');
INSERT INTO `tbl_rol_restriccion` VALUES ('19', 'SAD', 'VIS', 'V');

-- ----------------------------
-- Table structure for tbl_sala
-- ----------------------------
DROP TABLE IF EXISTS `tbl_sala`;
CREATE TABLE `tbl_sala` (
  `IDSala` int NOT NULL AUTO_INCREMENT,
  `IDPiso` int DEFAULT NULL,
  `Sala` int DEFAULT NULL,
  PRIMARY KEY (`IDSala`) USING BTREE,
  KEY `FK_PISO_SALA` (`IDPiso`),
  CONSTRAINT `FK_PISO_SALA` FOREIGN KEY (`IDPiso`) REFERENCES `tbl_piso` (`IDPiso`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_sala
-- ----------------------------
INSERT INTO `tbl_sala` VALUES ('1', '1', '1');
INSERT INTO `tbl_sala` VALUES ('2', '1', '2');
INSERT INTO `tbl_sala` VALUES ('3', '1', '5');
INSERT INTO `tbl_sala` VALUES ('4', '1', '6');

-- ----------------------------
-- Table structure for tbl_sala_puerta
-- ----------------------------
DROP TABLE IF EXISTS `tbl_sala_puerta`;
CREATE TABLE `tbl_sala_puerta` (
  `IDSalaPuerta` int NOT NULL AUTO_INCREMENT,
  `IDSala` int DEFAULT NULL,
  `SN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Puerta` int DEFAULT NULL,
  PRIMARY KEY (`IDSalaPuerta`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tbl_sala_puerta
-- ----------------------------
INSERT INTO `tbl_sala_puerta` VALUES ('1', '4', 'AJYX233160037', '1');
INSERT INTO `tbl_sala_puerta` VALUES ('2', '3', 'AJYX233160037', '1');
INSERT INTO `tbl_sala_puerta` VALUES ('3', '2', 'AJYX233160037', '1');
INSERT INTO `tbl_sala_puerta` VALUES ('4', '1', 'AJYX233160037', '2');
INSERT INTO `tbl_sala_puerta` VALUES ('6', '2', 'MWA5244600020', '1');
INSERT INTO `tbl_sala_puerta` VALUES ('7', '3', 'MWA5244600020', '1');
INSERT INTO `tbl_sala_puerta` VALUES ('8', '4', 'MWA5244600020', '1');
INSERT INTO `tbl_sala_puerta` VALUES ('9', '1', 'MWA5244600020', '2');

-- ----------------------------
-- Table structure for tbl_ubicacion
-- ----------------------------
DROP TABLE IF EXISTS `tbl_ubicacion`;
CREATE TABLE `tbl_ubicacion` (
  `IDUbicacion` int NOT NULL AUTO_INCREMENT,
  `IDSala` int DEFAULT NULL,
  `SN` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Puerta` int DEFAULT NULL,
  PRIMARY KEY (`IDUbicacion`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tbl_ubicacion
-- ----------------------------
INSERT INTO `tbl_ubicacion` VALUES ('13', '1', 'AJYX233160037', '2');
INSERT INTO `tbl_ubicacion` VALUES ('14', '2', 'AJYX233160037', '1');
INSERT INTO `tbl_ubicacion` VALUES ('15', '3', 'MWA5244600020', '1');
INSERT INTO `tbl_ubicacion` VALUES ('16', '4', 'MWA5244600020', '2');

-- ----------------------------
-- Table structure for tbl_ubicacion_usuario
-- ----------------------------
DROP TABLE IF EXISTS `tbl_ubicacion_usuario`;
CREATE TABLE `tbl_ubicacion_usuario` (
  `IDUbicacionUsuario` int NOT NULL AUTO_INCREMENT,
  `IDUsuario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IDUbicacion` int DEFAULT NULL,
  PRIMARY KEY (`IDUbicacionUsuario`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tbl_ubicacion_usuario
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_usuarios
-- ----------------------------
DROP TABLE IF EXISTS `tbl_usuarios`;
CREATE TABLE `tbl_usuarios` (
  `IDUsuario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `NombreUsuario` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CorreoElectronico` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Passwd` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `IDRol` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `PassTemp` bit(1) DEFAULT NULL,
  `FechaCreacion` date DEFAULT NULL,
  `Telefono` int DEFAULT NULL,
  PRIMARY KEY (`IDUsuario`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tbl_usuarios
-- ----------------------------
INSERT INTO `tbl_usuarios` VALUES ('10.645.780-8', 'Francisco Vega', 'Franciscovegar@gmail.com', 'cee1b0c12a236777b44af45addfdf17e', 'RES', '', null, '995324428');
INSERT INTO `tbl_usuarios` VALUES ('16.497.336-0', 'Felipe Sepùlveda', 'sepulvedafelipe@sapsg.com', '81dc9bdb52d04dc20036dbd8313ed055', 'ADM', '\0', null, null);
INSERT INTO `tbl_usuarios` VALUES ('16.497.676-0', 'Test user', 'testuser@test.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'ADM', '\0', null, null);
INSERT INTO `tbl_usuarios` VALUES ('741.085.296-3', null, null, 'c3d39cb5a2cd514f50c9adb8f2b42ec3', 'PRO', '', null, '123123132');
INSERT INTO `tbl_usuarios` VALUES ('8.666.092-K', 'Claudio', 'claudiodominguez@msci.cl', '827ccb0eea8a706c4c34a16891f84e7b', 'PRO', '\0', null, '942769382');

-- ----------------------------
-- Table structure for tbl_visita
-- ----------------------------
DROP TABLE IF EXISTS `tbl_visita`;
CREATE TABLE `tbl_visita` (
  `IDVisita` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `NombreVisita` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `CorreoElectronico` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Telefono` int DEFAULT NULL,
  `Rol` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'VIS',
  `FechaInicio` datetime DEFAULT NULL,
  `FechaTermino` datetime DEFAULT NULL,
  `IDUbicacion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`IDVisita`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tbl_visita
-- ----------------------------
INSERT INTO `tbl_visita` VALUES ('13.443.663-8', 'Felipe', 'sepulvedafelipe@sapsg.com', '954671324', 'VIS', '2026-02-02 14:23:34', '2026-02-04 14:23:34', '1');
INSERT INTO `tbl_visita` VALUES ('24.223.544-4', 'invitado Cristian ', 'cristian.sarmiento.s@gmail.com', '944753708', 'VIS', '2025-10-24 11:31:54', '2025-10-26 11:31:54', '1');
INSERT INTO `tbl_visita` VALUES ('410.520.637-8', 'TEst ', 'likatav129@atinjo.com', '741085296', 'VIS', '2026-01-13 14:11:00', '2026-01-15 14:11:00', '2');
INSERT INTO `tbl_visita` VALUES ('789.456.123-2', 'Test', 'pitaw21166@atinjo.com', '161437529', 'VIS', '2026-01-13 13:57:00', '2026-01-16 13:57:00', '1');
INSERT INTO `tbl_visita` VALUES ('8.666.092-k', 'Claudio Dominguez', 'claudio.dominguez@msci.cl', '942769382', 'VIS', '2025-09-05 09:58:53', '2025-09-07 09:58:53', '3');
INSERT INTO `tbl_visita` VALUES ('963.852.741-0', 'Test', 'test@test.com', '789456132', 'VIS', '2026-01-19 14:33:00', '2026-01-14 14:33:00', '3');

-- ----------------------------
-- Procedure structure for sp_add_device_command
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_add_device_command`;
DELIMITER ;;
CREATE PROCEDURE `sp_add_device_command`(
    IN p_sn VARCHAR(50),
    IN p_command_id INT,
    IN p_command TEXT,
    IN p_priority INT
)
BEGIN
    DECLARE queue_count INT;
    DECLARE max_queue_size INT;
    
    -- Get max queue size from config
    SELECT CAST(config_value AS UNSIGNED) INTO max_queue_size 
    FROM push_protocol_config 
    WHERE config_key = 'MAX_COMMAND_QUEUE_SIZE';
    
    -- Count pending commands
    SELECT COUNT(*) INTO queue_count
    FROM device_command_queue
    WHERE sn = p_sn AND status = 'pending';
    
    -- Remove oldest command if queue is full
    IF queue_count >= max_queue_size THEN
        DELETE FROM device_command_queue
        WHERE id = (
            SELECT id FROM (
                SELECT id FROM device_command_queue
                WHERE sn = p_sn AND status = 'pending'
                ORDER BY priority ASC, created_at ASC
                LIMIT 1
            ) AS oldest
        );
    END IF;
    
    -- Insert new command
    INSERT INTO device_command_queue (sn, command_id, command, priority)
    VALUES (p_sn, p_command_id, p_command, COALESCE(p_priority, 0));
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_cleanup_old_commands
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_cleanup_old_commands`;
DELIMITER ;;
CREATE PROCEDURE `sp_cleanup_old_commands`(
    IN p_days INT
)
BEGIN
    DELETE FROM device_command_queue
    WHERE status IN ('executed', 'failed')
    AND created_at < DATE_SUB(NOW(), INTERVAL p_days DAY);
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_get_active_devices
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_active_devices`;
DELIMITER ;;
CREATE PROCEDURE `sp_get_active_devices`()
BEGIN
    SELECT * FROM device_registry 
    WHERE is_active = 1 
    ORDER BY last_seen DESC;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_get_device_by_sn
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_device_by_sn`;
DELIMITER ;;
CREATE PROCEDURE `sp_get_device_by_sn`(
    IN p_sn VARCHAR(50)
)
BEGIN
    SELECT * FROM device_registry WHERE sn = p_sn;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_get_next_command
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_next_command`;
DELIMITER ;;
CREATE PROCEDURE `sp_get_next_command`(
    IN p_sn VARCHAR(50)
)
BEGIN
    DECLARE cmd_id BIGINT;
    
    -- Get the highest priority pending command
    SELECT id INTO cmd_id
    FROM device_command_queue
    WHERE sn = p_sn AND status = 'pending'
    ORDER BY priority DESC, created_at ASC
    LIMIT 1;
    
    IF cmd_id IS NOT NULL THEN
        -- Update status to sent
        UPDATE device_command_queue
        SET status = 'sent', sent_at = NOW()
        WHERE id = cmd_id;
        
        -- Return the command
        SELECT * FROM device_command_queue WHERE id = cmd_id;
    ELSE
        -- Return empty result
        SELECT NULL as id, NULL as command;
    END IF;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_get_push_config
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_push_config`;
DELIMITER ;;
CREATE PROCEDURE `sp_get_push_config`()
BEGIN
    SELECT config_key, config_value FROM push_protocol_config;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_log_device_connection
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_log_device_connection`;
DELIMITER ;;
CREATE PROCEDURE `sp_log_device_connection`(
    IN p_sn VARCHAR(50),
    IN p_event_type VARCHAR(20),
    IN p_ip_address VARCHAR(45),
    IN p_details TEXT
)
BEGIN
    INSERT INTO device_connection_log (sn, event_type, ip_address, details)
    VALUES (p_sn, p_event_type, p_ip_address, p_details);
    
    -- Update last_seen for device
    UPDATE device_registry
    SET last_seen = NOW()
    WHERE sn = p_sn;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_register_device
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_register_device`;
DELIMITER ;;
CREATE PROCEDURE `sp_register_device`(
    IN p_sn VARCHAR(50),
    IN p_registry_code VARCHAR(20),
    IN p_device_name VARCHAR(100),
    IN p_firmware_version VARCHAR(50),
    IN p_mac_address VARCHAR(50),
    IN p_ip_address VARCHAR(45),
    IN p_model VARCHAR(50),
    IN p_push_version VARCHAR(20),
    IN p_session_id VARCHAR(100)
)
BEGIN
    INSERT INTO device_registry (
        sn, registry_code, device_name, firmware_version, 
        mac_address, ip_address, model, push_version, session_id, last_seen
    ) VALUES (
        p_sn, p_registry_code, p_device_name, p_firmware_version,
        p_mac_address, p_ip_address, p_model, p_push_version, p_session_id, NOW()
    )
    ON DUPLICATE KEY UPDATE
        device_name = p_device_name,
        firmware_version = p_firmware_version,
        mac_address = p_mac_address,
        ip_address = p_ip_address,
        model = p_model,
        push_version = p_push_version,
        session_id = p_session_id,
        last_seen = NOW(),
        is_active = 1;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_register_device_enhanced
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_register_device_enhanced`;
DELIMITER ;;
CREATE PROCEDURE `sp_register_device_enhanced`(
    IN p_sn VARCHAR(50),
    IN p_registry_code VARCHAR(20),
    IN p_device_name VARCHAR(100),
    IN p_firmware_version VARCHAR(50),
    IN p_mac_address VARCHAR(50),
    IN p_ip_address VARCHAR(45),
    IN p_model VARCHAR(50),
    IN p_push_version VARCHAR(20),
    IN p_session_id VARCHAR(100),
    IN p_device_type VARCHAR(50),
    IN p_comm_type VARCHAR(50),
    IN p_max_package_size INT,
    IN p_lock_count INT,
    IN p_reader_count INT,
    IN p_aux_in_count INT,
    IN p_aux_out_count INT,
    IN p_machine_type VARCHAR(50),
    IN p_max_user_count INT,
    IN p_max_attlog_count INT,
    IN p_max_finger_count INT,
    IN p_max_user_finger_count INT,
    IN p_netmask VARCHAR(45),
    IN p_gateway VARCHAR(45),
    IN p_zkfp_version VARCHAR(20),
    IN p_verify_styles VARCHAR(50),
    IN p_event_types TEXT,
    IN p_features JSON,
    IN p_capabilities JSON,
    IN p_raw_data JSON
)
BEGIN
    INSERT INTO device_registry (
        sn, registry_code, device_name, firmware_version, 
        mac_address, ip_address, model, push_version, session_id,
        device_type, comm_type, max_package_size, lock_count, reader_count,
        aux_in_count, aux_out_count, machine_type, max_user_count,
        max_attlog_count, max_finger_count, max_user_finger_count,
        netmask, gateway, zkfp_version, verify_styles, event_types,
        features, capabilities, raw_data, last_seen
    ) VALUES (
        p_sn, p_registry_code, p_device_name, p_firmware_version,
        p_mac_address, p_ip_address, p_model, p_push_version, p_session_id,
        p_device_type, p_comm_type, p_max_package_size, p_lock_count, p_reader_count,
        p_aux_in_count, p_aux_out_count, p_machine_type, p_max_user_count,
        p_max_attlog_count, p_max_finger_count, p_max_user_finger_count,
        p_netmask, p_gateway, p_zkfp_version, p_verify_styles, p_event_types,
        p_features, p_capabilities, p_raw_data, NOW()
    )
    ON DUPLICATE KEY UPDATE
        device_name = p_device_name,
        firmware_version = p_firmware_version,
        mac_address = p_mac_address,
        ip_address = p_ip_address,
        model = p_model,
        push_version = p_push_version,
        session_id = p_session_id,
        device_type = p_device_type,
        comm_type = p_comm_type,
        max_package_size = p_max_package_size,
        lock_count = p_lock_count,
        reader_count = p_reader_count,
        aux_in_count = p_aux_in_count,
        aux_out_count = p_aux_out_count,
        machine_type = p_machine_type,
        max_user_count = p_max_user_count,
        max_attlog_count = p_max_attlog_count,
        max_finger_count = p_max_finger_count,
        max_user_finger_count = p_max_user_finger_count,
        netmask = p_netmask,
        gateway = p_gateway,
        zkfp_version = p_zkfp_version,
        verify_styles = p_verify_styles,
        event_types = p_event_types,
        features = p_features,
        capabilities = p_capabilities,
        raw_data = p_raw_data,
        last_seen = NOW(),
        is_active = 1;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_save_device_access_log
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_save_device_access_log`;
DELIMITER ;;
CREATE PROCEDURE `sp_save_device_access_log`(
    IN p_sn VARCHAR(50),
    IN p_card_no VARCHAR(50),
    IN p_card_decimal BIGINT,
    IN p_door_no INT,
    IN p_access_result VARCHAR(20),
    IN p_denial_reason VARCHAR(100),
    IN p_event_code VARCHAR(10),
    IN p_original_event_code VARCHAR(10),
    IN p_user_id VARCHAR(50),
    IN p_event_time TIMESTAMP,
    IN p_in_out_status INT,
    IN p_verify_type INT,
    IN p_room_id INT,
    IN p_is_visitor BOOLEAN,
    IN p_visitor_deleted BOOLEAN,
    IN p_access_start_time TIMESTAMP,
    IN p_access_end_time TIMESTAMP,
    IN p_server_time TIMESTAMP,
    IN p_device_ip VARCHAR(45),
    IN p_event_data JSON
)
BEGIN
    INSERT INTO device_access_logs (
        sn, card_no, card_decimal, door_no, access_result, denial_reason,
        event_code, original_event_code, user_id, event_time, in_out_status, verify_type,
        room_id, is_visitor, visitor_deleted, access_start_time, access_end_time,
        server_time, device_ip, event_data
    ) VALUES (
        p_sn, p_card_no, p_card_decimal, p_door_no, p_access_result, p_denial_reason,
        p_event_code, p_original_event_code, p_user_id, p_event_time, p_in_out_status, p_verify_type,
        p_room_id, p_is_visitor, p_visitor_deleted, p_access_start_time, p_access_end_time,
        p_server_time, p_device_ip, p_event_data
    );
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_save_realtime_event
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_save_realtime_event`;
DELIMITER ;;
CREATE PROCEDURE `sp_save_realtime_event`(
    IN p_sn VARCHAR(50),
    IN p_event_type VARCHAR(50),
    IN p_event_code VARCHAR(10),
    IN p_user_id VARCHAR(50),
    IN p_card_no VARCHAR(50),
    IN p_door_no INT,
    IN p_event_time TIMESTAMP,
    IN p_in_out_status INT,
    IN p_verify_type INT,
    IN p_event_data JSON
)
BEGIN
    INSERT INTO device_realtime_events (
        sn, event_type, event_code, user_id, card_no, door_no,
        event_time, in_out_status, verify_type, event_data
    ) VALUES (
        p_sn, p_event_type, p_event_code, p_user_id, p_card_no, p_door_no,
        p_event_time, p_in_out_status, p_verify_type, p_event_data
    );
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_update_command_result
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_update_command_result`;
DELIMITER ;;
CREATE PROCEDURE `sp_update_command_result`(
    IN p_command_id INT,
    IN p_sn VARCHAR(50),
    IN p_result TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE device_command_queue
    SET 
        result = p_result,
        status = p_status,
        executed_at = NOW()
    WHERE command_id = p_command_id AND sn = p_sn;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_update_device_last_seen
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_update_device_last_seen`;
DELIMITER ;;
CREATE PROCEDURE `sp_update_device_last_seen`(
    IN p_sn VARCHAR(50)
)
BEGIN
    UPDATE device_registry
    SET last_seen = NOW()
    WHERE sn = p_sn;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Acceso_Eliminar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Acceso_Eliminar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Acceso_Eliminar`(IN pid VARCHAR(10))
BEGIN

  DELETE FROM tbl_acceso WHERE IDAcceso = pid;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Acceso_ObtenerPorAcceso
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Acceso_ObtenerPorAcceso`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Acceso_ObtenerPorAcceso`(IN pid VARCHAR(10))
BEGIN
  #Routine body goes here...
  SELECT 
		IDAcceso,
    IDUsuario,
    Payload
  FROM tbl_acceso WHERE IDAcceso = pid;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Acceso_ObtenerPorUsuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Acceso_ObtenerPorUsuario`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Acceso_ObtenerPorUsuario`(IN prut VARCHAR(50))
BEGIN
  #Routine body goes here...
  SELECT 
		IDAcceso,
    IDUsuario,
    Payload
  FROM tbl_acceso WHERE IDUsuario = prut;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Areas_Estacionamiento_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Areas_Estacionamiento_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Areas_Estacionamiento_Guardar`(IN parea VARCHAR(35), IN pregion int, IN ppuestos int, IN pnotas VARCHAR(35))
BEGIN

	INSERT INTO tbl_area_estacionamiento(Area, RegionArea, Puestos, Notas)
	VALUES(parea, pregion, ppuestos, pnotas);
		
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Areas_Estacionamiento_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Areas_Estacionamiento_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Areas_Estacionamiento_Listar`()
BEGIN
  #Routine body goes here...
  SELECT 
    IDArea,
		Area,
		(select Region FROM tbl_region_estacionamiento where IDRegion = RegionArea) as RegionArea,
		Puestos,
		Notas
  FROM tbl_area_estacionamiento ORDER BY Area ASC;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Casetas_Estacionamiento_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Casetas_Estacionamiento_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Casetas_Estacionamiento_Guardar`(IN pcaseta VARCHAR(35), IN parea int, IN pequipo VARCHAR(35), IN ppase int)
BEGIN

	INSERT INTO tbl_caseta_estacionamiento(Caseta, Area, Equipo, Pase)
	VALUES(pcaseta, parea, pequipo, ppase);
		
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Casetas_Estacionamiento_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Casetas_Estacionamiento_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Casetas_Estacionamiento_Listar`()
BEGIN
  #Routine body goes here...
  SELECT 
    IDCaseta,
		Caseta,
#IDArea,
		(select Area FROM tbl_area_estacionamiento where IDArea = IDArea LIMIT 1) as Area,
		Equipo,
		Pase
  FROM tbl_caseta_estacionamiento ORDER BY IDCaseta ASC;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Device_Get
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Device_Get`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Device_Get`()
BEGIN
  SELECT *
  FROM Dispositivos
  ORDER BY creado_en DESC;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Dispositivo_ActualizarActivo
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Dispositivo_ActualizarActivo`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Dispositivo_ActualizarActivo`(
    IN p_id INT,
    IN p_activo TINYINT
)
BEGIN
    UPDATE Dispositivos
    SET activo = p_activo
    WHERE id = p_id;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Dispositivo_Editar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Dispositivo_Editar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Dispositivo_Editar`(
    IN p_numero_serie VARCHAR(50),
    IN p_nombre VARCHAR(100),
    IN p_codigo_registro VARCHAR(100),
    IN p_version_firmware VARCHAR(50),
    IN p_ip_address VARCHAR(50),
    IN p_building VARCHAR(100),
    IN p_door VARCHAR(100),
    IN p_deteccion_mascara TINYINT,
    IN p_deteccion_infrarrojo TINYINT,
    IN p_activo TINYINT
)
BEGIN
    UPDATE Dispositivos
    SET
        nombre = p_nombre,
        codigo_registro = p_codigo_registro,
        version_firmware = p_version_firmware,
        ip_address = p_ip_address,
        building = p_building,
        door = p_door,
        deteccion_mascara = p_deteccion_mascara,
        deteccion_infrarrojo = p_deteccion_infrarrojo,
        activo = p_activo
    WHERE numero_serie = p_numero_serie COLLATE utf8mb4_general_ci;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Dispositivo_Eliminar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Dispositivo_Eliminar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Dispositivo_Eliminar`(
    IN p_id INT
)
BEGIN
    DELETE FROM Dispositivos
    WHERE id = p_id;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Dispositivo_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Dispositivo_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Dispositivo_Guardar`(
    IN p_numero_serie VARCHAR(100),
    IN p_nombre VARCHAR(100),
    IN p_codigo_registro VARCHAR(100),
    IN p_version_firmware VARCHAR(50),
    IN p_ip_address VARCHAR(45),
    IN p_building VARCHAR(100),
    IN p_door VARCHAR(100),
    IN p_deteccion_mascara TINYINT,
    IN p_deteccion_infrarrojo TINYINT,
    IN p_activo TINYINT
)
BEGIN
    INSERT INTO Dispositivos (
        numero_serie,
        nombre,
        codigo_registro,
        version_firmware,
        ip_address,
        building,
        door,
        deteccion_mascara,
        deteccion_infrarrojo,
        activo
    )
    VALUES (
        p_numero_serie,
        p_nombre,
        p_codigo_registro,
        p_version_firmware,
        p_ip_address,
        p_building,
        p_door,
        p_deteccion_mascara,
        p_deteccion_infrarrojo,
        p_activo
    );

    SELECT LAST_INSERT_ID() AS dispositivo_id;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Dispositivo_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Dispositivo_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Dispositivo_Listar`()
BEGIN

  SELECT
    d.id,
    d.numero_serie,
    d.nombre,
    d.codigo_registro,
    d.version_firmware,
    d.ip_address,
    d.building,
    d.door,
    d.deteccion_mascara,
    d.deteccion_infrarrojo,
    d.activo,
    d.creado_en,
    d.actualizado_en
  FROM Dispositivos d
  ORDER BY d.creado_en DESC;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Edificio_Actualizar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Edificio_Actualizar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Edificio_Actualizar`(IN pid INT, IN pedi CHAR(1))
BEGIN

	UPDATE tbl_edificio SET Edificio = pedi
	WHERE IDEdificio = pid;
		
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Edificio_Eliminar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Edificio_Eliminar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Edificio_Eliminar`(IN pid INT)
BEGIN

	DELETE FROM tbl_edificio WHERE IDEdificio = pid;
		
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Edificio_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Edificio_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Edificio_Guardar`(IN pedi CHAR(1))
BEGIN

	INSERT INTO tbl_edificio(Edificio) VALUES(pedi);
		
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Edificio_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Edificio_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Edificio_Listar`()
BEGIN
  #Routine body goes here...
  SELECT 
    IDEdificio,
		Edificio
  FROM tbl_edificio ORDER BY Edificio ASC;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Emp_Eliminar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Emp_Eliminar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Emp_Eliminar`(IN pidusuario INT)
BEGIN
  #Routine body goes here...
  DELETE FROM tbl_emp WHERE IDUsuario = pidusuario;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Emp_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Emp_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Emp_Guardar`(IN pidusuario INT, IN pnombre VARCHAR(255), IN pnumerotarjeta INT, IN ppass VARCHAR(255), IN ptiempoinicio VARCHAR(25), IN ptiempofinal VARCHAR(25), IN psuperuser BIT)
BEGIN
  #Routine body goes here...
  INSERT INTO tbl_emp(IDUsuario, Nombre, NumeroTarjeta, `Password`, TiempoInicio, TiempoFinal, SuperUser) 
  VALUES(pidusuario, pnombre, pnumerotarjeta, ppass, ptiempoinicio, ptiempofinal, psuperuser);
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Emp_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Emp_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Emp_Listar`()
BEGIN
  #Routine body goes here...
  SELECT 
    IDUsuario,
    Nombre,
    NumeroTarjeta,
    `Password`,
    IFNULL(TiempoInicio, '') AS TiempoInicio,
    IFNULL(TiempoFinal, '') AS TiempoFinal,
    SuperUser
  FROM tbl_emp;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Huella_InsertarWS
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Huella_InsertarWS`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Huella_InsertarWS`(IN prut VARCHAR(50), IN pfid INT, IN pinfo LONGTEXT)
BEGIN
  #Routine body goes here...
  INSERT INTO tbl_huella(IDUsuario, IDDedo, DatoHuella)
  VALUES(prut, pfid, pinfo);
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_IDAcceso_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_IDAcceso_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_IDAcceso_Listar`()
BEGIN
  #Routine body goes here...
  SELECT 
		IDAcceso
  FROM tbl_acceso;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Log_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Log_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Log_Guardar`(IN pfuncion VARCHAR(255), IN plinea INT, IN prequest LONGTEXT)
BEGIN
	#Routine body goes here...
	INSERT INTO tbl_log(Funcion, Linea, Request)
  VALUES(pfuncion, plinea, prequest);
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Mobile_Rol_Select
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Mobile_Rol_Select`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Mobile_Rol_Select`(IN puser VARCHAR(50))
BEGIN
	#Routine body goes here...
	DECLARE var_rol VARCHAR(3) DEFAULT "";
	
	SELECT IDRol INTO var_rol FROM tbl_usuarios WHERE IDUsuario = puser;
	
	SELECT rr.*,r.Descripcion FROM tbl_rol_restriccion rr LEFT JOIN tbl_rol r ON rr.Restriccion = r.IDRol WHERE Rol = var_rol;
	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Mobile_Unidad_Select
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Mobile_Unidad_Select`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Mobile_Unidad_Select`(IN puser VARCHAR(50))
BEGIN
	#Routine body goes here...
	DECLARE var_rol VARCHAR(3) DEFAULT "";
	DECLARE param TEXT DEFAULT "";

	SELECT IDRol INTO var_rol FROM tbl_usuarios WHERE IDUsuario = puser;
	
	SET param = IF(var_rol = "SAD" OR var_rol = "ADM", "FROM tbl_ubicacion u", 
	CONCAT('FROM `tbl_ubicacion_usuario` uu LEFT JOIN tbl_ubicacion u ON uu.IDUbicacion = u.IDUbicacion WHERE uu.IDUsuario = "', puser, '"'));
	
	SET @sql = CONCAT('SELECT 
		u.IDUbicacion,
		CONCAT(u.NroEdificio, "-", u.NroHabitacion) AS Unidad ', param, ';');
  PREPARE stmt1 FROM @sql ;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;
	
	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Mobile_Usuarios_Agregar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Mobile_Usuarios_Agregar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Mobile_Usuarios_Agregar`(IN prut VARCHAR(50), IN pname VARCHAR(50), IN ppass VARCHAR(50), IN pemail VARCHAR(100), IN ptelefono INT(9), IN prol VARCHAR(3), IN pfecha VARCHAR(10), IN pubi INT)
BEGIN
  #Routine body goes here...
  
  INSERT INTO tbl_usuarios(IDUsuario, NombreUsuario, Passwd, CorreoElectronico, Telefono, IDRol, FechaCreacion, PassTemp) 
	VALUES(prut, pname, MD5(ppass), pemail, ptelefono, prol, pfecha, 1);
	
	INSERT INTO tbl_ubicacion_usuario(IDUbicacion, IDUsuario)
	VALUES(pubi, prut);
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Mobile_Visita_Actualizar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Mobile_Visita_Actualizar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Mobile_Visita_Actualizar`(IN prut VARCHAR(50), IN pname VARCHAR(50), IN pemail VARCHAR(100), IN ptelefono INT(9), IN pfechainicio VARCHAR(20), IN pfechatermino VARCHAR(20), IN pubi INT)
BEGIN
  #Routine body goes here...
  
  UPDATE tbl_visita SET
    NombreVisita = pname, CorreoElectronico = pemail, Telefono = ptelefono, FechaInicio = pfechainicio,
    FechaTermino = pfechatermino, IDUbicacion = pubi
  WHERE IDVisita = prut;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Mobile_Visita_Agregar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Mobile_Visita_Agregar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Mobile_Visita_Agregar`(IN prut VARCHAR(50), IN pname VARCHAR(50), IN pemail VARCHAR(100), IN ptelefono INT(9), IN pfechainicio VARCHAR(20), IN pfechatermino VARCHAR(20), IN pubi INT)
BEGIN
  #Routine body goes here...
  
  INSERT INTO tbl_visita(IDVisita, NombreVisita, CorreoElectronico, Telefono, FechaInicio, FechaTermino, IDUbicacion) 
	VALUES(prut, pname, pemail, ptelefono, pfechainicio, pfechatermino, pubi);
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Piso_Actualizar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Piso_Actualizar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Piso_Actualizar`(IN pid INT, IN pidedi INT, IN ppiso INT)
BEGIN

	UPDATE tbl_piso SET IDEdificio = pidedi, Piso = ppiso
	WHERE IDPiso = pid;
		
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Piso_Eliminar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Piso_Eliminar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Piso_Eliminar`(IN pid INT)
BEGIN

	DELETE FROM tbl_piso WHERE IDPiso = pid;
		
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Piso_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Piso_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Piso_Guardar`(IN pidedi INT, IN ppiso INT)
BEGIN

	INSERT INTO tbl_piso(IDEdificio, Piso) VALUES(pidedi, ppiso);
		
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Piso_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Piso_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Piso_Listar`()
BEGIN
  #Routine body goes here...
  SELECT 
    p.IDPiso,
		e.IDEdificio,
		e.Edificio,
		p.Piso
  FROM tbl_piso p
	LEFT JOIN tbl_edificio e ON p.IDEdificio = e.IDEdificio
	ORDER BY e.Edificio ASC, p.Piso ASC;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Rol_Select
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Rol_Select`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Rol_Select`(IN puser VARCHAR(50))
BEGIN
	#Routine body goes here...
	DECLARE var_rol VARCHAR(3) DEFAULT "";
	
	SELECT IDRol INTO var_rol FROM tbl_usuarios WHERE IDUsuario = puser;
	
	SELECT rr.*,r.Descripcion FROM tbl_rol_restriccion rr LEFT JOIN tbl_rol r ON rr.Restriccion = r.IDRol WHERE Rol = var_rol AND rr.Tipo <> "V";
	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Sala_Actualizar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Sala_Actualizar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Sala_Actualizar`(IN pid INT, IN ppiso INT, IN psala INT)
BEGIN

	UPDATE tbl_sala SET IDPiso = ppiso, Sala = psala
	WHERE IDSala = pid;
	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Sala_Eliminar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Sala_Eliminar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Sala_Eliminar`(IN pid INT)
BEGIN

	DELETE FROM tbl_sala WHERE IDSala = pid;
	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Sala_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Sala_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Sala_Guardar`(IN ppiso INT, IN psala INT)
BEGIN

	INSERT INTO tbl_sala(IDPiso, Sala) VALUES(ppiso, psala);
	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Sala_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Sala_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Sala_Listar`()
BEGIN
  #Routine body goes here...
  SELECT 
		p.IDEdificio,
		e.Edificio,
		s.IDPiso,
		p.Piso,
    s.IDSala,
		s.Sala
  FROM tbl_sala s
	LEFT JOIN tbl_piso p ON s.IDPiso = p.IDPiso
	LEFT JOIN tbl_edificio e ON p.IDEdificio = e.IDEdificio;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Ubicacion_Eliminar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Ubicacion_Eliminar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Ubicacion_Eliminar`(IN pid INT)
BEGIN
  
  DELETE FROM tbl_ubicacion WHERE IDUbicacion = pid;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Ubicacion_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Ubicacion_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Ubicacion_Guardar`(IN pidsala INT, IN psn VARCHAR(255), IN ppuerta INT)
BEGIN
  #Routine body goes here...
  INSERT INTO tbl_ubicacion(IDSala, SN, Puerta)
  VALUES(pidsala, psn, ppuerta);
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Ubicacion_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Ubicacion_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Ubicacion_Listar`()
BEGIN
  
	SELECT
		u.IDUbicacion,
 		p.IDEdificio,
 		e.Edificio,
 		s.IDPiso,
 		p.Piso,
    u.IDSala,
 		s.Sala,
		u.SN,
		u.Puerta
  FROM tbl_ubicacion u, tbl_sala s
 	LEFT JOIN tbl_piso p ON s.IDPiso = p.IDPiso
	LEFT JOIN tbl_edificio e ON p.IDEdificio = e.IDEdificio
	WHERE u.IDSala = s.IDSala;
	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Ubicacion_ObtenerPorSNPuerta
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Ubicacion_ObtenerPorSNPuerta`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Ubicacion_ObtenerPorSNPuerta`(IN psn VARCHAR(255), IN ppuerta INT)
BEGIN
  #Routine body goes here...
  SELECT 
    e.Edificio,
    u.IDSala,
    CONCAT(p.Piso, s.Sala) AS PisoSala,
    u.Puerta
  FROM tbl_ubicacion u
  LEFT JOIN tbl_sala s ON u.IDSala = s.IDSala
  LEFT JOIN tbl_piso p ON s.IDPiso = p.IDPiso
  LEFT JOIN tbl_edificio e ON p.IDEdificio = e.IDEdificio
  WHERE u.SN = psn AND u.Puerta = ppuerta;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Ubicacion_Usuarios_ObtenerPorID
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Ubicacion_Usuarios_ObtenerPorID`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Ubicacion_Usuarios_ObtenerPorID`(IN pid VARCHAR(50))
BEGIN
  #Routine body goes here...
  
  SELECT 
    NroEdificio AS Edificio,
    NroHabitacion AS PisoSala
  FROM tbl_ubicacion_usuario uu 
  LEFT JOIN tbl_ubicacion u ON uu.IDUbicacion = u.IDUbicacion
  WHERE IDUsuario = pid OR REPLACE(REPLACE(IDUsuario, '.', ''), '-', '') = pid;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Usuario_AgregarEnlace
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Usuario_AgregarEnlace`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Usuario_AgregarEnlace`(IN pacceso VARCHAR(10), IN prut VARCHAR(50), IN ppayload VARCHAR(255))
BEGIN
  #Routine body goes here...
  
  INSERT INTO tbl_acceso(IDAcceso, IDUsuario, Payload) 
	VALUES(pacceso, prut, ppayload);
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Usuario_Eliminar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Usuario_Eliminar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Usuario_Eliminar`(IN prut VARCHAR(50))
BEGIN
  
  DELETE FROM tbl_usuarios WHERE IDUsuario = prut;
	DELETE FROM tbl_acceso WHERE IDUsuario = prut;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Usuario_Enlace_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Usuario_Enlace_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Usuario_Enlace_Listar`(IN prut VARCHAR(50))
BEGIN
  #Routine body goes here...
  SELECT 
		IFNULL(IDAcceso, "") AS IDAcceso,
		IFNULL(IDUsuario, "") AS IDUsuario,
		IFNULL(Payload, "") AS Payload
  FROM tbl_acceso
  WHERE IDUsuario = prut;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Usuario_Guardar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Usuario_Guardar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Usuario_Guardar`(IN prut VARCHAR(50), IN pname VARCHAR(50), IN ppass VARCHAR(50), IN pemail VARCHAR(100), IN ptelefono INT(9), IN prol VARCHAR(3))
BEGIN
  #Routine body goes here...
  
  INSERT INTO tbl_usuarios(IDUsuario, NombreUsuario, Passwd, CorreoElectronico, Telefono, IDRol, PassTemp) 
	VALUES(prut, pname, MD5(ppass), pemail, ptelefono, prol, 1);
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Usuario_Listar
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Usuario_Listar`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Usuario_Listar`()
BEGIN
  #Routine body goes here...
  SELECT 
		IFNULL(u.IDUsuario, "") AS IDUsuario,
		IFNULL(u.NombreUsuario, "") AS NombreUsuario,
		IFNULL(u.CorreoElectronico, "") AS CorreoElectronico,
		IFNULL(u.Telefono, "") AS Telefono,
		IFNULL(u.IDRol, "") AS IDRol,
		IFNULL(r.Descripcion, "") AS Rol,
    IFNULL(a.IDAcceso, "") AS IDAcceso
  FROM tbl_usuarios u
	LEFT JOIN tbl_rol r ON u.IDRol = r.IDRol
  LEFT JOIN tbl_acceso a ON u.IDUsuario = a.IDUsuario;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Usuario_ObtenerWS
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Usuario_ObtenerWS`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Usuario_ObtenerWS`(IN pid VARCHAR(50))
BEGIN
  #Routine body goes here...
  SELECT 
		IFNULL(u.IDUsuario, "") AS IDUsuario,
		IFNULL(u.NombreUsuario, "") AS NombreUsuario
  FROM tbl_usuarios u
  WHERE IDUsuario = pid;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Usuarios_CambiarPass
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Usuarios_CambiarPass`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Usuarios_CambiarPass`(IN pid VARCHAR(50), IN ppass VARCHAR(50))
BEGIN
  #Routine body goes here...
  
  UPDATE tbl_usuarios SET Passwd = MD5(ppass), PassTemp = 0
	WHERE IDUsuario = pid;
  
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for spPRY_Usuarios_ObtenerPorID
-- ----------------------------
DROP PROCEDURE IF EXISTS `spPRY_Usuarios_ObtenerPorID`;
DELIMITER ;;
CREATE PROCEDURE `spPRY_Usuarios_ObtenerPorID`(IN pid VARCHAR(50))
BEGIN
  #Routine body goes here...
  
  SELECT 
    IDUsuario,
    NombreUsuario,
    Passwd,
    IDRol,
		PassTemp
  FROM tbl_usuarios 
  WHERE IDUsuario = pid OR REPLACE(REPLACE(IDUsuario, '.', ''), '-', '') = pid;
  
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `DeleteUbicacionUsuario`;
DELIMITER ;;
CREATE TRIGGER `DeleteUbicacionUsuario` BEFORE DELETE ON `tbl_usuarios` FOR EACH ROW BEGIN
  DELETE FROM tbl_ubicacion_usuario uu WHERE uu.IDUsuario = old.IDUsuario;
END
;;
DELIMITER ;
SET FOREIGN_KEY_CHECKS=1;
