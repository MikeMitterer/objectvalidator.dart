part of objectvalidator.validators;

class Pattern extends Validator<String, Pattern> {

    final String pattern;

    const Pattern(this.pattern, { CheckAgainstOnError<Pattern> onError: _onError })
        : super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final String value) => checkPattern(pattern,value);

    static ErrorMessage _onError(final Pattern pattern) {
        return (final value)
            => l10n("Value (${value?.toString()}) must match the pattern $pattern!");
    }
}

bool checkPattern(final String pattern, final String value) {
    final RegExp regexp = new RegExp(pattern);
    if(value == null) {
        return false;
    }
    return regexp.hasMatch(value);
}
