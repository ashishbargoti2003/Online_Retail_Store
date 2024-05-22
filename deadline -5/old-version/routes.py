from backend.app import app,jsonify, Customer,engine
from backend.models import Product


@app.route('/api/customer')
def display_customer():
    # customers = Customer.query.all()
    # customer_data = [{
    #     'ID': customer.Customer_ID,
    #     'Patient ID': customer.First_Name
    # } for customer in customers]
    # return jsonify(customer_data)
    Session = sessionmaker(bind=engine)
    session = Session()
    customers = session.query(Customer).all()
    session.close()
    return jsonify([serialize_customer(customer) for customer in customers])