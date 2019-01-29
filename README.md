## ObjectValidator
> Object-Validator for Dart

### Usage

Define your class you want to validate and implement the `Verifiable<AnotherPerson>` interface

```dart
class AnotherPerson implements Verifiable<AnotherPerson> {
    final int _age;

    AnotherPerson(this._age);

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
```

If you want to check your object for being valid - it looks like this:

```dart
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

            // If you use 'isAnotherPersonValid' it's not necessary to 
            // implement the 'Verifiable<AnotherPerson>' interface for 'AnotherPerson' 
            isAnotherPersonValid(person,ifInvalid: (final AnotherPerson ap, final ObjectValidator ov)
                => violations.addAll(ov.violations));

            expect(violations.length, 1);
            expect(violations.first, "Age must be between 15 and 55 but was 99!");
        }); 
        
```

For more - check out my tests...

## Features and bugs
Please file feature requests and bugs at the [issue tracker](https://github.com/MikeMitterer/objectvalidator.dart/issues).

### License

    Copyright 2019 Michael Mitterer, IT-Consulting and Development Limited,
    Austrian Branch

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, 
    software distributed under the License is distributed on an 
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
    either express or implied. See the License for the specific language 
    governing permissions and limitations under the License.
    
If this plugin is helpful for you - please [(Circle)](http://gplus.mikemitterer.at/) me.

[1]: https://github.com/MikeMitterer/objectvalidator.dart/issues
