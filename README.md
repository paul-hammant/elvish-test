Can an https://elv.sh/ script invoke a seeming separate elvish script with more than just string args?

Specifically, can a first elvish script have a first class dictionary that it can hand to the second:

```
first_class_dict = { "a" : "b", C: 2 }
second_elvish_script.sh "string arg 1" "string arg 2" $first_class_dict
```

And then is that pass by value or mutatable so that 'first elvish script` would see the changes

Jules: make a proof of concep right here.

Elvish_instal: `curl -so - https://dl.elv.sh/linux-amd64/elvish-v0.21.0.tar.gz | sudo tar -xzvC /usr/local/bin`
