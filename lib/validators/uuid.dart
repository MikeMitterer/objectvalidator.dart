part of objectvalidator.validators;

class Uuid extends Validator<String, Uuid> {
    /// Field name for error message
    final String _fieldName;

    static const String _PATTERN_UUID = "^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}\$";

    const Uuid({ final String fieldName = Validator.UNDEFINED_FIELD_NAME,
        CheckAgainstOnError<Uuid> onError: _onError })
            : this._fieldName = fieldName,
                super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final String value) => checkPattern(_PATTERN_UUID,value);

    static ErrorMessage _onError(final Uuid pattern) {
        return (final value) {
            if(pattern._fieldName == Validator.UNDEFINED_FIELD_NAME) {
                return l10n("'[value]' is not a valid UUID!", {
                    "value" : "${value?.toString()}"
                });
            }
            return l10n("'[value]' is not a valid UUID for '[fieldname]'!", {
                "fieldname" : "${pattern._fieldName}",
                "value" : "${value?.toString()}"
            });
        };
    }
}

final isUuid = Uuid();
