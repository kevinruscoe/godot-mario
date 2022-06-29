extends Label

var coins = 0

func _ready():
	refresh_ui()
	EventBus.connect("coins_collected", self, "_on_coins_collected")
	
func refresh_ui():
	set_text(String(coins) + " coins")

func _on_coins_collected(amount):
	coins += amount
	refresh_ui()
