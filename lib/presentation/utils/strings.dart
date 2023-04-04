import '../../main.dart';

const String stagingDomain = 'http://13.42.195.120';
const String liveDomain = 'http://13.42.195.120'; //'http://0.0.0.0:4455';

const String stagingURL = "$stagingDomain";
const String liveURL = '$liveDomain';

class AppStrings {
  // static const String noRouteFound = "No Route Found";
  static String get baseUrl => appDebugMode.value ? stagingURL : liveURL;
  static String get baseDomain =>
      appDebugMode.value ? stagingDomain : liveDomain;
}

const String kUrl = 'https://picsum.photos/200/200';

const String kAvatar = 'assets/images/avatar-icon.png';
