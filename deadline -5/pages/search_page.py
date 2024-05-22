import streamlit as st
import time

# Set page title and favicon
def search():
    st.markdown(
        """
        <div>
        <h1 style="color:green;text-align:center;">Croma</h1>
        </div>
        """,
        unsafe_allow_html=True,
    )
    st.markdown(
        """
        <div style="position:fixed;bottom:10px;text-align:center;width:100%;">
        <p style="color:#666666;">© 2024 Croma. All rights reserved.</p>
        </div>
        """,
        unsafe_allow_html=True,
    )
    st.text_input("")
    if st.button("Search"):
            progress_bar = st.progress(0)
            for i in range(100):
                time.sleep(0.005)
                progress_bar.progress(i + 1)
    

if __name__ == "__main__":
    search()
