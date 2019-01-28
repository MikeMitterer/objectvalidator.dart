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

    group('ObjectValidator', () {
        setUp(() {
        });

        test('> Name should be valid', () {
            final Name name = new Name("Mike");
            expect(() => name.validate(), isNot(throwsException));
        }); // end of 'Name should be valid' test

        test('> empty Name throws Exception', () {
            final violations = List<String>();
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
            final violations = List<String>();
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
            final violations = List<String>();
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
            final AnotherPerson person = AnotherPerson(55);
            expect(() => person.validate(), isNot(throwsException));
        }); // end of 'AnotherPerson' test

        test('> AnotherPerson must be between 15 and 55 years old and fails', () {
            final AnotherPerson person = AnotherPerson(99);
            expect(() => person.validate(), throwsException);

            final violations = List<String>();
            try {
                person.validate();
            } on ViolationException catch(e) {
                violations.addAll(e.violations);
            }

            expect(violations.length, 1);
            expect(violations.first, "Age must be between 15 and 55 but was 99!");
        }); // end of 'AnotherPerson' test

        test('> Valid AreaCodes object should throw now exception', () {
            final areacodes = new AreaCodes(codes: <String>["ab", "cd"]);
            expect(() => areacodes.validate(), isNot(throwsException));
        }); // end of 'Valid AreaCodes object should throw now exception' test

        test('> AreaCodes has no codes - should throw Exception', () {
            final areacodes = new AreaCodes();
            expect(() => areacodes.validate(), throwsException);
        }); // end of 'Empty List' test

//        test('> MinLength', () {
//            final User user = new User("Joe", "joe@test.com");
//
//            final ObjectValidator<User> beanValidator = new ObjectValidator<User>();
//            final List<ViolationInfo> violationinfos = beanValidator.validate(user);
//
//            expect(violationinfos.length,1);
//            expect(violationinfos[0].message,"Name lenght must be at least 4 characters...");
//        }); // end of 'MinLength' test

//        test('> Age in abstract BaseClass', () {
//            final User user = new User.withAge(3,"Mike", "joe@test.com");
//
//            final ObjectValidator<User> beanValidator = new ObjectValidator<User>();
//            final List<ViolationInfo> violationinfos = beanValidator.validate(user);
//
//            expect(violationinfos.length,1);
//            expect(violationinfos[0].message,"Age must be between 5 and 99 years");
//
//        }); // end of 'Age in abstract BaseClass' test

//        test('> City', () {
//            final City city = new City("",null);
//            final ObjectValidator<City> beanValidator = new ObjectValidator<City>();
//            final List<ViolationInfo> violationinfos = beanValidator.validate(city);
//
//            expect(violationinfos.length,2);
//        }); // end of 'City' test

//        test('> User in City', () {
//            final UserInCity userInCity = new UserInCity(
//                new City("6363", "Westendorf"),
//                new User("Joe", "office@mikemitterer.at")
//            );
//
//            final ObjectValidator<UserInCity> beanValidator = new ObjectValidator<UserInCity>();
//            final List<ViolationInfo> violationinfos = beanValidator.validate(userInCity);
//
//            violationinfos.forEach((final ViolationInfo info) {
//               _logger.info("${info.rootBean.runtimeType} -> ${info.message}");
//            });
//            expect(violationinfos.length,1);
//            expect(violationinfos[0].message,"Name lenght must be at least 4 characters...");
//
//            //_debugViolationInfo(violationinfos);
//        }); // end of 'User in City' test

//        test('> UserInCityWith null', () {
//            final UserInCity userInCity = new UserInCity(null, new User("Mike", "office@mikemitterer.at"));
//
//            final ObjectValidator<UserInCity> beanValidator = new ObjectValidator<UserInCity>();
//            final List<ViolationInfo> violationinfos = beanValidator.validate(userInCity);
//
//            expect(violationinfos.length,1);
//            expect(violationinfos[0].message,"City must be valid");
//        }); // end of 'UserInCityWith null' test

//        test('> User in City with null and wrong Name', () {
//            final UserInCity userInCity = new UserInCity(null, new User("Joe", "office@mikemitterer.at"));
//
//            final ObjectValidator<UserInCity> beanValidator = new ObjectValidator<UserInCity>();
//            final List<ViolationInfo> violationinfos = beanValidator.validate(userInCity);
//
//            expect(violationinfos.length,2);
//            expect(violationinfos[0].message,"City must be valid");
//            expect(violationinfos[1].message,"Name lenght must be at least 4 characters...");
//        }); // end of 'User in City with null and wrong Name' test

//        test('> UUID', () {
//            final User user = new User.withUUID("Mike", "joe@test.com","123");
//
//            final ObjectValidator<User> beanValidator = new ObjectValidator<User>();
//            final List<ViolationInfo> violationinfos = beanValidator.validate(user);
//
//            expect(violationinfos.length,1);
//            expect(violationinfos[0].message,"UserID must be a UUID");
//
//        }); // end of 'UUID' test

//        test('> Password', () {
//            final UsernamePassword userpassword = new UsernamePassword("joe@test.com", "12345678aA%");
//            final UsernamePassword invalidUP = new UsernamePassword("joe@test.com", "12345678aA");
//
//            final ObjectValidator<UsernamePassword> beanValidator = new ObjectValidator<UsernamePassword>();
//            final List<ViolationInfo> violationinfos = beanValidator.validate(userpassword);
//
//            expect(violationinfos.length,0);
//
//            final List<ViolationInfo> violationinfos2 = beanValidator.validate(invalidUP);
//            expect(violationinfos2.length,1);
//            expect(violationinfos2[0].message,"12345678aA is not a valid password");
//
//        }); // end of 'UUID' test
    });
    // end 'BeanValidator' group

//    group('Exception', () {
//        test('> ViolationException', () {
//
//            final Name name = new Name("Mike");
//            final ObjectValidator<Name> bv = new ObjectValidator<Name>();
//
//            expect(() => bv.verify(name),isNot(throwsException));
//
//            final Name invalidName = new Name("");
//            expect(() => bv.verify(invalidName),throwsException);
//
//        }); // end of 'ViolationException' test
//
//    }); // End of 'Exception' group

}
