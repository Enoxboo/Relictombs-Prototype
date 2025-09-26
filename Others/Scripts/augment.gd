extends Resource
class_name Augment

enum Element { None, Fire, Water, Wind, Earth }

@export var id: String
@export var augment_name: String
@export var description: String
@export var element: Element
@export var scene_reference: PackedScene
