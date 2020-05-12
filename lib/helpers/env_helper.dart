import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simpledebts/models/common/env.dart';

class EnvHelper {

  static Env get env {
    return Env.fromJson(DotEnv().env);
  }

}