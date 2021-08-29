extends KinematicBody2D

export var DAMAGE = 1
onready var aniP = $AnimationPlayer

func _ready():
	scale =Vector2(0.6,0.6)
