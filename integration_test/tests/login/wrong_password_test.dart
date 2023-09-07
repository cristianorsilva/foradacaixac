import 'package:foradacaixac/main.dart';
import 'package:patrol/patrol.dart';
import '../../screens/login_not_remembered_screen.dart';

void main() {

  patrolTest('Wrong Password informed', nativeAutomation: true, ($) async {
    await $.pumpWidgetAndSettle(const MyApp());
    await LoginNotRememberedScreen().informUserAndPassword($, '92903540039', '172830');
    await LoginNotRememberedScreen().tapButtonLogin($);
    await LoginNotRememberedScreen().grandPermissionIfRequired($);
    await LoginNotRememberedScreen().checkTextAlertDialogMessage($, 'Usuário ou senha inválidos');
  });

}
