library beanvalidator;

import 'dart:collection';

import 'package:beanvalidator/constraints.dart' as bv;
import 'package:l10n/l10n.dart';
import 'package:logging/logging.dart';
import 'package:reflectable/reflectable.dart';
import 'package:validate/validate.dart';

export 'package:beanvalidator/constraints.dart';

part 'beanvalidator/BeanValidator.dart';
part 'beanvalidator/ViolationException.dart';
part 'beanvalidator/ViolationInfo.dart';

class BeanReflector extends Reflectable {
    const BeanReflector()
        : super(
            declarationsCapability, // Recommendation http://goo.gl/OlUri0
            instanceInvokeCapability,
            metadataCapability,
            nameCapability,
            reflectedTypeCapability,
            superclassQuantifyCapability,
            typeRelationsCapability
    );
}

const BeanReflector beanreflector = const BeanReflector();



