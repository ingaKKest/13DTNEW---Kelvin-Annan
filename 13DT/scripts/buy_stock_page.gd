extends Sprite2D

# runs when mega button selected 
var mega_pressed = true
func _on_mega_pressed():
	mega_pressed = true

# runs when large button selected 
var large_pressed = false
func _on_large_pressed():
	large_pressed = true

# runs when mid button selected 
var mid_pressed = false
func _on_mid_pressed():
	mid_pressed = true

# runs when small button selected 
var small_pressed = false
func _on_small_pressed():
	small_pressed = true

# runs when micro button selected 
var micro_pressed = false
func _on_micro_pressed():
	micro_pressed = true
	
# runs when index button selected 
var index_pressed = false 
func _on_index_pressed():
	index_pressed = true

var stock_button_1_pressed = false
var stock_button_2_pressed = false
var stock_button_3_pressed = false
var stock_button_4_pressed = false
var stock_button_5_pressed = false
var stock_button_6_pressed = false
var stock_button_7_pressed = false
var stock_button_8_pressed = false
var stock_button_9_pressed = false

# runs when first row of stocks are press in the buy stock page 
func _on_stock_buy_button_1_pressed():
	stock_button_1_pressed = true

# runs when second row of stocks are press in the buy stock page 
func _on_stock_buy_button_2_pressed():
	stock_button_2_pressed = true

# runs when third row of stocks are press in the buy stock page 
func _on_stock_buy_button_3_pressed():
	stock_button_3_pressed = true

# runs when fourth row of stocks are press in the buy stock page 
func _on_stock_buy_button_4_pressed():
	stock_button_4_pressed = true

# runs when fifth row of stocks are press in the buy stock page 
func _on_stock_buy_button_5_pressed():
	stock_button_5_pressed = true

# runs when sixth row of stocks are press in the buy stock page 
func _on_stock_buy_button_6_pressed():
	stock_button_6_pressed = true

# runs when seventh row of stocks are press in the buy stock page 
func _on_stock_buy_button_7_pressed():
	stock_button_7_pressed = true

# runs when eighth row of stocks are press in the buy stock page 
func _on_stock_buy_button_8_pressed():
	stock_button_8_pressed = true

# runs when nine  row of stocks are press in the buy stock page 
func _on_stock_buy_button_9_pressed():
	stock_button_9_pressed = true

var buy_stocks_home_button = false

# runs when home button is pressed 
func _on_home_button_2_pressed():
	buy_stocks_home_button = true

var time_graph_button_day = false
var time_graph_button_week = false
var time_graph_button_month = true

# runs when day graph button is selected 
func _on_time_graph_button_day_pressed():
	time_graph_button_day = true

# runs when week graph button is selected 
func _on_time_graph_button_week_pressed():
	time_graph_button_week = true

# runs when month graph button is selected 
func _on_time_graph_button_month_pressed():
	time_graph_button_month = true

# runs when buy button is pressed
var buy_stock = false
func _on_buy_pressed():
	buy_stock = true

# runs when sell button is pressed
var sell_stock = false
func _on_sell_pressed():
	sell_stock = true

# runs when confirm order button is pressed 
var confirm_order = false
func _on_confirm_order_button_pressed():
	confirm_order = true

# runs when exit menu is pressed
var exit_menu = false
func _on_exit_menu_pressed():
	exit_menu = true
	
# turns off warning in text
func _on_warning_timer_timeout():
		$"buy_menu/warning".visible = false
		$"buy_menu/success".visible = false
		$"buy_menu/warning_selling2".visible = false
		$"buy_menu/warning_selling".visible = false


