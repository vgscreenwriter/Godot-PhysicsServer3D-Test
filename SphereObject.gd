# Class for creating 3D sphere objects that utilize the PhysicsServer and RenderingServer
class_name SphereObject extends PhysicsObject

# Override constructor
func _init() -> void:
	
	# Initialize the physics object's collision shape
	_object_shape = SphereShape3D.new();
	# Define the collision shape's size
	(_object_shape as SphereShape3D).radius = 1.0;
	
	# Initialize the mesh instance
	_mesh_instance = SphereMesh.new();
	# Define the mesh instance properties
	(_mesh_instance as SphereMesh).radius = 1.0;
	(_mesh_instance as SphereMesh).height = 2.0;
	# Decrease radial segments and rings to increase performance
	(_mesh_instance as SphereMesh).radial_segments = 6;
	(_mesh_instance as SphereMesh).rings = 3;
	
	# Create a material
	var _material:StandardMaterial3D = StandardMaterial3D.new();
	# Assign the material's properties
	_material.albedo_color = Color( randf_range( 0.1, 0.9 ), randf_range( 0.1, 0.9 ), randf_range( 0.1, 0.9 ) );
	
	# Apply the material to the mesh instance
	_mesh_instance.surface_set_material( 0, _material );
	

func CreateSphere( location:Vector3, world_space:RID, world_scenario:RID ) -> void:
	
	# Collision layer = 3 (sphere)
	# Collision mask = 337
	# layer 1 (floor / val 1) + layer 5 (box / val 16) + layer 7 (cylinder / val 64) + layer 9 (subfloor / val 256) = 337
	
	super.CreateObject( location, world_space, world_scenario, 3, 337 );

func DrawSphere() -> void:
	
	super.DrawObject();
	
