### QuestManager.gd

extends Node2D

@onready var quest_ui = $QuestUI

# Signals
signal quest_updated(quest_id: String)
signal objective_updated(quest_id: String, objective_id: String)

## Notify game when questlist has been updated, i.e. Adding or removing a quest
signal quest_list_updated()

# Stores all active quests
var quests = {}

# Add quests
func add_quest(quest: Quest):
	## Add to dictionary and emit signal to update 
	quests[quest.quest_id] = quest
	quest_updated.emit(quest.quest_id)

# Remove quests
func remove_quest(quest_id: String):
	## Remove from dictionary and emit signal to update list
	quests.erase(quest_id)
	quest_list_updated.emit()
	
# Get quest with ID
func get_quest(quest_id: String) -> Quest:
	return quests.get(quest_id, null)
	
# Update quest
func update_quest(quest_id: String, state: String):
	var quest = get_quest(quest_id)
	if quest:
		quest.state = state
		quest_updated.emit(quest_id)
		if state == "completed":
			remove_quest(quest_id)
		
# Get selected quest
func get_active_quests() -> Array:
	var active_quests = []
	for quest in quests.values():
		if quest.state == "in_progress":
			active_quests.append(quest)
	return active_quests
	
# Complete objective
func complete_objective(quest_id: String, objective_id: String):
	var quest = get_quest(quest_id)
	if quest:
		quest.complete_objective(objective_id)
		objective_updated.emit(quest_id, objective_id)

# Check if the player has all required items for the quest upon activation
func check_quest_item_completion(quest: Quest):
	for objective in quest.objectives:
		if objective.target_type == "collection" and not objective.is_completed:
			# Check if the item is in inventory
			var required_quantity = objective.required_quantity
			var collected_quantity = Global_Inventory.get_item_quantity(objective.target_id, objective.item_type)

			if collected_quantity >= required_quantity:
				# Mark the objective as completed
				objective.is_completed = true
				Global_Inventory.remove_item_quantity(objective.target_id, objective.item_type, required_quantity)

	# Mark the quest as completed if all objectives are met
	if quest.is_completed():
		Global_Player.handle_quest_completion(quest)


# Show/hide quest log
func show_hide_log():
	quest_ui.show_hide_log()
