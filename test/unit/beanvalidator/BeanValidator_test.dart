part of unit.test;

testBeanValidator() {
    final Logger _logger = new Logger("unit.test.BeanValidator");

    void _debugViolationInfo(final List<ViolationInfo> violationinfos) {
        violationinfos.forEach((final ViolationInfo info) {
            _logger.shout(info.message);
        });
    }

    group('BeanValidator', () {
        setUp(() {
        });

        test('> Name - not empty', () {
            final Name name = new Name("Mike");

            final BeanValidator<Name> bv = new BeanValidator<Name>();
            List<ViolationInfo<Name>> violationInfos = bv.validate(name);

            expect(violationInfos.length, 0);

            final Name invalidName = new Name("");
            violationInfos = bv.validate(invalidName);
            expect(violationInfos.length, 3);

            expect(violationInfos[0].message, "Firstname must not be EMPTY");
            expect(violationInfos[1].message, "Firstname () must be at least 4 characters long");

            final Name invalidName2 = new Name("abc");
            violationInfos = bv.validate(invalidName2);
            expect(violationInfos.length, 2);

            expect(violationInfos[0].message, "Firstname (abc) must be at least 4 characters long");
            expect(violationInfos[1].message, "Name must be at least 4 chars long but was only 3 characters long");

        });
        // end of 'Name - not empty' test

       test('> Inheritance', () {
           final Name2 name = new Name2("Mike");

           final BeanValidator<Name2> bv = new BeanValidator<Name2>();
           List<ViolationInfo<Name2>> violationInfos = bv.validate(name);

           expect(violationInfos.length, 0);

           final Name2 invalidName = new Name2("");
           violationInfos = bv.validate(invalidName);

           expect(violationInfos.length, 3);

           expect(violationInfos[0].message, "Firstname must not be EMPTY");
           expect(violationInfos[1].message, "Firstname () must be at least 4 characters long");

           final Name2 invalidName2 = new Name2("abc");
           violationInfos = bv.validate(invalidName2);
           expect(violationInfos.length, 2);

           expect(violationInfos[0].message, "Firstname (abc) must be at least 4 characters long");
           expect(violationInfos[1].message, "Name must be at least 4 chars long but was only 3 characters long");

       }); // end of 'Inheritance' test

        test('> Inheritance and ovwerwrite', () {
            final Name3 name = new Name3("Mike");

            final BeanValidator<Name3> bv = new BeanValidator<Name3>();
            List<ViolationInfo<Name3>> violationInfos = bv.validate(name);

            expect(violationInfos.length, 0);

            final Name3 invalidName = new Name3("");
            violationInfos = bv.validate(invalidName);

            expect(violationInfos.length, 3);

            expect(violationInfos[0].message, "Firstname must not be EMPTY");
            expect(violationInfos[1].message, "Firstname () must be at least 4 characters long");

            final Name3 invalidName2 = new Name3("abc");
            violationInfos = bv.validate(invalidName2);
            expect(violationInfos.length, 1);

            expect(violationInfos[0].message, "Firstname (abc) must be at least 4 characters long");

        }); // end of 'Inheritance and ovwerwrite' test

        test('> Inheritance and ovwerwrite II', () {
            final Name3 invalidName = new Name3("");

            final BeanValidator<Name3> bv = new BeanValidator<Name3>();
            List<ViolationInfo<Name3>> violationInfos = bv.validate(invalidName);

            violationInfos = bv.validate(invalidName);

            expect(violationInfos.length, 3);

            expect(violationInfos[0].message, "Firstname must not be EMPTY");
            expect(violationInfos[1].message, "Firstname () must be at least 4 characters long");

            final Name3 invalidName2 = new Name3("abc");
            violationInfos = bv.validate(invalidName2);
            expect(violationInfos.length, 1);

            expect(violationInfos[0].message, "Firstname (abc) must be at least 4 characters long");

        }); // end of 'Inheritance and ovwerwrite II' test

        test('> Empty List', () {
            final AreayCodes areacodes = new AreayCodes();
            final BeanValidator<AreayCodes> beanvalidator = new BeanValidator<AreayCodes>();

            List<ViolationInfo<AreayCodes>> violationinfos = beanvalidator.validate(areacodes);
            expect(violationinfos.length,1);
            expect(violationinfos[0].message,"List must not be empty");
        }); // end of 'Empty List' test

        test('> MinLength', () {
            final User user = new User("Joe", "joe@test.com");

            final BeanValidator<User> beanValidator = new BeanValidator<User>();
            final List<ViolationInfo<User>> violationinfos = beanValidator.validate(user);

            expect(violationinfos.length,1);
            expect(violationinfos[0].message,"Name lenght must be at least 4 characters...");
        }); // end of 'MinLength' test

        test('> Age in abstract BaseClass', () {
            final User user = new User.withAge(3,"Mike", "joe@test.com");

            final BeanValidator<User> beanValidator = new BeanValidator<User>();
            final List<ViolationInfo<User>> violationinfos = beanValidator.validate(user);

            expect(violationinfos.length,1);
            expect(violationinfos[0].message,"Age must be between 5 and 99 years");

        }); // end of 'Age in abstract BaseClass' test

        test('> City', () {
            final City city = new City("",null);
            final BeanValidator<City> beanValidator = new BeanValidator<City>();
            final List<ViolationInfo<City>> violationinfos = beanValidator.validate(city);

            expect(violationinfos.length,2);
        }); // end of 'City' test

        test('> User in City', () {
            final UserInCity userInCity = new UserInCity(
                new City("6363", "Westendorf"),
                new User("Joe", "office@mikemitterer.at")
            );

            final BeanValidator<UserInCity> beanValidator = new BeanValidator<UserInCity>();
            final List<ViolationInfo<UserInCity>> violationinfos = beanValidator.validate(userInCity);

            violationinfos.forEach((final ViolationInfo info) {
               _logger.info("${info.rootBean.runtimeType} -> ${info.message}");
            });
            expect(violationinfos.length,1);
            expect(violationinfos[0].message,"Name lenght must be at least 4 characters...");

            //_debugViolationInfo(violationinfos);
        }); // end of 'User in City' test

        test('> UserInCityWith null', () {
            final UserInCity userInCity = new UserInCity(null, new User("Mike", "office@mikemitterer.at"));

            final BeanValidator<UserInCity> beanValidator = new BeanValidator<UserInCity>();
            final List<ViolationInfo<UserInCity>> violationinfos = beanValidator.validate(userInCity);

            expect(violationinfos.length,1);
            expect(violationinfos[0].message,"City must be valid");
        }); // end of 'UserInCityWith null' test

        test('> User in City with null and wrong Name', () {
            final UserInCity userInCity = new UserInCity(null, new User("Joe", "office@mikemitterer.at"));

            final BeanValidator<UserInCity> beanValidator = new BeanValidator<UserInCity>();
            final List<ViolationInfo<UserInCity>> violationinfos = beanValidator.validate(userInCity);

            expect(violationinfos.length,2);
            expect(violationinfos[0].message,"City must be valid");
            expect(violationinfos[1].message,"Name lenght must be at least 4 characters...");
        }); // end of 'User in City with null and wrong Name' test

        test('> UUID', () {
            final User user = new User.withUUID("Mike", "joe@test.com","123");

            final BeanValidator<User> beanValidator = new BeanValidator<User>();
            final List<ViolationInfo<User>> violationinfos = beanValidator.validate(user);

            expect(violationinfos.length,1);
            expect(violationinfos[0].message,"UserID must be a UUID");

        }); // end of 'UUID' test

        test('> Password', () {
            final UsernamePassword userpassword = new UsernamePassword("joe@test.com", "12345678aA%");
            final UsernamePassword invalidUP = new UsernamePassword("joe@test.com", "12345678aA");

            final BeanValidator<UsernamePassword> beanValidator = new BeanValidator<UsernamePassword>();
            final List<ViolationInfo> violationinfos = beanValidator.validate(userpassword);

            expect(violationinfos.length,0);

            final List<ViolationInfo> violationinfos2 = beanValidator.validate(invalidUP);
            expect(violationinfos2.length,1);
            expect(violationinfos2[0].message,"12345678aA is not a valid password");

        }); // end of 'UUID' test
    });
    // end 'BeanValidator' group


}

//------------------------------------------------------------------------------------------------
// Helper
//------------------------------------------------------------------------------------------------

