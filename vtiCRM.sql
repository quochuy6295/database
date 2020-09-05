-- create database vti_CRM
DROP DATABASE IF EXISTS vtiCRM;
CREATE DATABASE IF NOT EXISTS vtiCRM;
USE vtiCRM;

-- drop table if exists
DROP TABLE IF EXISTS 	`User`;
DROP TABLE IF EXISTS 	User_role;
DROP TABLE IF EXISTS 	`Role`;
DROP TABLE IF EXISTS 	Role_permission;
DROP TABLE IF EXISTS 	User_permission;
DROP TABLE IF EXISTS 	Permission;
DROP TABLE IF EXISTS 	Course;
DROP TABLE IF EXISTS 	`Group`;
DROP TABLE IF EXISTS 	RegistrationUserToken;
DROP TABLE IF EXISTS 	ResetPasswordToken;

-- create table user
CREATE TABLE IF NOT EXISTS `User` (
    userId 					BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `source`				NVARCHAR(100), 	-- online, offline, sự kiện, giới thiệu....
	firstname 				NVARCHAR(20) NOT NULL, 
	lastname 				NVARCHAR(20) NOT NULL, 
 -- fullname 				NVARCHAR(40) NOT NULL, 			-- concat(user_firstname, user_lastname ); cấu hình trong java 
	username 				NVARCHAR(50) NOT NULL CHECK (LENGTH(`username`) >= 6 AND LENGTH(`username`) <= 50),
    gender 					ENUM('Male', 'Female'),
    phoneNumber 			VARCHAR(20) UNIQUE NOT NULL CHECK (LENGTH(`phoneNumber`) >= 9 AND LENGTH(`phoneNumber`) <= 15), -- phải có
    email 					NVARCHAR(50) UNIQUE NOT NULL CHECK (LENGTH(`email`) >= 6 AND LENGTH(`email`) <= 50), -- phải có
    `password` 				VARCHAR(60) NOT NULL CHECK (LENGTH(`password`) >= 8 AND LENGTH(`password`) <= 15), -- phải có
    birthDate 				DATE,
    school 					NVARCHAR(30),
    address 				NVARCHAR(50),
    socialNetwork 			NVARCHAR(50),					-- facabook, zalo...
    `status` 				NVARCHAR(30), 		-- chưa context, sai số, không quan tâm/từ chối, quan tâm, tìm hiểu thêm, 
    historyTransaction 		NVARCHAR(200), 	-- tư vấn viên tự note lại
    createDate 				DATETIME DEFAULT NOW(),
    `enable` 				BIT,							-- 0: Not Active, 1: Active,
    token					NVARCHAR(50)
    
);

-- create table role
CREATE TABLE IF NOT EXISTS `Role` (
    roleId 		INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` 		ENUM('Admin', 'Mod', 'Student') NOT NULL DEFAULT 'Student',
    `desc` 		NVARCHAR(100)
);

-- create table permission
CREATE TABLE IF NOT EXISTS Permission (
    permissionId 		INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` 				NVARCHAR(50) NOT NULL,
    `desc` 				NVARCHAR(100) 
);
-- create table User_role
CREATE TABLE IF NOT EXISTS User_role (
	roleId 		INT UNSIGNED NOT NULL,
    userId 		BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY(roleId, userId),
    FOREIGN KEY (roleId) REFERENCES `Role`(roleId),
    FOREIGN KEY (userId) REFERENCES `User`(userId)
);

-- create table Role_permission
CREATE TABLE IF NOT EXISTS Role_permission (
	roleId 				INT UNSIGNED NOT NULL,
	permissionId 		INT UNSIGNED NOT NULL,
    -- PRIMARY KEY(role_id, permission_id),
	FOREIGN KEY (roleId) REFERENCES `Role`(roleId),
	FOREIGN KEY (permissionId) REFERENCES Permission (permissionId)
);

-- create table User_permission
CREATE TABLE IF NOT EXISTS User_permission (
	userId 				BIGINT UNSIGNED NOT NULL,
	permissionId 		INT UNSIGNED NOT NULL,
   	FOREIGN KEY (userId) REFERENCES `User`(userId),
	FOREIGN KEY (permissionId) REFERENCES Permission (permissionId)
);

-- create table Group
CREATE TABLE IF NOT EXISTS `Group` (
	groupId 		INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name` 			NVARCHAR(50) NOT NULL,
    createDate 		DATETIME DEFAULT NOW()
);

-- Create table UserGroup
CREATE TABLE IF NOT EXISTS UserGroup (
	groupId 		INT UNSIGNED NOT NULL,
    userId 			BIGINT UNSIGNED NOT NULL,
   	FOREIGN KEY (userId) REFERENCES `User`(userId),
	FOREIGN KEY (groupId) REFERENCES `Group`(groupId)
);

-- create table Course
CREATE TABLE IF NOT EXISTS Course (
	courseid 	INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `name`		NVARCHAR(50) NOT NULL, 			-- nonIT, IT, tester, khác...
	`desc` 		NVARCHAR(100)
);

-- Create table UserCourse
CREATE TABLE IF NOT EXISTS UserCourse (
	courseid 	INT UNSIGNED NOT NULL,
   	userId 		BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (courseid) REFERENCES `Course`(courseid),
    FOREIGN KEY (userId) REFERENCES `User`(userId)
);

-- Create table Registration_User_Token
CREATE TABLE IF NOT EXISTS RegistrationUserToken ( 	
	id 				INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	token	 		VARCHAR(36) UNIQUE,
	userId 			BIGINT UNSIGNED NOT NULL,
	expiryDate 		DATETIME , 			-- 864000000 ~ 10 ngày; test thì cho time ít thôi ^^
    FOREIGN KEY (userId) REFERENCES `User`(userId)
);

-- Create table Reset_Password_Token
CREATE TABLE IF NOT EXISTS ResetPasswordToken ( 	
	id 				INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	token	 		VARCHAR(36) UNIQUE,
	userId			BIGINT UNSIGNED NOT NULL,
	expiryDate 		DATETIME ,  			-- 864000000 ~ 10 ngày; test thì cho time ít thôi ^^
    FOREIGN KEY (userId) REFERENCES `User`(userId)
);

