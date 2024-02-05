from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData, ForeignKey
from sqlalchemy.ext.declarative import declared_attr
from sqlalchemy.orm import validates
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy_serializer import SerializerMixin
from sqlalchemy.sql import func
from datetime import datetime


# Definitions of tables and associated schema constructs
metadata = MetaData()

# A Flask SQLAlchemy extension
db = SQLAlchemy(metadata=metadata)


class User(db.Model, SerializerMixin):
    __tablename__ = 'user_table'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    
    plan = db.relationship('Plan', back_populates='user', cascade='all, delete-orphan')

class Plan(db.Model, SerializerMixin):
    __tablename__ = 'plan_table'

    id = db.Column(db.Integer, primary_key=True)
    monthly_income = db.Column(db.Float, nullable=False)
    savings = db.Column(db.Float, nullable=False)
    bills = db.Column(db.Float, nullable=False)
    entertainment = db.Column(db.Float, nullable=False)
    food = db.Column(db.Float, nullable=False)
    
    user_id = db.Column(db.Integer, db.ForeignKey('user_table.id'))
    user = db.relationship('User', back_populates='plan')

    expenses = db.relationship('Expense', back_populates='plan', cascade='all, delete-orphan')

class Expense(db.Model, SerializerMixin):
    __tablename__ = 'expense_table'
    serialize_rules = ['-plan']

    id = db.Column(db.Integer, primary_key=True)
    category = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String)
    amount = db.Column(db.Float, nullable=False)
    
    plan_id = db.Column(db.Integer, db.ForeignKey('plan_table.id'))
    plan = db.relationship('Plan', back_populates='expenses')
