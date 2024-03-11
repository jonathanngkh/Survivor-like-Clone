# Boilerplate class to get full autocompletion and type checks for the `SpellGoblin` when coding the pell goblin's states.
class_name SpellGoblinState
extends State

# Typed reference to the SpellGoblin node.
var spellgoblin: SpellGoblin

func _ready() -> void:
	# The states are children of the `Spell Goblin` node so their `_ready()` callback will execute first. That's why we wait for the `owner` to be ready first.
	await owner.ready
	
	# The `as` keyword casts the `owner` variable to the `SpellGoblin` type. If the `owner` is not a `SpellGoblin`, we'll get `null`.
	spellgoblin = owner as SpellGoblin
	
	# This check will tell us if we inadvertently assign a derived state script in a scene other than `SpellGoblin.tscn`, which would be unintended. This can help prevent some bugs that are difficult to understand.
	assert(spellgoblin != null)
