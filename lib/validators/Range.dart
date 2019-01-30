part of objectvalidator.validators;

class Range extends Validator<num,Range> {
    /// Field name for error message
    final String _fieldName;

    final num start;
    final num end;

    const Range(this.start, this.end, { final String fieldName = Validator.UNDEFINED_FIELD_NAME,
            CheckAgainstOnError<Range> onError: _onError })
                : this._fieldName = (fieldName == Validator.UNDEFINED_FIELD_NAME ? fieldName : "'$fieldName'"),
                    super(onError);

    @override
    String errorMessage(final invalidValue) => onError(this)(invalidValue);

    @override
    bool isValid(final num value) => value != null && value >= start && value <= end;

    static ErrorMessage _onError(final Range range) {
        return (final invalidValue) {
            if(range._fieldName == Validator.UNDEFINED_FIELD_NAME) {
                return l10n("Range must be between [start] and [end] but was [invalidValue]", {
                    "start" : "${range.start}",
                    "end" : "${range.end}",
                    "invalidValue" : "$invalidValue"
                });
            }
            return l10n("[fieldname] must be between [start] and [end] but was [invalidValue]", {
                "fieldname" : "${range._fieldName}",
                "start" : "${range.start}",
                "end" : "${range.end}",
                "invalidValue" : "$invalidValue"
            });
        };
    }
}

final isInRangeBetween10And40 =
    Range(10, 40, onError: (final Range rx) => (dynamic invalidValue)
        => l10n("Range must be between [start] and [end]", {
            "start" : "${rx.start}",
            "end" : "${rx.end}"
        }));

Range isInRange(final num start, final num end, { CheckAgainstOnError<Range> onError }) =>
    Range(start, end, onError: onError);
