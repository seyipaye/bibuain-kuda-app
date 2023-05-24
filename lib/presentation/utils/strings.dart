import '../../data/bank/bank.dart';
import '../../main.dart';

const String stagingDomain = 'http://127.0.0.1:8070';
const String liveDomain = 'http://192.168.1.196:8070'; //'http://0.0.0.0:4455';

const String stagingURL = "$stagingDomain";
const String liveURL = '$liveDomain';

class AppStrings {
  // static const String noRouteFound = "No Route Found";
  static String get baseUrl => appDebugMode.value ? stagingURL : liveURL;
  static String get baseDomain =>
      appDebugMode.value ? stagingDomain : liveDomain;
}

const String kUrl = 'https://picsum.photos/200/200';

const kBank = const Bank(
  'Guranty Trust Bank',
  'code',
  'slug',
  'https://nigerianbanks.xyz/logo/guaranty-trust-bank.png',
  4,
);

const String kAvatar = 'assets/images/avatar-icon.png';
