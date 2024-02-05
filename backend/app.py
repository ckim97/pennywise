
from flask import Flask, make_response, jsonify, request, session
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
import datetime
from flask_cors import CORS



from models import db, Plan

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


@app.post("/plans")
def post_plan():
    try:
        data = request.json
        new_plan = Plan(
            monthly_income=data['monthly_income'],
            savings=data['savings'],
            bills=data['bills'],
            entertainment=data['entertainment'],
            food=data['food']
        )

        db.session.add(new_plan)
        db.session.commit()
        return new_plan.to_dict(), 201

    except Exception as e:
        print(e)
        return {"errors": str(e)}, 400
        


if __name__ == "__main__":
    app.run(port=5555, debug=True)
