// ----------------------------------------------------------------------------
// Start der Tests mit:
//      pub run test -p content-shell test/unit/test.dart
//

@TestOn("content-shell")

library unit.test;

import 'package:test/test.dart';

//---------------------------------------------------------
// Extra packages (piepag) (http_utils, validate, signer)
//---------------------------------------------------------
import 'package:l10n/l10n.dart';

//-----------------------------------------------------------------------------
// Logging

import 'package:logging/logging.dart';
import 'package:logging_handlers/logging_handlers_shared.dart';

//---------------------------------------------------------
// Testimports (nur bei Unit-Tests)
//

import 'package:beanvalidator/beanvalidator.dart';

part '_resources/TestClasses.dart';

part 'constraints/Matcher_test.dart';
part 'constraints/Constraints_test.dart';

part 'beanvalidator/BeanValidator_test.dart';

//-----------------------------------------------------------------------------
// Test-Imports (find . -mindepth 2 -iname "*.dart" | sed "s/\.\///g" | sed "s/\(.*\)/part '\1';/g")


// Mehr Infos: http://www.dartlang.org/articles/dart-unit-tests/
void main() {
    final Logger logger = new Logger("test");

    configLogging();

    testMatchers();
    testConstraints();
    testBeanValidator();
}

// Weitere Infos: https://github.com/chrisbu/logging_handlers#quick-reference

void configLogging() {
    //hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler());
}
