from flask import Flask, redirect, url_for
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from flask_mysqldb import MySQL
import os

from flask_sqlalchemy import SQLAlchemy
# app.config['SECRET_KEY'] = '5791628bb0b13ce0c676dfde280ba245'
# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///site.db'

app = Flask(__name__)

SECRET_KEY = os.urandom(32)
app.config['SECRET_KEY'] = SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = "mysql+mysqlconnector://KUNGFOO:skinnyqueenz2021@localhost:3306/TEST"
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'KUNGFOO'
app.config['MYSQL_PASSWORD'] = 'skinnyqueenz2021'
app.config['MYSQL_DB'] = 'TEST'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

# sqlalchemy.create_engine(
#     'mysql+mysqlconnector://pyuser:Py@pp4Demo@localhost:3306/sqlalchemy',
#     echo=True)
db = SQLAlchemy(app)

dbm = MySQL(app)

bcrypt = Bcrypt(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'
login_manager.login_message_category = 'info'

@login_manager.unauthorized_handler
def unauthorized_handler():
    return redirect(url_for("login"))

from martial_arts import routes