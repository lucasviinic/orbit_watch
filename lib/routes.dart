import 'presenters/home/home.dart';
import 'presenters/onboard/onboard.dart';

routes(context) {
  return {
    "/home": (context) => const Home(),
    "/onboard": (context) => const Onboard()
  };
}
