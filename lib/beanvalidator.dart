library beanvalidator;

import 'package:beanvalidator/constraints.dart' as bv;

@MirrorsUsed(
    metaTargets: const [ bv.Range, bv.Pattern, bv.EMail, bv.Uuid,
        bv.Password, bv.NotEmptyAndNotNull, bv.VObject, bv.MinLength ]
)
import 'dart:mirrors';
import 'package:logging/logging.dart';

import 'package:validate/validate.dart';

import 'package:l10n/l10n.dart';

export 'package:beanvalidator/constraints.dart';

part 'src/beanvalidator/ViolationInfo.dart';
part 'src/beanvalidator/BeanValidator.dart';
