# Class for creating 3D box objects that utilize the PhysicsServer and RenderingServer
class_name BoxObject extends PhysicsObject

# Override constructor
func _init() -> void:
	
	# Initialize the physics object's collision shape 
	_object_shape = BoxShape3D.new();
	# Define the collision shape's size
	(_object_shape as BoxShape3D).size = Vector3( 1.5, 1.5, 1.5 );
	
	# Initialize the mesh instance
	_mesh_instance = BoxMesh.new();
	# Define the mesh instance properties
	(_mesh_instance as BoxMesh).size = Vector3( 1.5, 1.5, 1.5 );
	
	# Initialize a material
	var _material:StandardMaterial3D = StandardMaterial3D.new();
	# Assign the material's properties
	_material.albedo_color = Color( randf_range( 0.1, 0.9 ), randf_range( 0.1, 0.9 ), randf_range( 0.1, 0.9 ) );
	
	# Apply the material to the mesh's surface
	_mesh_instance.surface_set_material( 0, _material );


func CreateBox( location:Vector3, world_space:RID, world_scenario:RID ) -> void:
	
	# Collision layer = 5 (box)
	# Collision mask = 325; 
	# layer 1 (floor / val 1) + layer 3 (sphere / val 4) + layer 7 (cylinder / val 64) + layer 9 (subfloor / val 256) = 325
	
	super.CreateObject( location, world_space, world_scenario, 5, 325 );

func DrawBox() -> void:
	
	super.DrawObject();
