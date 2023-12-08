import 'package:foradacaixac/main.dart';
import 'package:patrol/patrol.dart';
import '../../screens/home_screen.dart';
import '../../screens/login_not_remembered_screen.dart';

void main() {
  patrolTest('Successful Login', ($) async {
    await $.pumpWidgetAndSettle(const MyApp());
    await LoginNotRememberedScreen().informUserAndPassword($, '92903540039', '172839');
    await LoginNotRememberedScreen().tapButtonLogin($);
    await LoginNotRememberedScreen().grandPermissionIfRequired($);
    await HomeScreen().checkTextWelcomeUser($, 'Olá, João');
  });

}
