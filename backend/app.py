
from flask import Flask, make_response, jsonify, request, session
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
import datetime
from flask_cors import CORS



from models import db, Plan, Expense

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///app.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.json.compact = False

migrate = Migrate(app, db)

db.init_app(app)


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
        


if __name__ == "__main__":
    app.run(port=5555, debug=True)

   