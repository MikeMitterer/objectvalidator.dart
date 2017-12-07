//@TestOn("content-shell")
import 'package:test/test.dart';

import 'package:reflectable/reflectable.dart';
// import 'package:logging/logging.dart';

// Annotate with this class to enable reflection.
class Reflector extends Reflectable {
    const Reflector()
        : super(
            invokingCapability,metadataCapability, declarationsCapability
        );
}

const reflector = const Reflector();

class MetaReflector extends Reflectable {
    const MetaReflector()
        : super(metadataCapability,subtypeQuantifyCapability, declarationsCapability );
}
const metareflector = const MetaReflector();

@metareflector
class MyAnnotation {
    final String name;
    const MyAnnotation(this.name);
}

class MyExtendedAnnotation extends MyAnnotation {
  const MyExtendedAnnotation(String name) : super(name);
}

@reflector // This annotation enables reflection on A.
class A {
    final int a;
    A(this.a);

    int valueFunction() => a;
    int get value => a;

    @MyAnnotation("James Bond")
    String nameFunction() => "Mike";

    @MyExtendedAnnotation("Wolverine")
    String nameFunction2() => "Mike";

}

main() async {
    // final Logger _logger = new Logger("test.Reflectable");
    // configLogging();
    
    //await saveDefaultCredentials();

    group('Reflectable', () {
        setUp(() { });

        test('> InstanceMirror', () {
            final A a = new A(10);
            final InstanceMirror im = reflector.reflect(a);

            expect(im.invoke("valueFunction",[]),10);
            expect(im.invokeGetter("value"),10);
        }); // end of 'InstanceMirror' test

        test('> ClassMirror', () {
            final A a = new A(10);
            final InstanceMirror im = reflector.reflect(a);
            final ClassMirror cm = im.type;

            expect(cm,new isInstanceOf<ClassMirror>());
            expect(cm.simpleName,"A");
        }); // end of 'ClassMirror' test

        test('> Annotation', () {
            final A a = new A(10);
            final InstanceMirror im = reflector.reflect(a);
            final ClassMirror cm = im.type;

            Map<String, MethodMirror> instanceMembers = cm.instanceMembers;
            expect(instanceMembers.keys.contains("valueFunction"),isTrue);
            expect(instanceMembers.keys.contains("value"),isTrue);
            expect(instanceMembers.keys.contains("nameFunction"),isTrue);

            final MethodMirror mm = instanceMembers["nameFunction"];
            expect(mm.isRegularMethod,isTrue);

            expect(mm.metadata.length,1);

            final x = mm.metadata.first;
            expect(x,new isInstanceOf<MyAnnotation>());
            expect((x as MyAnnotation).name,"James Bond");

            final InstanceMirror imAnnotation = metareflector.reflect(x);
            final ClassMirror cmAnnotation = imAnnotation.type;

            expect(cmAnnotation.simpleName,"MyAnnotation");
        }); // end of 'Annotation' test

        test('> Inherited Annotation', () {
            final A a = new A(10);
            final InstanceMirror im = reflector.reflect(a);
            final ClassMirror cm = im.type;

            Map<String, MethodMirror> instanceMembers = cm.instanceMembers;
            expect(instanceMembers.keys.contains("nameFunction2"),isTrue);

            final MethodMirror mm = instanceMembers["nameFunction2"];
            expect(mm.isRegularMethod,isTrue);

            expect(mm.metadata.length,1);

            final x = mm.metadata.first;
            expect(x,new isInstanceOf<MyExtendedAnnotation>());
            expect((x as MyExtendedAnnotation).name,"Wolverine");

            final InstanceMirror imAnnotation = metareflector.reflect(x);
            final ClassMirror cmAnnotation = imAnnotation.type;

            expect(cmAnnotation.simpleName,"MyExtendedAnnotation");
        }); // end of 'Inherited Annotation' test


    });
    // End of 'Reflectable' group
}

// - Helper --------------------------------------------------------------------------------------
