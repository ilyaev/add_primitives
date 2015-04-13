extends "builder/mesh_builder.gd"

func build_mesh(params, smooth = false, reverse = false):
	if params == DEFAULT:
		params = [1.0, 1.0, 2.0]
		
	var w = params[0]
	var h = params[1]
	var l = params[2]
	
	var fd = Vector3(0, 0, l)
	var rd = Vector3(w, 0, 0)
	var ud = Vector3(0, h, 0)
	
	var offset = Vector3(w/2, h/2, l/2) * -1
	
	begin(VS.PRIMITIVE_TRIANGLES)
	add_smooth_group(smooth)
	
	add_quad(build_plane_verts(rd, fd, offset), plane_uv(w, l), reverse)
	add_quad(build_plane_verts(ud, rd, offset), plane_uv(h, w), reverse)
	
	var d = offset.distance_to(offset + Vector3(0, -h, l))
	
	offset.y += h
	add_quad([offset, offset + rd, offset + Vector3(w, -h, l), offset + Vector3(0, -h, l)], plane_uv(w, d), reverse)
	add_tri([offset + Vector3(0, -h, l), offset - ud, offset], plane_uv(l, h, false), reverse)
	add_tri([offset + rd, (offset + rd) - ud, offset + Vector3(w, -h, l)], plane_uv(h, l, false), reverse)
	
	generate_normals()
	var mesh = commit()
	clear()
	
	return mesh
	
func mesh_parameters(parameters):
	add_tree_range(parameters, 'Width', 1, 0.1, 0.1, 100)
	add_tree_range(parameters, 'Height', 1, 0.1, 0.1, 100)
	add_tree_range(parameters, 'Length', 2, 0.1, 0.1, 100)
	
func container():
	return "Extra Objects"
