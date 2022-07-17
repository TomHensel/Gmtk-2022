extends Control


func _ready():
	$CanvasLayer/VBoxContainer/VolumeSlider.grab_focus()
	$CanvasLayer/VBoxContainer/VolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))



func _on_ReturnButton_pressed():
	get_tree().change_scene("res://Scenes/Menu/Menu.tscn")


func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
