
from flask import Flask, make_response, jsonify, request, session
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
import datetime
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, auth
from werkzeug.security import generate_password_hash, check_password_hash
from flask_bcrypt import Bcrypt

from models import db, Plan, Expense, User



app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///app.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.json.compact = False

migrate = Migrate(app, db)

db.init_app(app)
bcrypt = Bcrypt(app)

cred = credentials.Certificate('secrets/pennywise-50658-firebase-adminsdk-ol55h-706f1d280f.json')
firebase_admin.initialize_app(cred)

#Check firebase connection  
def check_firebase_connection():
    try:
        user = auth.get_user_by_email('blah@blah.com')
        print('Successfully fetched user data:', user)
    except Exception as e:
        print('Failed to fetch user data:', e)

check_firebase_connection()

@app.get("/")
def index():
    return "Home"

#PLAN

@app.get("/plans/<int:id>")
def get_plan_by_id(id):
    plan = db.session.get(Plan, id)
    if not plan:
        return {"error": "Post not found"}, 404
    return plan.to_dict(), 200

@app.post("/plans")
def post_plan():
    try:
        data = request.json
        new_plan = Plan(
            monthly_income=data['monthly_income'],
            savings=data['savings'],
            bills=data['bills'],
            entertainment=data['entertainment'],
            food=data['food'],
            user_id=data['user_id']
        )

        db.session.add(new_plan)
        db.session.commit()
        return new_plan.to_dict(), 201

    except Exception as e:
        print(e)
        return {"errors": str(e)}, 400
    
#EXPENSES
    
@app.get('/expenses/<int:id>')
def get_expenses_by_plan_id(id):
    try:
        expenses = Expense.query.filter_by(plan_id=id).all()
        expense_list = [{'id': expense.id, 'category': expense.category, 'amount': expense.amount, 'description': expense.description} for expense in expenses]
        return {'expenses':expense_list}, 200
    except Exception as e:
        print(e)
        return {"errors": str(e)}, 500
        

@app.post('/expenses')
def post_expenses():
    try:
        data = request.json
        new_expense = Expense(
            category=data['category'],
            description=data['description'],
            amount=data['amount'],
            plan_id=data['plan_id'],
        )
        db.session.add(new_expense)
        db.session.commit()
        return new_expense.to_dict(), 201
    except Exception as e:
        print(e)
        return {"errors": str(e)}, 400
    
@app.patch('/expenses/<int:id>')
def patch_expense(id):
    current_expense = db.session.get(Expense, id)
    if not current_expense:
        return {"error": "Post not found"}, 404
    try:
        data = request.json
        for key in data:
            setattr(current_expense, key, data[key])
            db.session.add(current_expense)
            db.session.commit()
            return current_expense.to_dict(202)
    except Exception as e:
        print(e)
        return {"errors": ["validation errors"]}, 400
    
#users
    
@app.get('/users')
def get_users():
    users = User.query.all()
    return {'users' : [user.to_dict() for user in users]}


# @app.post("/api/users")
# def signup():
#     try:
#         data = request.json
#         password_hash = bcrypt.generate_password_hash(data.get("password"))
#         new_user = User(
#             name=data.get("name"),
#             age=int(data.get("age")),
#             social=data.get("social"),
#             username=data.get("username"),
#             password=password_hash,
#         )
#         db.session.add(new_user)
#         db.session.commit()
#         return new_user.to_dict(), 201
#     except Exception as e:
#         print("error in signup: " + str(e))
#         return {"errors": ["validation errors"]}, 400

@app.post('/users')
def post_user():
    try:
        data = request.json
        firebase_user = auth.create_user(
            email=data.get("email"),
            email_verified=False,
            password=data.get("password"),
            display_name=data.get("username"),
            disabled=False
        )
        hashed_password = bcrypt.generate_password_hash(data.get("password")).decode('utf-8')
        new_user = User(
            username = data.get("username"),
            email = data.get("email"),
            password = data.get("password")
        )
        db.session.add(new_user)
        db.session.commit()
        return new_user.to_dict(), 201
    except Exception as e:
        print(e)
        return {"errors": ["validation errors"]}, 400
   


if __name__ == "__main__":
    app.run(port=5555, debug=True)

   