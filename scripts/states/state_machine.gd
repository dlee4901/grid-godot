extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(_on_state_transition)

func _process(delta):
	if current_state:
		current_state.update(delta)

func _on_state_transition(old: String, new: String):
	print("state_transition: ", old, " -> ", new)
	if old != current_state.name:
		return
	var new_state = states.get(new)
	if not new_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state

func init():
	if initial_state:
		initial_state.enter()
		current_state = initial_state
