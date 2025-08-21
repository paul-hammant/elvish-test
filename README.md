# Passing Data Between Elvish Scripts

This repository explores two methods for passing data (specifically, a map) from one Elvish script to another, answering the question of whether Elvish has special, in-process mechanisms for doing so.

The conclusion is **yes**, Elvish's module system allows for passing data structures directly between scripts running in the same process, which avoids the need for serialization.

---

## Method 1: The Elvish-Native Module System (Recommended)

This is the ideal method for communication between Elvish scripts. It involves treating one script as a **module** (a library) and importing it into the main script. This causes all the code to run in the **same process**, allowing for direct passing of Elvish data types.

The key concepts are:
- **`use` command:** Imports an Elvish script as a module. Our proof-of-concept shows that you can use a relative path (e.g., `use ./lib`) to load a module from the current directory.
- **Functions:** The module exposes functions that can be called by the main script.
- **Direct Data Passing:** You can pass maps, lists, and other Elvish types directly to the module's functions as arguments. No serialization is needed.
- **Pass-by-Value:** The proof-of-concept also demonstrates that maps are immutable and effectively passed by value. The `assoc` command, used for modification, returns a *new* map, leaving the original unchanged. To see changes, the caller must use the returned value.

### Proof-of-Concept Scripts

-   `main.elv`: The main script. It imports `lib.elv`, calls a function from it, and passes a map directly.
-   `lib.elv`: The library module. It defines a function that accepts, modifies, and returns a map.

### Invocation

```sh
elvish ./main.elv
```

### Expected Output

```
 Original map in main.elv (before call):
[
 &a=	b
 &c=	2
]

Calling function from lib.elv module...
Map returned from lib:process-map:
[
 &a=	b
 &c=	2
 &new-key=	'added in lib'
]

Original map in main.elv (after call):
[
 &a=	b
 &c=	2
]
 --- Inside lib:process-map ---
Received map:
[
 &a=	b
 &c=	2
]

Modifying map...
Returning new map.
--- Exiting lib:process-map ---
```
The output shows the original map in `main.elv` is unaffected by the function call, confirming pass-by-value behavior.

---

## Method 2: Standard `exec` with JSON Serialization

This is the traditional POSIX-style method, which works for communication between any two programs, not just Elvish-to-Elvish. It involves running the second script as a **separate process** and passing data via command-line arguments and standard output.

The process is:
1.  The calling script (`first.elv`) serializes its map into a JSON string.
2.  It executes the second script (`second.elv`), passing the JSON string as a command-line argument. This launches a new `execve` process.
3.  The second script deserializes the JSON, modifies the map, and prints the *new* map back to its standard output as a JSON string.
4.  The first script captures this standard output and deserializes it to get the modified map.

This method is more universal but also more cumbersome, as it requires explicit serialization and deserialization. The original `first.elv` and `second.elv` scripts that implemented this have been removed from the repository in favor of the superior module-based approach.

---

## Conclusion: A Feature Request

The investigation in this repository concluded that while Elvish's module system is powerful for in-process code sharing, it currently lacks two features that would enable more advanced patterns:

1.  A mechanism for a script to know if it's being run directly (like Python's `if __name__ == '__main__'`).
2.  A mechanism for passing data structures by reference to allow for mutation.

A feature request has been filed with the Elvish development team to track these ideas. You can follow the discussion here:

-   [GitHub Issue #1906: Feature Request: Adaptive Scripts and Pass-by-Reference Arguments](https://github.com/elves/elvish/issues/1906)
