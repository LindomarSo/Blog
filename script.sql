IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [dbo].[Category] (
    [Id] int NOT NULL IDENTITY,
    [Name] NVARCHAR(100) NOT NULL,
    [Slug] VARCHAR(100) NOT NULL,
    CONSTRAINT [PK_Category] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Role] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    [Slug] nvarchar(max) NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Tag] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    [Slug] nvarchar(max) NULL,
    CONSTRAINT [PK_Tag] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [User] (
    [Id] int NOT NULL IDENTITY,
    [Name] NVARCHAR(100) NOT NULL,
    [Email] nvarchar(max) NULL,
    [PasswordHash] nvarchar(max) NULL,
    [Image] nvarchar(max) NULL,
    [Slug] VARCHAR(100) NOT NULL,
    [Bio] nvarchar(max) NULL,
    CONSTRAINT [PK_User] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Post] (
    [Id] int NOT NULL IDENTITY,
    [Title] nvarchar(max) NULL,
    [Summary] nvarchar(max) NULL,
    [Body] nvarchar(max) NULL,
    [Slug] nvarchar(450) NULL,
    [CreateDate] datetime2 NOT NULL,
    [LastUpdateDate] SMALLDATETIME NOT NULL DEFAULT (GETDATE()),
    [CategoryId] int NULL,
    [AuthorId] int NULL,
    CONSTRAINT [PK_Post] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Post_Author] FOREIGN KEY ([AuthorId]) REFERENCES [User] ([Id]),
    CONSTRAINT [FK_Post_Category] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Category] ([Id])
);
GO

CREATE TABLE [UserRole] (
    [RoleId] int NOT NULL,
    [UserId] int NOT NULL,
    CONSTRAINT [PK_UserRole] PRIMARY KEY ([RoleId], [UserId]),
    CONSTRAINT [FK_UserRole_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Role] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserRole_UserId] FOREIGN KEY ([UserId]) REFERENCES [User] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [PostTag] (
    [PostId] int NOT NULL,
    [TagId] int NOT NULL,
    CONSTRAINT [PK_PostTag] PRIMARY KEY ([PostId], [TagId]),
    CONSTRAINT [FK_PostTag_PostId] FOREIGN KEY ([PostId]) REFERENCES [Tag] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_PostTag_TagId] FOREIGN KEY ([TagId]) REFERENCES [Post] ([Id]) ON DELETE CASCADE
);
GO

CREATE UNIQUE INDEX [IX_Category_Slug] ON [dbo].[Category] ([Slug]);
GO

CREATE INDEX [IX_Post_AuthorId] ON [Post] ([AuthorId]);
GO

CREATE INDEX [IX_Post_CategoryId] ON [Post] ([CategoryId]);
GO

CREATE UNIQUE INDEX [IX_Post_Slup] ON [Post] ([Slug]) WHERE [Slug] IS NOT NULL;
GO

CREATE INDEX [IX_PostTag_TagId] ON [PostTag] ([TagId]);
GO

CREATE UNIQUE INDEX [IX_User_Slug] ON [User] ([Slug]);
GO

CREATE INDEX [IX_UserRole_UserId] ON [UserRole] ([UserId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230225210007_Initial', N'7.0.3');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [User] ADD [GitHub] nvarchar(max) NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230225211746_AddGitHubField', N'7.0.3');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[User]') AND [c].[name] = N'Bio');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [User] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [User] ALTER COLUMN [Bio] VARCHAR(250) NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230225212034_AlterBioColumnType', N'7.0.3');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[User]') AND [c].[name] = N'Email');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [User] DROP CONSTRAINT [' + @var1 + '];');
UPDATE [User] SET [Email] = '' WHERE [Email] IS NULL;
ALTER TABLE [User] ALTER COLUMN [Email] VARCHAR(250) NOT NULL;
ALTER TABLE [User] ADD DEFAULT '' FOR [Email];
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230225212700_AlterColumnEmailTypeAndSize', N'7.0.3');
GO

COMMIT;
GO

