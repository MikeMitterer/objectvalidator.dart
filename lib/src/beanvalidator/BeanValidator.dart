part of beanvalidator;

class BeanValidator<T> {
    final _logger = new Logger('beanvalidator.BeanValidator');

    BeanValidator() {
    }

    List<ViolationInfo<T>> validate(final T obj) {
        Validate.notNull(obj);

        final List<ViolationInfo<T>> violationinfos = new List<ViolationInfo<T>>();

        final mirror = reflect(obj);
        final ClassMirror classMirror = mirror.type;
        final String mirrorType = _getMirrorType(mirror);

        _logger.info("Object ${obj.toString()} reflected to: ${mirrorType}");


        for (var member in classMirror.declarations.values) {
            final String simplename = MirrorSystem.getName(member.simpleName);

            _logger.info("Instance: ${member}");
            _logger.info("Simple-name: $simplename");
            _logger.info("Qualified-name: ${MirrorSystem.getName(member.qualifiedName)}");

            bool isGetter = false;
            if(member is MethodMirror) {
                final MethodMirror methodmirror = member as MethodMirror;
                isGetter = methodmirror.isGetter;
            }
            _logger.info("isGetter: $isGetter");

            if (member.metadata.length > 0) {
                member.metadata.forEach((final InstanceMirror element) {
                    _logger.info("    Metadata: ${element}");

                    if (element.hasReflectee) {
                        // ParentKlasse (Jede Konkrete ConstraintsKlasse hat Constraint als Parent (super-Klasse))
                        final instanceParent = element.reflectee;
                        _logger.info("           Parent: ${instanceParent}");
                        _logger.info("               isConstraint: ${instanceParent is Constraint ? 'yes' : 'no'}");

                        if (instanceParent is Constraint) {
                            final Constraint constraint = instanceParent as Constraint;

                            // Invokes a getter and returns a mirror on the result. The getter
                            // can be the implicit getter for a field or a user-defined getter
                            // method.
                            if(mirror != null && mirror is InstanceMirror) {
                                final value = mirror.getField(member.simpleName).reflectee;
                                final bool matches = constraint.matches(value, { } );
                                final L10N l10n = constraint.l10n;

                                _logger.info("               Value: ${value}");
                                _logger.info("                   Matches: " + (matches ? "yes" : "no"));

                                if(!matches) {
                                    final ViolationInfo<T> violationinfo = new ViolationInfo<T>(simplename,l10n,value,obj);
                                    violationinfos.add(violationinfo);
                                }
                            }
                        }
                    }
                });
            }
        }

        return violationinfos;
    }

    // -- private -------------------------------------------------------------

    String _getMirrorType(final mirror) {
        return mirror.runtimeType.toString().replaceAll("_Local","");
    }

}
