import 'package:flutter/foundation.dart';

class AppConstants {
  // Use relative path '/api' in release mode (for Vercel proxy) 
  // and direct IP in development mode.
  static const String baseUrl = kReleaseMode 
      ? '/api' 
      : 'http://18.208.248.234:3000/api';
}
