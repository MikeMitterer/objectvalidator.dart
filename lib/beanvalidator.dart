library beanvalidator;

import 'dart:collection';

import 'package:beanvalidator/constraints.dart' as bv;
import 'package:l10n/l10n.dart';

@MirrorsUsed(

    /// Annotations
    metaTargets: const [ bv.Constraint, bv.Range, bv.Pattern, bv.EMail, bv.Uuid,
        bv.Password, bv.NotEmptyAndNotNull, bv.VObject, bv.MinLength ],

    /// Necessary to get access to [Constraints.l10n] for example
    targets: const [ "beanvalidator.constraints" ]
)
import 'dart:mirrors';
import 'package:logging/logging.dart';

import 'package:validate/validate.dart';

export 'package:beanvalidator/constraints.dart';

part 'beanvalidator/BeanValidator.dart';
part 'beanvalidator/ViolationException.dart';
part 'beanvalidator/ViolationInfo.dart';

