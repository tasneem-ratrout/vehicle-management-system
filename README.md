# 🚀 API Upgrade 

## 📌 Overview
This branch introduces a major upgrade to the Vehicle Management System by transitioning from local storage to a real API-based architecture.

---

## 🔄 What Changed

### 🔹 API Integration
- Replaced `StorageService` as the primary data source with `VehicleApiService` using **Dio**
- Implemented:
  - GET /vehicles
  - POST /vehicles
  - PUT /vehicles/:id
  - DELETE /vehicles/:id

---

### 🔹 Polling (Auto Refresh)
- Added automatic data refresh every **30 seconds**
- Implemented inside `VehicleBloc`

---

### 🔹 Error Handling Improvements
- Replaced generic error state with:
  - `NetworkErrorState`
  - `TimeoutErrorState`
  - `ServerErrorState`
- Each error displays a different UI message

---

### 🔹 Offline Fallback
- If API fails → app loads last cached data
- Implemented using `SharedPreferences`

---

### 🔹 Dashboard Screen
- Added a new dashboard page
- Displays:
  - Total vehicles
  - Cars / Trucks / Motorcycles count

---

### 🔹 Pull-to-Refresh
- Implemented `RefreshIndicator` in all list screens
- Users can manually refresh data

---

## 🧠 Technical Highlights
- Clean Architecture (BLoC + Repository + Service)
- Separation of concerns
- Improved scalability and maintainability

---

## 📂 Main Files Added / Updated

### 🆕 Added
- `vehicle_api_service.dart`
- `dashboard_screen.dart`

### ✏️ Updated
- `vehicle_repository.dart`
- `vehicle_bloc.dart`
- `vehicle_state.dart`
- All screens (Cars, Trucks, Motorcycles, Home)

---

## 🏆 Summary
This branch upgrades the system from a static local application into a dynamic, API-driven system with real-time updates, offline support, and improved user experience.

---
