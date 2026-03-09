import 'package:flutter/foundation.dart';

class AppConstants {
  // Change this to true when you want to force local backend
  static const bool useLocal = true;

  static String get baseUrl {
    if (useLocal) {
      return 'http://192.168.1.25:3000/api'; // local/dev server
    }

    // default behavior
    return kReleaseMode
        ? '/api' // production (Vercel proxy)
        : 'http://18.208.248.234:3000/api';
  }
}
