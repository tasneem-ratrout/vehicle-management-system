import 'package:dio/dio.dart';

class NetworkUnavailableException implements Exception {
  final String message;
  NetworkUnavailableException([this.message = 'Network unavailable']);
}

class ApiTimeoutException implements Exception {
  final String message;
  ApiTimeoutException([this.message = 'Request timeout']);
}

class ApiServerException implements Exception {
  final String message;
  final int? statusCode;

  ApiServerException(this.message, {this.statusCode});
}

class VehicleApiService {
  VehicleApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              // Replace with your own mock API host that exposes /vehicles.
              baseUrl: const String.fromEnvironment(
                'VEHICLE_API_BASE_URL',
                defaultValue: 'https://example.mockapi.io/api/v1',
              ),
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
            ),
          );

  final Dio _dio;

  static const int _defaultPageSize = 20;
  static final List<Map<String, dynamic>> _mockStore = _buildInitialMockStore();

  bool get _useBuiltInMock =>
      _dio.options.baseUrl.contains('example.mockapi.io');

  Future<List<Map<String, dynamic>>> getAllVehiclesPaginated({
    int pageSize = _defaultPageSize,
  }) async {
    final all = <Map<String, dynamic>>[];
    var page = 1;

    while (true) {
      final batch = await getVehicles(page: page, limit: pageSize);
      if (batch.isEmpty) {
        break;
      }

      all.addAll(batch);

      if (batch.length < pageSize) {
        break;
      }

      page++;
      if (page > 500) {
        break;
      }
    }

    return all;
  }

  Future<List<Map<String, dynamic>>> getVehicles({
    int page = 1,
    int limit = _defaultPageSize,
  }) async {
    if (_useBuiltInMock) {
      final start = (page - 1) * limit;
      if (start >= _mockStore.length) {
        return [];
      }

      final end = (start + limit).clamp(0, _mockStore.length);
      return _mockStore.sublist(start, end).map((e) => {...e}).toList();
    }

    try {
      final res = await _dio.get(
  '/vehicles',
  queryParameters: {
    'page': page,
    'limit': limit,
  },
);

      return _extractVehicleList(res.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> addVehicle(Map<String, dynamic> data) async {
    if (_useBuiltInMock) {
      final item = Map<String, dynamic>.from(data);
      final hasId = (item['id']?.toString().trim().isNotEmpty ?? false);
      item['id'] = hasId
          ? item['id'].toString()
          : DateTime.now().microsecondsSinceEpoch.toString();
      _mockStore.add(item);
      return {...item};
    }

    try {
      final res = await _dio.post('/vehicles', data: data);
      return _asMap(res.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> updateVehicle(
    String id,
    Map<String, dynamic> data,
  ) async {
    if (_useBuiltInMock) {
      final index = _mockStore.indexWhere((e) => e['id'].toString() == id);
      final item = Map<String, dynamic>.from(data)..['id'] = id;
      if (index != -1) {
        _mockStore[index] = item;
      }
      return {...item};
    }

    try {
      final res = await _dio.put('/vehicles/$id', data: data);
      return _asMap(res.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteVehicle(String id) async {
    if (_useBuiltInMock) {
      _mockStore.removeWhere((e) => e['id'].toString() == id);
      return;
    }

    try {
      await _dio.delete('/vehicles/$id');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  List<Map<String, dynamic>> _extractVehicleList(dynamic payload) {
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
          .toList();
    }

    if (payload is Map<String, dynamic>) {
      final dynamic list =
          payload['data'] ?? payload['items'] ?? payload['vehicles'];
      if (list is List) {
        return list
            .whereType<Map>()
            .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
            .toList();
      }
    }

    throw ApiServerException('Unexpected API payload format');
  }

  Map<String, dynamic> _asMap(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    if (payload is Map) {
      return payload.map((k, v) => MapEntry(k.toString(), v));
    }

    throw ApiServerException('Unexpected API payload format');
  }

  Exception _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiTimeoutException();
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return ApiServerException('Server error', statusCode: code);
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return NetworkUnavailableException();
    }
  }

  static List<Map<String, dynamic>> _buildInitialMockStore() {
    return [
      {
        'id': '1',
        'type': 'car',
        'manufactureCompany': 'Toyota',
        'manufactureDate': '2023-03-10T00:00:00.000',
        'model': 'Corolla',
        'engine': {
          'manufacture': 'Toyota',
          'manufactureDate': '2023-01-05T00:00:00.000',
          'model': '2ZR',
          'capacity': 1800,
          'cylinders': 4,
          'fuelType': 'gasoline',
        },
        'plateNum': 110234,
        'gearType': 'automatic',
        'bodySerialNum': 908877,
        'length': 4630,
        'width': 1780,
        'color': 'White',
        'chairNum': 5,
        'isFurnitureLeather': true,
      },
      {
        'id': '2',
        'type': 'truck',
        'manufactureCompany': 'Volvo',
        'manufactureDate': '2022-08-20T00:00:00.000',
        'model': 'FH16',
        'engine': {
          'manufacture': 'Volvo',
          'manufactureDate': '2022-06-10T00:00:00.000',
          'model': 'D16K',
          'capacity': 16000,
          'cylinders': 6,
          'fuelType': 'diesel',
        },
        'plateNum': 220045,
        'gearType': 'normal',
        'bodySerialNum': 554411,
        'length': 7200,
        'width': 2500,
        'color': 'Blue',
        'freeWeight': 8900,
        'fullWeight': 18000,
      },
      {
        'id': '3',
        'type': 'motorcycle',
        'manufactureCompany': 'Yamaha',
        'manufactureDate': '2024-01-12T00:00:00.000',
        'model': 'MT-07',
        'engine': {
          'manufacture': 'Yamaha',
          'manufactureDate': '2023-11-20T00:00:00.000',
          'model': 'CP2',
          'capacity': 689,
          'cylinders': 2,
          'fuelType': 'gasoline',
        },
        'plateNum': 330912,
        'gearType': 'normal',
        'bodySerialNum': 332299,
        'tierDiameter': 17,
        'length': 2085,
      },
    ];
  }
}
