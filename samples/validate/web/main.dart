import 'dart:html' as dom;

import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import 'package:mdl/mdl.dart';
import 'package:beanvalidator/beanvalidator.dart';

@beanreflector
class UsernamePassword {

    @EMail(message: const L10N( "{{value}} is not a valid eMail address"))
    String username;

    @Password(message: const L10N( "{{value}} is not a valid password"))
    final String password;

    UsernamePassword(this.username, this.password);
}

main() async {

    registerMdl();
    await componentFactory().run();

    void _bindSignals() {
        final MaterialButton button = MaterialButton.widget(dom.querySelector("#validate-pattern"));

        button.onClick.listen((_) {

            final UsernamePassword userpassword = new UsernamePassword("office@mikemitterer.at", "12345678aA#");
            final BeanValidator<UsernamePassword> beanValidator = new BeanValidator<UsernamePassword>();

            List<ViolationInfo> violationinfos = beanValidator.validate(userpassword);

            log("Violoations I: ${violationinfos.length == 0 ? 'no violations'
                : throw 'Pfhuuu - sollte nicht kommen!'}");

            userpassword.username = "test";
            violationinfos = beanValidator.validate(userpassword);

            log("Violoations II: ${violationinfos.first.l10n.message}");
        });
    }

    _bindSignals();
}

dom.Element _output;
void log(final message,[ final List additionalParams ]) {
    final now = new DateTime.now();

    final time = new dom.SpanElement()
        ..text = "${new DateFormat("HH:mm:ss").format(now)}.${now.millisecond}";

    final text = new dom.SpanElement()
        ..text = message.toString();

    final line = new dom.LIElement()
        ..append(time)
        ..append(text)
    ;
    if(additionalParams != null) {
        final ul = new dom.UListElement();
        additionalParams.forEach((final element) {
            final li = new dom.LIElement()..text = element.toString();
            ul.append(li);
        });
        line.append(ul);
    }

    (_output ??= dom.querySelector('#log')).append(line);
}

