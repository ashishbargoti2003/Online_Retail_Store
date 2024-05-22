from backend.app import db

class Product(db.Model):
    __tablename__ = 'products'

    Product_ID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    Name = db.Column(db.String(255), nullable=False)
    Category1 = db.Column(db.String(50), nullable=False)
    Category2 = db.Column(db.String(50))
    Category3 = db.Column(db.String(50))
    Brand_Name = db.Column(db.String(100), nullable=False)
    Price = db.Column(db.DECIMAL(10, 2), nullable=False)
    Description = db.Column(db.TEXT, nullable=False)

# Define Customer model
class Customer(db.Model):
    __tablename__ = 'customer'

    Customer_ID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    First_Name = db.Column(db.String(255), nullable=False)
    Middle_Name = db.Column(db.String(255))
    Last_Name = db.Column(db.String(255), nullable=False)
    Email_ID = db.Column(db.String(255), unique=True, nullable=False)
    Password = db.Column(db.String(255), nullable=False)
    Contact_Number = db.Column(db.String(20), unique=True, nullable=False)
    Payment_Mode = db.Column(db.String(50), nullable=False)