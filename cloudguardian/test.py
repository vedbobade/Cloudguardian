from health_check import get_health_status
from alert import send_alert

print(get_health_status(20, 35, 21))
print(get_health_status(85, 35, 21))
print(get_health_status(95, 35, 21))

send_alert(95)
