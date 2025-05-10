extends Node2D


@onready var label: Label = $Label

const base_text = "[E] to "

var player = null
var active_areas = []
var can_interact = true

func _ready():
	# Connect to the player_added signal from the MultiplayerTest node
	var multiplayer_test = get_tree().get_root().get_node("World/MultiplayerTest")  # Adjust the path if necessary
	multiplayer_test.connect("player_added", Callable(self, "_on_player_added"))

func _on_player_added(new_player):
	player = new_player
	print("Player added to InteractionManager:", player)

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(delta):

	if active_areas.size() > 0 && can_interact:
	
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 16
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()
		

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			active_areas[0].interact.call()
			
			can_interact = true
			
		
			
