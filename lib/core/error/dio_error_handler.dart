import 'dart:io';
import 'package:dio/dio.dart';
import 'failure.dart';

abstract class DioErrorHandler {
  // منع إنشاء نسخة من الكلاس لأنه يحتوي على دوال ثابتة فقط
  const DioErrorHandler._();

  /// نقطة الدخول الشاملة لمعالجة أي نوع من الأخطاء (Dio, System Exceptions, Type Errors, etc.)
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is SocketException) {
      return const NetworkFailure('No internet connection detected.');
    }

    if (error is TypeError) {
      // يعالج أخطاء تحويل البيانات (مثال: إذا تغير نوع البيانات القادمة من السيرفر من int إلى String فجأة)
      return const ServerFailure('Data parsing error. Please contact support.');
    }

    if (error is Exception) {
      return UnknownFailure(error.toString().replaceAll('Exception: ', ''));
    }

    // المعالج الأخير والنهائي لأي خطأ غير متوقع على الإطلاق
    return UnknownFailure(error?.toString() ?? 'An unexpected error occurred.');
  }

  /// معالجة الأخطاء الخاصة بـ Dio والشبكة بشكل دقيق
  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const NetworkFailure('Connection timed out. Please try again.');

      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection detected.');

      case DioExceptionType.badCertificate:
        return const NetworkFailure(
          'Secure connection failed (Bad Certificate).',
        );

      case DioExceptionType.cancel:
        return const UnknownFailure('The request was cancelled.');

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.unknown:
      default:
        // التحقق من وجود SocketException مخفي داخل الأخطاء غير المعروفة في Dio
        if (error.error is SocketException ||
            (error.message?.contains('SocketException') ?? false)) {
          return const NetworkFailure('No internet connection detected.');
        }
        return UnknownFailure(
          error.message ?? 'An unexpected network error occurred.',
        );
    }
  }

  /// قراءة استجابة السيرفر الخاطئة (HTTP 4xx & 5xx) واستخراج نص الخطأ الفعلي المرسل من الخلفية (Backend)
  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure('Server returned an empty response.');
    }

    final statusCode = response.statusCode;
    final dynamic responseData = response.data;

    // 1. محاولة استخراج رسالة الخطأ الموجهة للمستخدم من الـ JSON المرسل من السيرفر
    String? apiErrorMessage;
    if (responseData is Map<String, dynamic>) {
      apiErrorMessage =
          responseData['message']?.toString() ??
          responseData['error']?.toString() ??
          responseData['msg']?.toString();
    } else if (responseData is String && responseData.isNotEmpty) {
      apiErrorMessage = responseData;
    }

    if (apiErrorMessage != null && apiErrorMessage.isNotEmpty) {
      return ServerFailure(apiErrorMessage);
    }

    // 2. حلول بديلة عامة بناءً على كود حالة الـ HTTP في حال لم يرسل السيرفر نص خطأ محدد
    switch (statusCode) {
      case 400:
        return const ServerFailure('Bad request. Please check your input.');
      case 401:
        return const ServerFailure('Unauthorized access. Please log in again.');
      case 403:
        return const ServerFailure(
          'Forbidden access. You do not have permission.',
        );
      case 404:
        return const ServerFailure('Requested resource not found.');
      case 409:
        return const ServerFailure('Conflict occurred. Please try again.');
      case 500:
        return const ServerFailure(
          'Internal server error. Please try again later.',
        );
      default:
        return ServerFailure(
          'Server error occurred (Status Code: ${statusCode ?? "Unknown"})',
        );
    }
  }
}
