import 'package:test/test.dart';
import 'package:logging/logging.dart';

import 'package:objectvalidator/objectvalidator.dart';
import 'package:objectvalidator/validators.dart' as v;

import '../_resources/TestClasses.dart';

main() {
    final Logger _logger = new Logger("test.Matchers");
    //configLogging(show: Level.FINE);

    group('Matchers', () {

        group('> Range', () {

            test('> in Range', () {
                expect(v.isInRangeBetween10And40.isValid(20), isTrue);
                expect(v.isInRange(-50.0, 50.0).isValid(-50.0) , isTrue );
            }); // end of 'Range' test

            test('> Not in Range', () {
                expect(v.Range(-10.0, 40.0).isValid(-10.1), isFalse);
                expect(v.isInRange(-50.0, 50.0).isValid(-50.1), isFalse);
            });
            // end of 'Not in Range' test

        }); // End of 'Range' group

        group('> NotNull', () {

            test('> NotNull', () {
                expect(v.NotNull().isValid("Hallo"), isTrue);
                expect(v.NotNull().isValid(0), isTrue);
            }); // end of 'NotNull' test

            test('> Null', () {
                expect(v.NotNull().isValid(null), isFalse);
            });
            // end of 'Null' test

        }); // End of '> NotNull' group


        group('> eMail', () {

            test('> Valid eMail', () {
                expect(v.EMail().isValid("office@mikemitterer.at"), isTrue);
                expect(v.isEMail.isValid("office@mikemitterer.at"), isTrue);
            }); // end of 'Valid eMail' test

            test('> Invalid eMail', () {
                expect(v.EMail().isValid("office@mikemitterer.localhostx"), isFalse);
                expect(v.isEMail.isValid("office-mikemitterer.at"), isFalse);
            });
            // end of 'Invalid eMail' test

        });
        // End of '> eMail' group

        group('> Uuid', () {
            final String v4UUID = "eab27287-508f-42f1-9d69-f2d911a5154c";

            test('> Valid UUID', () {
                expect(v.Uuid().isValid(v4UUID), isTrue);
                expect(v.isUuid.isValid(v4UUID), isTrue);
            }); // end of 'Valid UUID' test

            test('> Invalid UUID', () {
                expect(v.Uuid().isValid("Hallo"), isFalse);
                expect(v.isUuid.isValid(null), isFalse);
            });
            // end of 'Invalid UUID' test

        });
        // End of '> Uuid' group

        group('> Password', () {
            final String password = "12345678aB#";
            final String invalidPassword = "0123456789abcdefgB0123456789abcdefgB#";

            test('> Valid Password', () {
                expect(v.Password().isValid(password), isTrue);
                expect(v.isPassword.isValid(password), isTrue);
                expect(v.isPassword.isValid("12345678aB?"), isTrue);
            }); // end of 'Valid UUID' test

            test('> Invalid Password', () {
                expect(v.Password().isValid("Hallo"), isFalse);
                expect(v.isPassword.isValid(null), isFalse);
                expect(v.isPassword.isValid("12345678aB# a") , isFalse);
                expect(v.isPassword.isValid("12345678aB# "), isFalse);
                expect(v.isPassword.isValid("12345678aB;"), isFalse);
                expect(v.isPassword.isValid(invalidPassword), isFalse);
            });
            // end of 'Invalid UUID' test

        });
        // End of '> Password' group

        group('> NotEmptyAndNotNull', () {

            test('> NotEmptyAndNotNull', () {
                expect(v.NotEmpty().isValid("Hallo"), isTrue);
                expect(v.isNotEmpty.isValid("Hallo"), isTrue);
                expect(v.isNotEmpty.isValid(10), isTrue);
            }); // end of 'NotEmpty' test

            test('> NotEmptyAndNotNullWithList', () {
                expect(v.NotEmpty().isValid(List<String>()..add("Test")), isTrue);
            }); // end of 'NotEmptyWithList' test

            test('> Empty', () {
                expect(v.isNotEmpty.isValid(""), isFalse);
                expect(v.isNotEmpty.isValid(null), isFalse);
                expect(v.isNotEmpty.isValid(List<String>()), isFalse);
            }); // end of 'Empty' test

        });
        // End of '> NotEmpty' group

        group('> MinLength', () {

            test('> Valid', () {
                expect(v.MinLength(2).isValid([ "Hallo", "Test" ]), isTrue);
            });

            test('> Invalid', () {
                expect(v.MinLength(3).isValid([ "Hallo", "Test" ]), isFalse);
            }); // end of 'Invalid' test


        });
        // End of '> MinLength' group

        group('> Is Positive', () {
            test('> Valid', () {
                expect(v.IsPositive().isValid(1), isTrue);
                expect(v.IsPositive().isValid(5.55), isTrue);
                expect(v.IsPositive().isValid(int.parse("27")), isTrue);
                expect(v.IsPositive().isValid(double.parse("42.5")), isTrue);
            }); // end of 'Valid' test

            test('> Invalue', () {
                expect(v.isPositive.isValid(0),isFalse);
                expect(v.isPositive.isValid(-5.6),isFalse);

            }); // end of 'Invalue' test

        }); // End of '> Is Positive' group

        group('> Check without reflection', () {
            
            test('> _defaultErrorMessage', () {
                final ov = ObjectValidator();

                ov.verify(1, v.Range(5, 10));

                expect(ov.isValid, false);
                expect(ov.violations.first, "Range must be between 5 and 10 but was 1");
            }); // end of '_defaultErrorMessage' test

            test('> isInRange between 10 and 40 should be false', () {
                final ov = ObjectValidator();

                ov.verify(1, v.isInRangeBetween10And40);

                expect(ov.isValid, false);
                expect(ov.violations.first, "Range must be between 10 and 40");
            }); // end of 'isInRange' test

            test('> isInRange between 10 and 40 should be true', () {
                final ov = ObjectValidator();
                ov.verify(10, v.isInRangeBetween10And40);
                expect(ov.isValid, true);
            }); // end of 'isInRange' test

            test('> isInRange fails with custom message', () {
                final ov = ObjectValidator();

                ov.verify(4, v.isInRange(5, 10, onError: (final v.Range rx)
                    => (dynamic invalidValue) => "My custom message $invalidValue - ${rx.start}"));

                expect(ov.isValid, false);
                expect(ov.violations.first, "My custom message 4 - 5");

            }); // end of 'isInRange with custom message' test

            test('> MyName with valid age', () {
                final name = MyName(25);
                expect(() => name.validate(), isNot(throwsException));
            }); // end of 'MyName with valid age' test

            test('> MyName with wrong age', () {
                final name = MyName(99);
                expect(() => name.validate(), throwsException);

                bool foundException = false;
                try {
                    name.validate();
                } on Exception catch(e) {
                    foundException = true;
                }
                expect(foundException, true);
            }); // end of 'MyName' test

        });
    });
    // End of 'Matchers' group


}
