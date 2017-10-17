/*
 Navicat Premium Data Transfer

 Source Server         : mysqlserver
 Source Server Type    : SQL Server
 Source Server Version : 11003128
 Source Host           : 112.87.238.213
 Source Database       : mxr_IM
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 11003128
 File Encoding         : utf-8

 Date: 10/17/2017 16:55:01 PM
*/

-- ----------------------------
--  Table structure for T_ChatRoom
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[T_ChatRoom]') AND type IN ('U'))
	DROP TABLE [dbo].[T_ChatRoom]
GO
CREATE TABLE [dbo].[T_ChatRoom] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[UUID] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[name] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL,
	[chatRoomIcon] varchar(1) COLLATE Chinese_PRC_CI_AS NULL,
	[userMaxNum] int NULL DEFAULT ((0)),
	[type] int NULL DEFAULT ((0)),
	[status] int NULL DEFAULT ((0)),
	[updateTime] datetime NULL,
	[createTime] datetime NULL
)
ON [PRIMARY]
GO
EXEC sp_addextendedproperty 'MS_Description', N'唯一标识', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoom', 'COLUMN', 'UUID'
GO
EXEC sp_addextendedproperty 'MS_Description', N'聊天室名称', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoom', 'COLUMN', 'name'
GO
EXEC sp_addextendedproperty 'MS_Description', N'聊天室图片', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoom', 'COLUMN', 'chatRoomIcon'
GO
EXEC sp_addextendedproperty 'MS_Description', N'聊天室允许的最大用户量 ， 0表示无限', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoom', 'COLUMN', 'userMaxNum'
GO
EXEC sp_addextendedproperty 'MS_Description', N'聊天室类型（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoom', 'COLUMN', 'type'
GO
EXEC sp_addextendedproperty 'MS_Description', N'聊天室的状态（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoom', 'COLUMN', 'status'
GO
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoom', 'COLUMN', 'updateTime'
GO
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoom', 'COLUMN', 'createTime'
GO

-- ----------------------------
--  Table structure for T_User_ChatRoom
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[T_User_ChatRoom]') AND type IN ('U'))
	DROP TABLE [dbo].[T_User_ChatRoom]
GO
CREATE TABLE [dbo].[T_User_ChatRoom] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[UUID] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[userId] int NOT NULL,
	[chatRoomId] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[type] int NULL DEFAULT ((0)),
	[status] int NULL DEFAULT ((0)),
	[createTime] datetime NULL,
	[updateTime] datetime NULL
)
ON [PRIMARY]
GO
EXEC sp_addextendedproperty 'MS_Description', N'唯一标识', 'SCHEMA', 'dbo', 'TABLE', 'T_User_ChatRoom', 'COLUMN', 'UUID'
GO
EXEC sp_addextendedproperty 'MS_Description', N'用户标识', 'SCHEMA', 'dbo', 'TABLE', 'T_User_ChatRoom', 'COLUMN', 'userId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'聊天室标识', 'SCHEMA', 'dbo', 'TABLE', 'T_User_ChatRoom', 'COLUMN', 'chatRoomId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'类型（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_ChatRoom', 'COLUMN', 'type'
GO
EXEC sp_addextendedproperty 'MS_Description', N'状态（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_ChatRoom', 'COLUMN', 'status'
GO
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', 'dbo', 'TABLE', 'T_User_ChatRoom', 'COLUMN', 'createTime'
GO
EXEC sp_addextendedproperty 'MS_Description', N'上次更新时间', 'SCHEMA', 'dbo', 'TABLE', 'T_User_ChatRoom', 'COLUMN', 'updateTime'
GO

-- ----------------------------
--  Table structure for T_ChatRoomMessage
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[T_ChatRoomMessage]') AND type IN ('U'))
	DROP TABLE [dbo].[T_ChatRoomMessage]
GO
CREATE TABLE [dbo].[T_ChatRoomMessage] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[UUID] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[chatRoomId] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[userId] int NOT NULL,
	[content] nvarchar(max) COLLATE Chinese_PRC_CI_AS NULL,
	[contentType] int NULL DEFAULT ((0)),
	[type] int NULL DEFAULT ((0)),
	[status] int NULL DEFAULT ((0)),
	[createTime] datetime NULL,
	[updateTime] datetime NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO
EXEC sp_addextendedproperty 'MS_Description', N'唯一标识', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoomMessage', 'COLUMN', 'UUID'
GO
EXEC sp_addextendedproperty 'MS_Description', N'聊天室标识 外键', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoomMessage', 'COLUMN', 'chatRoomId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'用户标识', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoomMessage', 'COLUMN', 'userId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'消息内容', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoomMessage', 'COLUMN', 'content'
GO
EXEC sp_addextendedproperty 'MS_Description', N'消息的类型（0:纯文字）', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoomMessage', 'COLUMN', 'contentType'
GO
EXEC sp_addextendedproperty 'MS_Description', N'类型（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoomMessage', 'COLUMN', 'type'
GO
EXEC sp_addextendedproperty 'MS_Description', N'状态（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoomMessage', 'COLUMN', 'status'
GO
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoomMessage', 'COLUMN', 'createTime'
GO
EXEC sp_addextendedproperty 'MS_Description', N'上次更新时间', 'SCHEMA', 'dbo', 'TABLE', 'T_ChatRoomMessage', 'COLUMN', 'updateTime'
GO

-- ----------------------------
--  Table structure for T_User_FriendShip
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[T_User_FriendShip]') AND type IN ('U'))
	DROP TABLE [dbo].[T_User_FriendShip]
GO
CREATE TABLE [dbo].[T_User_FriendShip] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[UUID] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[userId] int NOT NULL,
	[friendCollectionId] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[type] int NULL DEFAULT ((0)),
	[status] int NULL DEFAULT ((0)),
	[createTime] datetime NULL,
	[updateTime] datetime NULL
)
ON [PRIMARY]
GO
EXEC sp_addextendedproperty 'MS_Description', N'唯一标识', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip', 'COLUMN', 'UUID'
GO
EXEC sp_addextendedproperty 'MS_Description', N'用户id', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip', 'COLUMN', 'userId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'好友集合ID', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip', 'COLUMN', 'friendCollectionId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'好友关系类型（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip', 'COLUMN', 'type'
GO
EXEC sp_addextendedproperty 'MS_Description', N'好友状态（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip', 'COLUMN', 'status'
GO
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip', 'COLUMN', 'createTime'
GO
EXEC sp_addextendedproperty 'MS_Description', N'最后一次更新时间', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip', 'COLUMN', 'updateTime'
GO

-- ----------------------------
--  Table structure for T_User_FriendShip_Collection
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[T_User_FriendShip_Collection]') AND type IN ('U'))
	DROP TABLE [dbo].[T_User_FriendShip_Collection]
GO
CREATE TABLE [dbo].[T_User_FriendShip_Collection] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[UUID] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[friendGroupId] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[type] int NULL DEFAULT ((0)),
	[status] int NULL DEFAULT ((0)),
	[createTime] datetime NULL,
	[updateTime] datetime NULL
)
ON [PRIMARY]
GO
EXEC sp_addextendedproperty 'MS_Description', N'唯一标识', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Collection', 'COLUMN', 'UUID'
GO
EXEC sp_addextendedproperty 'MS_Description', N'好友分组ID', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Collection', 'COLUMN', 'friendGroupId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'记录的状态（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Collection', 'COLUMN', 'type'
GO
EXEC sp_addextendedproperty 'MS_Description', N'记录的状态（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Collection', 'COLUMN', 'status'
GO
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Collection', 'COLUMN', 'createTime'
GO
EXEC sp_addextendedproperty 'MS_Description', N'最后一次更新时间', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Collection', 'COLUMN', 'updateTime'
GO

-- ----------------------------
--  Table structure for T_User_FriendShip_Group
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[T_User_FriendShip_Group]') AND type IN ('U'))
	DROP TABLE [dbo].[T_User_FriendShip_Group]
GO
CREATE TABLE [dbo].[T_User_FriendShip_Group] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[UUID] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[name] nvarchar(50) COLLATE Chinese_PRC_90_CI_AS_KS NULL,
	[type] int NULL DEFAULT ((0)),
	[status] int NULL DEFAULT ((0)),
	[createTime] datetime NULL,
	[updateTime] datetime NULL
)
ON [PRIMARY]
GO
EXEC sp_addextendedproperty 'MS_Description', N'唯一标识', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Group', 'COLUMN', 'UUID'
GO
EXEC sp_addextendedproperty 'MS_Description', N'分组名称', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Group', 'COLUMN', 'name'
GO
EXEC sp_addextendedproperty 'MS_Description', N'类型（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Group', 'COLUMN', 'type'
GO
EXEC sp_addextendedproperty 'MS_Description', N'状态（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Group', 'COLUMN', 'status'
GO

-- ----------------------------
--  Table structure for T_User_FriendShip_Friend
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[T_User_FriendShip_Friend]') AND type IN ('U'))
	DROP TABLE [dbo].[T_User_FriendShip_Friend]
GO
CREATE TABLE [dbo].[T_User_FriendShip_Friend] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[UUID] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[userId] int NOT NULL,
	[friendGroupId] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[type] int NULL DEFAULT ((0)),
	[status] int NULL DEFAULT ((0)),
	[createTime] datetime NULL,
	[updateTime] datetime NULL
)
ON [PRIMARY]
GO
EXEC sp_addextendedproperty 'MS_Description', N'唯一标识', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Friend', 'COLUMN', 'UUID'
GO
EXEC sp_addextendedproperty 'MS_Description', N'好友的ID', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Friend', 'COLUMN', 'userId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'所在的组ID', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Friend', 'COLUMN', 'friendGroupId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'类型（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Friend', 'COLUMN', 'type'
GO
EXEC sp_addextendedproperty 'MS_Description', N'状态（备用）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Friend', 'COLUMN', 'status'
GO

-- ----------------------------
--  Table structure for T_User_FriendShip_Invitation
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[T_User_FriendShip_Invitation]') AND type IN ('U'))
	DROP TABLE [dbo].[T_User_FriendShip_Invitation]
GO
CREATE TABLE [dbo].[T_User_FriendShip_Invitation] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[UUID] nvarchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[userId] int NOT NULL,
	[invitedUserId] int NOT NULL,
	[content] nvarchar(100) COLLATE Chinese_PRC_CI_AS NULL,
	[type] int NULL DEFAULT ((0)),
	[status] int NULL DEFAULT ((0)),
	[createTime] datetime NULL,
	[updateTime] datetime NULL
)
ON [PRIMARY]
GO
EXEC sp_addextendedproperty 'MS_Description', N'标识', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Invitation', 'COLUMN', 'UUID'
GO
EXEC sp_addextendedproperty 'MS_Description', N'发送邀请的用户id', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Invitation', 'COLUMN', 'userId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'被邀请的用户Id', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Invitation', 'COLUMN', 'invitedUserId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'附带的消息（100字以内）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Invitation', 'COLUMN', 'content'
GO
EXEC sp_addextendedproperty 'MS_Description', N'类型（0:默认申请好友）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Invitation', 'COLUMN', 'type'
GO
EXEC sp_addextendedproperty 'MS_Description', N'状态（0:正在邀请 1:通过邀请 2:拒绝邀请）', 'SCHEMA', 'dbo', 'TABLE', 'T_User_FriendShip_Invitation', 'COLUMN', 'status'
GO

-- ----------------------------
--  Table structure for T_P2P_ChatMessage
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID('[dbo].[T_P2P_ChatMessage]') AND type IN ('U'))
	DROP TABLE [dbo].[T_P2P_ChatMessage]
GO
CREATE TABLE [dbo].[T_P2P_ChatMessage] (
	[ID] int IDENTITY(1,1) NOT NULL,
	[UUID] varchar(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[senderId] int NOT NULL,
	[receiverId] int NOT NULL,
	[content] nvarchar(max) COLLATE Chinese_PRC_CI_AS NULL,
	[type] int NULL DEFAULT ((0)),
	[status] int NULL DEFAULT ((0)),
	[createTime] datetime NULL,
	[updateTime] datetime NULL,
	[contentType] int NULL DEFAULT ((0))
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO
EXEC sp_addextendedproperty 'MS_Description', N'递增', 'SCHEMA', 'dbo', 'TABLE', 'T_P2P_ChatMessage', 'COLUMN', 'ID'
GO
EXEC sp_addextendedproperty 'MS_Description', N'发送方', 'SCHEMA', 'dbo', 'TABLE', 'T_P2P_ChatMessage', 'COLUMN', 'senderId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'接收方id', 'SCHEMA', 'dbo', 'TABLE', 'T_P2P_ChatMessage', 'COLUMN', 'receiverId'
GO
EXEC sp_addextendedproperty 'MS_Description', N'发送的内容', 'SCHEMA', 'dbo', 'TABLE', 'T_P2P_ChatMessage', 'COLUMN', 'content'
GO


-- ----------------------------
--  Primary key structure for table T_ChatRoom
-- ----------------------------
ALTER TABLE [dbo].[T_ChatRoom] ADD
	CONSTRAINT [PK__T_ChatRo__CB59B0AAAE725BDF] PRIMARY KEY CLUSTERED ([UUID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Primary key structure for table T_User_ChatRoom
-- ----------------------------
ALTER TABLE [dbo].[T_User_ChatRoom] ADD
	CONSTRAINT [PK__T_User_C__27E1155DFF169702] PRIMARY KEY CLUSTERED ([UUID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Uniques structure for table T_User_ChatRoom
-- ----------------------------
ALTER TABLE [dbo].[T_User_ChatRoom] ADD
	CONSTRAINT [UQ__T_User_C__F72F97B716D86C2B] UNIQUE NONCLUSTERED ([userId] ASC, [chatRoomId] ASC) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [PRIMARY]
GO

-- ----------------------------
--  Primary key structure for table T_ChatRoomMessage
-- ----------------------------
ALTER TABLE [dbo].[T_ChatRoomMessage] ADD
	CONSTRAINT [PK__T_ChatRo__4808B9931FC056B7] PRIMARY KEY CLUSTERED ([UUID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Primary key structure for table T_User_FriendShip
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip] ADD
	CONSTRAINT [PK__T_User_F__3214EC275B46E42B] PRIMARY KEY CLUSTERED ([UUID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Primary key structure for table T_User_FriendShip_Collection
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Collection] ADD
	CONSTRAINT [PK__T_User_F__3214EC27B3EB5AF9] PRIMARY KEY CLUSTERED ([UUID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Primary key structure for table T_User_FriendShip_Group
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Group] ADD
	CONSTRAINT [PK__T_User_F__3214EC27224BAFBD] PRIMARY KEY CLUSTERED ([UUID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Primary key structure for table T_User_FriendShip_Friend
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Friend] ADD
	CONSTRAINT [PK__T_User_F__3214EC275270EB3C] PRIMARY KEY CLUSTERED ([UUID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Primary key structure for table T_User_FriendShip_Invitation
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Invitation] ADD
	CONSTRAINT [PK__T_User_F__65A475E78B29C0B7] PRIMARY KEY CLUSTERED ([UUID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Primary key structure for table T_P2P_ChatMessage
-- ----------------------------
ALTER TABLE [dbo].[T_P2P_ChatMessage] ADD
	CONSTRAINT [PK__T_P2P_Ch__65A475E7B3C6EEF1] PRIMARY KEY CLUSTERED ([UUID]) 
	WITH (PAD_INDEX = OFF,
		IGNORE_DUP_KEY = OFF,
		ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON)
	ON [default]
GO

-- ----------------------------
--  Foreign keys structure for table T_User_ChatRoom
-- ----------------------------
ALTER TABLE [dbo].[T_User_ChatRoom] ADD
	CONSTRAINT [FK__T_User_Ch__chatR__4CA06362] FOREIGN KEY ([chatRoomId]) REFERENCES [dbo].[T_ChatRoom] ([UUID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

-- ----------------------------
--  Foreign keys structure for table T_ChatRoomMessage
-- ----------------------------
ALTER TABLE [dbo].[T_ChatRoomMessage] ADD
	CONSTRAINT [FK__T_ChatRoo__chatR__4AB81AF0] FOREIGN KEY ([chatRoomId]) REFERENCES [dbo].[T_ChatRoom] ([UUID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

-- ----------------------------
--  Foreign keys structure for table T_User_FriendShip
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip] ADD
	CONSTRAINT [FK__T_User_Fr__frien__4BAC3F29] FOREIGN KEY ([friendCollectionId]) REFERENCES [dbo].[T_User_FriendShip_Collection] ([UUID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

-- ----------------------------
--  Foreign keys structure for table T_User_FriendShip_Collection
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Collection] ADD
	CONSTRAINT [FK__T_User_Fr__frien__4CA06362] FOREIGN KEY ([friendGroupId]) REFERENCES [dbo].[T_User_FriendShip_Group] ([UUID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

-- ----------------------------
--  Foreign keys structure for table T_User_FriendShip_Friend
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Friend] ADD
	CONSTRAINT [所属组的外键] FOREIGN KEY ([friendGroupId]) REFERENCES [dbo].[T_User_FriendShip_Group] ([UUID]) ON DELETE NO ACTION ON UPDATE NO ACTION
GO

-- ----------------------------
--  Options for table T_ChatRoom
-- ----------------------------
ALTER TABLE [dbo].[T_ChatRoom] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[T_ChatRoom]', RESEED, 2)
GO

-- ----------------------------
--  Options for table T_User_ChatRoom
-- ----------------------------
ALTER TABLE [dbo].[T_User_ChatRoom] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[T_User_ChatRoom]', RESEED, 6)
GO

-- ----------------------------
--  Options for table T_ChatRoomMessage
-- ----------------------------
ALTER TABLE [dbo].[T_ChatRoomMessage] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[T_ChatRoomMessage]', RESEED, 108)
GO

-- ----------------------------
--  Options for table T_User_FriendShip
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[T_User_FriendShip]', RESEED, 1078)
GO

-- ----------------------------
--  Options for table T_User_FriendShip_Collection
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Collection] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[T_User_FriendShip_Collection]', RESEED, 1078)
GO

-- ----------------------------
--  Options for table T_User_FriendShip_Group
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Group] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[T_User_FriendShip_Group]', RESEED, 1080)
GO

-- ----------------------------
--  Options for table T_User_FriendShip_Friend
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Friend] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[T_User_FriendShip_Friend]', RESEED, 1081)
GO

-- ----------------------------
--  Options for table T_User_FriendShip_Invitation
-- ----------------------------
ALTER TABLE [dbo].[T_User_FriendShip_Invitation] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[T_User_FriendShip_Invitation]', RESEED, 7)
GO

-- ----------------------------
--  Options for table T_P2P_ChatMessage
-- ----------------------------
ALTER TABLE [dbo].[T_P2P_ChatMessage] SET (LOCK_ESCALATION = TABLE)
GO
DBCC CHECKIDENT ('[dbo].[T_P2P_ChatMessage]', RESEED, 153)
GO

