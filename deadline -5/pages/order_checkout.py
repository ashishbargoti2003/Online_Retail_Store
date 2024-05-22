from utility import st,launch_connection
import time
import random

db = launch_connection()
mc = db.cursor()

def display_order_checkout(cart_items, shipping_options, payment_methods):
    """Displays the order checkout page with a clear layout.

    Args:
      cart_items (list): A list of dictionaries containing cart item details.
      shipping_options (list): A list of dictionaries containing shipping option details.
      billing_info (dict): A dictionary containing user's billing information.
      payment_methods (list): A list of dictionaries containing payment method details.
  """
    st.write('''<style>
    [data-testid="stVerticalBlock"] > [style*="flex-direction: column;"] > [data-testid="stVerticalBlock"] { 
        border-radius: 15px;
        box-shadow: 0px 2px 5px rgba(0,0,0,0.1);
        padding: 20px;
    }        
    </style>''', unsafe_allow_html=True)
    # st.title("Order Checkout")

    if(cart_items == None):
         st.write("No items in your cart!")
         st.write("Please place items in your cart to place an order!")
         return

    with st.container():
        st.subheader("Cart Summary")
        st.write("-" * 20)  # Separator
        total_price = 0
        col3, col4 = st.columns([2,1])
        for item in cart_items:
            price = item[1] * item[2]
            total_price += price
            with col3:
                st.write(f"Product Name: {item[0]}")
                st.write(f"Quantity: {item[2]}")
            with col4:
                 st.write(f"Price: Rs.{price:.2f}")
                 st.write("\n")
                 st.write("\n")
        st.write("-" * 20)
        st.write(f"**Total:** Rs.{total_price:.2f}")

    st.write("\n")
    st.write("\n")
    st.write("\n")
    st.write("\n")

    col1, col2 = st.columns(2)
        
    with col1:
        with st.container():
            st.subheader("Shipping")
            st.write("-" * 20)
            list = []
            for item in shipping_options:
                 list.append(f"{item[2]}, {item[3]}, {item[4]}, {item[5]} - {item[7]}, {item[6]}")
            selected_shipping = st.radio("Select Shipping Option", list, key="shipping_option")
    
    with col2:
        with st.container():
            st.subheader("Payment Method")
            st.write("-" * 20)
            selected_payment = st.radio("Select Payment Method", payment_methods, key="payment_method")
            if selected_payment == "Credit Card":
                    # Display credit card details input fields
                    st.subheader("Credit Card Details")
                    card_number = st.text_input("Card Number")
                    expiry_date = st.text_input("Expiry Date (MM/YY)")
                    cvv = st.text_input("CVV", type="password")
            elif selected_payment == "Debit Card":
                    # Display debit card details input fields (similar to credit card)
                    st.subheader("Debit Card Details")
                    card_number = st.text_input("Card Number")
                    expiry_date = st.text_input("Expiry Date (MM/YY)")
                    cvv = st.text_input("CVV", type="password")
            # Order confirmation button (implementation depends on your logic)
            if st.button("Place Order"):
                with st.spinner("Processing order..."):
                    time.sleep(2)  # Simulate processing time

                # Generate random captcha letters
                captcha_letters = random.sample("ABCDEFGHIJKLMNOPQRSTUVWXYZ", 5)
                captcha_text = "".join(captcha_letters)
                st.write(f"Captcha: {captcha_text}")
                # Get user input for captcha
                user_captcha = st.text_input("Enter the security code:")
                if(st.button("Verify")):
                    if user_captcha == captcha_text:
                        with st.spinner("Verifying..."):
                            time.sleep(1)  
                        st.success("Order confirmed! Thank you for your purchase.")                         
                        query = f"DELETE from Cart C"
                        mc.execute(query)
                    else:
                        st.error("Invalid captcha. Please try again.")
                # Process order confirmation logic here
    

def main():
    st.set_page_config(page_title="Croma Online Retail Store", page_icon=":computer:")

    query1 = f"Select P.Name, P.Price, C.Quantity from Products P, Cart C where C.Product_ID = P.Product_ID AND C.Customer_ID = 1"
    mc.execute(query1)
    cart_items = mc.fetchall()
    query2 = f"Select * from Addresses A WHERE A.Customer_ID = 1"
    mc.execute(query2)
    shipping_options = mc.fetchall()

    payment_methods = ["Credit Card","Debit Card"]

    display_order_checkout(cart_items, shipping_options, payment_methods)

if __name__ == "__main__":
    main()