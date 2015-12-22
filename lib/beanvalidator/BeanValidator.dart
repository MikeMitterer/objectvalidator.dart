part of beanvalidator;

/// Überprüft eine Klasse ([T]) auf Gültigkeit
class BeanValidator<T> {
    final _logger = new Logger('beanvalidator.BeanValidator');

    BeanValidator() {
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

        final InstanceMirror instanceMirror = beanreflector.reflect(obj);
        final ClassMirror classMirror = instanceMirror.type;
        final String mirrorType = _getMirrorType(instanceMirror);
        final String simplename = classMirror.simpleName;

        _logger.fine("Object ${obj.toString()} reflected to: ${mirrorType}");
        _logger.fine("   SimpleName: $simplename");

        _addViolationInfos(obj, violationinfos,instanceMirror,classMirror,useKeyPrefix ? simplename : "");

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
            final String simplename = member.simpleName;

            _logger.fine("Instance: ${member}");
            _logger.fine("Simple-name: $simplename");
            _logger.fine("Qualified-name: ${member.qualifiedName}");

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
                member.metadata.forEach( (final element) {
                    _iterateThroughMetaData(simplename,element,member,obj,violationinfos,mirror,classMirror,keyPrefix);
                });
            }
        }
    }

    _iterateThroughMetaData(final String simplename,final element,final member,final obj, final Map<String,ViolationInfo> violationinfos,final InstanceMirror mirror,final ClassMirror classMirror,final String keyPrefix) {
        final isRegularMethod = (member is MethodMirror) ? (member as MethodMirror).isRegularMethod : false;

        _logger.fine("    Metadata: ${element} RT: ${element.runtimeType}");

        if(element is bv.VObject) {
            final bv.Constraint constraint = element as bv.Constraint;
            //final value = member;

            if(_isConstraintCheckOK(constraint,simplename,element,member,obj,violationinfos,mirror,keyPrefix)) {

                final value = isRegularMethod ? (mirror as InstanceMirror).invoke(simplename,[]) :
                (mirror as InstanceMirror).invokeGetter(simplename);

                final Map<String,ViolationInfo> test = _validate(value,useKeyPrefix: true);

                violationinfos.addAll(test);
                _logger.fine("           SubVioloationMap for ${member.simpleName} added");
            }

        } else if (element != null) {
            // ParentKlasse (Jede Konkrete ConstraintsKlasse hat Constraint als Parent (super-Klasse))
            final instanceParent = element;

            _logger.fine("           Parent: ${instanceParent}");
            _logger.fine("               isConstraint: ${instanceParent is bv.Constraint ? 'yes' : 'no'}");

            if (instanceParent is bv.Constraint) {
                final bv.Constraint constraint = instanceParent as bv.Constraint;
                _isConstraintCheckOK(constraint,simplename,element,member,obj,violationinfos,mirror,keyPrefix);
            }
        }

    }

    /// [simplename] ist z.B. username
    /// [element] Instance of 'EMail'
    /// [member] VariableMirrorImpl('VariableMirror on 'username'')
    /// [obj] Instance of 'UsernamePassword'
    /// [instanceMirror] _InstanceMirrorImpl('InstanceMirror on Instance of 'UsernamePassword'')
    /// [keyPrefix] ???
    ///
    bool _isConstraintCheckOK(final bv.Constraint constraint,final String simplename,final element,
        final member,final obj, final Map<String,ViolationInfo> violationinfos,
            final InstanceMirror instanceMirror,final String keyPrefix) {

        final isRegularMethod = (member is MethodMirror) ? (member as MethodMirror).isRegularMethod : false;

        _logger.fine("                - SimpleName: ${simplename}");
        _logger.fine("                - Element: ${element}");
        _logger.fine("                - Element-Reflectee: ${constraint}");
        _logger.fine("                - Member: ${member}");
        _logger.fine("                - Obj: ${obj}");
        _logger.fine("                - InstanceMirror: ${instanceMirror}");
        _logger.fine("                - Prefix: ${keyPrefix}");

        // Invokes a getter and returns a mirror on the result. The getter
        // can be the implicit getter for a field or a user-defined getter
        // method.
        if(instanceMirror != null && instanceMirror is InstanceMirror) {
            final field = member;
            final reflectee = field;
            final value = isRegularMethod ? (instanceMirror as InstanceMirror).invoke(simplename,[]) :
                (instanceMirror as InstanceMirror).invokeGetter(simplename);

            _logger.fine("                    - SimpleName: ${member.simpleName}");
            _logger.fine("                    - Field-Type: ${field.runtimeType}");
            _logger.fine("                    - Value: ${value}");

            // Wenn Value eine Funktion ist dann wird die Funktion selbst aufgerufen
            final bool matches = constraint.matches(value, { } );
            final String valueToCheckAgainst = constraint.valueToCheckAgainst;
            final L10N l10n = constraint.l10n;

            final InstanceMirror imAnnotation = bv.metareflector.reflect(element);
            final ClassMirror cmAnnotation = imAnnotation.type;

            final String violationKey = "$keyPrefix/$simplename/${cmAnnotation.simpleName}";

            _logger.fine("                        - Matches: " + (matches ? "yes" : "no"));
            _logger.fine("                        - ValueToCheckAgainst: $valueToCheckAgainst");
            _logger.fine("                        - ViolationKey: $violationKey");

            if(!matches) {
                final ViolationInfo violationinfo = new ViolationInfo(simplename,l10n,value,valueToCheckAgainst,obj);
                violationinfos[violationKey] = violationinfo;
                _logger.fine("                           - Key '$violationKey' added...");

            } else if(violationinfos.containsKey(violationKey)) {
                violationinfos.remove(violationKey);
                _logger.fine("                           - Key '$violationKey' removed...");
            }

            return matches;
        }

        return false;
    }
}