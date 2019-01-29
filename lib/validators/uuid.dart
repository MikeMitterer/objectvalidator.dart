part of objectvalidator.validators;

class Uuid extends Validator<String, Uuid> {
    static const String _PATTERN_UUID = "^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}\$";

    const Uuid({ CheckAgainstOnError<Uuid> onError: _onError })
        : super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final String value) => checkPattern(_PATTERN_UUID,value);

    static ErrorMessage _onError(final Uuid pattern) {
        return (final value)
            => l10n("${value?.toString()} is not a valid UUID!");
    }
}

final isUuid = Uuid();
