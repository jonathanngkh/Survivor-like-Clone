# Boilerplate class to get full autocompletion and type checks for the `BigGoblin` when coding the big goblin's states.
class_name BigGoblinState
extends State

# Typed reference to the BigGoblin node.
var biggoblin: BigGoblin

func _ready() -> void:
	# The states are children of the `Big Goblin` node so their `_ready()` callback will execute first. That's why we wait for the `owner` to be ready first.
	await owner.ready
	
	# The `as` keyword casts the `owner` variable to the `BigGoblin` type. If the `owner` is not a `BigGoblin`, we'll get `null`.
	biggoblin = owner as BigGoblin
	
	# This check will tell us if we inadvertently assign a derived state script in a scene other than `BigGoblin.tscn`, which would be unintended. This can help prevent some bugs that are difficult to understand.
	assert(biggoblin != null)
