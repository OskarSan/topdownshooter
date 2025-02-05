extends Node2D


var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

@onready var host_button: Button = $Host
@onready var join_button: Button = $Join

func _ready():
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_host_pressed() -> void:
	host_button.hide()
	join_button.hide()
	peer.create_server(3000)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	
func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)


func _on_join_pressed() -> void:
	host_button.hide()
	join_button.hide()
	peer.create_client("localhost", 3000)
	multiplayer.multiplayer_peer = peer
	
	
func _on_peer_disconnected(id: int):
	var player_name = str(id)
	if has_node(player_name):
		var player = get_node(player_name)
		player.queue_free()
	
