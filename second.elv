# second.elv

# 1. Script arguments are in a list called $args. The first argument ($args[0])
#    is the JSON string from first.elv. Deserialize it into a map.
var received_map = (echo $args[0] | from-json)

# Send diagnostic output to stderr to avoid polluting stdout, which is used
# to return the final JSON data.
echo "--- Inside second.elv ---" >&2
echo "Map received from first.elv:" >&2
pprint $received_map >&2
echo "Value of key 'a': "(put $received_map[a]) >&2

# 2. Modify the map using chained 'assoc' calls.
# 'assoc' takes one key-value pair at a time, returning a new map.
echo "\nModifying the map (changing 'C', adding 'new_key')..." >&2
var temp_map = (assoc $received_map C 99)
var modified_map = (assoc $temp_map new_key "added in second.elv")

# 3. Serialize the MODIFIED map to JSON and print it to stdout.
echo "Final map in second.elv before returning:" >&2
pprint $modified_map >&2
echo "--- Exiting second.elv ---" >&2

# The final to-json output is the only thing printed to stdout.
echo $modified_map | to-json
