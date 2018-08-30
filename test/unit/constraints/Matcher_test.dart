import 'package:test/test.dart';
import 'package:logging/logging.dart';
//import 'package:console_log_handler/print_log_handler.dart';
//import 'package:console_log_handler/console_log_handler.dart';

import 'package:l10n/l10n.dart';
import 'package:objectvalidator/objectvalidator.dart';

import 'Matcher_test.reflectable.dart';

main() {
    final Logger _logger = new Logger("test.Matchers");
    //configLogging(show: Level.FINE);

    initializeReflectable();

    group('Matchers', () {

        group('> Range', () {

            test('> in Range', () {
                expect(20.0, isInRangeBetween10And40);
                expect(-50.0, isInRange(-50.0, 50.0));
            }); // end of 'Range' test

            test('> Not in Range', () {
                expect(-10.1, isNot(new Range(start: -10.0, end: 40.0, message: l10n("Hier nicht notwendig"))));
                expect(-50.1, isNot(isInRange(-50.0, 50.0)));
            });
            // end of 'Not in Range' test

        }); // End of 'Range' group

        group('> NotNull', () {

            test('> NotNull', () {
                expect("Hallo", new NotNull(message: l10n("Hier nicht notwendig")));
                expect(0, new NotNull(message: l10n("Hier nicht notwendig")));
            }); // end of 'NotNull' test

            test('> Null', () {
                expect(null, isNot(new NotNull(message: l10n("Hier nicht notwendig"))));
            });
            // end of 'Null' test

        }); // End of '> NotNull' group


        group('> eMail', () {

            test('> Valid eMail', () {
                expect("office@mikemitterer.at", new EMail(message: l10n("Hier nicht notwendig")));
                expect("office@mikemitterer.at", isEMail);
            }); // end of 'Valid eMail' test

            test('> Invalid eMail', () {
                expect("office@mikemitterer.localhostx", isNot(new EMail(message: l10n("Hier nicht notwendig"))));
                expect("office-mikemitterer.at", isNot(isEMail));
            });
            // end of 'Invalid eMail' test

        });
        // End of '> eMail' group

        group('> Uuid', () {
            final String v4UUID = "eab27287-508f-42f1-9d69-f2d911a5154c";

            test('> Valid UUID', () {
                expect(v4UUID, new Uuid(message: l10n("Hier nicht notwendig")));
                expect(v4UUID, isUuid);
            }); // end of 'Valid UUID' test

            test('> Invalid UUID', () {
                expect("Hallo", isNot(new Uuid(message: l10n("Hier nicht notwendig"))));
                expect(null, isNot(isUuid));
            });
            // end of 'Invalid UUID' test

        });
        // End of '> Uuid' group

        group('> Password', () {
            final String password = "12345678aB#";
            final String invalidPassword = "0123456789abcdefgB0123456789abcdefgB#";

            test('> Valid Password', () {
                expect(password, new Password(message: l10n("Hier nicht notwendig")));
                expect(password, isPassword);
                expect("12345678aB?", isPassword);
            }); // end of 'Valid UUID' test

            test('> Invalid Password', () {
                expect("Hallo", isNot(new Password(message: l10n("Hier nicht notwendig"))));
                expect(null, isNot(isPassword));
                expect("12345678aB# a", isNot(isPassword));
                expect("12345678aB# ", isNot(isPassword));
                expect("12345678aB;", isNot(isPassword));
                expect(invalidPassword, isNot(isPassword));
            });
            // end of 'Invalid UUID' test

        });
        // End of '> Password' group

        group('> NotEmptyAndNotNull', () {

            test('> NotEmptyAndNotNull', () {
                expect("Hallo", new NotEmptyAndNotNull(message: l10n("Hier nicht notwendig")));
                expect("Hallo", isNotEmptyAndNotNull);
            }); // end of 'NotEmpty' test

            test('> NotEmptyAndNotNullWithList', () {
                expect(new List<String>()..add("Test"), new NotEmptyAndNotNull(message: l10n("Hier nicht notwendig")));
            }); // end of 'NotEmptyWithList' test

            test('> Empty', () {
                expect(10, isNot(new NotEmptyAndNotNull(message: l10n("Hier nicht notwendig"))));
                expect("", isNot(new NotEmptyAndNotNull(message: l10n("Hier nicht notwendig"))));
                expect(null, isNot(isNotEmptyAndNotNull));
                expect(new List<String>(), isNot(new NotEmptyAndNotNull(message: l10n("Hier nicht notwendig"))));
            }); // end of 'Empty' test

        });
        // End of '> NotEmpty' group

        group('> VObject', () {
//            final Location location = new Location(20.0,40.0);
//
//            test('> IsValid', () {
//                expect(location, new VObject(message: l10n("no.key","Hier nicht notwendig")));
//                expect(location, isVObjectValid);
//            }); // end of 'IsValid' test

            test('> Invalid', () {
                expect(null, isNot(new VObject(message: l10n("Hier nicht notwendig"))));

                // Sollte (nach der Implementierung von ValidatorBean) nicht auskommentiert sein
                //expect("Hallo", isNot(isVObjectValid));
                //expect(10, isNot(isVObjectValid));
            }); // end of 'Invalid' test

        });
        // End of '> VObject' group

        group('> MinLength', () {

            test('> Valid', () {
                expect([ "Hallo", "Test" ], new MinLength(2,message: l10n("Hier nicht notwendig")));
            });

            test('> Invalid', () {
                expect([ "Hallo", "Test" ], isNot(new MinLength(3,message: l10n("Hier nicht notwendig"))));
            }); // end of 'Invalid' test


        });
        // End of '> MinLength' group

        group('> Is Positive', () {
            test('> Valid', () {
                expect(1,new IsPositive(message: l10n("Hier nicht notwendig")));
                expect(5.55,new IsPositive(message: l10n("Hier nicht notwendig")));
                expect("27",new IsPositive(message: l10n("Hier nicht notwendig")));
                expect("42.5",new IsPositive(message: l10n("Hier nicht notwendig")));
            }); // end of 'Valid' test

            test('> Invalue', () {
                expect(0,isNot(new IsPositive(message: l10n("Hier nicht notwendig"))));
                expect(true,isNot(new IsPositive(message: l10n("Hier nicht notwendig"))));
                expect(false,isNot(new IsPositive(message: l10n("Hier nicht notwendig"))));
                expect("-5",isNot(new IsPositive(message: l10n("Hier nicht notwendig"))));
                expect(-5.6,isNot(new IsPositive(message: l10n("Hier nicht notwendig"))));

            }); // end of 'Invalue' test

        }); // End of '> Is Positive' group
    });
    // End of 'Matchers' group


}
