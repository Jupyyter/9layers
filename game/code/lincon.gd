extends RigidBody2D

@export var interaction_text: String = "Default interaction text"
@onready var detection_area: Area2D = $DetectionArea

func _ready():
    # Ensure the Area2D is set up correctly
    if not detection_area:
        push_error("DetectionArea node not found in Lincon. Please add an Area2D child node.")

func get_text() -> String:
    return interaction_text