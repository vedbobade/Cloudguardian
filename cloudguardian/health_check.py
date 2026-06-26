def get_health_status(cpu, ram, disk):
	
	if cpu > 90 or ram > 90 or disk > 90 :
		return "CRITICAL"
	
	elif cpu > 80 or ram > 80 or disk > 80 :
		return "WARNING"

	else:
		return "HEALTHY"
