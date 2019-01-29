part of objectvalidator.validators;

class NotEmpty extends Validator<dynamic, NotEmpty> {

    const NotEmpty({ CheckAgainstOnError<NotEmpty> onError: _onError })
        : super(onError);

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

    static ErrorMessage _onError(final NotEmpty notNull) {
        return (final value)
            => l10n("Value must not be empty but was ${value?.toString()}!");
    }
}

const isNotEmpty = NotEmpty();
