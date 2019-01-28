part of objectvalidator.validators;

class EMail extends Validator<String, EMail> {
    /// ,9: TLD .localhost hat 9 Stellen
    static const String _PATTERN_EMAIL =
        "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$";

    const EMail({ CheckAgainstOnError<EMail> onError: _onError })
        : super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final String value) => checkPattern(_PATTERN_EMAIL,value);

    static ErrorMessage _onError(final EMail pattern) {
        return (final value)
            => l10n("${value?.toString()} must be a valid e-mail address!");
    }
}

final isEMail = EMail();
