extends Node2D

@onready var dante: CharacterBody2D = $dante
@onready var lincon: RigidBody2D = $lincon
@onready var textbox: CanvasLayer = $textBox
var cutscene_triggered: bool = false
var cutscene_texts: Array = [
    "hey",
    "i am lincon the terribe",
    "you are about to die"
]
var current_text_index: int = 0
var waiting_for_input: bool = false
var cutscene_finished: bool = false

func _ready() -> void:
    pass

func _process(delta: float) -> void:
    if not cutscene_triggered and not cutscene_finished:
        var distance = dante.global_position.distance_to(lincon.global_position)
        if distance <= 200:
            start_cutscene()
    
    if waiting_for_input and Input.is_action_just_pressed("ui_accept"):
        waiting_for_input = false
        advance_cutscene()

func start_cutscene() -> void:
    cutscene_triggered = true
    dante.set_cutscene_state(true)  # Disable Dante's movement
    show_next_text()

func show_next_text() -> void:
    if current_text_index < cutscene_texts.size():
        textbox.show_text(cutscene_texts[current_text_index])
        current_text_index += 1
        waiting_for_input = true
    else:
        end_cutscene()

func advance_cutscene() -> void:
    if current_text_index < cutscene_texts.size():
        show_next_text()
    else:
        end_cutscene()

func end_cutscene() -> void:
    cutscene_triggered = false
    cutscene_finished = true
    current_text_index = 0
    textbox.hide()
    dante.set_cutscene_state(false)  # Re-enable Dante's movement
    print("Cutscene ended")  # Debug message