import '../../main.dart';

const String stagingDomain = 'https://smart-backend.onrender.com';
const String liveDomain =
    'https://smart-backend.onrender.com'; //'http://0.0.0.0:4455';

const String stagingURL = "$stagingDomain/api/v1";
const String liveURL = '$liveDomain/api/v1';

class AppStrings {
  // static const String noRouteFound = "No Route Found";
  static String get baseUrl => appDebugMode.value ? stagingURL : liveURL;
  static String get baseDomain =>
      appDebugMode.value ? stagingDomain : liveDomain;
}

const String kUrl = 'https://picsum.photos/200/200';

const String kAvatar = 'assets/images/avatar-icon.png';
