extends CharacterBody2D

const MAX_SPEED = 300.0
const JUMP_VELOCITY = 350.0
const ACCELERATION = 10.0
const FRICTION = 10.0

var current_interactable: RigidBody2D = null
var in_cutscene: bool = false
var currentSpeed: float = 0.0

@onready var interaction_area: Area2D = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	interaction_area.connect("body_entered", Callable(self, "_on_interaction_area_body_entered"))
	interaction_area.connect("body_exited", Callable(self, "_on_interaction_area_body_exited"))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not in_cutscene:
		if Input.is_action_just_pressed("ui_accept") and current_interactable:
			interact()
		
		# Jumping
		if Input.is_action_pressed("ui_up") and is_on_floor():
			velocity.y = -JUMP_VELOCITY
		
		# Horizontal movement
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			# Apply acceleration in the given direction
			currentSpeed += direction * ACCELERATION
			# Clamp currentSpeed between -MAX_SPEED and MAX_SPEED
			currentSpeed = clamp(currentSpeed, -MAX_SPEED, MAX_SPEED)
			velocity.x = currentSpeed
			
			# Flip sprite based on direction
			sprite.flip_h = direction < 0
			animation_player.play("run")
		else:
			# Apply friction when there's no input
			currentSpeed = move_toward(currentSpeed, 0, FRICTION)
			velocity.x = currentSpeed
			animation_player.play("idle")
	else:
		velocity = Vector2.ZERO
		animation_player.play("idle")

	move_and_slide()

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is RigidBody2D and body.has_method("get_text"):
		current_interactable = body

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body == current_interactable:
		current_interactable = null

func interact() -> void:
	if current_interactable:
		var text = current_interactable.get_text()
		var textbox = get_node("../textBox")
		if textbox:
			textbox.show_text(text)

func set_cutscene_state(state: bool) -> void:
	in_cutscene = state
	if in_cutscene:
		animation_player.play("idle")
