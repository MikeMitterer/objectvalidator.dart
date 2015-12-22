library beanvalidator.constraints;

import 'package:matcher/matcher.dart' as m;
import 'package:reflectable/reflectable.dart';

import 'package:l10n/l10n.dart';

part 'constraints/matchers.dart';

/// Reflector for annotation
///
/// Damit ist es möglich den Typ der Annotation
/// abzufragen
///
///     final InstanceMirror imAnnotation = metareflector.reflect(x);
///     final ClassMirror cmAnnotation = imAnnotation.type;
///
///     print(cmAnnotation.simpleName)
class MetaReflector extends Reflectable {
    const MetaReflector() : super(
            metadataCapability,
            subtypeQuantifyCapability,
            declarationsCapability // Recommendation http://goo.gl/OlUri0
    );
}
const metareflector = const MetaReflector();