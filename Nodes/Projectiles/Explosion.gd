extends Sprite
export var itemdrop = "heart"
export var probDrop = 4
export var hasItem = false
func _ready():
	$Effects2.play("Det")
	yield($Effects2,"animation_finished")
	if hasItem:
		iGenerator.getItem(itemdrop,position,probDrop)
	queue_free()
