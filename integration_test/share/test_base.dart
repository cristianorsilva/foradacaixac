import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:patrol/patrol.dart';
import '../share/test_constants.dart' as constants;

Function checkTextFromWidget2(PatrolIntegrationTester $, Symbol widgetKey, String expectedText) {
  return () {
    String? data = $(widgetKey).last.text;
    expect(data, expectedText);
  };
}

(Function, String) checkTextFromWidget(PatrolIntegrationTester $, String widgetKey, String expectedText, [int subStringLength = 0, bool getLast = true]) {
  return (
    () {
      String? data;
      if (getLast) {
        data = $(Symbol(widgetKey)).last.text;
      } else {
        data = $(Symbol(widgetKey)).first.text;
      }
      if (subStringLength > 0) {
        expect(data?.substring(0, subStringLength), expectedText);
      } else {
        expect(data, expectedText);
      }
    },
    widgetKey
  );
}

// As duas funções abaixo não são utilizadas ate o momento no projeto com automação Patrol
/*
Future<void> takeScreenshot(
    WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String dirFeature, String dirDateHour, String dirTestName) async {
  DateFormat formatter = DateFormat('HH:mm:ss:SSSS');
  String screenshotName = formatter.format(DateTime.now()).replaceAll(":", "_");

  await tester.pumpAndSettle();
  await binding.takeScreenshot('${constants.mainDirectory}$dirFeature$dirDateHour$dirTestName$screenshotName');
}

String defineDirectoryDateHour() {
  DateFormat formatter;
  formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
  String dirDateHour = "${formatter.format(DateTime.now()).replaceAll("/", "_").replaceAll(" ", "_").replaceAll(":", "_")}/";
  return dirDateHour;
}
*/