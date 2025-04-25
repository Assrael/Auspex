extends Camera3D

var marker = preload("res://_Game/Programming/Sai/Inventory/TestScene/pointerBall.tscn");

func _input(event):
	if (event.is_action_pressed("click")):
		print("yeee")
		shoot_ray();

func shoot_ray():
	var mousePos = get_viewport().get_mouse_position();
	var rayLength = 1000;
	
	var from = project_ray_origin(mousePos);
	var to = from + project_ray_normal(mousePos) * rayLength;
	var space = get_world_3d().direct_space_state;
	
	var rayQuery = PhysicsRayQueryParameters3D.new();
	rayQuery.from = from;
	rayQuery.to = to;
	
	var raycastResult = space.intersect_ray(rayQuery);
	print(raycastResult);
	
	if (!raycastResult.is_empty()):
		var instance = marker.instantiate();
		instance.position = raycastResult["position"];
		$'../'.add_child(instance);
	


func _process(delta):
	pass
