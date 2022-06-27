extends Label

var coins = 0

func _ready():
	refresh_ui()
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	
func refresh_ui():
	set_text(String(coins) + " coins")

func _on_coin_collected():
	coins += 1
	refresh_ui()
