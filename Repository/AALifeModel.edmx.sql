
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 08/29/2017 14:57:07
-- Generated from EDMX file: D:\fxlweb\SexSpiderWeb\Repository\AALifeModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [aalife_20170820];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[SexSpider]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SexSpider];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'SexSpider'
CREATE TABLE [dbo].[SexSpider] (
    [SiteId] int IDENTITY(1,1) NOT NULL,
    [SiteRank] nvarchar(10)  NOT NULL,
    [VipLevel] tinyint  NOT NULL,
    [IsHided] tinyint  NOT NULL,
    [SiteName] nvarchar(50)  NOT NULL,
    [ListPage] nvarchar(200)  NOT NULL,
    [PageEncode] nvarchar(10)  NOT NULL,
    [Domain] nvarchar(50)  NOT NULL,
    [SiteLink] nvarchar(200)  NOT NULL,
    [ListDiv] nvarchar(50)  NOT NULL,
    [ImageDiv] nvarchar(50)  NOT NULL,
    [PageDiv] nvarchar(50)  NULL,
    [PageLevel] tinyint  NOT NULL,
    [ListFilter] nvarchar(50)  NULL,
    [ImageFilter] nvarchar(50)  NULL,
    [PageFilter] nvarchar(50)  NULL,
    [DocType] nvarchar(10)  NULL,
    [SiteFilter] nvarchar(50)  NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [SiteId] in table 'SexSpider'
ALTER TABLE [dbo].[SexSpider]
ADD CONSTRAINT [PK_SexSpider]
    PRIMARY KEY CLUSTERED ([SiteId] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------