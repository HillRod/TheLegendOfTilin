extends Control

signal start_pressed
var is_listening: bool = false

func _ready():
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play("button_blink")
	is_listening = true

func _physics_process(delta):
	if Input.is_action_pressed("ui_accept") and is_listening:
		is_listening = false
		$AnimationPlayer.play_backwards("fade")
		yield($AnimationPlayer,"animation_finished")
		emit_signal("start_pressed")
		queue_free()
