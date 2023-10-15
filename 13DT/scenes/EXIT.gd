extends Button

var username = ''
var exit_permitted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func exit_page(total, day_count):
	$end_screen/total_amount.text = '$' + str(total)
	var profit_per_day = (total - 10000) / day_count
	profit_per_day = roundToTwoDecimals(profit_per_day)
	$end_screen/profit_per_day_amount.text = '$' + str(profit_per_day)
	if total > 10000:
		$end_screen/final_message.text = 'Congratulations!'
	else:
		$end_screen/final_message.text = 'Try Harder Next Time!'

	
	
func roundToTwoDecimals(number: float) -> float:
	return round(number * 100) / 100


func _on_timer_timeout():
	$end_screen/error_label.visible = false
	$end_screen/error_label2.visible = false 

func is_valid_input(text):
	# Check if the text contains spaces
	# Check if the character length is between 3 and 12
	var text_length = text.length()
	if " " in text:
		$end_screen/error_label2.visible = true
		$end_screen/error_label2/Timer.start()
	elif text_length < 3 or text_length > 12:
		$end_screen/error_label.visible = true
		$end_screen/error_label/Timer.start()
	else:
		exit_permitted = true
	

