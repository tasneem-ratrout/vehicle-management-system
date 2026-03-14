## 🌿 BLoC Branch Update

This branch (`bloc-pattern`) includes a refactored version of the project using the **BLoC pattern**.

### Added in this branch:
- 🚗 `VehicleBloc` for managing vehicle lists
- 🔎 `SearchBloc` for handling search results
- 💾 `PersistenceBloc` for reactive save/load states
- 📦 `VehicleRepository` for centralizing data operations
- 🗄 `StorageService` for JSON persistence
- 🎨 Refactored UI using `BlocBuilder`
- 🚀 `LoadVehiclesEvent` dispatched in `main.dart`
- ✅ 3 unit tests for `VehicleBloc`

This makes the project cleaner, more maintainable, and easier to test.
