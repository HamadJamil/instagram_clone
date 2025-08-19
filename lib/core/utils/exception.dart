class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException(this.message, {this.code});
}

class NetworkException implements Exception {
  final String message;
  final String? code;
  const NetworkException(this.message, {this.code});
}

class FirestoreException implements Exception {
  final String message;
  final String? code;
  const FirestoreException(this.message, {this.code});
}
