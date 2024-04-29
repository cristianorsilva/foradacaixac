import 'package:foradacaixac/main.dart';
import 'package:patrol/patrol.dart';
import '../../screens/login_not_remembered_screen.dart';

void main() {

  patrolTest('Nonexistent Document informed', ($) async {
    await $.pumpWidgetAndSettle(const MyApp());
    await LoginNotRememberedScreen().informUserAndPassword($, '90691216037', '172839');
    await LoginNotRememberedScreen().tapButtonLogin($);
    await LoginNotRememberedScreen().grandPermissionIfRequired($);
    await LoginNotRememberedScreen().checkTextAlertDialogMessage($, 'Usuário ou senha inválidos');
  });
}
