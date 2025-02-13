extends CanvasLayer

@onready var fps_label: Label = $FPSLabel
@onready var ping_label: Label = $PingLabel
@onready var debug_label: Label = $DebugLabel
@onready var address_label: Label = $AddressLabel

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
			#packetPeer = ENetPacketPeer, get_peer(1) == the host
			#
			#get_statistic(3):
			#PEER_ROUND_TRIP_TIME = 3
			#Mean packet round trip time for reliable packets.
			#
			ping_label.text = "Ping: %s ms" % packetPeer.get_statistic(3)
			address_label.text = str("port: %s" % packetPeer.get_remote_port())
		
		debug_label.text = str("id: %d" % multiplayer.get_unique_id())
	else:
		ping_label.text = "Ping: N/A"
