part of objectvalidator;

/// Checks class for validation
class ObjectValidator {
    // final _logger = new Logger('beanvalidator.BeanValidator');

    /// List with error messages
    final violations = List<String>();

    /// Checks if there were errors
    bool get isValid => violations.isEmpty;

    /// Checks [value] for errors.
    /// To determine if [value] is valid or not it uses [Validator]
    ///
    bool verify<T>(final T value,final Validator validator) {
        if(!validator.isValid(value)) {
            violations.add(validator.errorMessage(value));
            return false;
        }
        return true;
    }

    bool verifyAll<T>(final T value, final List<Validator> validators) {
        bool valid = true;
        validators?.forEach((final Validator validator) {
            if(!verify(value, validator)) {
                valid = false;
            }
        });
        return valid;
    }

    /// Resets all violations
    void clear() => violations.clear();

    // -- private -------------------------------------------------------------

}
