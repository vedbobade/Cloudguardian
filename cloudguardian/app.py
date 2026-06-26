import streamlit as st

# Page Settings
st.set_page_config(
    page_title="CloudGuardian Dashboard",
    page_icon="🛡️",
    layout="wide"
)

# Sample Data
cpu_usage = 45
ram_usage = 38
disk_usage = 22
status = "HEALTHY"

# Title
st.title("🛡️ CloudGuardian Dashboard")
st.write("AWS EC2 Monitoring & Health Management")

# Three Columns
col1, col2, col3 = st.columns(3)

with col1:
    st.metric("CPU Usage", f"{cpu_usage}%")

with col2:
    st.metric("RAM Usage", f"{ram_usage}%")

with col3:
    st.metric("Disk Usage", f"{disk_usage}%")

st.write("---")

# Status
if status == "HEALTHY":
    st.success("Server Status: HEALTHY")
elif status == "WARNING":
    st.warning("Server Status: WARNING")
else:
    st.error("Server Status: CRITICAL")

st.write("---")

# Alerts
st.subheader("📢 Recent Alerts")
st.info("No issues detected.")
