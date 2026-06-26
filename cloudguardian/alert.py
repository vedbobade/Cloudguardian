import os
import smtplib
from email.message import EmailMessage
from dotenv import load_dotenv

# Load values from .env file
load_dotenv()

# Function to send alert email
def send_alert(cpu_usage):

    # Read email details from .env
    my_email = os.getenv("EMAIL_USER")
    my_password = os.getenv("EMAIL_PASSWORD")
    alert_email = os.getenv("ALERT_EMAIL")

    # Create email
    email = EmailMessage()

    # Email subject
    email["Subject"] = "CloudGuardian Alert"

    # sender email 
    email["From"] = my_email

    #receiver email
    email["To"] = alert_email

    # email message
    email.set_content(
        f"Warning!\n\n"
        f"CPU Usage is {cpu_usage}%\n\n"
        f"Server Status: CRITICAL"
    )

    # connect to gmail 
    gmail_server = smtplib.SMTP_SSL("smtp.gmail.com",465)

    #login
    gmail_server.login(my_email, my_password)

    #send gmail
    gmail_server.send_message(email)

    # close connection
    gmail_server.quit()

    print("Alert Email Seant !!!!!!!!!!!!")
