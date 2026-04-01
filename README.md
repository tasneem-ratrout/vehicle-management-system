# 🚀 API Upgrade 

## 🔧 Mock API Setup

The app now uses Dio with a real HTTP layer and expects a mock API host that exposes:

- GET `/vehicles` 
- POST `/vehicles`
- PUT `/vehicles/:id`
- DELETE `/vehicles/:id`

Set the API host using Dart define:

```bash
flutter run --dart-define=VEHICLE_API_BASE_URL=https://your-mock-api-host/api/v1
```

You can use a free provider like MockAPI and create a `vehicles` resource with the same JSON fields used by your models.

If no `VEHICLE_API_BASE_URL` is provided, the app now uses a built-in in-memory mock dataset so it can run without showing a startup server error.

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
