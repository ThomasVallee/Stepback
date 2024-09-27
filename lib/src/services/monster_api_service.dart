// lib/services/monster_api_service.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MonsterApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.monsterapi.ai'; // Replace with actual base URL

  MonsterApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers['Authorization'] = 'Bearer ${dotenv.env['MONSTER_API_TOKEN']}';
    _dio.options.headers['Content-Type'] = 'multipart/form-data';
  }

  /// Sends an image file to MonsterAPI.ai for transformation.
  /// 
  /// Returns the URL of the transformed image on success.
  Future<String> transformImage(File imageFile, {int year = 1900}) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        'year': year.toString(), // Example parameter; adjust as needed
        // Add any other required fields based on MonsterAPI.ai's API documentation
      });

      Response response = await _dio.post('/transform', data: formData);

      if (response.statusCode == 200) {
        // Parse the response based on MonsterAPI.ai's API structure
        // Example response structure:
        // {
        //   "status": "success",
        //   "data": {
        //     "transformed_image_url": "https://example.com/transformed_image.jpg"
        //   }
        // }
        if (response.data['status'] == 'success') {
          String transformedImageUrl = response.data['data']['transformed_image_url'];
          return transformedImageUrl;
        } else {
          throw Exception('Transformation failed: ${response.data['message']}');
        }
      } else {
        throw Exception('Failed to transform image: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error during image transformation: $e');
    }
  }
}
