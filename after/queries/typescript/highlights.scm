; extends

; Type alias definitions: type Foo = ...
(type_alias_declaration
  name: (type_identifier) @type.definition)

; Interface definitions: interface Foo { ... }
(interface_declaration
  name: (type_identifier) @type.definition)

; Enum definitions: enum Foo { ... }
(enum_declaration
  name: (identifier) @type.definition)

; Class definitions: class Foo { ... }
(class_declaration
  name: (type_identifier) @type.definition)

; Function definitions: function foo() { ... }
(function_declaration
  name: (identifier) @function.definition)

; Method definitions in classes/objects
(method_definition
  name: (property_identifier) @function.definition)

; Variable definitions: const foo = ..., let bar = ..., var baz = ...
(variable_declarator
  name: (identifier) @variable.definition)
