
import '../../main.dart';

const String stagingDomain = 'https://foodello.herokuapp.com';
const String liveDomain = 'https://foodelo-beta.herokuapp.com';

const String stagingURL = "$stagingDomain/api/v1";
const String liveURL = '$liveDomain/api/v1';

class AppStrings {
  // static const String noRouteFound = "No Route Found";
  static String get baseUrl => appDebugMode.value ? stagingURL : liveURL;
  static String get baseDomain =>
      appDebugMode.value ? stagingDomain : liveDomain;
}

const String kUrl =
    'https://res.cloudinary.com/foodelo/image/upload/v1664922282/Foodelo/Media/ve98cxkhbzeobzdnn0sm.png';

const int kCripsExpiryTime = 1; // In hours

const String cripsID = '8f23541e-0518-4659-ba4f-7cda9aa5ac68';

const String googleMapsAPIKey = "AIzaSyB-_DDU0TQKu5wWEKybt1VkM-1VbXVIDl8";
