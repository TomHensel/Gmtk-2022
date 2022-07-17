extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/VBoxContainer/StartButton.grab_focus()
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -15)



func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/Level/testLevel.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://Scenes/Menu/Options.tscn")
