from flask import Flask, render_template, jsonify
from flask_sqlalchemy import SQLAlchemy


app = Flask( __name__)

database_uri = "mysql+mysqlconnector://root:_dontTry%400809@localhost/croma_online"

# Configure SQLAlchemy
app.config['SQLALCHEMY_DATABASE_URI'] = database_uri
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize SQLAlchemy
db = SQLAlchemy(app)

from backend import routes