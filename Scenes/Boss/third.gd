extends State

@export
var clone_cleaveL_state: State
var time_waited = 0.0

func enter() -> void:
	super()
	#parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	return null
	
func process_frame(delta: float) -> State:
	return null
