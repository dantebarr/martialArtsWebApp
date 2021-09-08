from datetime import datetime
from martial_arts import db, login_manager
from flask_login import UserMixin
from enum import Enum

import enum
class skillEnum(Enum):
    low = 1
    medium = 2
    high = 3


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    name = db.Column(db.String(20), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(60), nullable=False)
    dob = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    phone = db.Column(db.String(10), nullable=False)
    belt = db.Column(db.String(6), nullable=False),
    instructor_ref = db.relationship("Instructor", backref="user", lazy=True)
    student_ref = db.relationship("Student", backref="user", lazy=True)

    def get_instructor(self):
        if(self.instructor_ref != []):
            return self.instructor_ref[0]
        else:
            return

    def get_student(self):
        if(self.student_ref != []):
            return self.student_ref[0]
        else:
            return

    def is_instructor(self):
        return (self.instructor_ref != [])

    def __repr__(self):
        return f"User('{self.name}', '{self.email}')"

class Instructor(User):
    id = db.Column(db.Integer, db.ForeignKey('user.id'), primary_key=True, nullable=False)
    specialization = db.Column(db.String(20))
    years_experience = db.Column(db.Integer)
    courses = db.relationship("teaches", lazy=True)

class Student(User):
    id = db.Column(db.Integer, db.ForeignKey('user.id'), primary_key=True, nullable=False)
    courses = db.relationship("Course", lazy=True, secondary="belongsto")

class Course(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    age_group = db.Column(db.String(5))
    name = db.Column(db.String(100))
    skill_level = db.Column(db.Enum(skillEnum))
    time = db.Column(db.Integer)
    students = db.relationship("Student", lazy=True, secondary="belongsto")
    activities = db.relationship("Activity", lazy=True)

class belongsto(db.Model):
    student_id = db.Column(db.Integer, db.ForeignKey("student.id"), primary_key=True, nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("course.id"), primary_key=True, nullable=False)

class teaches(db.Model):
    instructor_id = db.Column(db.Integer, db.ForeignKey("instructor.id"), primary_key=True, nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("course.id"), primary_key=True, nullable=False)

class Activity(db.Model):
    name = db.Column(db.String(20), primary_key=True, nullable=False)
    deadline = db.Column(db.DateTime)
    description = db.Column(db.String(200))
    url = db.Column(db.String(2048))
    user_id = db.Column(db.Integer)
    course_id = db.Column(db.Integer, db.ForeignKey("course.id"), primary_key=True, nullable=False)

class activityvideo(db.Model):
    activity_name = db.Column(db.String(20), db.ForeignKey("activity.name"), primary_key=True, nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("course.id"), primary_key=True, nullable=False)
    student_id = db.Column(db.Integer, db.ForeignKey("student.id"), primary_key=True, nullable=False)
    timestamp = db.Column(db.DateTime)
    url = db.Column(db.String(2048))



