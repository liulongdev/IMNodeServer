/*
 Navicat Premium Data Transfer

 Source Server         : mysqlserver
 Source Server Type    : SQL Server
 Source Server Version : 11003128
 Source Host           : 112.87.238.213
 Source Database       : userdata
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 11003128
 File Encoding         : utf-8

 Date: 10/17/2017 16:55:13 PM
*/

-- ----------------------------
--  Table structure for UserInfo
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[UserInfo]') AND type IN ('U'))
	DROP TABLE [dbo].[UserInfo]
GO
CREATE TABLE [dbo].[UserInfo] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[userID] int NOT NULL,
	[userNickName] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL
)
ON [PRIMARY]
GO


-- ----------------------------
--  Primary key structure for table UserInfo
-- ----------------------------
ALTER TABLE [dbo].[UserInfo] ADD
	CONSTRAINT [PK__UserInfo__CB9A1CDF9EFF5BBB] PRIMARY KEY CLUSTERED ([userID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Options for table UserInfo
-- ----------------------------
ALTER TABLE [dbo].[UserInfo] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[UserInfo]', RESEED, 3)
GO

