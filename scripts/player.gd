# 이 스크림트를 코드에서 Player 라는 타입 이름으로 참조할 수 있게 함.
class_name Player

# 위치 회전 신호, 충돌 감지 등
extends Area2D

# 플리에어의 움직임을 바깥에 알리는 신호
signal moved

# 1초에 움직일 픽셀
const SPEED := 260.0
# 회전속도
const ROTATION_SPEED := 12.0
# 화면 경계
const BOUNDARY_RADIUS := 22.0

# 화면 크기
var play_area_size := Vector2(800, 600)
var can_move := true

func _process(delta: float) -> void:
# {
	# 입력 처리		
	if not can_move:
		return
	
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	
	# 이동 방향으로 회전하기
	if input_direction == Vector2.ZERO:
		return
		
	var target_rotation := input_direction.angle() + PI / 2.0
	rotation = lerp_angle(
		rotation,
		target_rotation,
		min(1.0, ROTATION_SPEED * delta)
	)
	
	# 이동 방향으로 나아가기
	position += input_direction * SPEED * delta
	
	# 화면 경계 제한
	position = position.clamp(
		Vector2(BOUNDARY_RADIUS, BOUNDARY_RADIUS),
		play_area_size - Vector2(BOUNDARY_RADIUS, BOUNDARY_RADIUS)
	)
	
	# 이동 신호 추가
	moved.emit()
# } // _process

func reset(start_position: Vector2) -> void:
	position = start_position
	rotation = 0.0
	can_move = true
