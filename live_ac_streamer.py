import socket
import time
import mmap
import ctypes
import sys
import serial
import serial.tools.list_ports

# ==========================================
# WINDOWS ANTI-THROTTLE OVERRIDE (MAXIMUM)
# ==========================================
if sys.platform == "win32":
    try:
        process_handle = ctypes.windll.kernel32.GetCurrentProcess()
        # 0x00000100 is REALTIME_PRIORITY_CLASS. 
        # Bypasses Windows Game Mode CPU throttling.
        ctypes.windll.kernel32.SetPriorityClass(process_handle, 0x00000100)
        print("System Priority: REALTIME (Maximum Override Active)")
    except Exception as e:
        print(f"Priority override failed: {e}")

# ==========================================
# 1. HARDWIRED SETUP (COM PORT HUNTER)
# ==========================================
def auto_find_arduino():
    print("Hunting for a hardwired USB connection...")
    ports = serial.tools.list_ports.comports()
    
    for port in ports:
        if "Bluetooth" in port.description or "BTHENUM" in port.device:
            continue
            
        if any(x in port.description for x in ["USB", "CH340", "CP210", "Arduino", "Serial"]):
            print(f"--> Found Hardware on {port.device} ({port.description})")
            try:
                ser = serial.Serial(port.device, 115200, timeout=1)
                time.sleep(1) 
                return ser
            except Exception as e:
                print(f"    Could not open {port.device}: {e}")
                
    print("--> No active wired connection detected.")
    return None

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

ESP32_IP = auto_detect_esp32_ip()
UDP_PORT = 4210
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

if ser:
    print("\n=== ACTIVE PIPELINE: PRIMARY HARDWIRED MODE ===")
else:
    print(f"\n=== ACTIVE PIPELINE: WIRELESS FALLBACK MODE (Target: {ESP32_IP}) ===")

# ==========================================
# 3. ASSETTO CORSA MEMORY STRUCTURE
# ==========================================
class ACPhysics(ctypes.Structure):
    _pack_ = 4
    _fields_ = [
        ("packetId", ctypes.c_int32),
        ("gas", ctypes.c_float),
        ("brake", ctypes.c_float),
        ("fuel", ctypes.c_float),
        ("gear", ctypes.c_int32),
        ("rpms", ctypes.c_int32),
        ("steerAngle", ctypes.c_float),
        ("speedKmh", ctypes.c_float),
    ]

# ==========================================
# 4. MAIN STREAMING LOOP
# ==========================================
def main():
    global ser 
    try:
        print("Waiting for Assetto Corsa telemetry...")
        shm = mmap.mmap(-1, ctypes.sizeof(ACPhysics), "acpmf_physics")
        ac_data = ACPhysics.from_buffer(shm)
        print("Telemetry linked. Stream is LIVE.")
        print("Press Ctrl+C to stop.\n")

        step_time = 0.05 
        loop_counter = 0 # Used to throttle the console printing

        while True:
            # 1. READ AND CONVERT
            speed = ac_data.speedKmh      
            throttle = ac_data.gas * 100.0  
            brake = ac_data.brake * 100.0   
            
            MAX_STEERING_LOCK = 400.0
            raw_steer_degrees = ac_data.steerAngle * MAX_STEERING_LOCK
            steer = abs(raw_steer_degrees)

            # 2. FORMAT DATA
            telemetry_string = f"{speed:.2f},{throttle:.2f},{brake:.2f},{steer:.2f}\n"
            encoded_payload = telemetry_string.encode('utf-8')
            
            # 3. CONSOLE STEALTH MODE (Only print every 10th loop to save Windows rendering time)
            if loop_counter % 10 == 0:
                mode_label = "WIRED" if ser else "WIRELESS"
                print(f"[{mode_label}] Sending: Speed:{speed:.1f} | Thr:{throttle:.1f} | Brk:{brake:.1f} | Str:{steer:.1f}")
            
            # 4. FAULT-TOLERANT ROUTING
            if ser:
                try:
                    ser.write(encoded_payload)
                except Exception:
                    print("\n!!! PRIMARY CONNECTION LINK SEVERED !!! Deploying Emergency Wi-Fi Routing...")
                    try:
                        ser.close()
                    except Exception:
                        pass
                    ser = None  
                    sock.sendto(encoded_payload, (ESP32_IP, UDP_PORT))
            else:
                sock.sendto(encoded_payload, (ESP32_IP, UDP_PORT))
            
            loop_counter += 1
            time.sleep(step_time)

    except KeyboardInterrupt:
        print("\nStopping telemetry stream...")
    except Exception as e:
        print(f"\nError: {e}")
    finally:
        if ser:
            ser.close()

if __name__ == "__main__":
    main()