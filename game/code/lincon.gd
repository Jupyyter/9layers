extends RigidBody2D

@export var interaction_text: String = "Default interaction text"

func get_text() -> String:
	return interaction_text