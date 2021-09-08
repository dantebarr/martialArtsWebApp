from flask import render_template, url_for, flash, redirect, request
from martial_arts import app, db, dbm, bcrypt
from martial_arts.forms import CreateClassForm, LoginForm, RegistrationForm, EditActivityForm, EditAccountForm, AddVideo, DeleteActivityForm
from martial_arts.models import User, Instructor, Course, Activity, belongsto, teaches, activityvideo, skillEnum
from flask_login import login_user, current_user, logout_user, login_required
from datetime import datetime

@app.route("/")
@app.route("/home")
@login_required
def home():
    print(type(current_user.instructor_ref))
    if(current_user.is_instructor()):
        courselist = Course.query.all()
    else:
        student = current_user.get_student()
        courselist = student.courses
        # print(courselist)
    return render_template('home.html', courses=courselist)

@app.route("/activitylist/<int:id_arg>")
@login_required
def activitylist(id_arg):
    if not current_user.is_instructor():
        res = belongsto.query.filter(belongsto.student_id==current_user.id, belongsto.course_id==id_arg)
        if(res == []):
            flash("You are not a student in that course.")
            return redirect(url_for("home"))

    cur = dbm.connection.cursor()
    query =  "SELECT curr.name, curr.description, curr.deadline, t.c FROM (SELECT * FROM activity WHERE course_ID="+str(id_arg)+") AS curr LEFT JOIN (SELECT activity_name, COUNT(DISTINCT course_ID, student_ID) as c FROM activityvideo WHERE course_ID="+str(id_arg)+" GROUP BY activity_name) as t ON curr.name=t.activity_name;"
    cur.execute(query)
    activities = cur.fetchall()
    # print(activities)

    current_course = Course.query.filter_by(id=id_arg).first()

    # query2 = "WITH T AS (SELECT activity.course_ID as course_id, activity.name as name, activityvideo.student_ID as student_id FROM activity LEFT JOIN activityvideo WHERE activity.course_ID=activityvideo.course_ID AND activity.name=activityvideo.activity_name) SELECT s.name FROM student as s WHERE NOT EXISTS(SELECT * FROM T WHERE course_id="+str(id_arg)+"

    # counts = activityvideo.query.filter(activityvideo.course_id==current_course.id).with_entities(activityvideo.activity_name)

    # print(activities)
    return render_template('activitylist.html', activitylist=activities, coursename=current_course.name, courseid=current_course.id)

@app.route("/activity/<int:id_arg>/<string:activity_name>")
@login_required
def activity(id_arg, activity_name):
    cur = dbm.connection.cursor()
    query = f'SELECT * FROM activity WHERE activity.name="{activity_name}"'
    cur.execute(query)
    activity_info = cur.fetchall()[0]
    print(activity_info)
    # Count total number of submissions for an activity
    query = f"SELECT count(*) as c FROM activityvideo WHERE course_ID={id_arg} AND activity_name='{activity_name}'"
    cur.execute(query)
    vid_total = cur.fetchall()[0]
    if(current_user.is_instructor()):
        return render_template('inst_activity.html', post= activity_info, course_id= id_arg, vid_total= vid_total)
    else:
        return render_template('std_activity.html', post= activity_info, course_id= id_arg, vid_total= vid_total)

@app.route("/activity/<int:id_arg>/<string:activity_name>/edit", methods=['GET', 'POST'])
@login_required
def activity_edit(id_arg, activity_name, methods=['POST']):
    conn = dbm.connection
    cur = conn.cursor()
    query = f'SELECT * FROM activity WHERE activity.name="{activity_name}"'
    cur.execute(query)
    activity_info = cur.fetchall()[0]

    form = EditActivityForm()
    if form.validate_on_submit():
        new_activity_info = {}
        new_activity_info["name"] = form.name.data
        new_activity_info["deadline"] = form.deadline.data
        new_activity_info["description"] = form.description.data
        new_activity_info["url"] = form.url.data
        # Handle others
        print(new_activity_info)

        attr_to_set = []
        for attribute in new_activity_info:
            if not new_activity_info[attribute]:
                continue
            attr_to_set.append(f"{attribute} = '{new_activity_info[attribute]}'")
        set_str = ", ".join(attr_to_set)

        # Make update query to activity with the same ID from activity_info
        query = f"UPDATE activity SET {set_str} WHERE name = '{activity_info['name']}'"
        print(query)
        cur.execute(query)
        conn.commit()
        if new_activity_info['name']:
            activity_name = new_activity_info['name']
        return redirect(f'/activity/{id_arg}/{activity_name}')
    return render_template('inst_activity_edit.html', post=activity_info, form=form)

@app.route("/activity/<int:id_arg>/<string:activity_name>/delete", methods=['GET', 'POST'])
@login_required
def activity_delete(id_arg, activity_name, methods=['POST']):
    conn = dbm.connection
    cur = conn.cursor()
    query = f'SELECT * FROM activity WHERE activity.name="{activity_name}"'
    cur.execute(query)
    activity_info = cur.fetchall()[0]

    form = DeleteActivityForm()
    if form.validate_on_submit():
        print("Now deleting activity with cascade effect")

        query = f"DELETE FROM activity WHERE course_ID={id_arg} AND name='{activity_name}'"
        print(query)
        cur.execute(query)
        conn.commit()
        
        return redirect(f'/activitylist/{id_arg}')
    return render_template('inst_activity_delete.html', post=activity_info, form=form)

@app.route("/activity/<int:course_id>/<string:activity_name>/addvideo", methods=['GET', 'POST'])
@login_required
def addvideo(course_id, activity_name, methods=['POST']):
    conn = dbm.connection
    cur = conn.cursor()
    query = f'SELECT * FROM activity WHERE activity.name="{activity_name}"'
    cur.execute(query)
    activity_info = cur.fetchall()[0]

    form = AddVideo()
    if form.validate_on_submit():
        video_url = form.video_url.data
        # Handle others
        print(video_url)
        now = datetime.now()
        formatted_date = now.strftime("%Y-%m-%d %H:%M:%S")
        print(formatted_date)
        id = int(current_user.get_id())
        print(type(id))
        print(id)

        # Make INSERT query to add video to db
        query = f'INSERT INTO activityvideo (activity_name, student_ID, timestamp, url, course_ID) VALUES ("{activity_name}", {id}, "{formatted_date}", "{video_url}", {course_id})'
        cur.execute(query)
        conn.commit()

        return redirect(f'/activity/{course_id}/{activity_name}')
    return render_template('add_video.html', post=activity_info, form=form)

@app.route("/std_activity")
@login_required
def std_activity():
    return render_template('std_activity.html')

@app.route("/instructor")
@login_required
def instructor():
    cur = dbm.connection.cursor()
    cur.execute('''SELECT  ID, skill_level, age_group, course.name AS ClassName FROM course''')
    classes = cur.fetchall()
    print(classes)
    return render_template('instructor.html', title='Instructor', posts= classes)

# @app.route("/student")
# def student():
#     cur = dbm.connection.cursor()
#     cur.execute('''SELECT  ID, skill_level, age_group, course.name AS ClassName FROM course''')
#     activities = cur.fetchall()

#     print(activities)
#     return render_template('student.html', title='Student', posts= activities)

@app.route("/createclass", methods=['GET', 'POST'])
@login_required
def createclass():
    if not current_user.is_instructor():
        return redirect(url_for("home"))
    form = CreateClassForm()
    if form.validate_on_submit():
        new_course = Course()
        new_course.age_group = form.agegroup.data
        if(form.skilllevel.data == "low"):
            new_course.skill_level = skillEnum.low
        elif(form.skilllevel.data == "med"):
            new_course.skill_level = skillEnum.medium
        elif(form.skilllevel.data == "high"):
            new_course.skill_level = skillEnum.high
        new_course.name = form.classname.data

        db.session.add(new_course)
        db.session.commit()

        new_teaches = teaches()
        new_teaches.instructor_id = current_user.id
        new_teaches.course_id = new_course.id

        db.session.add(new_teaches)
        db.session.commit()

        flash('Your Class has been created!', 'success')
        return redirect(url_for('home'))
    return render_template('createclass.html', title='Create New Class', form=form)

@app.route("/addactivity/<int:id_arg>", methods=['GET', 'POST'])
@login_required
def addactivity(id_arg):
    if not current_user.is_instructor():
        return redirect(url_for("home"))
    form = EditActivityForm()
    if form.validate_on_submit():
        new_activity = Activity()
        new_activity.name = form.name.data
        new_activity.course_id = id_arg
        new_activity.deadline = form.deadline.data
        new_activity.description = form.description.data
        new_activity.url = form.url.data
        new_activity.user_id = current_user.id

        db.session.add(new_activity)
        db.session.commit()

        temp=id_arg

        flash('Your Activity has been created!', 'success')
        return redirect(url_for('activitylist', id_arg=temp))
    return render_template('createactivity.html', title='Add New Activity', form=form)

@app.route("/about")
def about():
    return render_template('about.html', title='About')


@app.route("/register", methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        user = User(name=form.name.data, email=form.email.data, password=hashed_password)
        db.session.add(user)
        db.session.commit()

        flash('Your account has been created! You are now able to log in', 'success')
        return redirect(url_for('login'))
    return render_template('register.html', title='Register', form=form)


@app.route("/login", methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(email=form.email.data).first()
        if user and bcrypt.check_password_hash(user.password, form.password.data):
            login_user(user, remember=form.remember.data)
            next_page = request.args.get('next')
            return redirect(next_page) if next_page else redirect(url_for('home'))
        else:
            flash('Login Unsuccessful. Please check email and password', 'danger')
    return render_template('login.html', title='Login', form=form)


@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))


@app.route("/account")
@login_required
def account():
    if not current_user.is_authenticated:
        return redirect(url_for('home'))
    return render_template('account.html', title='Account',post= (current_user.name, current_user.email, current_user.dob, current_user.phone, current_user.belt))

@app.route("/account/edit", methods=['GET', 'POST'])
@login_required
def account_edit(methods=['POST']):
    if not current_user.is_authenticated:
        return redirect(url_for('home'))
    form = EditAccountForm()
    if form.validate_on_submit():
        user = current_user
        if form.name.data!="":
            user.name = form.name.data
        if form.email.data!="":
            user.email = form.email.data
        if form.dob.data!="":
            user.dob = form.dob.data
        if form.phone.data!="":
            user.phone = form.phone.data
        if form.belt.data!="":
            user.belt = form.belt.data
        db.session.commit()

        return redirect(url_for('account'))
    return render_template('account_edit.html', form=form)