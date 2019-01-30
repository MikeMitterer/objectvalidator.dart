part of objectvalidator.validators;

class NotNull extends Validator<dynamic, NotNull> {
    /// Field name for error message
    final String _fieldName;

    const NotNull({final String fieldName = Validator.UNDEFINED_FIELD_NAME,
        CheckAgainstOnError<NotNull> onError: _onError })
            : this._fieldName = fieldName,
                super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final value) => value != null;

    static ErrorMessage _onError(final NotNull notNull) {
        if(notNull._fieldName == Validator.UNDEFINED_FIELD_NAME) {
            return (final value) {
                return l10n("Object must not be null!");
            };
        }
        return (final value) {
            return l10n("'[fieldname]' must not be null!", {
                "fieldname": "${notNull._fieldName}"
            });
        };
    }

}

const isNotNull = const NotNull();
