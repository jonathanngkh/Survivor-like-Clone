# Boilerplate class to get full autocompletion and type checks for the `RogueGoblin` when coding the rogue goblin's states.
class_name RogueGoblinState
extends State

# Typed reference to the RogueGoblin node.
var roguegoblin: RogueGoblin

func _ready() -> void:
	# The states are children of the `Rogue Goblin` node so their `_ready()` callback will execute first. That's why we wait for the `owner` to be ready first.
	await owner.ready
	
	# The `as` keyword casts the `owner` variable to the `RogueGoblin` type. If the `owner` is not a `RogueGoblin`, we'll get `null`.
	roguegoblin = owner as RogueGoblin
	
	# This check will tell us if we inadvertently assign a derived state script in a scene other than `RogueGoblin.tscn`, which would be unintended. This can help prevent some bugs that are difficult to understand.
	assert(roguegoblin != null)
