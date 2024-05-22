from utility import st

# Function to display Product Catalogue
def view_products():
    st.subheader("Product Catalogue")
    
# Function to display Cart Details
def view_cart():
    st.subheader("Cart Details")

# Function to display Wishlist
def view_wishlist():
    st.subheader("My Wishlist")
    # Add content for Wishlist here

# Function to display Customer Profile
def customer_profile():
    st.subheader("Customer Profile")
    # Add content for Customer Profile here

# Function to display Order History
def order_history():
    st.subheader("Order History")
    # Add content for Order History here

# Function to display Returns & Refunds
def returns_refunds():
    st.subheader("Returns & Refunds")
    # Add content for Returns & Refunds here

# Function for Customer Homepage
def customer_homepage():
    menu = [
        "View Products",
        "View Cart",
        "My Wishlist",
        "Customer Profile",
        "Order History",
        "Returns & Refunds"
    ]
    selected_option = st.sidebar.radio("Select an Option :dart:", menu)
    if selected_option == "View Products":
        view_products()
    elif selected_option == "View Cart":
        view_cart()
    elif selected_option == "My Wishlist":
        view_wishlist()
    elif selected_option == "Customer Profile":
        customer_profile()
    elif selected_option == "Order History":
        order_history()
    elif selected_option == "Returns & Refunds":
        returns_refunds()
