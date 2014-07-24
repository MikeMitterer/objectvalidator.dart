part of beanvalidator.constraints;

Matcher isBetweenMinus180AndPlus180() => allOf(greaterThanOrEqualTo(-180.0), lessThanOrEqualTo(180));

abstract class Constraint extends Matcher implements Translatable {
    /// Translatable message
    final L10N message;

    const Constraint(this.message);

    L10N get l10n => message;

    String get valueToCheckAgainst;
}

/// Wird z.B. bei Location verwendet um die Grad auf -90 bzw. +90 zu begrenzen
class Range extends Constraint {
    final double start;
    final double end;

    const Range({this.start, this.end, final L10N message}): super(message);

    /// matchState can be supplied and may be used to add details about the mismatch
    /// that are too costly to determine in describeMismatch.
    bool matches(item, Map matchState) {
        bool checkTyped(final value) {
            return value >= start && value <= end;
        }
        return (checkTyped(item));
    }

    Description describe(Description description) => description.add("Range to be between $start and $end");

    String get valueToCheckAgainst => "$start / $end";
}

/// Nur zum testen in den Unit-Tests
/// Sample: expect(20.0, isInRangeBetween10And40);
const Matcher isInRangeBetween10And40 = const Range(start: 10.0, end: 40.0, message: const L10N("matcher.isinrangebetween10an40","Test") );

/// Sample für Unit-Tests:
///     expect(-50.1,isNot(isInRange(-50.0,50.0)));
Range isInRange(final double vstart, final double vend) => new Range(start: vstart, end: vend, message: l10n("matcher.isinrange","Test"));

class NotNull extends Constraint {
    const NotNull({ final L10N message}) : super(message);

    bool matches(item, Map matchState) {
        return item != null;
    }

    Description describe(Description description) => description.add("Value must not be null!");

    String get valueToCheckAgainst => "null";
}

class Pattern extends Constraint {
    //static const String PATTERN_ALPHANUMERIC  = "^[a-zA-Z0-9öäüÖÄÜß]+\$";
    //static const String PATTERN_HEX           = "^(0x[a-fA-F0-9]+)|([a-fA-F0-9])+\$";

    final String pattern;

    const Pattern({this.pattern, final L10N message}) : super(message);

    bool matches(item, Map matchState) {
        final RegExp regexp = new RegExp(pattern);
        if (item is String) {
            return regexp.hasMatch(item);
        }
        return false;
    }

    Description describe(Description description) => description.add("$pattern not found");

    String get valueToCheckAgainst => pattern;
}

class EMail extends Pattern {
    static const String _PATTERN_EMAIL = "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$";

    // ,9: TLD .localhost hat 9 Stellen

    const EMail({final L10N message}) : super(pattern: _PATTERN_EMAIL, message: message);

    Description describe(Description description) => description.add("Not a valid email address");

    String get valueToCheckAgainst => "email ($_PATTERN_EMAIL)";
}

const Matcher isEMail = const EMail(message: const L10N("matcher.isemail","Nur für Annotation!"));

class Uuid extends Pattern {
    static const String _PATTERN_UUID = "^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}\$";

    const Uuid({final L10N message}) : super(pattern: _PATTERN_UUID, message: message);

    Description describe(Description description) => description.add("Not a valid v4 UUID");

    String get valueToCheckAgainst => "UUID ($_PATTERN_UUID)";
}

const Matcher isUuid = const Uuid(message: const L10N("matcher.isuuid","Nur für Annotation!"));

class NotEmpty extends Constraint {

    const NotEmpty({final L10N message}) : super(message);

    bool matches(item, Map matchState) {
        if (item == null) {
            return false;
        }

        try {
            return item.isNotEmpty;
        }
        on NoSuchMethodError
        catch(error) {
            return false;
        }
    }

    Description describe(Description description) => description.add("Must not be empty");

    String get valueToCheckAgainst => "not empty";
}

const Matcher isNotEmpty = const NotEmpty(message: const L10N("macher.isnotempty","Nur für Annontation"));

/// Dient nur als "Marker" für eine "Unter-Validation-Object" - darf prinzipiell nicht null sein
class VObject extends Constraint {
    const VObject({final L10N message}) : super(message);

    bool matches(item, Map matchState) {
        return (item != null);

        /*
        Bei der tatsächlichen Implementierung wird hier ValidatorBean.validate(item) aufgerufen.
        Wenn die Anzahl der Constraints > 0 ist werden die Messages dem VialoationHandler (evtl. Callback)
        hinzugefügt
        */
    }

    Description describe(Description description) => description.add("Must not be null");

    String get valueToCheckAgainst => "not empty";
}

const Matcher isVObjectValid = const VObject(message: const L10N("matcher.isvobjectvalid","Nur für Annotation"));


class MinLenght extends Constraint {
    final int minLength;

    const MinLenght( this.minLength ,{ final L10N message } ) :
        super(message != null ? message : const L10N("default.minlength","Legth of {{field}} is invalid"));


    bool matches(item, Map matchState) {
        if(item == null || minLength < 0) {
            return false;
        }

        if(item is String) {
            return (item as String).length >= minLength;
        }

        if(item is Map) {
            return (item as Map).length >= minLength;
        }

        if(item is Iterable) {
            return (item as Iterable).length >= minLength;
        }

        return false;

    }

    Description describe(Description description) => description.add("Length must be at least $minLength");

    String get valueToCheckAgainst => "$minLength";
}