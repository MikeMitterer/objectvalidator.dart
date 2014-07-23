part of beanvalidator;

/**
 * Wenn in der "message" der Platzhaler %value% vorkommt wird dieser PH durch den Wert
 * von invalidValue ersetzt
 */
class ViolationInfo<T> implements Translatable {
    final _logger = new Logger('beanvalidator.ViolationInfo');

    final String methodName;
    final L10N l10n;
    final Object invalidValue;
    final T rootBean;


    ViolationInfo(this.methodName, final L10N l10nFromConstraint, final Object invalidValue, this.rootBean) :
        l10n = new L10NImpl(l10nFromConstraint.key,l10nFromConstraint.message.replaceAll("%value%",ViolationInfo._getValue(invalidValue)),l10nFromConstraint.variables),
        this.invalidValue = invalidValue {

        Validate.notBlank(methodName,"Method-Name must not be blank");
        Validate.notNull(l10n,"l10n must not be null");
        Validate.notNull(rootBean,"Root-Bean must not be null");
    }

    String get message => l10n.message;

    // -- private -------------------------------------------------------------

    static String _getValue(final Object obj) {
        return obj != null ? obj.toString() : 'null';
    }
}
