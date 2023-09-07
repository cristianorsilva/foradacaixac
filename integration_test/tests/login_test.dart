import 'package:foradacaixac/main.dart';
import 'package:patrol/patrol.dart';
import '../screens/home_screen.dart';
import '../screens/login_not_remembered_screen.dart';

void main() {
  patrolTest('Successful Login', nativeAutomation: true, ($) async {
    await $.pumpWidgetAndSettle(const MyApp());
    await LoginNotRememberedScreen().informUserAndPassword($, '92903540039', '172839');
    await LoginNotRememberedScreen().tapButtonLogin($);
    await LoginNotRememberedScreen().grandPermissionIfRequired($);
    await HomeScreen().checkTextWelcomeUser($, 'Olá, João');
  });

  patrolTest('Wrong Password informed', nativeAutomation: true, ($) async {
    await $.pumpWidgetAndSettle(const MyApp());
    await LoginNotRememberedScreen().informUserAndPassword($, '92903540039', '172830');
    await LoginNotRememberedScreen().tapButtonLogin($);
    await LoginNotRememberedScreen().grandPermissionIfRequired($);
    await LoginNotRememberedScreen().checkTextAlertDialogMessage($, 'Usuário ou senha inválidos');
  });

  patrolTest('Nonexistent Document informed', nativeAutomation: true, ($) async {
    await $.pumpWidgetAndSettle(const MyApp());
    await LoginNotRememberedScreen().informUserAndPassword($, '90691216037', '172839');
    await LoginNotRememberedScreen().tapButtonLogin($);
    await LoginNotRememberedScreen().grandPermissionIfRequired($);
    await LoginNotRememberedScreen().checkTextAlertDialogMessage($, 'Usuário ou senha inválidos');
  });
}
