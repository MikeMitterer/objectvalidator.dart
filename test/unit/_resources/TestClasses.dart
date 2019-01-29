library unit.test.resources;

import 'package:objectvalidator/objectvalidator.dart';
import 'package:objectvalidator/validators.dart';

import 'package:l10n/l10n.dart';

class UserInCity implements Verifiable<UserInCity> {
    final City _city;
    final User _user;

    UserInCity(this._city, this._user);

    // @VObject(message: const L10N("City must be valid"))
    City getCity() {
        return _city;
    }

    // @VObject(message: const L10N("User must be valid"))
    User getUser() {
        return _user;
    }

    @override
    void validate(
        { void Function(final UserInCity obj, final ObjectValidator ov) ifInvalid = throwViolationException }) {

        final ov = ObjectValidator();

        ov.verify(getCity(), IsValid(onError: (final IsValid isValid)
            => (final invalidObj) => l10n("City-Verification failed with: '${isValid.violations.join(", ")}'")));

        ov.verify(getUser(), IsValid(onError: (final IsValid isValid)
            => (final invalidObj) => l10n("User-Verification failed with: '${isValid.violations.join(", ")}'")));

        ifInvalid(this,ov);
    }
}

class AreaCodes implements Verifiable<AreaCodes> {
    final List<String> _codes;

    AreaCodes({final List<String> codes = const <String>[]}) : _codes = codes;

    // @NotEmptyAndNotNull(message: const L10N("List must not be empty"))
    List<String> getCodes() {
        return _codes;
    }

    @override
    void validate({ifInvalid = throwViolationException}) {
        final ov = ObjectValidator();

        ov.verify(getCodes(), isNotEmpty);
        ifInvalid(this,ov);
    }
}

class City implements Verifiable<City> {
    final String zip;
    final String name;

    City(this.zip, this.name);

    // @NotEmptyAndNotNull(message: const L10N("ZIP-Code must not be empty"))
    String getZip() {
        return zip;
    }

    // @NotEmptyAndNotNull(message: const L10N("Cityname must not be empty"))
    String getName() {
        return name;
    }

    @override
    void validate({ifInvalid = throwViolationException}) {
        final ov = ObjectValidator();

        ov.verify(getZip(), isNotEmpty);
        ov.verify(getName(), isNotEmpty);

        ifInvalid(this,ov);
    }
}

abstract class Person {
    final int age;

    Person(this.age);

    // @Range(start: 5.0, end: 99.0, message: const L10N("Age must be between 5 and 99 years"))
    int getAge() {
        return age;
    }
}

class AnotherPerson implements Verifiable<AnotherPerson> {
    final int _age;

    AnotherPerson(this._age);

    // @Range(start: 15.0, end: 55.0, message: const L10N("Age must be between 15 and 55 years"))
    int get age => _age;

    @override
    void validate({ifInvalid = throwViolationException}) => isAnotherPersonValid(this, ifInvalid: ifInvalid);
}

void isAnotherPersonValid<T>(final AnotherPerson ap,
    { void Function(final AnotherPerson obj,final ObjectValidator ov) ifInvalid = throwViolationException }) {

    final ov = ObjectValidator();

    ov.verify(ap.age, Range(15, 55, onError: (final Range range)
        => (final invalidValue)
            => l10n("Age must be between ${range.start} and ${range.end} but was ${invalidValue.toString()}!")));

    ifInvalid(ap,ov);
}

class User extends Person implements Verifiable<User> {
    // @Uuid(message: const L10N("UserID must be a UUID"))
    String userID;

    // @NotEmptyAndNotNull(message: const L10N("Name must not be empty"))
    // @MinLength(4, message: const L10N("Name lenght must be at least 4 characters..."))
    final String name;

    final String eMail;

    User(this.name, this.eMail)
        : userID = "135ea20d-f57b-4960-b544-ceafde88d9b8",
            super(33);

    User.withAge(final int age, this.name, this.eMail)
        : userID = "135ea20d-f57b-4960-b544-ceafde88d9b8",
            super(age);

    User.withUUID(this.name, this.eMail, this.userID) : super(33);

    String getName() {
        return name;
    }

    // @EMail(message: const L10N("{{value}} is not a valid eMail address"))
    String getEmail() {
        return eMail;
    }

    String getUserID() {
        return userID;
    }

    @override
    void validate({ifInvalid = throwViolationException}) {
        final ov = ObjectValidator();
        
        ov.verify(getAge(), Range(5, 99,
            onError: (final Range range) => (final invalidValue)
                    => l10n("Age must be between ${range.start} and ${range.end} years "
                       " but was $invalidValue")));

        ov.verifyAll(name, [ isNotEmpty, MinLength(4,
            onError: (final MinLength minLength) => (final invalidValue)
                => l10n("The name '${invalidValue.toString()}' must have a "
                   "minimum lenght of ${minLength.minLength} characters!")) ]);

        ov.verify(getEmail(), isEMail);
        ov.verify(getUserID(), isUuid);

        ifInvalid(this,ov);
    }
}

class Name implements Verifiable<Name> {
    Name(this.firstname);

    // @NotEmptyAndNotNull(
    //    message: const L10N("Firstname must not be {{what}}", const {"what": "EMPTY"}))
    // @MinLength(4, message: const L10N("Firstname ({{value}}) must be at least 4 characters long"))
    final String firstname;

    // @MinLength(4,
    //    message: const L10N(
    //        "{{field}} must be at least {{value.to.check.against}} chars long but was only {{value.length}} characters long"))
    String get name => firstname;

    @override
    void validate({ifInvalid = throwViolationException}) {
        final ov = ObjectValidator();

        List<Validator> _forField(final String name) {
            return <Validator>[
                NotEmpty(onError: (final NotEmpty ne)
                => (final invalidValue) => l10n("'$name' must not be empty!")),

                MinLength(4, onError: (final MinLength ml)
                => (final invalidValue) => l10n("'$name' ('${invalidValue.toString()}')"
                    " must be at least 4 characters long!"))
            ];
        }
        ov.verifyAll(firstname, _forField("firstname"));
        ov.verifyAll(name, _forField("name"));

        ifInvalid(this,ov);

    }
}

class Name2 extends Name {
    Name2(final String name) : super(name);
}

class UsernamePassword implements Verifiable<UsernamePassword>{
    // @EMail(message: const L10N("{{value}} is not a valid eMail address"))
    final String username;

    // @Password(message: const L10N("{{value}} is not a valid password"))
    final String password;

    UsernamePassword(this.username, this.password);

  @override
  void validate({ifInvalid = throwViolationException}) {
      final ov = ObjectValidator();

      ov.verify(username, isEMail);
      ov.verify(password, isPassword);

      ifInvalid(this,ov);
  }
}

class MyName implements Verifiable<MyName> {
    final int age;

    MyName(this.age);

    @override
    void validate({ifInvalid = throwViolationException}) {
        final ov = ObjectValidator();

        ov.verify(age, isInRangeBetween10And40);

        ifInvalid(this,ov);
    }

}




