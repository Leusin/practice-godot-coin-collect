class_name HUD
extends CanvasLayer

# 라벨 노드 가져오기	
@onready var score_label: Label = $TopPanel/Stats/ScoreLabel
@onready var time_label: Label = $TopPanel/Stats/TimeLabel
@onready var controls_hint_label: Label = $ControlsHintLabel
@onready var game_over_label: Label = $GameOverLabel

# 점수 애니메이션 변수
var score_tween: Tween

func reset(start_time: float) -> void:
	if score_tween:
		score_tween.kill()
		
	score_label.scale = Vector2.ONE
	update_score(0)
	update_time(start_time)
	controls_hint_label.show()
	game_over_label.hide()

func update_score(score: int) -> void:
	score_label.text = "Score: %d" % score

	
func update_time(time_left: float) -> void:
	time_label.text = "Time: %d" % ceili(time_left)

	
func hide_controls_hint() -> void:
	controls_hint_label.hide()

	
func show_game_over(final_score: int) -> void:
	var message := "Game Over\nFinal Score: %d\nPress R to Restart"
	game_over_label.text = message % final_score
	game_over_label.show()


func play_score_feedback() -> void:
	if score_tween:
		score_tween.kill()
		
	score_label.scale = Vector2(1.15, 1.15)
	score_tween = create_tween()
	score_tween.tween_property(score_label, "scale", Vector2.ONE, 0.12)
