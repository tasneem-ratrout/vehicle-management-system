import 'package:dio/dio.dart';

class VehicleApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://mocki.io/v1", // مؤقت
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<List<dynamic>> getVehicles() async {
    final res = await _dio.get("/vehicles");
    return res.data;
  }

  Future<void> addVehicle(Map<String, dynamic> data) async {
    await _dio.post("/vehicles", data: data);
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> data) async {
    await _dio.put("/vehicles/$id", data: data);
  }

  Future<void> deleteVehicle(String id) async {
    await _dio.delete("/vehicles/$id");
  }
}