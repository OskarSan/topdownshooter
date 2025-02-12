extends CanvasLayer

@onready var fps_label: Label = $FPSLabel
@onready var ping_label: Label = $PingLabel
@onready var debug_label: Label = $DebugLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# update FPS
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	fps_label.text = "FPS: %d" % fps
	
	#update ping
	if multiplayer.multiplayer_peer and multiplayer.multiplayer_peer is ENetMultiplayerPeer:
		#var peer_id = multiplayer.get_unique_id()
		if multiplayer.is_server():
			ping_label.text = "Ping: host"
		else:
			# Clients get their ping to the server
			var packetPeer = multiplayer.get_multiplayer_peer().get_peer(1)
			#packetPeer = ENetPacketPeer, get_peer(1) gets the server maybe?
			ping_label.text = "Ping: %s ms" % packetPeer.get_statistic(3)
		
		debug_label.text = str(multiplayer.get_unique_id())
	else:
		ping_label.text = "Ping: N/A"
