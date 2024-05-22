from backend import render_template, app,db, jsonify
from backend.models import Product
@app.route('/test_db_connection')
def test_db_connection():
    try:
        # Attempt to query the database
        return jsonify({'message': 'Database connection successful'}), 200
    except Exception as e:
        return jsonify({'message': 'Database connection failed', 'error': str(e)}), 500



@app.route('/home') 
def home_page():
    products_data = Product.query.all()
    return render_template( 'index.html', items = products_data )
 

@app.route('/') 
def login_page():
    return render_template( 'login.html' )
