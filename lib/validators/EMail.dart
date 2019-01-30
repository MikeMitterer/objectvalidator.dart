part of objectvalidator.validators;

class EMail extends Validator<String, EMail> {
    /// Field name for error message
    final String _fieldName;

    /// ,9: TLD .localhost hat 9 Stellen
    static const String _PATTERN_EMAIL =
        "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$";

    const EMail({final String fieldName = Validator.UNDEFINED_FIELD_NAME,
        CheckAgainstOnError<EMail> onError: _onError })
            : this._fieldName = fieldName,
                super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final String value) => checkPattern(_PATTERN_EMAIL,value);

    static ErrorMessage _onError(final EMail pattern) {
        return (final value) {
            if(pattern._fieldName == Validator.UNDEFINED_FIELD_NAME) {
                return l10n("'[value]' is not a valid e-mail address!", {
                    "value" : "${value?.toString()}"
                });
            }
            return l10n("'[value]' is not a valid e-mail address for '[fieldname]'!", {
                "value" : "${value?.toString()}",
                "fieldname" : "${pattern._fieldName}"
            });
        };
    }
}

final isEMail = EMail();
