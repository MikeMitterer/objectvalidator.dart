part of objectvalidator.validators;

class NotNull extends Validator<dynamic, NotNull> {

    const NotNull({ CheckAgainstOnError<NotNull> onError: _onError })
        : super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final value) => value != null;

    static ErrorMessage _onError(final NotNull notNull) {
        return (final value)
            => l10n("Value must not be null!");
    }
}
