library objectvalidator.validators;

import 'package:l10n/l10n.dart';
import 'package:objectvalidator/objectvalidator.dart';

part 'validators/Range.dart';
part 'validators/IsPositive.dart';
part 'validators/NotNull.dart';
part 'validators/Pattern.dart';
part 'validators/EMail.dart';
part 'validators/uuid.dart';
part 'validators/Password.dart';
part 'validators/NotEmpty.dart';
part 'validators/MinLenght.dart';
part 'validators/IsValid.dart';

typedef ErrorMessage CheckAgainstOnError<T>(final T value);
typedef String ErrorMessage(final invalidValue);

abstract class Validator<T,C> {
    final CheckAgainstOnError<C> onError;

    const Validator(this.onError);

    bool isValid(final T value);

    String errorMessage(final invalidValue);
}


