extends Node

const AUGMENT_FOLDER: String = "res://Spells/Resources/"
var all_augments: Array[Augment]
var available_augments: Array[Augment]

func _ready() -> void:
	all_augments = get_all_augments_in_folder(AUGMENT_FOLDER)
	available_augments = all_augments

func get_all_augments_in_folder(path: String) -> Array[Augment]:
	var augments: Array[Augment] = []
	var dir = DirAccess.open(path)
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		augments.append(load(path + "/" + file_name))
		file_name = dir.get_next()
	
	return augments

func get_random_augments(count: int) -> Array[Augment]:
	available_augments.shuffle()
	return available_augments.slice(0, count)
