extern "C" {
#include "DRSsimulink.h"
}
#include <ESP32Servo.h>
#include <WiFi.h>
#include <WiFiUdp.h>

Servo myServo;
const int ledPin = LED_BUILTIN;
unsigned long lastSerialTime = 0;

// ==========================================
// WIFI SETUP 1: Home Network (Desktop PC)
// ==========================================
const char* home_ssid = "NETGEAR94";
const char* home_password = "icysquash618";

// ==========================================
// WIFI SETUP 2: In-Car Network (Laptop)
// ==========================================
const char* ap_ssid = "DRS_Test_Stand";
const char* ap_password = "activeaero";

WiFiUDP Udp;
const unsigned int localUdpPort = 4210;
char incomingPacket[255]; 

void setup() {
  Serial.begin(115200);
  delay(3000);
  myServo.attach(5, 500, 2500); 
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW); 
  DRSsimulink_initialize(); 

  // --- THE NETWORK FALLBACK LOGIC ---
  Serial.println("\nBooting DRS Network Manager...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(home_ssid, home_password);

  int attempts = 0;
  // Try to connect to the house for 10 seconds
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }

  // Check the result
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[MODE 1] HOME NETWORK ACTIVE");
    Serial.print("Target IP for Desktop PC: ");
    Serial.println(WiFi.localIP()); 
    digitalWrite(ledPin, HIGH); 
  } else {
    Serial.println("\n[MODE 2] CAR NETWORK ACTIVE");
    Serial.println("Home WiFi not found. Starting standalone Hotspot.");
    WiFi.mode(WIFI_AP);
    WiFi.softAP(ap_ssid, ap_password);
    Serial.print("Target IP for In-Car Laptop: ");
    Serial.println(WiFi.softAPIP()); // This is permanently 192.168.4.1
  }

  // Open the UDP port to listen for Python packets
  Udp.begin(localUdpPort);
  Serial.println("UDP Server ready. Waiting for telemetry...");
}

void loop() {
  bool dataReceived = false;
  float speed = 0, throttle = 0, brake = 0, steer = 0;

  // ==========================================
  // 1. CHECK PRIMARY: HARDWIRED USB (SERIAL)
  // ==========================================
  if (Serial.available() > 0) {
    String serialData = Serial.readStringUntil('\n');
    if (sscanf(serialData.c_str(), "%f,%f,%f,%f", &speed, &throttle, &brake, &steer) == 4) {
      dataReceived = true;
      lastSerialTime = millis(); // Reset the Watchdog Timer
    }
  }

  // ==========================================
  // 2. CHECK FALLBACK: WIRELESS (UDP)
  // ==========================================
  int packetSize = Udp.parsePacket();
  if (packetSize) {
    int len = Udp.read(incomingPacket, 255);
    if (len > 0) { incomingPacket[len] = '\0'; }

    // Only process Wi-Fi if the USB Watchdog hasn't seen data in 500ms
    if (millis() - lastSerialTime > 500) {
      if (sscanf(incomingPacket, "%f,%f,%f,%f", &speed, &throttle, &brake, &steer) == 4) {
        dataReceived = true;
        
        // Debug LED to show it is running on Wireless Fallback
        digitalWrite(ledPin, HIGH);
        delay(5);
        digitalWrite(ledPin, LOW);
      }
    }
  }

  // ==========================================
  // 3. EXECUTE SIMULINK (If data came from anywhere)
  // ==========================================
  if (dataReceived) {
    DRSsimulink_U.Speed = speed;
    DRSsimulink_U.Throttle = throttle;
    DRSsimulink_U.BrakePressure = brake;
    DRSsimulink_U.SteeringAngle = steer;

    DRSsimulink_step();

    myServo.writeMicroseconds(1500 - int(DRSsimulink_Y.Out1) * (2000.0 / 270.0));
  }
}