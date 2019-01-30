part of objectvalidator.validators;

class IsValid extends Validator<Object, IsValid> {
    /// Field name for error message
    final String _fieldName;

    final violations = List<String>();

    IsValid({final String fieldName = Validator.UNDEFINED_FIELD_NAME,
        CheckAgainstOnError<IsValid> onError: _onError, void onNull(): _onNull })
            : this._fieldName = fieldName,
                super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final Object obj) {
        violations.clear();

        if(obj == null) {
            try {
                _onNull();
                return true;
            } on ViolationException catch(e) {
                violations.addAll(e.violations);
            }
            return false;
        }

        try {
            (obj as Verifiable).validate();
        } on ViolationException catch(e) {
            violations.addAll(e.violations);
            return false;
        }
        return true;
    }

    static ErrorMessage _onError(final IsValid isValid) {
        return (final invalidObject) {
            if(isValid._fieldName == Validator.UNDEFINED_FIELD_NAME) {
                return l10n("Found the following violoations: [violations]!", {
                    "violations" : "${isValid.violations.join(", ")}"
                });
            }
            return l10n("[fieldname]-Verification failed with: '[violations]'", {
                "violations" : "${isValid.violations.join(", ")}",
                "fieldname" : "${isValid._fieldName}"
            });
        };
    }

    static void _onNull() => throw ViolationException([ l10n("null-object not allowed") ]);
}

final isValid = IsValid();
