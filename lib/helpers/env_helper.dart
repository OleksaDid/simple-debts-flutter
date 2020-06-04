import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:simpledebts/models/common/env/env.dart';


class EnvHelper {
  
  static Future<void> setupEnvironment() async {
    WidgetsFlutterBinding.ensureInitialized();
    final info = await PackageInfo.fromPlatform();
    String envFile;

    switch (info.packageName) {
      case "com.simpledebts":
        envFile = '.env.prod';
        break;
      default:
        envFile = '.env.dev';
        break;
    }

    return DotEnv().load(envFile);
  }

  static Env get env {
    return Env.fromJson(DotEnv().env);
  }

}