extends Control


func _ready():
	$Label2.text = PlayerData.string

func _on_Button_pressed():
	get_tree().change_scene("res://src/scenes/loading.tscn")

func _on_TextureButton_pressed():
	get_tree().change_scene("res://src/ui/ui_scene/MainScreen.tscn")
