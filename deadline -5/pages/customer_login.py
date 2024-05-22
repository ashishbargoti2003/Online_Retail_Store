from utility import st,launch_connection
from menu import registration_menu_with_redirect
mc = launch_connection()
cur = mc.cursor()

registration_menu_with_redirect()
if st.session_state.login_key not in ["Login"]:
    st.warning("You do not have permission to view this page.")
    st.stop()

def customer_login_page():
    # cur=mc.cursor()
    st.header("Customer Login")
    login_method_options = ["Email", "Phone Number"]
    selected_method = st.radio("Choose Login Method:", login_method_options, key="login_method_key")

    # Input fields based on selected method
    if selected_method == "Email":
        inp = st.text_input("Enter your email address")
        password = st.text_input("Enter your password", type="password")
        login_button = st.button("Login with Email")
        # Add logic for login using email (e.g., database lookup)

    elif selected_method == "Phone Number":
        inp = st.text_input("Enter your phone number")
        password = st.text_input("Enter your password", type="password")
        login_button = st.button("Login with Phone Number")
        # Add logic for login using phone number (e.g., SMS verification)

    else:
        st.error("Unexpected login method selected!")

    # password = st.text_input("Password", type="password")

    cur.execute("SELECT * from Customer WHERE Email_ID = %s", (inp,))
    record = cur.fetchall()
    # print(record)
    # rajesh.sharma@example.com

    if st.button("Login"):
        # Add your login logic here
        if inp and password and (record[0][5] == password):
            st.success("Login successful!")
        else:
            st.error("Invalid username or password")    

if __name__ == "__main__":
    customer_login_page()