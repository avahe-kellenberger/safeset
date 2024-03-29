import
  nimtest,
  safeset,
  sequtils,
  hashes,
  sets

var i: int = 0

type Foo = object
  id: int
  children: SafeSet[Foo]

proc newFoo(): Foo =
  result = Foo(id: i, children: newSafeSet[Foo]())
  inc i

proc hash*(f: Foo): Hash =
  hash(f.id)

describe "SafeSet":

  describe "add":
    it "adds an element to the set":
      let safeset = newSafeSet[string]()
      safeset.add("foobar")
      assertEquals(safeset.len, 1)

      for item in safeset:
        assertEquals(item, "foobar")

    it "adds an element to the set during iteration":
      let safeset = newSafeSet[string]()
      safeset.add("foobar")
      assertEquals(safeset.len, 1)

      for item in safeset:
        safeset.add("barbaz")
      
      assertEquals(safeset.len, 2)

  describe "remove":
    it "removes an element remove the set":
      let safeset = newSafeSet[string]()
      safeset.add("foobar")
      assertEquals(safeset.len, 1)

      for item in safeset:
        assertEquals(item, "foobar")

      safeset.remove("foobar")
      assertEquals(safeset.len, 0)

    it "removes an element remove the set during iteration":
      let safeset = newSafeSet[string]()
      safeset.add("foobar")
      assertEquals(safeset.len, 1)

      for item in safeset:
        safeset.remove("foobar")

      assertEquals(safeset.len, 0)

  describe "add and remove during iteration":
    it "remove then add":
      let safeset = newSafeSet[string]()
      const elem = "foobar"
      safeset.add(elem)
      assertEquals(safeset.len, 1)

      for item in safeset:
        safeset.remove(elem)
        safeset.add(elem)

      assertEquals(safeset.len, 1)

    it "double loops":
      let safeset = newSafeSet[string]()
      const elem = "foobar"
      safeset.add(elem)
      assertEquals(safeset.len, 1)

      for item in safeset:
        safeset.add("aoeu")

      safeset.add("something")

      for item in safeset:
        safeset.add("htns")

      let items = safeset.items.toSeq()
      assertEquals(
        items,
        @["foobar", "aoeu", "something", "htns"]
      )

  describe "contains":

    it "reports when a safeset contains an element properly":
      let
        parent = newFoo()
        child = newFoo()

      assertEquals(parent.children.contains(child), false)

      parent.children.add(child)
      assertEquals(parent.children.contains(child), true)

