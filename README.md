## ObjectValidator
Object-Validator for Dart

### Usage

Define your class you want to validate:

```dart
@validator
class AnotherPerson {
    final int _age;

    AnotherPerson(this._age);

    @Range(start: 15.0, end: 55.0, message: const L10N("Age must be between 15 and 55 years"))
    int get age => _age;
}
```

Validation looks like this:

```dart
final AnotherPerson person1 = AnotherPerson(55);
final ObjectValidator<AnotherPerson> ov = new ObjectValidator<AnotherPerson>();

List<ViolationInfo> violationInfos = ov.validate(person1);
expect(violationInfos.length, 0);

final AnotherPerson person2 = AnotherPerson(14);

violationInfos = ov.validate(person2);
expect(violationInfos.length, 1);

expect(violationInfos[0].message, "Age must be between 15 and 55 years");

```

For more - check out my tests...

## Features and bugs
Please file feature requests and bugs at the [issue tracker](https://github.com/MikeMitterer/objectvalidator.dart/issues).


### License

    Copyright 2018 Michael Mitterer, IT-Consulting and Development Limited,
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