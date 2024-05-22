from utility import st
from Home import mc

# Function to fetch product records from MySQL
def fetch_products(search_query):
    if(mc == None): print("Yes3")
    mc.execute(f"SELECT * FROM products P where P.Name LIKE '%{search_query}%'")
    products = mc.fetchall()
    return products

# Display products in an organized manner
def display_products(products):
    st.write("# Products")
    if not products:
        st.write("No products found.")
    else:
        for product in products:
            st.write(f"## {product[1]}")  # Assuming the product name is in the second column
            st.write(f"Price: ${product[2]}")  # Assuming the price is in the third column
            st.write(f"Description: {product[3]}")  # Assuming the description is in the fourth column
            st.image(product[4], caption="Product Image", use_column_width=True)  # Assuming the image URL is in the fifth column

# Main function
def main():
    st.set_page_config(page_title="Croma Online Retail Store", page_icon=":computer:")
    st.markdown("<h3 style='color: green;'>Croma</h3>", unsafe_allow_html=True)

    st.markdown(
        """
        <div style="position:fixed;bottom:10px;text-align:center;width:100%;">
        <p style="color:#666666;">© 2024 Croma. All rights reserved.</p>
        </div>
        """,
        unsafe_allow_html=True,
    )
    
    # Search bar and button
    search_query = st.text_input("Search", "")
    if st.button("Search"):
        # Perform search logic here
        products = fetch_products(search_query)
        display_products(products)    


if __name__ == "__main__":
    main()
