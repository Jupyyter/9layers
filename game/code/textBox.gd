extends CanvasLayer

@onready var text_label: Label = $PanelContainer/MarginContainer/Label
@onready var timer: Timer = $Timer

var current_text: String = ""
var displayed_text: String = ""
var char_index: int = 0

func _ready() -> void:
	hide()
	timer.connect("timeout", _on_timer_timeout)

func show_text(text: String) -> void:
	current_text = text
	displayed_text = ""
	char_index = 0
	text_label.text = ""
	show()
	timer.start()

func _on_timer_timeout() -> void:
	if char_index < current_text.length():
		displayed_text += current_text[char_index]
		text_label.text = displayed_text
		char_index += 1
		timer.start()
	else:
		timer.stop()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and visible:
		if char_index < current_text.length():
			# Display all text immediately
			displayed_text = current_text
			text_label.text = displayed_text
			char_index = current_text.length()
			timer.stop()
		else:
			# Hide the textbox
			hide()