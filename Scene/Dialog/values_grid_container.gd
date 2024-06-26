class_name ValuesGridContainer extends GridContainer

@onready var clipboard_line_edit_scene := preload("res://Scene/clipboard_line_edit.tscn")

func add_value_fields(files: Array, key: String, edit_node_group: String):
	for file in files:
		var language_tag := (file as String).get_file().replace("ApplicationText_", "").replace(".xml", "")
		var language_name := Globals.Language_Dict.get(language_tag, "Not found") as String
		var lanugage = language_name + " (" + language_tag + ")"
		var value = Globals.xml_class.GetValue(key, file)
		_add_value_field(key, lanugage, value, file, edit_node_group)

func _add_value_field(key: String, label: String, edit_value: String, file: String, edit_node_group: String):
	var label_node := Label.new()
	label_node.text = label
	label_node.set_custom_minimum_size(Vector2(Globals.Label_Width, 0))
	add_child(label_node)

	var edit_node := clipboard_line_edit_scene.instantiate() as ClipboardLineEdit
	add_child(edit_node)
	edit_node.add_to_group(edit_node_group)
	edit_node.text = edit_value
	edit_node.size_flags_horizontal = SIZE_EXPAND_FILL
	edit_node.text_changed.connect(func(new_text:String): Globals.xml_class.SaveValue(key, file, new_text))

func clear():
	for child in get_children():
		remove_child(child)
