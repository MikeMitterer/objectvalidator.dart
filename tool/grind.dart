import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task()
@Depends(analyze, testUnit)
test() {
}

@Task()
testUnit() {
    new TestRunner().testAsync(files: "test/unit");

    // Alle test mit @TestOn("content-shell") im header
    new TestRunner().test(files: "test/unit",platformSelector: "chrome");
}

@Task()
analyze() {
    final List<String> libs = [
        "lib/beanvalidator.dart",
        "lib/constraints.dart"
    ];

    libs.forEach((final String lib) => Analyzer.analyze(lib));
    Analyzer.analyze("test");
}

//@DefaultTask()
//@Depends(test)
//build() {
//  Pub.build();
//}

@Task()
clean() => defaultClean();
