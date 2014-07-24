part of unit.test;

 class UserInCity {
    final City _city;
    final User _user;

    UserInCity(this._city,this._user);

    @VObject(message: const L10N("getcity","City must be valid"))
    City getCity() {
        return _city;
    }

    @VObject(message: const L10N("getuser","User must be valid"))
    User getUser() {
        return _user;
    }
}

 class AreayCodes {
    final List<String> _codes = new List<String>();

    @NotEmpty(message: const L10N("getcodes","List must not be empty"))
    List<String> getCodes() {
        return _codes;
    }
}

 class City {
    final String zip;
    final String name;


    City(this.zip, this.name);

    @NotEmpty(message: const L10N("getzip","ZIP-Code must not be empty"))
    String getZip() {
        return zip;
    }

    @NotEmpty(message: const L10N("getname","Cityname must not be empty"))
    String getName() {
        return name;
    }
}

 abstract class Person {
    final int age;

    Person(this.age);

    @Range(start: 5,end: 99, message: const L10N("getage", "Age must be between 5 and 99 years"))
    int getAge() {
        return age;
    }
}

 class User extends Person {
    @Uuid(message: const L10N("userid", "UserID must be a UUID"))
    String userID;

    @NotEmpty(message: const L10N("name", "Name must not be empty"))
    @MinLenght(4, message: const L10N("name", "Name lenght must be at least 4 characters..."))
    final String name;

    final String eMail;

    User(this.name,this.eMail) : super(33), userID = "135ea20d-f57b-4960-b544-ceafde88d9b8";
    User.withAge(final int age,this.name,this.eMail) : super(age), userID = "135ea20d-f57b-4960-b544-ceafde88d9b8";
    User.withUUID(this.name,this.eMail,this.userID) : super(33);

    String getName() {
        return name;
    }

    @EMail(message: const L10N("userid", "{{value}} is not a valid eMail address"))
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