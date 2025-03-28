extends CanvasLayer

@onready var fps_label: Label = $FPSLabel
@onready var ping_label: Label = $PingLabel
@onready var debug_label: Label = $DebugLabel
@onready var address_label: Label = $AddressLabel
@onready var packet_loss_label: Label = $PacketLossLabel
@onready var export_timer: Timer = $exportTimer


var network_data: Array = []
var is_client = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	print(multiplayer.is_server())
	if not multiplayer.is_server():
		is_client = true
		print(is_client)
		export_timer.wait_time = 5.0
		export_timer.start()
		export_timer.timeout.connect(_export_network_data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if is_client:
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
				var ping = packetPeer.get_statistic(3)  # PEER_ROUND_TRIP_TIME
				var packet_loss = (packetPeer.get_statistic(0) / 65536) * 100.0  # PEER_PACKETS_LOST
				var remote_port = packetPeer.get_remote_port()
				var player_id = multiplayer.get_unique_id()
				#packetPeer = ENetPacketPeer, get_peer(1) == the host
				#
				#get_statistic(3):
				#PEER_ROUND_TRIP_TIME = 3
				#Mean packet round trip time for reliable packets.
				#
				ping_label.text = "Ping: %s ms" % ping
				packet_loss_label.text = "Packet Loss %s%" % packet_loss
				address_label.text = str("port: %s" % remote_port)
				
				
				
			debug_label.text = str("id: %d" % multiplayer.get_unique_id())
		else:
			ping_label.text = "Ping: N/A"
			
func _export_network_data() -> void:
	if is_client and multiplayer.multiplayer_peer and multiplayer.multiplayer_peer is ENetMultiplayerPeer:
		
		var packetPeer = multiplayer.get_multiplayer_peer().get_peer(1)
		var ping = packetPeer.get_statistic(3)  # PEER_ROUND_TRIP_TIME
		var packet_loss_percent = (packetPeer.get_statistic(0) / 65536) * 100.0  # PEER_PACKETS_LOST
		var player_id = multiplayer.get_unique_id()

		# Append data to the network_data array
		
		
		network_data.append({
			"Client": player_id,
			"time": Time.get_ticks_msec(),
			"ping": ping,
			"packet_loss": packet_loss_percent,
		})



		# Export the network data to a JSON file
		var file = FileAccess.open("user://network_data.json", FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(network_data, "\t"))
			file.close()
			print("Data collected and saved to file")
		
	
