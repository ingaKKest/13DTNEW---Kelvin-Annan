extends Node2D

@onready var stock_app = $"stock-app"
@onready var stock_homepage = $"stock-app/stock_homepage"
@onready var money_stock = $"stock-app/Money"

@onready var buy_stock_page = $"stock-app/BUY_STOCK_PAGE"
@onready var stock_MEGA = $"stock-app/BUY_STOCK_PAGE/MEGA_SELECTED"
@onready var stock_LARGE = $"stock-app/BUY_STOCK_PAGE/LARGE_SELECTED"
@onready var stock_SMALL = $"stock-app/BUY_STOCK_PAGE/SMALL_SELECTED"
@onready var stock_MICRO = $"stock-app/BUY_STOCK_PAGE/MICRO_SELECTED"
@onready var stock_MID = $"stock-app/BUY_STOCK_PAGE/MID_SELECTED"
@onready var stock_INDEX = $"stock-app/BUY_STOCK_PAGE/INDEX_SELECTED"
@onready var BUY_STOCK_PAGE  = $"stock-app/BUY_STOCK_PAGE"
@onready var stock_homepage_lines = $"stock-app/Control2"
@onready var timer = $"stock-app/stock_timer"
@onready var buy_menu = $"stock-app/BUY_STOCK_PAGE/buy_menu"
@onready var slider = $"stock-app/BUY_STOCK_PAGE/buy_menu/price_slider"
@onready var stock_data = $"stock-app/stock_homepage/home_button"
@onready var stocks = stock_data.stocks
@onready var categories = stock_data.categories
@onready var indexes = stock_data.indexes
@onready var momentum_level_percentages = stock_data.momentum_level_percentages
@onready var stock_calculation = $"stock-app/stock_homepage"
@onready var page_design = $"stock-app"
@onready var leaderboard = $"stock-app/leaderboard_page"
@onready var graph : Line2D = $"stock-app/BUY_STOCK_PAGE/stock_lines"
@onready var exit =  $"stock-app/EXIT"
@onready var stock_lines = $"stock-app/Control2"



@export var sens_horizontal = .5
@export var sens_vertical = .5

var rotation_speed = 10


var recent_stock_index = 1
var recent_buy_index = 1


var volatility = 0

# Execute these functions when the scene is ready, including updating button states, setting momentum levels, and changing the mouse mode to captured.
func _ready():
	update_button_states()
	stock_calculation.set_momentum_levels()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Perform various processes in the game loop, including updating UI elements, handling interactions, and toggling main menu elements when the play button is pressed.
func _process(_delta):
		page_design.reset_portfolio()
		page_design.updateStockLabels(stock_data.userStocks, stocks, indexes)
		page_design.updateSelectedStocklines(page_design.recent_button_index)
		page_design.updateSelectedStockBuyControls(recent_buy_index)
		page_design.updateMoneyStockLabel(page_design.money)
		page_design.updateStockValues(stocks, indexes)
		page_design.graph_stock(page_design.graph_category, recent_buy_index, stocks, indexes)
		page_design.setElementVisibility(recent_stock_index)
		page_design.updateDayCounter()
		handleLeaderboardButton()
		handleStockCalculation()
		setRecentStockIndex()
		setRecentBuyIndex()
		handleBuyStockPageActions()
		handleBuyAndSellStockActions()
		setRecentButtonIndex()
		if $"stock-app/main_menu".play_button_pressed:
			toggleMainMenuElements(true)
		



# If the stock app is visible, unlock the mouse and disable player movement by setting the mouse mode to visible.
func _input(_event):
	if stock_app.visible:
		# Unlock the mouse and disable player movement
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE




# When the leaderboard is pressed, make it visible, while hiding other relevant UI elements and displaying the leaderboard entries.
func _on_leaderboard_pressed():
	leaderboard.visible = true
	BUY_STOCK_PAGE.visible = false
	stock_homepage.visible = false
	stock_homepage_lines.visible = false
	leaderboard.display_leaderboard()





var timer_count = 0
# Update button states based on the selected graph time in the UI.
func update_button_states():
	$"stock-app/BUY_STOCK_PAGE/TIME_GRAPH_BUTTON_DAY".set_pressed(page_design.graph_time == "day")
	$"stock-app/BUY_STOCK_PAGE/TIME_GRAPH_BUTTON_WEEK".set_pressed(page_design.graph_time == "week")
	$"stock-app/BUY_STOCK_PAGE/TIME_GRAPH_BUTTON_MONTH".set_pressed(page_design.graph_time == "month")

# Handle stock-related timer events, including calculating and updating stock values at different intervals.
func _on_stock_timer_timeout():
	timer_count = timer_count + 1
	if timer_count == 1:
		stock_calculation.calculate_stocks()
		stock_calculation.updateCurrentStockPrices(indexes)
	elif timer_count == 2:
		stock_calculation.day_values(stocks, categories, momentum_level_percentages)
		stock_calculation.updateCurrentStockPrices(indexes)
	elif timer_count == 3:
		stock_calculation.day_values(stocks, categories, momentum_level_percentages)
		stock_calculation.updateCurrentStockPrices(indexes)
	elif timer_count == 4:
		stock_calculation.day_values(stocks, categories, momentum_level_percentages)
		stock_calculation.updateCurrentStockPrices(indexes)
	elif timer_count == 5:
		stock_calculation.day_values(stocks, categories, momentum_level_percentages)
		stock_calculation.updateCurrentStockPrices(indexes)
	elif timer_count == 6:
		stock_calculation.day_values(stocks, categories, momentum_level_percentages)
		stock_calculation.updateCurrentStockPrices(indexes)
	elif timer_count == 7:
		stock_calculation.day_values(stocks, categories, momentum_level_percentages)
		stock_calculation.updateCurrentStockPrices(indexes)
	elif timer_count == 8:
		stock_calculation.day_values(stocks, categories, momentum_level_percentages)
		stock_calculation.updateCurrentStockPrices(indexes)
	elif timer_count == 9:
		stock_calculation.end_of_day(indexes, stocks)
		timer_count = -1
		page_design.day_counter = page_design.day_counter + 1 


# When the exit button is pressed, make the end screen visible and trigger the exit page with total portfolio and day counter information.
func _on_exit_pressed():
	$"stock-app/EXIT/end_screen".visible = true
	exit.exit_page(page_design.total_portfolio, page_design.day_counter)

# When the enter button is pressed, validate the input username and proceed to show the main menu while updating the leaderboard and reloading the scene.
func _on_enter_pressed():
	exit.username = $"stock-app/EXIT/end_screen/username".text
	exit.is_valid_input(exit.username)
	if exit.exit_permitted == true:
		$"stock-app/main_menu".visible = true
		$"stock-app/stock_homepage".visible = false
		$"stock-app/Money".visible = false
		$"stock-app/Money_total".visible = false
		$"stock-app/day_Counter".visible = false
		$"stock-app/EXIT".visible = false
		$"stock-app/BUY_STOCK_PAGE".visible = false
		$"stock-app/leaderboard".visible = false 
		exit.exit_permitted = false
		leaderboard.add_entry(exit.username, page_design.total_portfolio, page_design.day_counter)
		get_tree().reload_current_scene()
	
# exits menu
func _on_exit_menu_1_pressed():
	$"stock-app/EXIT/end_screen".visible = false


# Function to show or hide menu elements
func toggleMainMenuElements(show: bool):
	$"stock-app/main_menu".visible = not show
	$"stock-app/stock_homepage".visible = show
	$"stock-app/Money".visible = show
	$"stock-app/Money_total".visible = show
	$"stock-app/day_Counter".visible = show
	$"stock-app/EXIT".visible = show
	$"stock-app/leaderboard".visible = show
	$"stock-app/main_menu".play_button_pressed = false

# Function to handle leaderboard button press
func handleLeaderboardButton():
	if leaderboard.buy_stocks_leaderboard_button == true:
		BUY_STOCK_PAGE.visible = true
		stock_homepage.visible = false
		stock_homepage_lines.visible = false
		leaderboard.visible = false
		leaderboard.buy_stocks_leaderboard_button = false
	elif leaderboard.home_button_leaderboard_button == true:
		stock_homepage.visible = true
		BUY_STOCK_PAGE.visible = false
		stock_homepage_lines.visible = true
		leaderboard.visible = false
		leaderboard.home_button_leaderboard_button = false

# Function to handle stock calculation
func handleStockCalculation():
	if stock_calculation.buy_stocks_homepage == true:
		BUY_STOCK_PAGE.visible = true
		stock_homepage.visible = false
		stock_homepage_lines.visible = false
		leaderboard.visible = false
		stock_calculation.buy_stocks_homepage = false

# Function to set recent stock index
func setRecentStockIndex():
	if BUY_STOCK_PAGE.mega_pressed == true:
			recent_stock_index = 1
			BUY_STOCK_PAGE.mega_pressed = false
	elif BUY_STOCK_PAGE.large_pressed == true:
		recent_stock_index = 2
		BUY_STOCK_PAGE.large_pressed = false
	elif BUY_STOCK_PAGE.mid_pressed == true:
		recent_stock_index = 3
		BUY_STOCK_PAGE.mid_pressed = false

	elif BUY_STOCK_PAGE.small_pressed == true:
		BUY_STOCK_PAGE.small_pressed = false
		recent_stock_index = 4
	elif BUY_STOCK_PAGE.micro_pressed == true:
		recent_stock_index = 5
		BUY_STOCK_PAGE.micro_pressed = false
	elif BUY_STOCK_PAGE.index_pressed == true:
		recent_stock_index = 6
		BUY_STOCK_PAGE.index_pressed = false


# Function to set recent buy index
func setRecentBuyIndex():
	if BUY_STOCK_PAGE.stock_button_1_pressed == true:
		BUY_STOCK_PAGE.stock_button_1_pressed = false
		recent_buy_index = 1
	if BUY_STOCK_PAGE.stock_button_2_pressed == true:
		BUY_STOCK_PAGE.stock_button_2_pressed = false
		recent_buy_index = 2
	if BUY_STOCK_PAGE.stock_button_3_pressed == true:
		BUY_STOCK_PAGE.stock_button_3_pressed = false
		recent_buy_index = 3
	if BUY_STOCK_PAGE.stock_button_4_pressed == true:
		BUY_STOCK_PAGE.stock_button_4_pressed = false
		recent_buy_index = 4
	if BUY_STOCK_PAGE.stock_button_5_pressed == true:
		BUY_STOCK_PAGE.stock_button_5_pressed = false
		recent_buy_index = 5
	if BUY_STOCK_PAGE.stock_button_6_pressed == true:
		BUY_STOCK_PAGE.stock_button_6_pressed = false
		recent_buy_index = 6
	if BUY_STOCK_PAGE.stock_button_7_pressed == true:
		BUY_STOCK_PAGE.stock_button_7_pressed = false
		recent_buy_index = 7
	if BUY_STOCK_PAGE.stock_button_8_pressed == true:
		BUY_STOCK_PAGE.stock_button_8_pressed = false
		recent_buy_index = 8
	if BUY_STOCK_PAGE.stock_button_9_pressed == true:
		BUY_STOCK_PAGE.stock_button_9_pressed = false
		recent_buy_index = 9

# Function to handle buy stock page actions
func handleBuyStockPageActions():
	if BUY_STOCK_PAGE.buy_stocks_home_button == true:
		stock_homepage.visible = true
		BUY_STOCK_PAGE.visible = false
		stock_homepage_lines.visible = true
		leaderboard.visible = false
		BUY_STOCK_PAGE.buy_stocks_home_button = false
	if BUY_STOCK_PAGE.time_graph_button_day == true:
			page_design.graph_time = 'day'
			update_button_states()
			BUY_STOCK_PAGE.time_graph_button_day = false
	elif BUY_STOCK_PAGE.time_graph_button_week == true:
		BUY_STOCK_PAGE.time_graph_button_week = false
		page_design.graph_time = 'week'
		update_button_states()
	elif BUY_STOCK_PAGE.time_graph_button_month == true:
		BUY_STOCK_PAGE.time_graph_button_month = false
		page_design.graph_time = 'month'
		update_button_states()

# Function to handle buy and sell stock actions
func handleBuyAndSellStockActions():
	if BUY_STOCK_PAGE.buy_stock == true:
		buy_menu.visible = true
		page_design.version = 'buy'
		BUY_STOCK_PAGE.buy_stock = false
	if BUY_STOCK_PAGE.sell_stock == true:
		buy_menu.visible = true
		page_design.version = 'sell'
		BUY_STOCK_PAGE.sell_stock = false
	if BUY_STOCK_PAGE.confirm_order == true:
		BUY_STOCK_PAGE.confirm_order = false
		page_design.confirm_buy = true
	if BUY_STOCK_PAGE.exit_menu == true:
		buy_menu.visible = false
		BUY_STOCK_PAGE.exit_menu = false

# Function to set recent button index in stock lines
func setRecentButtonIndex():
	if stock_lines.stock_line_first == true:
			stock_lines.stock_line_first = false
			page_design.recent_button_index = 1
	elif stock_lines.stock_line1 == true:
		stock_lines.stock_line1 = false
		page_design.recent_button_index = 2
	elif stock_lines.stock_line2 == true:
		stock_lines.stock_line2 = false
		page_design.recent_button_index = 3
	elif stock_lines.stock_line3 == true:
		stock_lines.stock_line3 = false
		page_design.recent_button_index = 4
	elif stock_lines.stock_line4 == true:
		stock_lines.stock_line4 = false
		page_design.recent_button_index = 5
	elif stock_lines.stock_line5 == true:
		stock_lines.stock_line5 = false
		page_design.recent_button_index = 6
	elif stock_lines.stock_line6 == true:
		stock_lines.stock_line6 = false
		page_design.recent_button_index = 7
	elif stock_lines.stock_line7 == true:
		stock_lines.stock_line7 = false
		page_design.recent_button_index = 8
	elif stock_lines.stock_line8 == true:
		stock_lines.stock_line8 = false
		page_design.recent_button_index = 9
	# Continue for other stock line buttons

