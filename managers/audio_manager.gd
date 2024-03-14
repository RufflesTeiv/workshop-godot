extends Node

const base_stream_players := 5
var audio_players_pool : Array[AudioStreamPlayer] = []

## Event functions
func _ready():
	for i in range(base_stream_players):
		_instantiate_new_audio_player()
	
## Public functions	
func play_audio(stream: AudioStream, volume := 0.0) -> AudioStreamPlayer:
	var player = await _get_audio_player()
	player.stream = stream
	player.volume_db = volume
	player.play()
	return player
	
## Private functions
func _get_audio_player() -> AudioStreamPlayer:
	# Await next frame for no sound overlap
	await get_tree().process_frame
	
	# Get audio player
	for player in audio_players_pool:
		if !player.playing && !player.stream_paused:
			return player
	return _instantiate_new_audio_player()

func _instantiate_new_audio_player() -> AudioStreamPlayer:
	var stream_player = AudioStreamPlayer.new()
	add_child(stream_player)
	audio_players_pool.append(stream_player)
	return stream_player
