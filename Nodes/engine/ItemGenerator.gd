extends Node
const items = {
	"heart": "res://Nodes/Items/LifeUp.tscn",
	"bazooka": "res://Nodes/Items/LifeUp.tscn",
	"AK-47": "res://Nodes/Items/LifeUp.tscn",
	"Pala": "res://Nodes/Items/LifeUp.tscn",
	"Pichula": "res://Nodes/Items/LifeUp.tscn",
}

func _ready():
	randomize()
	#getItem("random",Vector2(50,50),5)

func getItem(itemName,pos,randProb):
	if randi() % randProb == 0:
		if itemName == "random":
			var randItem = items.keys()
			randItem = randItem[randi() % randItem.size()]
			itemName = randItem
		if itemName in items:
			print(itemName)
			var _item = load(items.get(itemName)).instance()
			_item.position = pos
			get_tree().get_nodes_in_group("itemField")[0].add_child(_item)
	else:
		print("nel")
