import psutil
from db import insert_metrics
from datetime import datetime
from health_check import get_health_status

#GET CPU USAGE PERCENTAGE
cpu_usage = psutil.cpu_percent(interval=1)

#GET RAM USAGE PERCENTAGE
ram_usage = psutil.virtual_memory().percent

#GET DISK USAGE PERCENTAGE
disk_usage = psutil.disk_usage("/").percent

#GET NETWORK STATISTICS
network = psutil.net_io_counters()

#BYTES SENT FROM THE SYATEM
bytes_sent = network.bytes_sent

#BYTES RECEIVED FROM THE SYSTEM
bytes_received = network.bytes_recv

# GE SERVER HEALTH STATUS
status = get_health_status(
	cpu_usage,
	ram_usage,
	disk_usage
)

#PRINT VALUES SO WE CAN SEE THEM
print ("Run Time:", datetime.now())
print ( "cpu usage:", cpu_usage)
print ( "ram usage:", ram_usage)
print ( "disk usage:", disk_usage)
print ( "Bytes sent:", bytes_sent)
print ( "Bytes received:", bytes_received)

#STORE VALUES IN POSTGRES SQL 
insert_metrics(
    cpu_usage,
    ram_usage,
    disk_usage,
    bytes_sent,
    bytes_received,
    status
	
)

print("Metrics inserted successfully!!!!!!!!")
