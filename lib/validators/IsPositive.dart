part of objectvalidator.validators;

class IsPositive extends Validator<num, IsPositive> {
    /// Field name for error message
    final String _fieldName;

    const IsPositive({final String fieldName = Validator.UNDEFINED_FIELD_NAME,
        CheckAgainstOnError<IsPositive> onError: _onError })
            : this._fieldName = fieldName,
                super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final num value) => value > 0;

    static ErrorMessage _onError(final IsPositive isPositive) {
        return (final invalidValue) {
            if(isPositive._fieldName == Validator.UNDEFINED_FIELD_NAME) {
                return l10n("Value must be greater than 0 but was [invalidValue]!", {
                    "invalidValue" : "${invalidValue?.toString()}"
                });
            }
            return l10n("[fieldname] must be greater than 0 but was [invalidValue]!", {
                "fieldname" : "${isPositive._fieldName}",
                "invalidValue" : "${invalidValue?.toString()}"
            });
        };
    }
}

const isPositive = IsPositive();
