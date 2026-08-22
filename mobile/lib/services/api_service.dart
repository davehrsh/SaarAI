import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/analysis_response.dart';

class ApiService {
  static const String _baseUrl =
      'https://saarai-production.up.railway.app';

  static const String _analyzeEndpoint = '/api/v1/analyze';

  Future<AnalysisResponse> analyzeImages(List<File> images) async {
    if (images.isEmpty) {
      throw ArgumentError('At least one image is required.');
    }

    if (images.length > 3) {
      throw ArgumentError('A maximum of 3 images is allowed.');
    }

    final uri = Uri.parse('$_baseUrl$_analyzeEndpoint');

    final request = http.MultipartRequest('POST', uri);

    for (final image in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          image.path,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      return AnalysisResponse.fromJson(json);
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: _extractErrorMessage(response.body),
    );
  }

  String _extractErrorMessage(String body) {
    try {
      final json = jsonDecode(body);

      if (json is Map<String, dynamic> && json['detail'] is String) {
        return json['detail'] as String;
      }
    } catch (_) {
      // Fall through to generic message.
    }

    return 'Something went wrong while processing your request.';
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() {
    return 'ApiException($statusCode): $message';
  }
}