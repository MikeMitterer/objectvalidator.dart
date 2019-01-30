part of objectvalidator.validators;

class NotEmpty extends Validator<dynamic, NotEmpty> {
    /// Field name for error message
    final String _fieldName;

    const NotEmpty({final String fieldName = Validator.UNDEFINED_FIELD_NAME,
            CheckAgainstOnError<NotEmpty> onError: _onError })
                : this._fieldName = (fieldName == Validator.UNDEFINED_FIELD_NAME ? fieldName : "'$fieldName'"),
                    super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final value) {
        if(value == null) {
            return false;
        }

        if(value is List || value is Map || value is String) {
            return value.isNotEmpty;
        }

        return value.toString().isNotEmpty;
    }

    static ErrorMessage _onError(final NotEmpty notEmpty) {
        return (final value) {
            if(notEmpty._fieldName == Validator.UNDEFINED_FIELD_NAME) {
                return l10n("Value must not be empty!");
            }
            return l10n("[fieldname] must not be empty!", {
                "fieldname" : "${notEmpty._fieldName}"
            });
        };
    }
}

const isNotEmpty = NotEmpty();
