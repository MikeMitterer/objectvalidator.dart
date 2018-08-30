part of objectvalidator;

/// Überprüft eine Klasse ([T]) auf Gültigkeit
class ObjectValidator<T> {
    final _logger = new Logger('beanvalidator.BeanValidator');

    ObjectValidator() {
    }

    /// Überprüft das [obj] und gibt eine List mit [ViolationInfo]s zurück.
    /// Die Liste kann auch leer sein wenn keine Violations aufgetreten sind.
    ///
    /// Alternativ zu dieser Funktion gibt es [verify]
    List<ViolationInfo> validate(final T obj) {
        Validate.notNull(obj);
        return _validate(obj).values.toList();
    }

    /// Überprüft das [obj] und wirft eine [ViolationException] wenn es Probleme mit dem Objekt
    /// gibt.
    ///
    /// Alternativ zu dieser Funktion gibt es [validate]
    void verify(final T obj) {
        Validate.notNull(obj);
        final List<ViolationInfo> violations = validate(obj);
        if(violations.isNotEmpty) {
            throw new ViolationException(violations);
        }
    }

    // -- private -------------------------------------------------------------

    /// useKeyPrefix wird verwendet wenn untergeordnete Klassen (VObject) überprüft werden
    /// damit gleiche Methodenname in untergeordneten Ojekten unterschieden werden können
    Map<String,ViolationInfo> _validate(final obj,{ final bool useKeyPrefix: false }) {
        final Map<String,ViolationInfo> violationinfos = new Map<String,ViolationInfo>();

        final InstanceMirror mirror = validator.reflect(obj);
        final ClassMirror classMirror = mirror.type;
        final String mirrorType = _getMirrorType(mirror);
        final String simplename = classMirror.simpleName;

        _logger.fine("Object ${obj.toString()} reflected to: ${mirrorType}");
        _logger.fine("   SimpleName: $simplename");

        _addViolationInfos(obj, violationinfos,mirror,classMirror,useKeyPrefix ? simplename : "");

        return violationinfos;
    }

    /// Nur zur Info
    String _getMirrorType(final mirror) {
        return mirror.runtimeType.toString().replaceAll("_Local","");
    }

    /// keyPrefix: Dient als Unterscheidung für die Unterklassen
    _addViolationInfos(final obj, final Map<String,ViolationInfo> violationinfos,final InstanceMirror mirror,final ClassMirror classMirror,final String keyPrefix) {

        bool hasSuperClass() {
            return classMirror.superclass != null;
        }

        if(hasSuperClass()) {
            _addViolationInfos(obj,violationinfos,mirror,classMirror.superclass,keyPrefix);
        }

        // Durchlaufen aller Funktionen, Member usw. der Klasse
        for (var member in classMirror.declarations.values) {
            final String simplename = /*MirrorSystem.getName*/(member.simpleName);

            _logger.fine("Instance: ${member}");
            _logger.fine("Simple-name: $simplename");
            _logger.fine("Qualified-name: ${/*MirrorSystem.getName*/(member.qualifiedName)}");

            bool isGetter = false;
            bool isRegularMethod = false;

            if(member is MethodMirror) {
                final MethodMirror methodmirror = member;
                isGetter = methodmirror.isGetter;
                isRegularMethod = methodmirror.isRegularMethod;
            }
            _logger.fine("  isGetter: $isGetter");
            _logger.fine("  isRegularMethod: $isRegularMethod");

            if (member.metadata.length > 0) {
                member.metadata.forEach((final Object annotation) {
                    _logger.fine("    Annotation: ${annotation}");

                    final InstanceMirror element = validator.reflect(annotation);
                    _iterateThroughMetaData(simplename,element,member,obj,violationinfos,mirror,classMirror,keyPrefix);
                });
            }
        }
    }

    _iterateThroughMetaData(
        final String simplename,
        final InstanceMirror element,
        final member,
        final obj,
        final Map<String,ViolationInfo> violationinfos,
        final InstanceMirror instanceMirror,
        final ClassMirror classMirror,
        final String keyPrefix) {
        
        _logger.fine("    Metadata: ${element.reflectee}");

        if(element.hasReflectee && element.reflectee is ov.VObject) {
            final ov.Constraint constraint = element.reflectee as ov.Constraint;

            _logger.fine("               simpleName: ${simplename}");

            if(_isConstraintCheckOK(constraint,simplename,element,member,obj,violationinfos,instanceMirror,keyPrefix)) {

                final isRegularMethod = (member is MethodMirror) ? member.isRegularMethod : false;
                final value = isRegularMethod ? instanceMirror.invoke(simplename, [] ) : instanceMirror.invokeGetter(simplename);

                _logger.fine("                   isRegularMethod: ${isRegularMethod}");
                _logger.fine("                   Value: ${value}");

                final Map<String,ViolationInfo> test = _validate(/*isRegularMethod ? value() : */ value,useKeyPrefix: true);

                violationinfos.addAll(test);
                _logger.fine("           SubVioloationMap for ${member.simpleName} added");
            }

        } else if (element.hasReflectee) {
            // ParentKlasse (Jede Konkrete ConstraintsKlasse hat Constraint als Parent (super-Klasse))
            final instanceParent = element.reflectee;
            _logger.fine("           Parent: ${instanceParent}");
            _logger.fine("               isConstraint: ${instanceParent is ov.Constraint ? 'yes' : 'no'}");

            // Process only Constraints, ignore all other metadata
            if (instanceParent is ov.Constraint) {
                final ov.Constraint constraint = instanceParent;
                _isConstraintCheckOK(constraint,simplename,element,member,obj,violationinfos,instanceMirror,keyPrefix);
            }
        }

    }

    bool _isConstraintCheckOK(
            final ov.Constraint constraint,final String simplename,
            final InstanceMirror instanceMirrorElement,final member,final obj,
            final Map<String,ViolationInfo> violationinfos,
            final InstanceMirror instanceMirror,final String keyPrefix) {

        final isRegularMethod = (member is MethodMirror) ? member.isRegularMethod : false;

        // Invokes a getter and returns a mirror on the result. The getter
        // can be the implicit getter for a field or a user-defined getter
        // method.
        if(instanceMirror != null && instanceMirror is InstanceMirror) {
//            final field = instanceMirror.invokeGetter(member.simpleName);
//            final reflectee = (member as MethodMirror).re;
            final value = isRegularMethod ? instanceMirror.invoke(simplename, [] ) : instanceMirror.invokeGetter(simplename);

            _logger.fine("               Reflectee: ${instanceMirror.reflectee}");
            _logger.fine("               Type: ${member.runtimeType}");
            _logger.fine("               SimpleName: ${member.simpleName}");
            _logger.fine("               isRegularMethod: ${isRegularMethod}");
            _logger.fine("               Value: ${value}");

            // Wenn Value eine Funktion ist dann wird die Funktion selbst aufgerufen
            final bool matches = constraint.matches(value, { } );
            final String valueToCheckAgainst = constraint.valueToCheckAgainst;
            final L10N l10n = constraint.l10n;

            final String violationKey = "$keyPrefix/$simplename/${/*MirrorSystem.getName*/(instanceMirrorElement.type.simpleName)}";

            _logger.fine("                   Matches: " + (matches ? "yes" : "no"));
            _logger.fine("                   ValueToCheckAgainst: $valueToCheckAgainst");
            _logger.fine("                   ViolationKey: $violationKey");

            if(!matches) {
                final ViolationInfo violationinfo = new ViolationInfo(simplename,l10n,value,valueToCheckAgainst,obj);
                violationinfos[violationKey] = violationinfo;
                _logger.fine("                   Key '$violationKey' added...");

            } else if(violationinfos.containsKey(violationKey)) {
                violationinfos.remove(violationKey);
                _logger.fine("                   Key '$violationKey' removed...");
            }

            return matches;
        }

        return false;
    }
}
