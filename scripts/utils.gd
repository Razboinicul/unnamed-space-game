extends Node

func _ready():
	pass
	
func look_at_with_y(trans, new_y, v_up):
	# Y vector
	trans.basis.y = new_y.normalized()
	trans.basis.z = v_up * -1
	trans.basis.x = trans.basis.z.cross(trans.basis.y).normalized()
	# Recompute z = y cross X
	trans.basis.z = trans.basis.y.cross(trans.basis.x).normalized()
	trans.basis.x = trans.basis.x * -1
	trans.basis = trans.basis.orthonormalized() # make sure it is valid
	return trans

func look_at_with_z(trans, new_z, v_up):
	# Y vector
	trans.basis.z = new_z.normalized()
	trans.basis.y = v_up * 1
	trans.basis.x = trans.basis.y.cross(trans.basis.z).normalized()
	# Recompute z = y cross X
	trans.basis.y = trans.basis.z.cross(trans.basis.x).normalized()
	trans.basis.x = trans.basis.x * -1
	trans.basis = trans.basis.orthonormalized() # make sure it is valid
	return trans