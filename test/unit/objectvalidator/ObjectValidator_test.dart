import 'package:test/test.dart';

//import 'package:reflectable/reflectable.dart';
import 'package:logging/logging.dart';
//import 'package:console_log_handler/print_log_handler.dart';
//import 'package:console_log_handler/console_log_handler.dart';

import 'package:objectvalidator/objectvalidator.dart';
import '../_resources/TestClasses.dart';

main() {
    final Logger _logger = new Logger("unit.test.BeanValidator");
    //configLogging(show: Level.FINE);

    // void _debugViolationInfo(final List<ViolationInfo> violationinfos) {
    //     violationinfos.forEach((final ViolationInfo info) {
    //         _logger.shout(info.message);
    //     });
    // }

    final violations = List<String>();

    group('ObjectValidator', () {
        setUp(() {
            violations.clear();
        });

        test('> Name should be valid', () {
            final Name name = new Name("Mike");
            expect(() => name.validate(), isNot(throwsException));
        }); // end of 'Name should be valid' test

        test('> empty Name throws Exception', () {
            try {
                final Name invalidName = new Name("");
                invalidName.validate();
            } on ViolationException catch(e) {
                violations.addAll(e.violations);
            }
            expect(violations, isNotEmpty);
            expect(violations.length, 4);

            expect(violations.first, "'firstname' must not be empty!");
            expect(violations[1], "'firstname' ('') must be at least 4 characters long!");
            expect(violations[2], "'name' must not be empty!");
            expect(violations[3], "'name' ('') must be at least 4 characters long!");
        });

        test('> Short Name throws Exception', () {
            try {
                final Name invalidName = new Name("abc");
                invalidName.validate();
            } on ViolationException catch(e) {
                violations.addAll(e.violations);
            }
            expect(violations, isNotEmpty);
            expect(violations.length, 2);

            expect(violations[0], "'firstname' ('abc') must be at least 4 characters long!");
            expect(violations[1], "'name' ('abc') must be at least 4 characters long!");
        });

        test('> Short Name2 inherits from Name and throws Exception', () {
            try {
                final Name invalidName = new Name2("abc");
                invalidName.validate();
            } on ViolationException catch(e) {
                violations.addAll(e.violations);
            }
            expect(violations, isNotEmpty);
            expect(violations.length, 2);

            expect(violations[0], "'firstname' ('abc') must be at least 4 characters long!");
            expect(violations[1], "'name' ('abc') must be at least 4 characters long!");
        });

        test('> AnotherPerson should be between 15 and 55 years old', () {
            final person = AnotherPerson(55);
            expect(() => person.validate(), isNot(throwsException));
        });

        test('> AnotherPerson must be between 15 and 55 years old and fails', () {
            final person = AnotherPerson(99);
            expect(() => person.validate(), throwsException);

            try {
                person.validate();
            } on ViolationException catch(e) {
                violations.addAll(e.violations);
            }

            expect(violations.length, 1);
            expect(violations.first, "Age must be between 15 and 55 but was 99!");
        });

        test('> AnotherPerson - check with onError instead of Exception', () {
            final person = AnotherPerson(99);

            person.validate(ifInvalid: (final AnotherPerson ap, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            expect(violations.length, 1);
            expect(violations.first, "Age must be between 15 and 55 but was 99!");
        });

        test('> AnotherPerson - check with global function', () {
            final person = AnotherPerson(99);

            isAnotherPersonValid(person,ifInvalid: (final AnotherPerson ap, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            expect(violations.length, 1);
            expect(violations.first, "Age must be between 15 and 55 but was 99!");
        });


        test('> Valid AreaCodes object should throw no exception', () {
            final areacodes = new AreaCodes(codes: <String>["ab", "cd"]);
            expect(() => areacodes.validate(), isNot(throwsException));
        });

        test('> AreaCodes has no codes - should throw Exception', () {
            final areacodes = new AreaCodes();
            expect(() => areacodes.validate(), throwsException);
        });

        test('> MinLength', () {
            final user = new User("Joe", "joe@test.com");

            user.validate(ifInvalid: (final User user, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            expect(violations.length,1);
            expect(violations[0],"The name 'Joe' must have a minimum lenght of 4 characters!");
        }); // end of 'MinLength' test

        test('> Age must be between 5 and 99 years', () {
            final user = User.withAge(3,"Mike", "joe@test.com");

            user.validate(ifInvalid: (final User user, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            expect(violations.length,1);
            expect(violations[0],"Age must be between 5 and 99 years but was 3");

        }); // end of 'Age in abstract BaseClass' test

        test('> City without zip and name should be invalid', () {
            final city = City("",null);

            city.validate(ifInvalid: (final City user, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            expect(violations.length,2);
        }); // end of 'City' test

        test("> User 'Joe' in City - name should be to short", () {
            final userInCity = UserInCity(
                City("6363", "Westendorf"),
                User("Joe", "office@mikemitterer.at")
            );

            userInCity.validate(ifInvalid: (final UserInCity user, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            // violations.forEach((final String info) {
            //   print("UserInCity: $info");
            // });
            expect(violations.length,1);
            expect(violations[0],"User-Verification failed with: 'The name 'Joe' must have a minimum lenght of 4 characters!'");
        }); // end of 'User in City' test

        test('> UserInCityWith null', () {
            final userInCity = UserInCity(null, User("Mike", "office@mikemitterer.at"));

            userInCity.validate(ifInvalid: (final UserInCity user, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            // print(violations[0]);
            
            expect(violations.length,1);
            expect(violations[0],"City-Verification failed with: 'null-object not allowed'");
        }); // end of 'UserInCityWith null' test

        test('> User in City with null and wrong Name', () {
            final UserInCity userInCity = new UserInCity(null, new User("Joe", "office@mikemitterer.at"));

            userInCity.validate(ifInvalid: (final UserInCity user, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            // print(violations);

            expect(violations.length,2);
            expect(violations[0],"City-Verification failed with: 'null-object not allowed'");
            expect(violations[1],"User-Verification failed with: 'The name 'Joe' must have a minimum lenght of 4 characters!'");
        }); // end of 'User in City with null and wrong Name' test

        test('> UUID', () {
            final User user = User.withUUID("Mike", "joe@test.com","123");

            user.validate(ifInvalid: (final User user, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            expect(violations.length,1);
            expect(violations[0],"123 is not a valid UUID!");

        }); // end of 'UUID' test

        test('> Valid password', () {
            final up = UsernamePassword("joe@test.com", "12345678aA%");

            up.validate(ifInvalid: (final UsernamePassword up, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            expect(violations.length,0);
        });

        test('> Invalid password', () {
            final up = UsernamePassword("joe@test.com", "12345678aA");

            up.validate(ifInvalid: (final UsernamePassword up, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            expect(violations.length,1);
            expect(violations.first, "12345678aA is not a valid password!");
        });
    });
    // end 'BeanValidator' group
}
