import requests
import streamlit as st

def show_all_appointments():
    response = requests.get('http://localhost:5000/api/customer')
    if response.status_code == 200:
        appointments = response.json()
        if appointments:
            st.subheader('Customer Records')
            # Create a list of dictionaries for each row
            data = []
            for appointment in appointments:
                data.append({
                    'Customer_ID': appointment['Customer_ID'],
                    'First_Name': appointment['First_Name'],
                    'Middle_Name': appointment['Middle_Name'],
                    'Last_Name': appointment['Last_Name'],
                    'Email_ID': appointment['Email_ID'],
                    'Password': appointment['Password'],
                    'Contact_Number': appointment['Contact_Number'],
                    'Payment_Mode': appointment['Payment_Mode']
                })
            # Display the data as a table
            st.table(data)
        else:
            st.write("No appointments found")
    else:
        st.write("Failed to fetch appointments")


def main():
    st.title("Croma Online")
    show_all_appointments()


if __name__ == "__main__":
    main()
