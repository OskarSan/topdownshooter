extends Node2D


var peer = ENetMultiplayerPeer.new()
var port = null
@export var player_scene: PackedScene

@onready var host_button: Button = $Host
@onready var join_button: Button = $Join
@onready var port_input: LineEdit = $PortInput
@onready var ip_input: LineEdit = $IpInput



func _ready():
	if DisplayServer.get_name() == "headless":
		print("Running in headless mode. Creating server automatically...")
		create_server(1234)
	else:
		print("Not running in headless mode. Waiting for user input.")
	port_input.placeholder_text = "Port"
	ip_input.placeholder_text = "IP Address"
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func create_server(port: int):
	self.port = port
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)

func _on_host_pressed() -> void:
	host_button.hide()
	join_button.hide()
	port_input.hide()
	ip_input.hide()
	var result = peer.create_server(3000)
	if result != OK:
        print_error("Error creating server on port 3000: %s" % result)
        return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())
	print("Hosting game on port 3000")

func add_player(peer_id):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	add_child(player)

func _on_join_pressed() -> void:
	host_button.hide()
	join_button.hide()
	port_input.hide()
	ip_input.hide()
	var server_port = int(port_input.get_text())
	
	var server_ip = ip_input.get_text()
	if(server_ip == null):
		server_ip = "localhost"
	
	var result = peer.create_client(server_ip, int(port_input.get_text()))
	if result != OK:
		print("Error connecting to server at %s:%d: %s" % [server_ip, server_port, result])
		return
	multiplayer.multiplayer_peer = peer
	print("Connected to server at %s:%d" % [server_ip, server_port])


func _on_peer_disconnected(id: int):
	var player_name = str(id)
	if has_node(player_name):
		var player = get_node(player_name)
		player.queue_free()
	
