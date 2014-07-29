part of beanvalidator;

/**
 * Wenn in der "message" der Platzhaler {{field}} vorkommt wird dieser PH durch den
 * Feldnamen ersetzt.
 *
 * Kommt {{value}} vor wird der PH durch den Fehlerhaften Wert ersetzt.
 * Kommt {{value.length}} vor und ist der Wert ein Objekt bei dem die Länge festgestellt werden kann,
 * wird dieser PH durch die entsprechende Länge ersetzt.
 *
 * {{value.to.check.against}} wird durch den Wert ersetzt der nicht erreicht wurde
 */
class ViolationInfo<T> implements Translatable {
    final _logger = new Logger('beanvalidator.ViolationInfo');

    /// Feldname oder Funktionsname
    final String methodName;

    /// Wert des überprüften feldes
    final Object invalidValue;

    /// Parent-Object
    final T rootBean;

    /// Constraint L10N Info
    L10N _l10n;

    final String valueToCheckAgainst;

    static final RegExp _regexpMethod = new RegExp("(%method%|%field%)");

    ViolationInfo(this.methodName, final L10N l10nFromConstraint, this.invalidValue, this.valueToCheckAgainst, this.rootBean) {
        Validate.notBlank(methodName, "Method-Name must not be blank");
        Validate.notNull(l10nFromConstraint, "l10n must not be null");
        Validate.notNull(rootBean, "Root-Bean must not be null");
        Validate.notNull(valueToCheckAgainst, "valueToCheckAgainst must not be null");

        final Map<String, dynamic> l10nVars = new Map<String, dynamic>.from(l10nFromConstraint.vars);
        l10nVars.putIfAbsent("field", () => ViolationInfo._getMethodName(methodName));
        l10nVars.putIfAbsent("value", () => ViolationInfo._getValue(invalidValue));
        l10nVars.putIfAbsent("value.length", () => ViolationInfo._getLength(invalidValue));
        l10nVars.putIfAbsent("value.to.check.against", () => valueToCheckAgainst);

        _l10n = new L10N(l10nFromConstraint.message, l10nVars);
    }

    String get message => l10n.message;

    L10N get l10n => _l10n;

    // -- private -------------------------------------------------------------

    static String _getValue(final Object obj) {
        return obj != null ? obj.toString() : 'null';
    }

    static String _getMethodName(final String method) {

        String capitalizeFirstChar(final String value) {
            return (method[0].toUpperCase() + method.substring(1));
        }

        return method != null && !method.isEmpty ? capitalizeFirstChar(method) : '<unknown>';
    }

    static int _getLength(final Object invalidValue) {
        if (invalidValue != null) {

            if (invalidValue is String) {
                return (invalidValue as String).length;

            }
            else if (invalidValue is Map) {
                return (invalidValue as Map).length;

            }
            else if (invalidValue is Iterable) {
                    return (invalidValue as Iterable).length;

                }
        }
        return 0;
    }
}
