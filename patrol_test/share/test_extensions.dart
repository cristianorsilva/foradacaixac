import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

extension CheckCompareTextResults on String {
  void checkCompareResults(List<String> list) {}
}

extension CheckText on PatrolIntegrationTester {
  void checkTextOnTextWidgets(Set<(Function, String)> setFunctionString) {
    String result = '';

    setFunctionString.forEach((functionString) {
      try {
        functionString.$1.call();
      } on TestFailure catch (testFailure, e) {
        result += testFailure.message ?? '';
        result += 'WidgetKey: ' + functionString.$2.toString();
        result += '\n';
        result += '\n';
      }
    });
    if (result.isNotEmpty) fail(result);
  }
}
