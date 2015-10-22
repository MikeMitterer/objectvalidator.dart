part of unit.test;

/**
 *
 */

testMatchers() {
    final Logger logger = new Logger("test.Matchers");

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
            final String v3UUID = "c87ee674-4ddc-3efe-a74e-dfe25da5d7b3";
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
                expect([ "Hallo", "Test" ], new MinLenght(2,message: l10n("Hier nicht notwendig")));
            });

            test('> Invalid', () {
                expect([ "Hallo", "Test" ], isNot(new MinLenght(3,message: l10n("Hier nicht notwendig"))));
            }); // end of 'Invalid' test


        });
        // End of '> MinLength' group
    });
    // End of 'Matchers' group


}

//------------------------------------------------------------------------------------------------
// Helper
//------------------------------------------------------------------------------------------------
