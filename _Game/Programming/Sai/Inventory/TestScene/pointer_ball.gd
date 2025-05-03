extends Node3D

var counter = 0;
var time = 3;

func _process(_delta: float) -> void:
	counter += 1;
	if ((counter) >= (time * 60)):
		queue_free();
