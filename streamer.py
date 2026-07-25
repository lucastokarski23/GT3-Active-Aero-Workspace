import pandas as pd
import socket
import time
import serial
import serial.tools.list_ports

# ==========================================
# 1. HARDWIRED SETUP (COM PORT HUNTER)
# ==========================================
def auto_find_arduino():
    print("Hunting for a hardwired USB connection...")
    ports = serial.tools.list_ports.comports()
    
    for port in ports:
        # BLACKLIST: Explicitly ignore Windows Virtual Bluetooth Ports
        if "Bluetooth" in port.description or "BTHENUM" in port.device:
            continue
            
        # Scan system hardware descriptions for common USB-to-Serial chips
        if any(x in port.description for x in ["USB", "CH340", "CP210", "Arduino", "Serial"]):
            print(f"--> Found Hardware on {port.device} ({port.description})")
            try:
                # Synchronized with the 115200 baud configuration on the ESP32
                ser = serial.Serial(port.device, 115200, timeout=1)
                # Brief pause to allow the native USB connection to settle
                time.sleep(1) 
                return ser
            except Exception as e:
                print(f"    Could not open {port.device}: {e}")
                
    print("--> No active wired connection detected.")
    return None

# Attempt to establish primary wired pathway
ser = auto_find_arduino()

# ==========================================
# 2. WIRELESS FALLBACK SETUP (AUTO-DETECT)
# ==========================================
def auto_detect_esp32_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(('8.8.8.8', 80)) 
        my_pc_ip = s.getsockname()[0]
    except Exception:
        my_pc_ip = "127.0.0.1"
    finally:
        s.close()

    if my_pc_ip.startswith("192.168.4"):
        print(f"Fallback Network: CAR HOTSPOT (PC IP: {my_pc_ip})")
        return "192.168.4.1"
    else:
        print(f"Fallback Network: HOME NETGEAR (PC IP: {my_pc_ip})")
        return "10.0.0.19"

# Initialize wireless sockets so they stand armed and ready
ESP32_IP = auto_detect_esp32_ip()
UDP_PORT = 4210
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Print active pipeline status block
if ser:
    print("\n=== ACTIVE PIPELINE: PRIMARY HARDWIRED MODE ===")
else:
    print(f"\n=== ACTIVE PIPELINE: WIRELESS FALLBACK MODE (Target: {ESP32_IP}) ===")

# ==========================================
# 3. LOAD MOTEC CSV
# ==========================================
try:
    df = pd.read_csv('lap_data.csv', skiprows=12)
except FileNotFoundError:
    print("Error: 'lap_data.csv' not found. Ensure it is in the same folder.")
    exit()

print("Starting Telemetry Stream...")

# ==========================================
# 4. DATA PROPAGATION ENGINE
# ==========================================
try:
    for index, row in df.iterrows():
        try:
            speed = float(row.get('Ground Speed', 0))
            throttle = float(row.get('Throttle Pos', 0))
            brake = float(row.get('Brake Pos', 0))
            
            # Absolute value scaling to satisfy Simulink constraint mechanics
            raw_steer = float(row.get('Steering Angle', 0))
            steer = abs(raw_steer)
            
        except ValueError:
            continue
        
        if index % 5 == 0:
            mode_label = "WIRED" if ser else "WIRELESS"
            print(f"[{mode_label}] Row {index} | Speed: {speed:.1f} km/h | Steer: {steer:.1f}°")
        
        # Package and format the unified data string
        data_string = f"{speed:.2f},{throttle:.2f},{brake:.2f},{steer:.2f}\n"
        encoded_payload = data_string.encode('utf-8')
        
        # Fault-Tolerant Routing Logic
        if ser:
            try:
                ser.write(encoded_payload)
            except Exception:
                print("\n!!! PRIMARY CONNECTION LINK SEVERED !!! Deploying Emergency Wi-Fi Routing...")
                try:
                    ser.close()
                except Exception:
                    pass
                ser = None  # Clear reference to route all subsequent frames via UDP
                sock.sendto(encoded_payload, (ESP32_IP, UDP_PORT))
        else:
            sock.sendto(encoded_payload, (ESP32_IP, UDP_PORT))
        
        time.sleep(0.05)

    print("Lap Complete.")

except KeyboardInterrupt:
    print("\nStream manually aborted.")
finally:
    if ser:
        ser.close()