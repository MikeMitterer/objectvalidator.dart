part of objectvalidator.validators;

class Password extends Validator<String, Password> {
    /// Field name for error message
    final String _fieldName;

    static const String _PATTERN_PASSWORD =
        "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#\$%?])[0-9a-zA-Z@#\$%?]{8,15}\$";

    const Password({final String fieldName = Validator.UNDEFINED_FIELD_NAME,
        CheckAgainstOnError<Password> onError: _onError })
        : this._fieldName = fieldName,
            super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final String value) => checkPattern(_PATTERN_PASSWORD,value);

    static ErrorMessage _onError(final Password pattern) {
        return (final value) {
            if(pattern._fieldName == Validator.UNDEFINED_FIELD_NAME) {
                return l10n("'[value]' is not a valid password!", {
                    "value" : "${value?.toString()}"
                });
            }
            return l10n("'[value]' is not a valid password for '[fieldname]'!", {
                "value" : "${value?.toString()}",
                "fieldname" : "${pattern._fieldName}"
            });
        };
    }
}

final isPassword = Password();
