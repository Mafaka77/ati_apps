import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart';
import 'package:training_apps/main.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/screens/network_error_screen.dart'; // your storage reference

class BaseService extends GetxService {
  late Dio client;

  @override
  void onInit() {
    super.onInit();

    client = Dio(
      BaseOptions(
        // baseUrl: "http://192.168.29.114:5001/api", // ⬅️ set your API base URL
        baseUrl: Routes.BASE_URL,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 40),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {"Accept": "application/json"},
      ),
    );

    // SSL bypass (not recommended for production!)
    (client.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient httpClient) {
          httpClient.findProxy = (uri) => "DIRECT"; // bypass proxy
          httpClient.badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  true; // ignore SSL
          return httpClient;
        };

    // Attach interceptors
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token if exists
          final token = storage.read<String>('token');
          // print(token);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Optionally log or transform response
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          final status = error.response?.statusCode;
          print("STATUS: ${error.response?.statusCode}");
          print("DATA: ${error.response?.data}");
          print("MESSAGE: ${error.message}");
          if (status == 401) {
            // Unauthorized → remove token & redirect
            await storage.remove('token');
            Get.offAllNamed('/login-screen');
          } else if (status == null) {
            // Get.snackbar(
            //   "Network Error",
            //   "Please check your internet connection",
            // );
          } else if (status >= 500) {
            final msg =
                error.response?.data["message"] ?? "Server error occurred";
            // Server error
            Get.snackbar("Server Error", msg);
          }

          return handler.next(error);
        },
      ),
    );
  }
}
