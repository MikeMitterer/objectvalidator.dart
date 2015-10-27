part of beanvalidator;

class BeanValidator<T> {
    final _logger = new Logger('beanvalidator.BeanValidator');

    BeanValidator() {
    }

    List<ViolationInfo> validate(final T obj) {
        Validate.notNull(obj);
        return _validate(obj).values.toList();
    }

    // -- private -------------------------------------------------------------

    /// useKeyPrefix wird verwendet wenn untergeordnete Klassen (VObject) überprüft werden
    /// damit gleiche Methodenname in untergeordneten Ojekten unterschieden werden können
    Map<String,ViolationInfo> _validate(final obj,{ final bool useKeyPrefix: false }) {
        final Map<String,ViolationInfo> violationinfos = new Map<String,ViolationInfo>();

        final mirror = reflect(obj);
        final ClassMirror classMirror = mirror.type;
        final String mirrorType = _getMirrorType(mirror);
        final String simplename = MirrorSystem.getName(classMirror.simpleName);

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
            final String simplename = MirrorSystem.getName(member.simpleName);

            _logger.fine("Instance: ${member}");
            _logger.fine("Simple-name: $simplename");
            _logger.fine("Qualified-name: ${MirrorSystem.getName(member.qualifiedName)}");

            bool isGetter = false;
            bool isRegularMethod = false;

            if(member is MethodMirror) {
                final MethodMirror methodmirror = member as MethodMirror;
                isGetter = methodmirror.isGetter;
                isRegularMethod = methodmirror.isRegularMethod;
            }
            _logger.fine("  isGetter: $isGetter");
            _logger.fine("  isRegularMethod: $isRegularMethod");

            if (member.metadata.length > 0) {
                member.metadata.forEach((final InstanceMirror element) {
                    _iterateThroughMetaData(simplename,element,member,obj,violationinfos,mirror,classMirror,keyPrefix);
                });
            }
        }
    }

    _iterateThroughMetaData(final String simplename,final InstanceMirror element,final member,final obj, final Map<String,ViolationInfo> violationinfos,final InstanceMirror mirror,final ClassMirror classMirror,final String keyPrefix) {
        final isRegularMethod = (member is MethodMirror) ? (member as MethodMirror).isRegularMethod : false;

        _logger.fine("    Metadata: ${element}");

        if(element.hasReflectee && element.reflectee is bv.VObject) {
            final bv.Constraint constraint = element.reflectee as bv.Constraint;
            final value = mirror.getField(member.simpleName).reflectee;

            if(_isConstraintCheckOK(constraint,simplename,element,member,obj,violationinfos,mirror,keyPrefix)) {

                final Map<String,ViolationInfo> test = _validate(isRegularMethod ? value() : value,useKeyPrefix: true);

                violationinfos.addAll(test);
                _logger.fine("           SubVioloationMap for ${member.simpleName} added");
            }

        } else if (element.hasReflectee) {
            // ParentKlasse (Jede Konkrete ConstraintsKlasse hat Constraint als Parent (super-Klasse))
            final instanceParent = element.reflectee;
            _logger.fine("           Parent: ${instanceParent}");
            _logger.fine("               isConstraint: ${instanceParent is bv.Constraint ? 'yes' : 'no'}");

            if (instanceParent is bv.Constraint) {
                final bv.Constraint constraint = instanceParent as bv.Constraint;
                _isConstraintCheckOK(constraint,simplename,element,member,obj,violationinfos,mirror,keyPrefix);
            }
        }

    }

    bool _isConstraintCheckOK(final bv.Constraint constraint,final String simplename,final InstanceMirror element,final member,final obj, final Map<String,ViolationInfo> violationinfos,final InstanceMirror mirror,final String keyPrefix) {
        final isRegularMethod = (member is MethodMirror) ? (member as MethodMirror).isRegularMethod : false;

        // Invokes a getter and returns a mirror on the result. The getter
        // can be the implicit getter for a field or a user-defined getter
        // method.
        if(mirror != null && mirror is InstanceMirror) {
            final field = mirror.getField(member.simpleName);
            final reflectee = field.reflectee;
            final value = isRegularMethod ? reflectee() : reflectee;

            _logger.fine("               SimpleName: ${member.simpleName}");
            _logger.fine("               Field-Type: ${field.runtimeType}");
            _logger.fine("               Value: ${value}");

            // Wenn Value eine Funktion ist dann wird die Funktion selbst aufgerufen
            final bool matches = constraint.matches(value, { } );

            final L10N l10n = constraint.l10n;
            final String valueToCheckAgainst = constraint.valueToCheckAgainst;

            final String violationKey = "$keyPrefix/$simplename/${MirrorSystem.getName(element.type.simpleName)}";

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