extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta:float ) -> void:
	
	text = "FPS: " + str( Engine.get_frames_per_second() );
