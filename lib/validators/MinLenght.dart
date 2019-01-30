part of objectvalidator.validators;

class MinLength extends Validator<dynamic,MinLength> {
    /// Field name for error message
    final String _fieldName;

    final num minLength;

    const MinLength(this.minLength, {final String fieldName = Validator.UNDEFINED_FIELD_NAME,
        CheckAgainstOnError<MinLength> onError: _onError })
            : _fieldName = fieldName,
                super(onError);

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
        return (final invalidValue) {
            if(range._fieldName == Validator.UNDEFINED_FIELD_NAME) {
                return l10n("[invalidValue] must have a minimum lenght of [minLength]!", {
                    "invalidValue" : "${invalidValue}",
                    "minLenght" : "${range.minLength}"
                });
            }

            return l10n("[fieldname] must have a minimum lenght of [minLength] but was [invalidValue]!", {
                "fieldname" : "${range._fieldName}",
                "invalidValue" : "${invalidValue}",
                "minLenght" : "${range.minLength}"
            });
        };

    }
}

