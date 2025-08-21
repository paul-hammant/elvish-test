# first.elv

# 1. Define a map (dictionary)
var first_class_dict = [&a="b" &C=2]
echo "Original map in first.elv:"
pprint $first_class_dict

# 2. Serialize the map to JSON and pass it to the second script.
#    Use 'put' to place the map value into the pipeline for to-json.
#    The output of second.elv (a modified JSON string) is captured in a variable.
echo "\nCalling second.elv and passing the map as a JSON string..."
var modified_map_json = (elvish ./second.elv (put $first_class_dict | to-json))

# 3. Deserialize the returned JSON string and display the resulting map.
#    This demonstrates that the modified data has been passed back to the first script.
echo "\nMap returned from second.elv and deserialized in first.elv:"
var modified_map = (echo $modified_map_json | from-json)
pprint $modified_map
