class_name CylinderObject extends PhysicsObject


func _init() -> void:
	
	_object_shape = CylinderShape3D.new();
	(_object_shape as CylinderShape3D).height = 2.5;
	(_object_shape as CylinderShape3D).radius = 1.0;
	
	_mesh_instance = CylinderMesh.new();
	(_mesh_instance as CylinderMesh).height = 2.5;
	(_mesh_instance as CylinderMesh).top_radius = 1.0;
	(_mesh_instance as CylinderMesh).bottom_radius = 1.0;
	(_mesh_instance as CylinderMesh).radial_segments = 8;
	(_mesh_instance as CylinderMesh).rings = 4;
	
	# Create a material
	var _material:StandardMaterial3D = StandardMaterial3D.new();
	# Assign the material's properties
	_material.albedo_color = Color( randf_range( 0.1, 0.9 ), randf_range( 0.1, 0.9 ), randf_range( 0.1, 0.9 ) );
	
	# Apply the material to the mesh instance
	_mesh_instance.surface_set_material( 0, _material );

func CreateCylinder( location:Vector3, world_space:RID, world_scenario:RID ) -> void:
	
	# Collision layer = 7 (cylinder)
	# Collision mask = 277; 
	# layer 1 (floor / val 1) + layer 3 (sphere / val 4) + layer 5 (box / val 16) + layer 9 (subfloor / val 256) = 277
	
	super.CreateObject( location, world_space, world_scenario, 7, 277 );
	
	
func DrawCylinder() -> void:
	
	super.DrawObject();
