from utility import launch_connection, pd, st


mc = launch_connection()
cur=mc.cursor()


def view_cart(record):
  st.markdown("# Cart")
  cur.execute("SELECT * FROM cart WHERE customer_id = %s", (int(record[0])))
  data = cur.fetchall()
  
  if data:
    headers = ["Customer_ID", "Product_ID", "Quantity", "Total_Price", "Added_Date", "Action"]
    rows = []
    for item in data:
      row = list(item) + [""]  # Add empty cell for button
      rows.append(row)

    df = pd.DataFrame(rows, columns=headers)

    # Display table with buttons using st.table
    st.table(df.style.set_properties(**{'text-align': 'center'})  # Center cell content
             .set_table_styles([
                 {'selector': 'th',  'props': 'border-top: 1px solid black; border-bottom: 1px solid black;'},
                 {'selector': 'td',  'props': 'border: 1px solid black;'},
             ]))

    # Function to handle button click (replace with your removal logic)
    def handle_remove(customer_id, product_id):
    #   print("here:",customer_id,':',product_id)
      cur.execute("delete from cart where customer_id=%s and product_id=%s;",(customer_id,product_id))
      mc.commit()
      st.success("Cart updated successfully!")
      
      

    # Add button functionality within the table cells (using lambda for clarity)
    for i, row in df.iterrows():
      cols = st.columns(len(row))
      for j, value in enumerate(row):
        if j == len(row) - 1:
          
        #   print("before:",data[0],data[1])
          cols[j].button('Remove', key=f'remove_{row["Customer_ID"]}_{row["Product_ID"]}', on_click=lambda c=row["Customer_ID"], p=row["Product_ID"]: handle_remove(c, p))
        else:
          cols[j].write(value)
  else:
    st.write("Your cart is empty.") 



def view_wishlist(record):
    st.markdown("# Wishlist")
    cur.execute("SELECT * FROM wishlist WHERE customer_id = %s", (int(record[0]),))
    data = cur.fetchall()

    if data:
        headers = ["Customer_ID", "Product_ID","Added_Date", "Action"]
        rows = []
        for item in data:
            row = list(item) + [""]  # Add empty cell for button
            rows.append(row)

        df = pd.DataFrame(rows, columns=headers)

        # Display table with buttons using st.table
        st.table(df.style.set_properties(**{'text-align': 'center'})  # Center cell content
                 .set_table_styles([
                     {'selector': 'th',  'props': 'border-top: 1px solid black; border-bottom: 1px solid black;'},
                     {'selector': 'td',  'props': 'border: 1px solid black;'},
                 ]))

        # Function to handle button click (replace with your removal logic)
        def handle_remove(customer_id, product_id):
            #   print("here:",customer_id,':',product_id)
            cur.execute("delete from wishlist where customer_id=%s and product_id=%s;",(customer_id,product_id))
            mc.commit()
            st.success("Wishlist updated successfully!")
            
        # Add button functionality within the table cells (using lambda for clarity)
        for i, row in df.iterrows():
            cols = st.columns(len(row))
            for j, value in enumerate(row):
                if j == len(row) - 1:
                    cols[j].button('Remove', key=f'remove_{row["Customer_ID"]}_{row["Product_ID"]}', on_click=lambda c=row["Customer_ID"], p=row["Product_ID"]: handle_remove(c, p))
                else:
                    cols[j].write(value)
    else:
        st.write("Your cart is empty.")
 

def customer_options(record):
    
    st.subheader(f"Welcome back, {record[1]}!")

    menu = ["View Cart", "View Wishlist"]
    selected_option = st.sidebar.radio("Select an Option :dart:", menu)

    if selected_option == "View Cart":
        
        view_cart(record)
    if(selected_option=="View Wishlist"):
       
       view_wishlist(record)

