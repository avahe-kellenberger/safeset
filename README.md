# SafeSet

SafeSet is a HashSet implementation that allows the users to safely add and remove elements while iterating.

It is not designed to be thread-safe.

## Examples

See `tests/safeset_test.nim` for more comprehensive examples.

```nim
let safeset = newSafeSet[string]()
safeset.add("foobar")
assert(safeset.len == 1)

for item in safeset:
  safeset.remove("foobar")

assert(safeset.len == 0)
```

