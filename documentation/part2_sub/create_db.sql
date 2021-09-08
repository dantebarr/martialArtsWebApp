DROP DATABASE IF EXISTS `TEST`;
CREATE DATABASE `TEST`;
USE `TEST`;

CREATE TABLE User (
    ID              INTEGER     NOT NULL,
    name            VARCHAR(20) NOT NULL,
    password        VARCHAR(100),
    dob             DATE,
    phone           CHAR(10),
    email           VARCHAR(50) NOT NULL,
    belt            CHAR(6),
    PRIMARY KEY (ID)
);

CREATE TABLE Instructor (
    ID              INTEGER     NOT NULL,
    specialization  VARCHAR(20),
    years_experience INTEGER,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES User (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Student (
    ID              INTEGER     NOT NULL,
    points          INTEGER,
    skill_level     ENUM("low", "medium", "high"),
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES User (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Guardian (
    student_ID      INT         NOT NULL,
    name            VARCHAR(20) NOT NULL,
    phone           CHAR(10),
    email           VARCHAR(50),
    relationship    VARCHAR(15),
    PRIMARY KEY (student_ID, name),
    FOREIGN KEY (student_ID) REFERENCES Student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Class (
    ID              INT         NOT NULL,
    age_group       CHAR(5),
    name            VARCHAR(100),
    skill_level     ENUM("low", "medium", "high"),
    time            INT,
    num_students    INT,
    num_instructors INT,
    PRIMARY KEY (ID)
);

CREATE TABLE Activity (
    name            VARCHAR(20) NOT NULL,
    deadline        DATE,
    description     VARCHAR(200),
    url             VARCHAR(2048),
    user_ID         INT,
    class_ID        INT,
    PRIMARY KEY (name),
    FOREIGN KEY (user_ID) REFERENCES User (ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (class_ID) REFERENCES Class (ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE ActivityVideo (
    activity_name   VARCHAR(20) NOT NULL,
    student_ID      INT,
    timestamp       INT,
    url             VARCHAR(2048),
    PRIMARY KEY (activity_name, student_ID, timestamp),
    FOREIGN KEY (activity_name) REFERENCES Activity (name)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (student_ID) REFERENCES Student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE BelongsTo (
    student_ID      INT         NOT NULL,
    class_ID        INT         NOT NULL,
    PRIMARY KEY (student_ID, class_ID),
    FOREIGN KEY (student_ID) REFERENCES Student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (class_ID) REFERENCES Class (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Teaches (
    instructor_ID   INT         NOT NULL,
    class_ID        INT         NOT NULL,
    PRIMARY KEY (instructor_ID, class_ID),
    FOREIGN KEY (instructor_ID) REFERENCES Instructor (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (class_ID) REFERENCES Class (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Favourite (
    instructor_ID   INT         NOT NULL,
    activity_name   VARCHAR(20) NOT NULL,
    student_ID      INT         NOT NULL,
    PRIMARY KEY (instructor_ID, activity_name),
    FOREIGN KEY (instructor_ID) REFERENCES Instructor (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (activity_name) REFERENCES Activity (name)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (student_ID) REFERENCES Student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Vote (
    voter_ID        INT         NOT NULL,
    activity_name   VARCHAR(20) NOT NULL,
    votee_ID        INT         NOT NULL,
    PRIMARY KEY (voter_ID, activity_name),
    FOREIGN KEY (voter_ID) REFERENCES Student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (activity_name) REFERENCES Activity (name)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (votee_ID) REFERENCES Student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO User
	(ID, name, password, dob, phone, email, belt)
VALUES
	(0, "Bob", "Bobo", "2004-1-04", "7788220473", "bobthebuilder@yeshecan.com", "yellow"),
    (1, "Ella", "Ella2005", "2005-1-12", "7789998322", "Ella@gmail.com", "orange"),
    (2, "Ken", "KenKen", "2007-12-24", "5485723696", "Ken@yahoo.com", "black"),
    (3, "Will", "WillIAm", "2004-11-01", "1548796325", "Will@gmail.com", "white"),
    (4, "Jesse", "JessieJ", "2008-8-04", "7845916275", "Jesse@yahoo.com", "orange"),
    (5, "Ashley", "AshAsh", "2010-4-17", "1534628957", "Ashley@gmail.com", "yellow"),
    (6, "Fred", "fredie", "2008-3-13", "4568297312", "Fred@gmail.com", "yellow"),
    (7, "Tom", "tomathan", "2013-9-11", "4265135462", "Tom@yahoo.com", "blue"),
    (8, "Marie", "avemaria", "2013-7-01", "1982365488", "Marie@hotmail.com", "red"),
    (9, "Fraser", "river", "2012-2-02", "7897231548", "Fraser@gmail.com", "red");

INSERT INTO Instructor
	(ID, specialization, years_experience)
VALUES
	(0, "Judo", 3),
    (1, "Kendo", 1),
    (2, "Krav Maga", 2),
    (3, "Judo", 5),
    (4, "Karate", 10);

INSERT INTO Student
	(ID, points, skill_level)
VALUES
	(5, 6, "low"),
    (6, 3, "medium"),
    (7, 2, "low"),
    (8, 8, "high"),
    (9, 2,"high");
    
INSERT INTO Guardian
	(student_ID, name, phone, email, relationship)
VALUES
	(7, "Harald", "1579486325", "harald@gmail.com", "Father"),
    (8, "Frank", "1577203125", "frank@hotmail.com", "Father"),
    (6, "Wendy", "8302486325", "wendy@hotmail.com", "Mother"),
    (5, "Betty", "1579400423", "betty@yahoo.com", "Mother"),
    (9, "Mitch", "3288166325", "mitch@yahoo.com", "Father");
    
INSERT INTO Class
	(ID, age_group, name, skill_level, time, num_students, num_instructors)
VALUES
	(0, "07-12", "Young Skirmishers", "high", 90, 15, 1),
    (1, "12-14", "Young Brawlers", "low", 90, 6, 2),
    (2, "12-14", "Lil' Fightas", "low", 60, 20, 1),
    (3, "14-16", "Tiny Ninjas", "medium", 120, 5, 2),
    (4, "07-12", "Silver Masters", "medium", 90, 12, 2);
    
INSERT INTO Activity
	(name, deadline, description, url, user_ID, class_ID)
VALUES
	("activity1", "2021-3-04", "This is the first activity", "testurl.com", 3, 1),
    ("activity2", "2021-3-08", "This is the second activity", "othertesturl.com", 3, 2),
    ("activity3", "2021-3-12", "This is the third activity", "thirdtesturl.com", 1, 3),
    ("activity4", "2021-4-15", "This is the fourth activity", "nexttesturl.com", 0, 0),
    ("activity5", "2021-4-20", "This is the fifth activity", "tada.com", 9, 4);
    
INSERT INTO ActivityVideo
	(activity_name, student_ID, timestamp, url)
VALUES
	("activity1", 5, 118, "youtube.com/nh88ugvdisna"),
    ("activity2", 9, 79, "youtube.com/bfgsn54rsbfds"),
    ("activity3", 6, 222, "youtube.com/kytdvfed4avsd"),
    ("activity4", 6, 113, "youtube.com/jgfdsb3gsbfda"),
    ("activity5", 7, 347, "youtube.com/g453tg4t4rgxbgf");
    
INSERT INTO BelongsTo
	(student_ID, class_ID)
VALUES
	(5, 0),
    (6, 4),
    (7, 3),
    (8, 2),
    (9, 1);

INSERT INTO Teaches
	(instructor_ID, class_ID)
VALUES
	(1, 0),
    (2, 4),
    (4, 3),
    (3, 2),
    (0, 1);

INSERT INTO Favourite
	(instructor_ID, activity_name, student_ID)
VALUES
	(4, "activity4", 9),
    (3, "activity3", 5),
    (1, "activity2", 6),
    (2, "activity1", 7),
    (0, "activity1", 8);

INSERT INTO Vote
	(voter_ID, activity_name, votee_ID)
VALUES
	(9, "activity4", 8),
    (5, "activity3", 8),
    (6, "activity1", 5),
    (7, "activity1", 9),
    (8, "activity5", 7);
