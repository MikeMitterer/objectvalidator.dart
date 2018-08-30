library objectvalidator;

import 'dart:collection';

import 'package:reflectable/reflectable.dart';
import 'package:l10n/l10n.dart';
import 'package:logging/logging.dart';
import 'package:validate/validate.dart';
import 'package:dryice/dryice.dart' as di;

import 'constraints.dart' as ov;
export 'constraints.dart';

part 'objectvalidator/ObjectValidator.dart';
part 'objectvalidator/ViolationException.dart';
part 'objectvalidator/ViolationInfo.dart';

class ValidationReflector extends Reflectable {
    const ValidationReflector() : super(

        // instanceInvokeCapability,
        invokingCapability,
        reflectedTypeCapability,
        typeCapability,
        typingCapability,
        metadataCapability,
        superclassQuantifyCapability,
        // newInstanceCapability,
    );
}

const ValidationReflector validator = const ValidationReflector();
const ValidationReflector constraint = const ValidationReflector();

@di.inject
class ReflectionSample {
    final String _name;

  const ReflectionSample(this._name);
}




