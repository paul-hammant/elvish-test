# main.elv - The main script

# This tests if maps are passed by value or by reference.
use ./two/main

# Define a map
var my-map = [&a='b' &c=2]
echo "Original map in main.elv (before call):"
pprint $my-map

echo "\nCalling function from main module..."
# Call the function and capture the returned map
var returned-map = (main:process-map $my-map)

echo "Map returned from main:process-map:"
pprint $returned-map

echo "\nOriginal map in main.elv (after call):"
pprint $my-map
