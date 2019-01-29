part of objectvalidator.validators;

class IsValid extends Validator<Object, IsValid> {

    final violations = List<String>();

    IsValid({ CheckAgainstOnError<IsValid> onError: _onError, void onNull(): _onNull })
        : super(onError);

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
        return (final invalidObject)
            => l10n("Found the following violoations: ${isValid.violations.join(", ")}!");
    }

    static void _onNull() => throw ViolationException([ l10n("null-object not allowed") ]);
}
