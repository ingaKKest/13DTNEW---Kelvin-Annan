extends Button

var username = ''
var exit_permitted = false
# Called when the node enters the scene tree for the first time.



# Handle exit page UI updates, displaying total amount, profit per day, and a congratulatory message if the total is above $10,000.
func exit_page(total, day_count):
	$end_screen/total_amount.text = '$' + str(total)
	var profit_per_day = (total - 10000) / day_count
	profit_per_day = roundToTwoDecimals(profit_per_day)
	$end_screen/profit_per_day_amount.text = '$' + str(profit_per_day)
	if total > 10000:
		$end_screen/final_message.text = 'Congratulations!'
	else:
		$end_screen/final_message.text = 'Try Harder Next Time!'

	
# rounds number to two decimals
func roundToTwoDecimals(number: float) -> float:
	return round(number * 100) / 100

# makes error labels invisible 
func _on_timer_timeout():
	$end_screen/error_label.visible = false
	$end_screen/error_label2.visible = false 

# Check if the input text is valid, based on the presence of spaces and character length between 3 and 12.
# If valid, permit an exit operation.
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
	

