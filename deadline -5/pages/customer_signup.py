from utility import st
from menu import registration_menu_with_redirect


registration_menu_with_redirect()
if st.session_state.login_key not in ["Register"]:
    st.warning("You do not have permission to view this page.")
    st.stop()

def main():
    st.header("Customer Signup")
    name = st.text_input("Name")
    email = st.text_input("Email-ID")
    contact_number = st.text_input("Contact Number")
    password = st.text_input("Password", type="password")
    confirm_password = st.text_input("Confirm Password", type="password")
    if st.button("Signup"):
        # Add your signup logic here
        if password == confirm_password:
            st.success("Signup successful!")
        else:
            st.error("Passwords do not match")  

if __name__ == "__main__":
    main()