class_name ValueDialog extends Control

@onready var title_label: Label = %TitleLabel
@onready var attribute_grid_container: AttributesGridContainer = %AttributeGridContainer
@onready var values_grid_container: ValuesGridContainer = %ValuesGridContainer
@onready var create_item_container: CenterContainer = %CreateItemContainer
@onready var create_item_button: Button = %CreateItemButton

signal closed

var _is_software: bool
var _keys: Array
var _file_paths: Array
var _attribute_item: XmlItem

const edit_node_group: String = "value_dialog_value_edit"

func _ready():
	hide()

func init_change(is_software: bool, attribute_item: XmlItem, file_paths: Array):
	title_label.text = "Change Item"
	attribute_grid_container.init(is_software, attribute_item)
	attribute_grid_container.editable = false
	values_grid_container.add_value_fields(file_paths, attribute_item.key, edit_node_group)
	create_item_container.hide()
	init(is_software, file_paths)
	return self

func init_add(is_software: bool, file_paths: Array):
	title_label.text = "Add Item"
	attribute_grid_container.init(is_software, XmlItem.create_emtpy_item())
	attribute_grid_container.attribute_item_changed.connect(_on_attribute_changed)
	attribute_grid_container.editable = true
	create_item_container.show()
	create_item_button.disabled = true
	init(is_software, file_paths)
	return self

func init(is_software: bool, file_paths: Array):
	_is_software = is_software
	_file_paths = file_paths
	_keys = Globals.xml_class.GetKeys(file_paths.front())
	show()

func close():
	closed.emit()

func _add_item_to_files(item: XmlItem):
	for file_path in _file_paths:
		Globals.xml_class.AddItem(item, file_path, _is_software)

func _on_attribute_changed(item: XmlItem):
	_attribute_item = item
	create_item_button.disabled = !item.validate(_is_software, _keys)

func _on_create_item_pressed():
	create_item_container.hide()
	attribute_grid_container.editable = false
	_add_item_to_files(_attribute_item)
	values_grid_container.add_value_fields(_file_paths, _attribute_item.key, edit_node_group)
