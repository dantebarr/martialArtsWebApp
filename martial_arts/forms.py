from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, BooleanField, DateField, RadioField
from wtforms.validators import DataRequired, Length, Email, EqualTo, ValidationError
from martial_arts.models import User


class RegistrationForm(FlaskForm):
    name = StringField('Name', validators=[DataRequired(), Length(min=2, max=20)])
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password')])
    dob = StringField('Date of Birth')
    phone = StringField('Phone Number')
    belt = StringField('Belt')
    submit = SubmitField('Sign Up')

    def validate_name(self, name):
        user = User.query.filter_by(name=name.data).first()
        if user:
            raise ValidationError(
                'That name is taken. Please choose a different one.')

    def validate_email(self, email):
        user = User.query.filter_by(email=email.data).first()
        if user:
            raise ValidationError(
                'That email is taken. Please choose a different one.')


class LoginForm(FlaskForm):
    email = StringField('Email',
                        validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    remember = BooleanField('Remember Me')
    submit = SubmitField('Login')


class CreateClassForm(FlaskForm):
    classname = StringField('Class Name')
    agegroup = StringField('Age Group')
    skilllevel = RadioField('Skill Level', choices = ["low", "med", "high"])
    time = DateField ('Time')
    submit = SubmitField('Submit')

class EditActivityForm(FlaskForm):
    name = StringField('Activity Name', validators=[DataRequired(), Length(min=1, max=20)])
    deadline = DateField('Deadline')
    description = StringField('Description')
    url = StringField('URL', validators=[Length( max=2048)])
    submit = SubmitField('Submit')

class EditAccountForm(FlaskForm):
    name = StringField('Activity Name', validators=[Length(min=2, max=20)])
    email = StringField('Email', validators=[Email()])
    password = StringField('Password')
    confirm_password = PasswordField('Confirm Password', validators=[ EqualTo('password')])
    dob = StringField('Date of Birth')
    phone = StringField('Phone')
    belt = StringField('Belt')
    submit = SubmitField('Submit')

class AddVideo(FlaskForm):
    video_url = StringField('Video URL')
    submit = SubmitField('Submit')

class DeleteActivityForm(FlaskForm):
    submit = SubmitField('Submit')
