class_name Coin
extends Area2D
signal collected(collector: Area2D)

const RADIUS := 14.0

func set_active(active: bool) -> void:
	if active:
		show() # 엔진 제공 함수
	else:
		hide() # 엔진 제공 함수
	
	# monitoring: 다른 영역과 감지할지를 정하는 Area2D 속성
	# 엔진에서 제공하는 함수
	# 해당 (1)속성을 (2)다음 값으로 변경하도록 예약
	set_deferred("monitoring", active)
# end if set_active

func _on_area_entered(area: Area2D) -> void:
	collected.emit(area)
