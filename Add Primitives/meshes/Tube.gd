extends "builder/MeshBuilder.gd"

var height = 2.0
var outer_radius = 1.0
var inner_radius = 0.5
var segments = 16
var slice = 0
var fill_caps = true
var fill_ends = true

static func get_name():
	return "Tube"
	
func set_parameter(name, value):
	if name == 'Height':
		height = value
		
	elif name == 'Outer Radius':
		outer_radius = value
		
	elif name == 'Inner Radius':
		inner_radius = value
		
	elif name == 'Segments':
		segments = value
		
	elif name == 'Slice':
		slice = deg2rad(value)
		
	elif name == 'Fill Caps':
		fill_caps = value
		
	elif name == 'Fill Ends':
		fill_ends = value
		
func create(smooth, invert):
	var sa = PI * 2 - slice
	
	var ic = build_circle_verts(Vector3(), segments, inner_radius, sa)
	var oc = build_circle_verts(Vector3(), segments, outer_radius, sa)
	
	var ofs = Vector3(0, height/2, 0)
	
	begin(VS.PRIMITIVE_TRIANGLES)
	
	set_invert(invert)
	add_smooth_group(false)
	
	if fill_caps:
		for idx in range(segments):
			add_quad([oc[idx + 1] + ofs, ic[idx + 1] + ofs, ic[idx] + ofs, oc[idx] + ofs])
			add_quad([oc[idx] - ofs, ic[idx] - ofs, ic[idx + 1] - ofs, oc[idx + 1] - ofs])
			
	if fill_ends and slice != 0:
		add_quad([oc[0] + ofs, ic[0] + ofs, ic[0] - ofs, oc[0] - ofs])
		add_quad([ic[segments] + ofs, oc[segments] + ofs, oc[segments] - ofs, ic[segments] - ofs])
		
	add_smooth_group(smooth)
	
	for idx in range(segments):
		add_quad([oc[idx + 1] + ofs, oc[idx] + ofs, oc[idx] - ofs, oc[idx + 1] -ofs])
		add_quad([ic[idx] + ofs, ic[idx + 1] + ofs, ic[idx + 1] - ofs, ic[idx] -ofs])
		
	var mesh = commit()
	
	return mesh

func mesh_parameters(tree):
	add_tree_range(tree, 'Height', height)
	add_tree_range(tree, 'Outer Radius', outer_radius)
	add_tree_range(tree, 'Inner Radius', inner_radius)
	add_tree_range(tree, 'Segments', segments, 1, 1, 50)
	add_tree_range(tree, 'Slice', rad2deg(slice), 1, 0, 359)
	add_tree_empty(tree)
	add_tree_check(tree, 'Fill Caps', fill_caps)
	add_tree_check(tree, 'Fill Ends', fill_ends)
	

