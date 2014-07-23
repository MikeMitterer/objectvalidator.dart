part of unit.test;

class Name {

    @NotEmpty(message: "Firstname must not be empty")
    @MinLenght(minLength: 4, message: "Firstname mast be at least 4 characters long")
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

        expect(violationInfos[0].message,"Firstname must not be empty");
        expect(violationInfos[1].message,"Firstname mast be at least 4 characters long");

    }); // end of 'Name - not empty' test

    });
    // end 'BeanValidator' group
}

//------------------------------------------------------------------------------------------------
// Helper
//------------------------------------------------------------------------------------------------
