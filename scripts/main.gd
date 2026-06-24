extends Node2D

const SCREEN_SIZE := Vector2(800, 600)
const PLAYER_BOUNDARY_RADIUS := 22.0
const COIN_RADIUS := 14.0
const COIN_MARGIN := 28.0
const HUD_SAFE_HEIGHT := 72.0
const MIN_COIN_DISTANCE := PLAYER_BOUNDARY_RADIUS + COIN_RADIUS + 36.0
const MAX_COIN_SPAWN_ATTEMPTS := 12

@onready var player = $Player
@onready var coin = $Coin
@onready var hud = $HUD

@onready var game_timer: Timer = $GameTimer
@onready var pickup_audio: AudioStreamPlayer2D = $PickupAudio
@onready var game_over_audio: AudioStreamPlayer2D = $GameOverAudio

var score := 0
var is_game_over := false
var random := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random.randomize()
	player.moved.connect(hud.hide_controls_hint)
	coin.collected.connect(_on_coin_collected)
	game_timer.timeout.connect(_on_game_timer_timeout)
	_start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		_start_game()
	
	if is_game_over:
		return
	
	hud.update_time(game_timer.time_left)


func _start_game() -> void:
	score = 0
	is_game_over = false
	pickup_audio.stop()
	game_over_audio.stop()
	player.play_area_size = SCREEN_SIZE
	player.reset(SCREEN_SIZE / 2.0)
	coin.set_active(true)
	hud.reset(game_timer.wait_time)
	game_timer.start()
	_spawn_coin()


func _spawn_coin() -> void:
	var next_position := _random_coin_position()
	
	for _attempt in range(MAX_COIN_SPAWN_ATTEMPTS):
		if next_position.distance_to(player.position) >= MIN_COIN_DISTANCE:
			break
			
		next_position = _random_coin_position()
	coin.position = next_position	


func _random_coin_position() -> Vector2:
	return Vector2(
		random.randf_range(COIN_MARGIN, SCREEN_SIZE.x - COIN_MARGIN),
		random.randf_range(HUD_SAFE_HEIGHT, SCREEN_SIZE.y - COIN_MARGIN)
	)


func _on_coin_collected(collector: Area2D) -> void:
	if collector != player or is_game_over:
		return
	
	score += 1
	hud.update_score(score)
	hud.play_score_feedback()
	pickup_audio.stop()
	pickup_audio.play()
	_spawn_coin()


func _on_game_timer_timeout() -> void:
	is_game_over = true
	player.can_move = false
	coin.set_active(false)
	hud.update_time(0)
	hud.show_game_over(score)
	game_over_audio.play()
