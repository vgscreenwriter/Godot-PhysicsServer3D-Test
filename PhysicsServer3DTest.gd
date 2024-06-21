# A test of the physics 3d server for optimal performance
# Physics server accesses teh server directly and creates physics objects withotu needing to add them as nodes

class_name PhysicsServer3DTest extends Node3D

@export_group("Camera")
# Reference to camera
@export var camera:Camera3D;
# Camera movement speed and rotation speed
@export var camera_movement_speed:float = 5.0 * 0.1;
@export var camera_rotation_speed:float = 15.0 * 0.1;

@export_group("Misc")
# Location source of impulse to be applied to objects
@export var impulse_point:Marker3D;
# Define the number of test objects to spawn
@export var num_of_objects:int = 1000;

# Reference to world space and scenario
var world_space:RID;
var world_scenario:RID;

# Array of box objects
var box_array:Array[BoxObject] = [];

# Array of sphere objects
var sphere_array:Array[SphereObject] = [];

# Array of cylinders
var cylinder_array:Array[CylinderObject] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Define world space and world scenario
	world_space = get_world_3d().space;
	world_scenario = get_world_3d().scenario;
	
	# Create boxes / spheres
	for i:int in num_of_objects:
		#var x:float = randf_range( -5.0, 5.0 );
		var y:float = i + 5.0;
		#var z:float = randf_range( -5.0, 5.0 );
		
		CreateBox( Vector3( randf_range( -5.0, 5.0 ), y, randf_range( -5.0, 5.0 ) ) );
		CreateSphere( Vector3( randf_range( -5.0, 5.0 ), y, randf_range( -5.0, 5.0 ) ) );
		CreateCylinder( Vector3( randf_range( -5.0, 5.0 ), y, randf_range( -5.0, 5.0 ) ) );
	
# Handle keyboard input for applying impulse force to objects
func _unhandled_input( event:InputEvent ) -> void:
	
	if( event.is_action_pressed( "apply_impulse" ) ):
		
		# Apply an impulse to the objects by passing the impulse_point to their arrays
		var impulse_point_location:Vector3 = impulse_point.global_transform.origin;
		
		for i:int in num_of_objects:
			box_array[i].ApplyImpulse( impulse_point_location );
			sphere_array[i].ApplyImpulse( impulse_point_location );
			cylinder_array[i].ApplyImpulse( impulse_point_location );
			

# Called every tick
func _process( _delta:float ) -> void:
	
	# Draw boxes / spheres from the arrays
	for i:int in num_of_objects:
		box_array[i].DrawBox();
		sphere_array[i].DrawSphere();
		cylinder_array[i].DrawCylinder();
		

func _physics_process( _delta:float ) -> void:
	# Handle input for camera control
	HandleCameraControlInput();

# Handle input for controlling the camera
func HandleCameraControlInput() -> void:
	
	if( Input.is_action_pressed("cam_w") ):
		camera.transform.origin -= camera.transform.basis.z * camera_movement_speed;
	elif( Input.is_action_pressed("cam_s") ):
		camera.transform.origin += camera.transform.basis.z * camera_movement_speed;
	
	if( Input.is_action_pressed("cam_a") ):
		camera.transform.origin -= camera.transform.basis.x * camera_movement_speed;
	elif( Input.is_action_pressed("cam_d") ):
		camera.transform.origin += camera.transform.basis.x * camera_movement_speed;
	
	
	if( Input.is_action_pressed("cam_up") ):
		camera.rotate_object_local( Vector3.RIGHT, deg_to_rad( camera_rotation_speed ) );
	elif( Input.is_action_pressed("cam_down") ):
		camera.rotate_object_local( Vector3.RIGHT, -deg_to_rad( camera_rotation_speed ) );
	
	if( Input.is_action_pressed("cam_left") ):
		camera.global_rotation.y += deg_to_rad( camera_rotation_speed );
	elif( Input.is_action_pressed("cam_right") ):
		camera.global_rotation.y -= deg_to_rad( camera_rotation_speed );
		

# Creates a physics box
func CreateBox( location:Vector3 ) -> void:
	
	var box_object:BoxObject = BoxObject.new();
	box_object.CreateBox( location, world_space, world_scenario );
	
	# Append the box object to the box array
	box_array.append( box_object );

# Creates a physics sphere
func CreateSphere( location:Vector3 ) -> void:
	
	var sphere_object:SphereObject = SphereObject.new();
	sphere_object.CreateSphere( location, world_space, world_scenario );
	
	# Append the sphere object to the sphere array
	sphere_array.append( sphere_object );

# Creates a physics cylinder
func CreateCylinder( location:Vector3 ) -> void:
	
	var cylinder_object:CylinderObject = CylinderObject.new();
	cylinder_object.CreateCylinder( location, world_space, world_scenario );
	
	# Append the cylinder object to the cylinder array
	cylinder_array.append( cylinder_object );



func OnQuitButtonPressed() -> void:
	
	# Disable processes to prevent null read error after objects are freed
	set_process( false );
	set_physics_process( false );
	
	# REmove objects from memory
	for i:int in num_of_objects:
		box_array[i].FreeObject();
		sphere_array[i].FreeObject();
		cylinder_array[i].FreeObject();
		
	# Quit
	get_tree().quit();
	
