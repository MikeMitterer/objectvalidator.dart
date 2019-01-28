part of objectvalidator.validators;

class Range extends Validator<num,Range> {
    final num start;
    final num end;

    const Range(this.start, this.end, { CheckAgainstOnError<Range> onError: _onError })
        : super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final num value) => value != null && value >= start && value <= end;

    static ErrorMessage _onError(final Range range) {
        return (final invalidValue)
        => l10n("Range must be between ${range.start} and ${range.end} but was $invalidValue");
    }
}

final isInRangeBetween10And40 =
    Range(10, 40, onError: (final Range rx) => (dynamic invalidValue)
        => l10n("Range must be between ${rx.start} and ${rx.end}"));

Range isInRange(final num start, final num end, { CheckAgainstOnError<Range> onError }) =>
    Range(start, end, onError: onError);
