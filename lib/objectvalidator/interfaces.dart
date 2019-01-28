part of objectvalidator;

/// Marks a class as "verifiable"
///
///     class MyName implements Verifiable<MyName> {
///         ...
///     }
///
abstract class Verifiable<T> {
    void validate({ void Function(final T obj,final ObjectValidator ov) onError = throwIfInvalid });
}

void throwIfInvalid<T>(final T obj, final ObjectValidator checker) {
    if(!checker.isValid) {
        throw ViolationException(checker.violations);
    }
}

