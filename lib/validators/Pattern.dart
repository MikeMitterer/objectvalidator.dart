part of objectvalidator.validators;

class Pattern extends Validator<String, Pattern> {
    /// Field name for error message
    final String _fieldName;

    final String pattern;

    const Pattern(this.pattern, { final String fieldName = Validator.UNDEFINED_FIELD_NAME,
        CheckAgainstOnError<Pattern> onError: _onError })
            : _fieldName = fieldName,
                super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final String value) => checkPattern(pattern,value);

    static ErrorMessage _onError(final Pattern pattern) {
        return (final value) {
            if(pattern._fieldName == Validator.UNDEFINED_FIELD_NAME) {
                return l10n("'[value]' must match the pattern '[pattern]'!", {
                    "value" : "${value?.toString()}",
                    "pattern" : "${pattern.pattern}"
                });
            }
            return l10n("'[fieldname]' must match the pattern '[pattern]' but was '[value]'!", {
                "fieldname" : "${pattern._fieldName}",
                "value" : "${value?.toString()}",
                "pattern" : "$pattern"
            });
        };
    }
}

bool checkPattern(final String pattern, final String value) {
    final RegExp regexp = new RegExp(pattern);
    if(value == null) {
        return false;
    }
    return regexp.hasMatch(value);
}
