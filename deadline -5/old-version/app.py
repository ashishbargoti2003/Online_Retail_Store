from flask import Flask,render_template,jsonify
from flask_sqlalchemy import SQLAlchemy
import streamlit as st
from sqlalchemy import create_engine,text
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import sessionmaker

app = Flask(__name__)

# Configure SQLAlchemy
engine = create_engine('mysql+mysqlconnector://root:_dontTry%400809@localhost/croma_online')
app.config['SQLALCHEMY_DATABASE_URI'] = "mysql+mysqlconnector://root:_dontTry%400809@localhost/croma_online"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize SQLAlchemy
db = SQLAlchemy(app)

# with app.app_context():
# Reflect the existing database tables into SQLAlchemy models
Base = automap_base()
Base.prepare(engine, reflect= True )
Customer = Base.classes.customer
def serialize_customer(customer):
    return {
        'Customer_ID': customer.Customer_ID,
        'First_Name': customer.First_Name,
        'Middle_Name': customer.Middle_Name,
        'Last_Name': customer.Last_Name,
        'Email_ID': customer.Email_ID,
        'Password': customer.Password,
        'Contact_Number': customer.Contact_Number,
        'Payment_Mode': customer.Payment_Mode
    }

@app.route('/api/customer')

def display_customer():
    Session = sessionmaker(bind=engine)
    session = Session()
    customers = session.query(Customer).all()
    session.close()
    return jsonify([serialize_customer(customer) for customer in customers])

if __name__ == '__main__':
    app.run( debug=True )