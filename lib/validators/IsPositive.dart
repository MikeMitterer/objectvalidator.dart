part of objectvalidator.validators;

class IsPositive extends Validator<num, IsPositive> {

    const IsPositive({ CheckAgainstOnError<IsPositive> onError: _onError })
        : super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final num value) => value > 0;

    static ErrorMessage _onError(final IsPositive isPositive) {
        return (final invalidValue)
            => l10n("Value must be positive but war $invalidValue!");
    }
}

const isPositive = IsPositive();
