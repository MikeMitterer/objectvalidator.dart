import 'dart:html' as dom;

import 'package:console_log_handler/console_log_handler.dart';
import 'package:l10n/l10n.dart';
import 'package:logging/logging.dart';

import 'package:mdl/mdl.dart';
import 'package:beanvalidator/beanvalidator.dart';

@beanreflector
class UsernamePassword {

    @EMail(message: const L10N( "{{value}} is not a valid eMail address"))
    final String username;

    @Password(message: const L10N( "{{value}} is not a valid password"))
    final String password;

    UsernamePassword(this.username, this.password);
}

main() async {
    final Logger _logger = new Logger('validate.main');
    configLogging();

    registerMdl();
    await componentFactory().run();

    void _bindSignals() {
        final MaterialButton button = MaterialButton.widget(dom.querySelector("#validate-pattern"));
        button.onClick.listen((_) {

            final UsernamePassword userpassword = new UsernamePassword("office@mikemitterer.at", "12345678aA#");
            final BeanValidator<UsernamePassword> beanValidator = new BeanValidator<UsernamePassword>();
            final List<ViolationInfo> violationinfos = beanValidator.validate(userpassword);

            _logger.info("Violoations: ${violationinfos.join(", ")}");


        });
    }

    _bindSignals();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}

