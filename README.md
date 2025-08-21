# Elvish Script Map Passing Proof-of-Concept

This repository demonstrates how to pass a complex data structure (a map, or dictionary) from one Elvish script to another.

The core problem is that Elvish scripts run in separate processes and do not share memory. Therefore, you cannot directly pass a map variable from one script to another. The solution demonstrated here is to use **serialization**.

The process is as follows:
1.  The calling script (`first.elv`) serializes its map into a standardized string format (JSON).
2.  The JSON string is passed as a command-line argument to the called script (`second.elv`).
3.  The called script deserializes the JSON string back into a map data structure.
4.  To "return" a modified map, the called script serializes its new map to JSON and prints it to its standard output.
5.  The calling script captures the standard output and deserializes it to get the final, modified map.

This demonstrates a **pass-by-value** data exchange. The second script operates on a copy of the data, and any changes must be explicitly passed back to the caller.

## Included Scripts

-   `first.elv`: The main script that initiates the process.
-   `second.elv`: The script that receives the data, modifies it, and returns it.

## Invocation

To run the proof-of-concept, execute the `first.elv` script:

```sh
elvish ./first.elv
```

## Expected Output

When you run the script, you will see output from both `first.elv` (on standard output) and `second.elv` (diagnostic messages on standard error). The output demonstrates the entire process:

```
 Original map in first.elv:
[
 &C=	2
 &a=	b
]

Calling second.elv and passing the map as a JSON string...

Map returned from second.elv and deserialized in first.elv:
'[&C=99 &a=b &new_key=''added in second.elv'']'
 --- Inside second.elv ---
Map received from first.elv:
[
 &C=	2
 &a=	b
]
Value of key 'a': b

Modifying the map (changing 'C', adding 'new_key')...
Final map in second.elv before returning:
[
 &C=	99
 &a=	b
 &new_key=	'added in second.elv'
]
--- Exiting second.elv ---
```

### Output Analysis

-   **Original map in first.elv**: Shows the initial state of the map in the calling script.
-   **--- Inside second.elv ---**: These messages (from stderr) show what is happening inside the called script. You can see it receives the original map, reads a value from it, and then creates a modified version.
-   **Map returned from second.elv...**: This is the final output from the calling script, showing that it has successfully received the modified map that was returned from the second script.
