// RUN: %empty-directory(%t)

// RUN: mkdir %t/mods
// RUN: %{python} %utils/split_file.py -o %t %s

// RUN: %target-build-swift -module-name A -emit-module -o %t/mods/A.swiftmodule %t/a.swift
// RUN: %target-build-swift -module-name B -emit-module -o %t/mods/B.swiftmodule -I %t/mods %t/b.swift

// Replace A with an empty module so that all the decls are missing
// RUN: %target-build-swift -module-name A -emit-module -o %t/mods/A.swiftmodule %t/empty.swift

// RUN: %target-build-swift -module-name C -emit-module -o %t/mods/C.swiftmodule -I %t/mods -Xfrontend -experimental-allow-module-with-compiler-errors -index-store-path %t/idx %t/C.swift
// RUN: not --crash %target-swift-frontend -module-name C -emit-module -o %t/mods/C.swiftmodule -I %t/mods %t/C.swift

// BEGIN empty.swift

// BEGIN a.swift
public protocol ProtoA {}
public struct StructA {}
open class ClassA {}

// BEGIN b.swift

import A

public protocol ProtoB: ProtoA {}
public struct StructB: ProtoA {}
public class ClassB: ProtoA {}
public class InheritingClassB: ClassA {}

// BEGIN c.swift

import B

func useB(p: ProtoB, s: StructB, c: ClassB, i: InheritingClassB) {
  print("p:\(p) s:\(s) c:\(p) i:\(p)")
}

public protocol ProtoC: ProtoB {}
public protocol ClassC: ClassB {}
public protocol ClassC2: InheritingClassB {}
public struct AllAsMembers {
  let p: ProtoB
  let s: StructB
  let c: ClassB
  let i: InheritingClassB
}

extension ProtoB {
  func newProtoBMethod() {}
}
extension StructB {
  func newStructBMethod() {}
}
extension ClassB {
  func newClassBMethod() {}
}
extension InheritingClassB {
  func newInheritingClassBMethod() {}
}
