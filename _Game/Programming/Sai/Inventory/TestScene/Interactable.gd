extends StaticBody3D
class_name Interactable

# --- Common Interactable Properties (Optional) ---
@export var interaction_prompt : String = "Interact" # e.g., text to show on hover

# --- Base Interaction Methods ---
# Using underscore prefix because these are meant to be overridden (convention)
func _interact():
	print(name, " (StaticBody) received generic interaction.")
	emit_signal("interacted", self)

# Return value indicates if interaction was successful/handled
func _interactWithItem(itemData) -> bool:
	print(name, " (StaticBody) cannot handle item: ", itemData)
	
	# Default behavior: interaction fails
	emit_signal("interaction_failed", self, itemData)
	return false

# --- Public Facing Methods ---

# These are the methods the PlayerInteraction script will call.
# They can handle common checks before calling the overrideable methods.
func Interact():
	# Add any pre-interaction logic common to all InteractableStaticBodies here
	_interact()

func InteractWithItem(itemData) -> bool:
	# Add any pre-item-interaction logic here
	return _interactWithItem(itemData)

# --- Optional: Common Signals ---
signal Interacted(node)
signal InteractionFailed(node, item_data)
