import os 
import psycopg2

from dotenv import load_dotenv

#load values from .env file
load_dotenv()

#Functions to connet to postgres

def get_connections():
    
    connection = psycopg2.connect(
        host = os.getenv("DB_HOST"),
        port = os.getenv("DB_PORT"),
        database = os.getenv("DB_NAME"),
        user = os.getenv("DB_USER"),
        password = os.getenv("DB_PASSWORD")  
        
    )
    
    return connection

#FNCTION TO INSERT METRICS INTO THE TABLE

def insert_metrics(cpu, memory, disk, sent, received,status):
    
    # connection to database
    connection = get_connections()
    
    # create cursor
    cursor = connection.cursor()
    
    #SQL query
    query = """
    INSERT INTO metrics(
        cpu_usage,
        ram_usage,
        disk_usage,
        bytes_sent,
        bytes_received,
	status
        )
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        
    #Execute query
    cursor.execute(
        query,
        (cpu, memory, disk, sent, received, status)
    )
    
    #Save changes
    connection.commit()
    
    #close connection
    cursor.close()
    connection.close()
    
    print("Data saved in Postgre SQL!!!")
    

