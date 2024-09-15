extends Control

@onready var label = $Panel/Label
var text_speed = 0.05
var current_text = ""

func _ready():
    hide()

func show_text(text):
    current_text = text
    label.text = ""
    show()
    for char in text:
        label.text += char
        await get_tree().create_timer(text_speed).timeout

func _input(event):
    if event.is_action_pressed("ui_accept") and visible:
        hide()