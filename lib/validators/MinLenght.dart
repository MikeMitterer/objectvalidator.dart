part of objectvalidator.validators;

class MinLength extends Validator<dynamic,MinLength> {
    final num minLength;

    const MinLength(this.minLength, { CheckAgainstOnError<MinLength> onError: _onError })
        : super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final value) {
        if(value == null) {
            return false;
        }

        if(value is String) {
            return value.length >= minLength;
        }
        if(value is List) {
            return value.length >= minLength;
        }
        if(value is Map) {
            return value.length >= minLength;
        }
        return value.toString().length >= minLength;
    }

    static ErrorMessage _onError(final MinLength range) {
        return (final invalidValue)
        => l10n("$invalidValue must have a minimum lenght of ${range.minLength}!");
    }
}

