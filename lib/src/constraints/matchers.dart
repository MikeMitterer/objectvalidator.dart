part of beanvalidator.constraints;

Matcher isBetweenMinus180AndPlus180() => allOf(greaterThanOrEqualTo(-180.0), lessThanOrEqualTo(180));

abstract class Constraint extends Matcher {
    final String message;

    const Constraint(this.message);
}

/// Wird z.B. bei Location verwendet um die Grad auf -90 bzw. +90 zu begrenzen
class Range extends Constraint {
    final double start;
    final double end;

    const Range({this.start, this.end, final String message}): super(message);

    bool matches(item, Map matchState) {

        bool checkTyped(final value) {
            return value >= start && value <= end;
        }
        return (checkTyped(item));
    }

    Description describe(Description description) => description.add("Range to be between $start and $end");
}

/// Nur zum testen in den Unit-Tests
/// Sample: expect(20.0, isInRangeBetween10And40);
const Matcher isInRangeBetween10And40 = const Range(start: 10.0, end: 40.0, message: "Test");

/// Sample für Unit-Tests:
///     expect(-50.1,isNot(isInRange(-50.0,50.0)));

Range isInRange(final double vstart, final double vend) => new Range(start: vstart, end: vend, message: "Test");

class NotNull extends Constraint {
    const NotNull({ final String message}) : super(message);

    bool matches(item, Map matchState) {
        return item != null;
    }

    Description describe(Description description) => description.add("Value must not be null!");
}

class Pattern extends Constraint {
    //static const String PATTERN_ALPHANUMERIC  = "^[a-zA-Z0-9öäüÖÄÜß]+\$";
    //static const String PATTERN_HEX           = "^(0x[a-fA-F0-9]+)|([a-fA-F0-9])+\$";

    final String pattern;

    const Pattern({this.pattern, final String message}) : super(message);

    bool matches(item, Map matchState) {
        final RegExp regexp = new RegExp(pattern);
        if (item is String) {
            return regexp.hasMatch(item);
        }
        return false;
    }

    Description describe(Description description) => description.add("$pattern not found");
}

class EMail extends Pattern {
    static const String _PATTERN_EMAIL = "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$";

    // ,9: TLD .localhost hat 9 Stellen

    const EMail({final String message}) : super(pattern: _PATTERN_EMAIL, message: message);

    Description describe(Description description) => description.add("Not a valid email address");
}

const Matcher isEMail = const EMail(message: "Nur für Annotation!");

class Uuid extends Pattern {
    static const String _PATTERN_UUID = "^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}\$";

    const Uuid({final String message}) : super(pattern: _PATTERN_UUID, message: message);

    Description describe(Description description) => description.add("Not a valid v4 UUID");
}

const Matcher isUuid = const Uuid(message: "Nur für Annotation!");

class NotEmpty extends Constraint {

    const NotEmpty({final String message}) : super(message);

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
}

const Matcher isNotEmpty = const NotEmpty(message: "Nur für Annontation");

/// Dient nur als "Marker" für eine "Unter-Validation-Object" - darf prinzipiell nicht null sein
class VObject extends Constraint {
    const VObject({final String message}) : super(message);

    bool matches(item, Map matchState) {
        return (item != null);

        /*
        Bei der tatsächlichen Implementierung wird hier ValidatorBean.validate(item) aufgerufen.
        Wenn die Anzahl der Constraints > 0 ist werden die Messages dem VialoationHandler (evtl. Callback)
        hinzugefügt
        */
    }

    Description describe(Description description) => description.add("Must not be null");
}

const Matcher isVObjectValid = const VObject(message: "Nur für Annotation");
