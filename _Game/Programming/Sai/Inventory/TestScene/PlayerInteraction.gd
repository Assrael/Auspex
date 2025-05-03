extends Camera3D

var markerScene = preload("res://_Game/Programming/Sai/Inventory/TestScene/pointerBall.tscn");
@export var enableDebugMarker : bool = true;

# --- Edge Rotation Parameters ---
@export_group("Edge Camera Look Rotation")
@export var edgeRotationEnabled : bool = true
# How close to the edge (in pixels) the mouse needs to be
@export var edgeThreshold : float = 50.0
# How fast the camera rotates (degrees per second)
@export var edgeRotationSpeed : float = 90.0
# Limit vertical rotation to prevent flipping upside down
@export var clampVerticalRotation : bool = true
@export var minVerticalAngle : float = -85.0
@export var maxVerticalAngle : float = 85.0

# ----- Switch this to be in the InventorySystem -----
var selectedInventoryItem = null;

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("click")):
		ShootRay();

func ShootRay() -> void:
	var mousePos = get_viewport().get_mouse_position();
	var rayLength = 1000.0;
	var spaceState = get_world_3d().direct_space_state;
	var rayOrigin = project_ray_origin(mousePos);
	var rayEnd = rayOrigin + project_ray_normal(mousePos) * rayLength;
	var query = PhysicsRayQueryParameters3D.new();
	query.from = rayOrigin;
	query.to = rayEnd;

	# Try using query.collision_mask = 1 << 0; # Only collide with the first layer to limit the raycast to only the objects on layer 1

	var result = spaceState.intersect_ray(query);

	if enableDebugMarker and !result.is_empty():
		var instance = markerScene.instantiate();
		instance.position = result["position"];
		$'../'.add_child(instance);
		print("Raycast hit at: ", result["position"]);
		print("Raycast hit object: ", result["collider"].name);
		

	if (!result.is_empty()):
		var collider = result.collider;
		print("Clicked on: ", collider.name);
		
		if (collider and collider.has_method("Interact")):
			
			if (selectedInventoryItem != null):
				
				if (collider.has_method("InteractWithItem")):
					var interactionSuccess = collider.InteractWithItem(selectedInventoryItem);
					
					if (interactionSuccess):
						print("Interaction successful");
						# Use The Item or Clear the Item
					else:
						print("Cannot use ", selectedInventoryItem.name, " on ", collider.name);
				
				else: 
					print(collider.name, " cannot interact with ", selectedInventoryItem.name);
			
			else:
				print("No item selected to interact with ", collider.name);
				collider.Interact();
		
		else:
			print("Collider does not have Interact method");
	
	else:
		print("No hit detected");


func SetSelectedItem(itemData) -> void:
	selectedInventoryItem = itemData;
	print("Selected item: ", selectedInventoryItem.name);

func ClearSelectedItem() -> void:
	selectedInventoryItem = null;
	print("Cleared selected item");


func _process(delta):
	if edgeRotationEnabled:
		handle_edge_rotation(delta)


func handle_edge_rotation(delta):
	var mousePos = get_viewport().get_mouse_position()
	var viewportSize = get_viewport().get_visible_rect().size

	var rotateH : float = 0.0 
	var rotateV : float = 0.0 

	# Check Left Edge
	if mousePos.x < edgeThreshold:
		# Positive Y rotation 
		# Usually, mouse left -> pan left 
		rotateH = deg_to_rad(edgeRotationSpeed) * delta

	# Check Right Edge
	elif mousePos.x > viewportSize.x - edgeThreshold:
		# Negative Y rotation 
		# Usually, mouse right -> pan right 
		rotateH = -deg_to_rad(edgeRotationSpeed) * delta

	# Check Top Edge
	if mousePos.y < edgeThreshold:
		# Positive X rotation (pitch up)
		rotateV = deg_to_rad(edgeRotationSpeed) * delta

	# Check Bottom Edge
	elif mousePos.y > viewportSize.y - edgeThreshold:
		# Negative X rotation (pitch down)
		rotateV = -deg_to_rad(edgeRotationSpeed) * delta

	if rotateH != 0.0 or rotateV != 0.0:
		# Horizontal rotation around the global Y axis 
		rotate_y(rotateH)
		# Vertical rotation around the camera's local X axis 
		rotate_object_local(Vector3.RIGHT, rotateV)

		if clampVerticalRotation:
			var current_rotation_deg = rotation_degrees
			
			current_rotation_deg.x = clampf(current_rotation_deg.x, minVerticalAngle, maxVerticalAngle)
			current_rotation_deg.x = clampf(current_rotation_deg.x, -89.9, 89.9)
			rotation_degrees = current_rotation_deg
# bungus
