extends Label

var coins = 0

func _ready():
	refresh_ui()
	EventBus.connect("player_collected_coins", self, "_on_player_collected_coins")
	
func refresh_ui():
	set_text(String(coins) + " coins")

func _on_player_collected_coins(amount):
	coins += amount
	refresh_ui()
