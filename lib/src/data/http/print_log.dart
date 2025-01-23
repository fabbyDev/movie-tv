part of 'http.dart';

void _printLog(Map<String, dynamic> message, StackTrace? stackTrace) {
  if (kDebugMode) {
    log(
      '''
----------------------------------
${const JsonEncoder.withIndent('  ').convert(message)}
----------------------------------
          ''',
      stackTrace: stackTrace,
    );
  }
}
