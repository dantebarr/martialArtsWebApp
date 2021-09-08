DROP DATABASE IF EXISTS `TEST`;
CREATE DATABASE `TEST`;

DROP user IF EXISTS 'KUNGFOO'@'localhost';
FLUSH PRIVILEGES;
CREATE user 'KUNGFOO'@'localhost' IDENTIFIED BY 'skinnyqueenz2021';
GRANT ALL PRIVILEGES ON TEST.* TO 'KUNGFOO'@'localhost';

USE `TEST`;

CREATE TABLE user (
    ID              INTEGER     NOT NULL AUTO_INCREMENT,
    name            VARCHAR(20) NOT NULL,
    password        VARCHAR(100),
    dob             DATE,
    phone           CHAR(10),
    email           VARCHAR(50) NOT NULL,
    belt            CHAR(6),
    PRIMARY KEY (ID)
);

CREATE TABLE instructor (
    ID              INTEGER     NOT NULL,
    specialization  VARCHAR(20),
    years_experience INTEGER,
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES user (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE student (
    ID              INTEGER     NOT NULL,
    points          INTEGER,
    skill_level     ENUM("low", "medium", "high"),
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES user (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE guardian (
    student_ID      INT         NOT NULL,
    name            VARCHAR(20) NOT NULL,
    phone           CHAR(10),
    email           VARCHAR(50),
    relationship    VARCHAR(15),
    PRIMARY KEY (student_ID, name),
    FOREIGN KEY (student_ID) REFERENCES student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE course (
    ID              INT         NOT NULL	AUTO_INCREMENT,
    age_group       CHAR(5),
    name            VARCHAR(100),
    skill_level     ENUM("low", "medium", "high"),
    time            INT,
    PRIMARY KEY (ID)
);

CREATE TABLE activity (
    name            VARCHAR(20) NOT NULL,
    deadline        DATE,
    description     VARCHAR(200),
    url             VARCHAR(2048),
    user_ID         INT,
    course_ID        INT NOT NULL,
    PRIMARY KEY (name, course_ID),
    FOREIGN KEY (user_ID) REFERENCES user (ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (course_ID) REFERENCES course (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE activityvideo (
    activity_name   VARCHAR(20) NOT NULL,
    course_ID       INT NOT NULL,
    student_ID      INT NOT NULL,
    timestamp       DATE,
    url             VARCHAR(2048),
    PRIMARY KEY (activity_name, student_ID, course_ID),
    FOREIGN KEY (activity_name) REFERENCES activity (name)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (course_ID) REFERENCES course (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (student_ID) REFERENCES student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE belongsto (
    student_ID      INT         NOT NULL,
    course_ID        INT         NOT NULL,
    PRIMARY KEY (student_ID, course_ID),
    FOREIGN KEY (student_ID) REFERENCES student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (course_ID) REFERENCES course (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE teaches (
    instructor_ID   INT         NOT NULL,
    course_ID        INT         NOT NULL,
    PRIMARY KEY (instructor_ID, course_ID),
    FOREIGN KEY (instructor_ID) REFERENCES instructor (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (course_ID) REFERENCES course (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE favourite (
    instructor_ID   INT         NOT NULL,
    activity_name   VARCHAR(20) NOT NULL,
    student_ID      INT         NOT NULL,
    PRIMARY KEY (instructor_ID, activity_name),
    FOREIGN KEY (instructor_ID) REFERENCES instructor (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (activity_name) REFERENCES activity (name)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (student_ID) REFERENCES student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE vote (
    voter_ID        INT         NOT NULL,
    activity_name   VARCHAR(20) NOT NULL,
    votee_ID        INT         NOT NULL,
    PRIMARY KEY (voter_ID, activity_name),
    FOREIGN KEY (voter_ID) REFERENCES student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (activity_name) REFERENCES activity (name)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (votee_ID) REFERENCES student (ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO user
	(name, password, dob, phone, email, belt)
VALUES
    ("Bob", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2004-1-04", "7788220473", "bobthebuilder@yeshecan.com", "yellow"),
    ("Ella", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2005-1-12", "7789998322", "ella@gmail.com", "orange"),
    ("Ken", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2007-12-24", "5485723696", "ken@yahoo.com", "black"),
    ("Will", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2004-11-01", "1548796325", "will@gmail.com", "white"),
    ("Jesse", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2008-8-04", "7845916275", "jesse@yahoo.com", "orange"),
    ("Ashley", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2010-4-17", "1534628957", "ashley@gmail.com", "yellow"),
    ("Fred", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2008-3-13", "4568297312", "fred@gmail.com", "yellow"),
    ("Tom", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2013-9-11", "4265135462", "tom@yahoo.com", "blue"),
    ("Marie", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2013-7-01", "1982365488", "marie@hotmail.com", "red"),
    ("Fraser", "$2b$12$BQHiuGoV.wSz9PYACDtr0.Fkg.O3HFsiC6R7SFmDFK/jCsJNMI2UW", "2012-2-02", "7897231548", "fraser@gmail.com", "red"),
    ("teach", "$2b$12$5mXrK1Zp8lqQhrz8pOMmf.M.GS3hp.Gv5/LubYA4r0VrfbUIItV0O", "1000-1-01", "1234567890", "instructor@sfu.ca", "black"),
    ("student", "$2b$12$RYlcuhZxDooLZuAR1cI5muSi5v4c7GpHj2VRhF86ezh4WMGywI4ba", "2000-1-01", "0987654321", "student@sfu.ca", "white");

INSERT INTO instructor
	(ID, specialization, years_experience)
VALUES
	(1, "Judo", 3),
    (2, "Kendo", 1),
    (3, "Krav Maga", 2),
    (4, "Judo", 5),
    (5, "Karate", 10),
    (11, "Coding", 1000000);

INSERT INTO student
	(ID, points, skill_level)
VALUES
	(6, 6, "low"),
    (7, 3, "medium"),
    (8, 2, "low"),
    (9, 8, "high"),
    (10, 2,"high"),
    (12, 0, "low");
    
INSERT INTO guardian
	(student_ID, name, phone, email, relationship)
VALUES
	(6, "Harald", "1579486325", "harald@gmail.com", "Father"),
    (7, "Frank", "1577203125", "frank@hotmail.com", "Father"),
    (8, "Wendy", "8302486325", "wendy@hotmail.com", "Mother"),
    (9, "Betty", "1579400423", "betty@yahoo.com", "Mother"),
    (10, "Mitch", "3288166325", "mitch@yahoo.com", "Father");
    
INSERT INTO course
	(age_group, name, skill_level, time)
VALUES
	("07-12", "Young Skirmishers", "high", 90),
    ("12-14", "Young Brawlers", "low", 90),
    ("12-14", "Lil' Fightas", "low", 60),
    ("14-16", "Tiny Ninjas", "medium", 120),
    ("07-12", "Silver Masters", "medium", 90);
    
INSERT INTO activity
	(name, deadline, description, url, user_ID, course_ID)
VALUES
	("activity1", "2021-3-04", "This is the first activity", "testurl.com", 4, 2),
    ("activity2", "2021-3-08", "This is the second activity", "othertesturl.com", 4, 3),
    ("activity3", "2021-3-12", "This is the third activity", "thirdtesturl.com", 2, 4),
    ("activity4", "2021-4-15", "This is the fourth activity", "nexttesturl.com", 1, 1),
    ("activity5", "2021-4-20", "This is the fifth activity", "tada.com", 10, 5);
    
INSERT INTO activityvideo
	(activity_name, student_ID, timestamp, url, course_ID)
VALUES
	("activity1", 6, "2007-12-24", "youtube.com/nh88ugvdisna", 2),
    ("activity2", 10, "2007-12-24", "youtube.com/bfgsn54rsbfds", 3),
    ("activity3", 7, "2007-12-24", "youtube.com/kytdvfed4avsd", 4),
    ("activity4", 9, "2007-12-24", "youtube.com/jgfdsb3gsbfda", 1),
    ("activity5", 8, "2007-12-24", "youtube.com/g453tg4t4rgxbgf", 5);
    
INSERT INTO belongsto
	(student_ID, course_ID)
VALUES
	(10, 1),
    (6, 5),
    (7, 4),
    (8, 3),
    (9, 2);

INSERT INTO teaches
	(instructor_ID, course_ID)
VALUES
	(2, 1),
    (3, 5),
    (5, 4),
    (4, 3),
    (1, 2);

INSERT INTO favourite
	(instructor_ID, activity_name, student_ID)
VALUES
	(5, "activity4", 10),
    (4, "activity3", 6),
    (2, "activity2", 7),
    (3, "activity1", 8),
    (1, "activity1", 9);

INSERT INTO vote
	(voter_ID, activity_name, votee_ID)
VALUES
	(9, "activity4", 8),
    (10, "activity3", 8),
    (6, "activity1", 10),
    (7, "activity1", 9),
    (8, "activity5", 7);
