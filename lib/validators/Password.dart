part of objectvalidator.validators;

class Password extends Validator<String, Password> {

    static const String _PATTERN_PASSWORD =
        "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#\$%?])[0-9a-zA-Z@#\$%?]{8,15}\$";

    const Password({ CheckAgainstOnError<Password> onError: _onError })
        : super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final String value) => checkPattern(_PATTERN_PASSWORD,value);

    static ErrorMessage _onError(final Password pattern) {
        return (final value)
            => l10n("${value?.toString()} is not a valid password!");
    }
}

final isPassword = Password();
