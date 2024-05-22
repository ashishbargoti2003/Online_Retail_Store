import streamlit as st

# Sample customer data
customer_data = {
    "name": "John Doe",
    "email": "john.doe@example.com",
    "address": "123 Main St, Anytown, USA",
    "phone": "555-1234",
    "cart": ["Product 1", "Product 2", "Product 3"],
    "wishlist": ["Product 4", "Product 5"],
    "recently_purchased": ["Product 6", "Product 7"]
}

def display_account(customer_data):
    st.title("Customer Account Details")

    # CSS styling
    css = """
    <style>
    .details-container {
        border: 1px solid #ccc;
        padding: 10px;
        margin-bottom: 10px;
        border-radius: 5px;
    }
    .details-container h2 {
        font-size: 20px;
        color: #333;
        margin-bottom: 5px;
    }
    .details-container p {
        font-size: 16px;
        color: #666;
        margin: 5px 0;
    }
    </style>
    """
    st.markdown(css, unsafe_allow_html=True)

    # Display customer details in a container
    st.markdown("""
    <div class="details-container">
        <h2>Name</h2>
        <p>{}</p>
        <h2>Email</h2>
        <p>{}</p>
        <h2>Address</h2>
        <p>{}</p>
        <h2>Phone</h2>
        <p>{}</p>
    </div>
    """.format(customer_data["name"], customer_data["email"], customer_data["address"], customer_data["phone"]), unsafe_allow_html=True)

def edit_account(customer_data):
    st.title("Edit Account")
    new_name = st.text_input("Name", customer_data["name"])
    new_email = st.text_input("Email", customer_data["email"])
    new_address = st.text_area("Address", customer_data["address"])
    new_phone = st.text_input("Phone", customer_data["phone"])
    if st.button("Update Account"):
        customer_data["name"] = new_name
        customer_data["email"] = new_email
        customer_data["address"] = new_address
        customer_data["phone"] = new_phone
        st.success("Account updated successfully!")

def view_cart(customer_data):
    st.title("Shopping Cart")
    if not customer_data["cart"]:
        st.write("Your cart is empty.")
    else:
        for item in customer_data["cart"]:
            st.write(item)

def view_wishlist(customer_data):
    st.title("Wishlist")
    if not customer_data["wishlist"]:
        st.write("Your wishlist is empty.")
    else:
        for item in customer_data["wishlist"]:
            st.write(item)

def view_recently_purchased(customer_data):
    st.title("Recently Purchased Products")
    if not customer_data["recently_purchased"]:
        st.write("You haven't purchased anything yet.")
    else:
        for item in customer_data["recently_purchased"]:
            st.write(item)

# Main function
def main():
    st.set_page_config(page_title="Customer Account")

    display_account(customer_data)

    # Sidebar navigation
    option = st.sidebar.selectbox("Navigation", ["Account Details", "Edit Account", "View Cart", "View Wishlist", "View Recently Purchased"])
    
    if option == "Account Details":
        display_account(customer_data)
    elif option == "Edit Account":
        edit_account(customer_data)
    elif option == "View Cart":
        view_cart(customer_data)
    elif option == "View Wishlist":
        view_wishlist(customer_data)
    elif option == "View Recently Purchased":
        view_recently_purchased(customer_data)

if __name__ == "__main__":
    main()