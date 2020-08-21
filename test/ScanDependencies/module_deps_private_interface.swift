// RUN: %empty-directory(%t)
// RUN: mkdir -p %t/clang-module-cache
// RUN: echo "// swift-interface-format-version: 1.0" > %t/Foo.swiftinterface
// RUN: echo "// swift-module-flags: -module-name Foo" >> %t/Foo.swiftinterface
// RUN: echo "public func foo() {}" >> %t/Foo.swiftinterface

// RUN: cp %t/Foo.swiftinterface %t/Foo.private.swiftinterface

// RUN: %target-swift-frontend -scan-dependencies -module-cache-path %t/clang-module-cache %s -o %t/deps.json -I %t -disable-implicit-swift-modules -Xcc -Xclang -Xcc -fno-implicit-modules

// Check the contents of the JSON output
// RUN: %FileCheck %s < %t/deps.json

import Foo

// CHECK: "moduleInterfacePath": "{{.*}}Foo.private.swiftinterface",