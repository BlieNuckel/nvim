; extends

; Function definitions with parameters: def foo(x, y)
(call
  target: ((identifier) @_keyword
    (#any-of? @_keyword "def" "defp" "defmacro" "defmacrop"))
  (arguments
    (call
      target: (identifier) @function.definition)))

; Function definitions without parameters: def foo
(call
  target: ((identifier) @_keyword
    (#any-of? @_keyword "def" "defp" "defmacro" "defmacrop"))
  (arguments
    . (identifier) @function.definition))

; Function definitions with guards: def foo when bar
(call
  target: ((identifier) @_keyword
    (#any-of? @_keyword "def" "defp" "defmacro" "defmacrop"))
  (arguments
    (binary_operator
      left: (call
        target: (identifier) @function.definition)
      operator: "when")))
