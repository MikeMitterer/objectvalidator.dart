part of unit.test;

class Name {

    @NotEmpty( message: const L10NImpl("firstname.notempty", "Firstname must not be {{what}}",const { "what" : "EMPTY"} ))
    @MinLenght(message: const L10NImpl("firstname.minlength","Firstname (%value%) must be at least 4 characters long"),minLength: 4)
    final String firstname;

    Name(this.firstname);
}

testBeanValidator() {
    final Logger _logger = new Logger("unit.test.BeanValidator");

    group('BeanValidator', () {
        setUp(() {
        });

    test('> Name - not empty', () {
        final Name name = new Name("Mike");

        final BeanValidator<Name> bv = new BeanValidator<Name>();
        List<ViolationInfo<Name>> violationInfos = bv.validate(name);

        expect(violationInfos.length,0);

        final Name invalidName = new Name("");
        violationInfos = bv.validate(invalidName);
        expect(violationInfos.length,2);

        expect(violationInfos[0].message,"Firstname must not be EMPTY");
        expect(violationInfos[1].message,"Firstname () must be at least 4 characters long");

        final Name invalidName2 = new Name("abc");
        violationInfos = bv.validate(invalidName2);
        expect(violationInfos.length,1);

        expect(violationInfos[0].message,"Firstname (abc) must be at least 4 characters long");

    }); // end of 'Name - not empty' test

    });
    // end 'BeanValidator' group
}

//------------------------------------------------------------------------------------------------
// Helper
//------------------------------------------------------------------------------------------------
