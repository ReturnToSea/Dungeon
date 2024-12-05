@tool
extends Node2D

# Export, Allows setting it through the inspector
@export var item_id = ""
@export var item_name = ""
@export var item_type = ""
@export var item_texture = Texture
@export var item_effect = ""
@export var item_scale = Vector2(1, 1) # Default scale
var scene_path: String =  "res://Scenes/Inventory/Inventory_Item.tscn"

# Allow for dynamically changed sprites
@onready var icon_sprite = $Sprite2D

var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture

func _process(delta: float):
	# Update and show the updated icon
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
	if player_in_range and Input.is_action_just_pressed("pickup"):
		pickup_item()

# Create the dict for item info to be passed when adding it
func pickup_item(): 
	var item = {
		"id": item_id,
		"quantity": 1,
		"type": item_type,
		"name": item_name,
		"texture": item_texture,
		"effect": item_effect,
		"scene_path": scene_path,
		"scale": scale  # Used when dropping items
	}
	if Global_Player.Player_node:
		# Adding item to players inventory
		Global_Inventory.add_item(item, false)
		# Remove item from scene
		self.queue_free()
		
# Set the properties to allow items to be dropped and utilize saved values
func set_item_data(data):
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]
	item_scale = data["scale"]

# Set the items values for spawning
func initiate_items(type, name, effect, texture, scale):
	item_type = type
	item_name = name
	item_effect = effect
	item_texture = texture
	item_scale = scale
	
func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		body.interact_ui_label.text = "Press Enter to pick up"
		body.interact_ui.visible = true

func _on_area_2d_body_exited(body) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		body.interact_ui.visible = false
