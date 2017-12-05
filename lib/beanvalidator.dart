/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// Validation-Check für PODOs
///
///     @beanreflector
///     class UsernamePassword {
///
///         @EMail(message: const L10N( "{{value}} is not a valid eMail address"))
///         String username;
///
///         @Password(message: const L10N( "{{value}} is not a valid password"))
///         final String password;
///
///         UsernamePassword(this.username, this.password);
///     }
///
///     main() {
///         final UsernamePassword userpassword = new UsernamePassword("office@mikemitterer.at", "12345678aA#");
///         final BeanValidator<UsernamePassword> beanValidator = new BeanValidator<UsernamePassword>();
///         List<ViolationInfo> violationinfos = beanValidator.validate(userpassword);
///     }
///
library beanvalidator;

import 'dart:collection';

import 'package:beanvalidator/constraints.dart' as bv;
import 'package:l10n/l10n.dart';
import 'package:logging/logging.dart';
import 'package:reflectable/reflectable.dart';
import 'package:validate/validate.dart';

export 'package:beanvalidator/constraints.dart';

part 'beanvalidator/BeanValidator.dart';
part 'beanvalidator/ViolationException.dart';
part 'beanvalidator/ViolationInfo.dart';

class BeanReflector extends Reflectable {
    const BeanReflector()
        : super(
            declarationsCapability, // Recommendation http://goo.gl/OlUri0
            instanceInvokeCapability,
            metadataCapability,
            reflectedTypeCapability,
            superclassQuantifyCapability,
            typeRelationsCapability
    );
}

const BeanReflector beanreflector = const BeanReflector();



