# 🚗 Vehicle Management System  

A Flutter-based application for managing different types of vehicles using **Object-Oriented Programming (OOP)** principles.

---

## 📌 Project Overview

The Vehicle Management System allows users to:

- ➕ Add new vehicles
- ✏️ Modify existing vehicles
- 🗑 Delete vehicles
- 📍 Insert vehicles at a specific position
- 🔍 Search vehicles by:
  - Manufacture Company
  - Plate Number
  - Manufacture Date
- 🖨 Print vehicle details
- 💾 Automatically save & load data locally using JSON

---

## 🧠 OOP Concepts Used

✔ Encapsulation (Private fields with getters & setters)  
✔ Inheritance (Vehicle → Automobile → Car/Truck/Motorcycle)  
✔ Polymorphism  
✔ JSON Serialization (toJson / fromJson)  

---

## 🚘 Supported Vehicle Types

### 🚗 Car
- Chair Number
- Leather Interior
- Vehicle Dimensions
- Engine Details

### 🚚 Truck
- Free Weight
- Full Weight
- Vehicle Dimensions
- Engine Details

### 🏍 Motorcycle
- Tire Diameter
- Length
- Engine Details

---

## ⚙️ Technologies Used

- 💙 Flutter
- 🎯 Dart
- 📦 shared_preferences
- 🔁 JSON Encoding/Decoding

---

## 🖥 Application Screens

### 🏠 Home Screen
- Displays number of:
  - Cars
  - Trucks
  - Motorcycles
- Print All Vehicles button

### 🚗 Cars Screen
- Add / Edit / Delete
- Insert at position
- Search by company, plate, or date
- Print individual car

### 🚚 Trucks Screen
- Add / Edit / Delete
- Insert at position
- Search functionality
- Print truck details

### 🏍 Motorcycles Screen
- Add / Edit / Delete
- Insert at position
- Search functionality
- Print motorcycle details

---

## 💾 Data Storage
All vehicle data is stored locally using:

- 📦 shared_preferences
- 🔁 JSON encoding / decoding

The data is automatically:
- Saved after any modification (Add / Edit / Delete / Insert)
- Loaded automatically when the application starts

---

## 🔍 Search System

Users can search vehicles by:

- 🏢 Manufacture Company
- 🔢 Plate Number
- 📅 Manufacture Date

Search is dynamic and filters results instantly.

---

## 📌 Insert at Position

The application allows inserting a vehicle at a specific index in the list.

Example:
If you insert at position `0`, the vehicle will appear at the top of the list.

---

## ▶ How to Run the Project

### 1️⃣ Clone the repository

```bash
git clone https://github.com/tasneem-ratrout/vehicle-management-system.git


```

### 2️⃣ Navigate to the project folder

```bash
cd vehicle-management-system

```
### 3️⃣ Install dependencies

```bash
flutter pub get

```

### 4️⃣ Run the application

```bash
flutter run

```
To run on a specific device:
```bash
flutter devices
flutter run -d <device_id>
```

---
## 📂 Project Structure
```text
lib/
│
├── models/
│   ├── vehicle.dart
│   ├── automobile.dart
│   ├── car.dart
│   ├── truck.dart
│   ├── motorcycle.dart
│   ├── engine.dart
│   └── enums.dart
│
├── services/
│   ├── storage_service.dart
│   └── print_helpers.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── cars_screen.dart
│   ├── trucks_screen.dart
│   ├── motorcycles_screen.dart
│   ├── car_form_screen.dart
│   ├── truck_form_screen.dart
│   └── motorcycle_form_screen.dart
│
└── main.dart
```
---
## 👩‍💻 Developed By
Tasneem Ratrout

---
