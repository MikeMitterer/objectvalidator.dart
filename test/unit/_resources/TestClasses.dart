library unit.test.resources;

import 'package:objectvalidator/objectvalidator.dart';
import 'package:l10n/l10n.dart';

@validator
class UserInCity {
    final City _city;
    final User _user;

    UserInCity(this._city, this._user);

    @VObject(message: const L10N("City must be valid"))
    City getCity() {
        return _city;
    }

    @VObject(message: const L10N("User must be valid"))
    User getUser() {
        return _user;
    }
}

@validator
class AreayCodes {
    final List<String> _codes = new List<String>();

    @NotEmptyAndNotNull(message: const L10N("List must not be empty"))
    List<String> getCodes() {
        return _codes;
    }
}

@validator
class City {
    final String zip;
    final String name;

    City(this.zip, this.name);

    @NotEmptyAndNotNull(message: const L10N("ZIP-Code must not be empty"))
    String getZip() {
        return zip;
    }

    @NotEmptyAndNotNull(message: const L10N("Cityname must not be empty"))
    String getName() {
        return name;
    }
}

@validator
abstract class Person {
    final int age;

    Person(this.age);

    @Range(start: 5.0, end: 99.0, message: const L10N("Age must be between 5 and 99 years"))
    int getAge() {
        return age;
    }
}

@validator
class AnotherPerson {
    final int _age;

    AnotherPerson(this._age);

    @Range(start: 15.0, end: 55.0, message: const L10N("Age must be between 15 and 55 years"))
    int get age => _age;
}


@validator
class User extends Person {
    @Uuid(message: const L10N("UserID must be a UUID"))
    String userID;

    @NotEmptyAndNotNull(message: const L10N("Name must not be empty"))
    @MinLength(4, message: const L10N("Name lenght must be at least 4 characters..."))
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

    @EMail(message: const L10N("{{value}} is not a valid eMail address"))
    String getEmail() {
        return eMail;
    }

    String getUserID() {
        return userID;
    }

//        @Override
//        @Range(start = 5, end = 99, message = "Age must be between 5 and 99 years")
//        int getAge() {
//            return super.getAge();
//        }
}

@validator
class Name {

    Name(this.firstname);

    @NotEmptyAndNotNull(message: const L10N("Firstname must not be {{what}}", const { "what": "EMPTY"}))
    @MinLength(4, message: const L10N("Firstname ({{value}}) must be at least 4 characters long"))
    final String firstname;

    @MinLength(4, message: const L10N(
        "{{field}} must be at least {{value.to.check.against}} chars long but was only {{value.length}} characters long"))
    String get name => firstname;
}

@validator
class Name2 extends Name {
    Name2(final String name) : super(name);
}

@validator
class Name3 extends Name2 {
    Name3(final String name) : super(name);

    @MinLength(3, message: const L10N(
        "{{field}} must be at least {{value.to.check.against}} chars long but was only {{value.length}} characters long"))
    String get name => firstname;
}

@validator
class UsernamePassword {

    @EMail(message: const L10N("{{value}} is not a valid eMail address"))
    final String username;

    @Password(message: const L10N("{{value}} is not a valid password"))
    final String password;

    UsernamePassword(this.username, this.password);
}