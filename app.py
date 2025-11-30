import psutil
import time
import csv
from datetime import datetime

def log_performance():
    with open('system_performance.csv', 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["Timestamp", "CPU Usage", "Memory Usage", "Disk Usage"])
        
        while True:
            cpu = psutil.cpu_percent(interval=1)
            memory = psutil.virtual_memory().percent
            disk = psutil.disk_usage('/').percent
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            
            writer.writerow([timestamp, cpu, memory, disk])
            file.flush()  # Ensure data is written to file
            
            print(f"{timestamp} - CPU: {cpu}%, Memory: {memory}%, Disk: {disk}%")
            time.sleep(60)  # Log every minute

if __name__ == "__main__":
    log_performance()
