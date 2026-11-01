import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/analysis_response.dart';

class ApiService {
  static const String _baseUrl =
      'https://saarai-api-163377210633.asia-south1.run.app';

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
        await _createMultipartFile(image),
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

  Future<http.MultipartFile> _createMultipartFile(File image) async {
    final mimeType = _getMimeType(image.path);

    return http.MultipartFile.fromPath(
      'files',
      image.path,
      contentType: mimeType,
    );
  }

  MediaType _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');

      case 'png':
        return MediaType('image', 'png');

      case 'webp':
        return MediaType('image', 'webp');

      default:
        throw ArgumentError(
          'Unsupported image format: .$extension',
        );
    }
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
