# Base class for 3D physics objects utilizing the PhysicsServer and RenderingServer
class_name PhysicsObject extends Node3D

# Every physics object (RID) has a collision shape (Shape3D)
var _object:RID;
var _object_shape:Shape3D;
# Every mesh (RID) has a mesh instance (Mesh)
var _mesh:RID;
var _mesh_instance:Mesh;

#var _shape_id:int = 0;

# Virtual constructor function ( called when new() method is called )
func _init() -> void:
	pass;

# Create the physics object ie. its collision shape and mesh
func CreateObject( location:Vector3, world_space:RID, world_scenario:RID, collision_layer:int, collision_mask:int ) -> void:
	
	# Create the physics body from the physics server
	_object = PhysicsServer3D.body_create();
	# Set the object into world space (from model space)
	PhysicsServer3D.body_set_space( _object, world_space );
	# Give the object a shape
	PhysicsServer3D.body_add_shape( _object, _object_shape );
	# Define the object's body type e.g. rigid, kinematic, static
	PhysicsServer3D.body_set_mode( _object, PhysicsServer3D.BODY_MODE_RIGID );
	# Set the object's collision layers and masks
	# Note: Layer/mask value is the sum of the value of all applicable layers e.g. layer 1 (floor / val 1) + layer 3 (sphere / val 4) = 5
	PhysicsServer3D.body_set_collision_layer( _object, collision_layer );
	PhysicsServer3D.body_set_collision_mask( _object, collision_mask ); 
	
	# Set the physics parameters ie. mass, inertia, gravity scale, etc.
	PhysicsServer3D.body_set_param( _object, PhysicsServer3D.BODY_PARAM_MASS, 1.5 );
	PhysicsServer3D.body_set_param( _object, PhysicsServer3D.BODY_PARAM_GRAVITY_SCALE, 1.25 );
	
	# Set the body shape's default transform
	#PhysicsServer3D.body_set_shape_transform( _object, _shape_id, Transform3D( Basis.IDENTITY, Vector3.ZERO ) );
	
	# Define a (default) transform 
	var trans:Transform3D = Transform3D( Basis.IDENTITY, location );
	# Apply a rotation to the transform
	#trans = trans.rotated_local( Vector3( 1.0, 0.0, 1.0 ).normalized(), PI * 0.25 );
	
	# Apply the transform to the object's physics body / collision shape via its body state
	PhysicsServer3D.body_set_state( _object, PhysicsServer3D.BODY_STATE_TRANSFORM, trans );
	
	# At this point, we've created the object's physics body and collision shape, but we have no visual representation of it yet
	# We use the rendering server to create a visual instance of it
	
	# Create an instance of the mesh using the Rendering server
	_mesh = RenderingServer.instance_create2( _mesh_instance, world_scenario );
	# The above is a longform of:
	#_mesh = RenderingServer.instance_create();
	#RenderingServer.instance_set_base( _mesh, _mesh_instance );
	#RenderingServer.instance_set_scenario( _mesh, world_scenario );
	
	# Apply the same transform to the mesh that we applied the shape's collision
	RenderingServer.instance_set_transform( _mesh, trans );

# Draw the object
# Gets the updated location of the physics object / collision shape AS IT IS MOVING, and applies it to the mesh so the two remain in sync
# To be called from _physics_process
func DrawObject() -> void:
	
	# Get the physics object's (collision shape's) current transform ( shape, location) from its state
	var trans:Transform3D = PhysicsServer3D.body_get_state( _object, PhysicsServer3D.BODY_STATE_TRANSFORM );
	
	# Apply the object's transform to its corresponding mesh
	RenderingServer.instance_set_transform( _mesh, trans );

# Apply an impulse to the object
func ApplyImpulse( _location:Vector3 ) -> void:
	
	var knockback_force:float = randf_range( 10.0, 15.0 );
	var impulse:Vector3 = Vector3( randf_range( -0.1, 0.1 ), randf_range( 1.0, 2.0 ), randf_range( -0.1, 0.1 ) ) * knockback_force;
	var offset:Vector3 = Vector3.ZERO;
	
	PhysicsServer3D.body_apply_impulse( _object, impulse, offset );

# Free objects that were created from the Physics and Rendering Servers
func FreeObject() -> void:
	
	# Free the object RIDs
	PhysicsServer3D.free_rid( _object );
	#PhysicsServer3D.free_rid( _object_shape.get_rid() );
	RenderingServer.free_rid( _mesh );
	RenderingServer.free_rid( _mesh_instance.get_rid() );
	
	# Queue object for deletion in memory (prevent orphan nodes)
	queue_free();
