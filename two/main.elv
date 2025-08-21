# lib.elv - A library of functions

# This function takes a map, prints it, modifies it, and returns the new map.
fn process-map {|m|
  echo "--- Inside lib:process-map ---" >&2
  echo "Received map:" >&2
  pprint $m >&2

  echo "\nModifying map..." >&2
  var new-map = (assoc $m 'new-key' 'added in lib')

  echo "Returning new map." >&2
  echo "--- Exiting lib:process-map ---\n" >&2

  put $new-map
}

# This block checks if the script is being run directly.
# It works by checking for the existence of the special '$args' variable,
# which is only defined when a script is the main entry point.
var is-main = (bool ?($args))
if $is-main {
  echo "--- Running two/main.elv directly ---"
  var empty-map = [&]
  echo "Created an empty map. Calling process-map..."
  var result = (process-map $empty-map)
  echo "Result from process-map:"
  pprint $result
}
