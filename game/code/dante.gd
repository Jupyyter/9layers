extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var textbox: Control

func _ready():
    # Try to find the textbox in the scene
    textbox = find_textbox()
    if not textbox:
        push_warning("Textbox node not found. Please check if it exists in the scene.")
    elif not textbox.is_valid():
        push_warning("Textbox found but it's not properly set up.")

func find_textbox() -> Control:
    var root = get_tree().root
    return find_node_by_type(root, "Control")

func find_node_by_type(node: Node, type: String) -> Node:
    if node.is_class(type) and node.has_method("show_text") and node.has_method("is_valid"):
        return node
    for child in node.get_children():
        var found = find_node_by_type(child, type)
        if found:
            return found
    return null

func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

    # Handle jump.
    if Input.is_action_pressed("ui_up") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    var direction := Input.get_axis("ui_left", "ui_right")
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
    
    # Check for overlapping bodies
    check_for_interaction()

func check_for_interaction() -> void:
    var space_state = get_world_2d().direct_space_state
    var query = PhysicsShapeQueryParameters2D.new()
    query.set_shape($CollisionShape2D.shape)
    query.transform = global_transform
    query.collision_mask = collision_mask  # Use the same collision mask as the player
    
    var results = space_state.intersect_shape(query)
    for result in results:
        var collider = result.collider
        if collider is RigidBody2D and collider.has_method("get_text"):
            var interaction_text = collider.get_text()
            show_interaction_text(interaction_text)
            break  # Only interact with the first valid object

func show_interaction_text(text: String) -> void:
    if textbox and textbox.is_valid() and textbox.has_method("show_text"):
        textbox.show_text(text)
    else:
        print("Unable to show text: ", text)
        print("Textbox not found, not valid, or doesn't have show_text method.")