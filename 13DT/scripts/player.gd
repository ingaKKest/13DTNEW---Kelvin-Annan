extends CharacterBody3D

@onready var stock_app = $"stock-app"
@onready var stock_homepage = $"stock-app/stock_homepage"
@onready var money_stock = $"stock-app/Money"
@onready var stock_home_indicator = $"stock-app/Control/home_indicator"
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





@export var sens_horizontal = .5
@export var sens_vertical = .5

var rotation_speed = 10


var recent_stock_index = 1
var recent_buy_index = 1


var volatility = 0

func _ready():
	update_button_states()
	stock_calculation.set_momentum_levels(stocks)



	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _process(delta):
		page_design.reset_portfolio()
		page_design.updateStockLabels(stock_data.userStocks, stocks, indexes)
		page_design.updateSelectedStocklines(page_design.recent_button_index)
		page_design.updateSelectedStockBuyControls(recent_buy_index, $"stock-app/BUY_STOCK_PAGE".visible)
		page_design.updateMoneyStockLabel(page_design.money)
		page_design.updateStockValues(stocks, indexes)
		page_design.graph_stock(page_design.graph_category, recent_buy_index, stocks, indexes)
		page_design.setElementVisibility(recent_stock_index)
		page_design.updateDayCounter()




func _input(event):
	if stock_app.visible:
		# Unlock the mouse and disable player movement
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		# Reset player movement

	else:
		# Lock the mouse and enable player movement
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))

func _on_home_indicator_pressed():
	stock_app.visible = false

	
func _on_stockline_1_pressed():
	page_design.recent_button_index = 2


func _on_stockline_2_pressed():
	page_design.recent_button_index = 3


func _on_stockline_3_pressed():
	page_design.recent_button_index = 4


func _on_stockline_4_pressed():
	page_design.recent_button_index = 5


func _on_stockline_5_pressed():
	page_design.recent_button_index = 6


func _on_stockline_6_pressed():
	page_design.recent_button_index = 7


func _on_stockline_7_pressed():
	page_design.recent_button_index = 8

	
func _on_stockline_8_pressed():
	page_design.recent_button_index = 9

	
func _on_stockline_9_pressed():
	page_design.recent_button_index = 10

	
func _on_stockline_10_pressed():
	page_design.recent_button_index = 11

	page_design.version = 'sell'

func _on_stockline_11_pressed():
	page_design.recent_button_index = 12

	page_design.version = 'sell'
	
func _on_home_button_pressed():
	stock_homepage.visible = false
	
func _on_mega_pressed():
	recent_stock_index = 1
	
func _on_large_pressed():
	recent_stock_index = 2

func _on_mid_pressed():
	recent_stock_index = 3

func _on_small_pressed():
	recent_stock_index = 4
	
func _on_micro_pressed():
	recent_stock_index = 5
func _on_index_pressed():
	recent_stock_index = 6

func _on_stock_buy_button_1_pressed():
	recent_buy_index = 1

func _on_stock_buy_button_2_pressed():
	recent_buy_index = 2
	
func _on_stock_buy_button_3_pressed():
	recent_buy_index = 3

func _on_stock_buy_button_4_pressed():
	recent_buy_index = 4

func _on_stock_buy_button_5_pressed():
	recent_buy_index = 5
	
func _on_stock_buy_button_6_pressed():
	recent_buy_index = 6

func _on_stock_buy_button_7_pressed():
	recent_buy_index = 7

func _on_stock_buy_button_8_pressed():
	recent_buy_index = 8

func _on_stock_buy_button_9_pressed():
		recent_buy_index = 9


# go to buy stock screen
func _on_buy_stocks_pressed():
	BUY_STOCK_PAGE.visible = true
	stock_homepage.visible = false
	stock_homepage_lines.visible = false
	leaderboard.visible = false


func _on_home_button_2_pressed():
	stock_homepage.visible = true
	BUY_STOCK_PAGE.visible = false
	stock_homepage_lines.visible = true
	leaderboard.visible = false
	
	
func _on_leaderboard_pressed():
	leaderboard.visible = true
	BUY_STOCK_PAGE.visible = false
	stock_homepage.visible = false
	stock_homepage_lines.visible = false
	leaderboard.display_leaderboard()

func _on_stock_select_first_pressed():
	page_design.recent_button_index = 1






func _on_time_graph_button_day_pressed():
	page_design.graph_time = 'day'
	update_button_states()

func _on_time_graph_button_week_pressed():
	page_design.graph_time = 'week'
	update_button_states()

func _on_time_graph_button_month_pressed():
	page_design.graph_time = 'month'
	update_button_states()

var timer_count = 0

func update_button_states():
	$"stock-app/BUY_STOCK_PAGE/TIME_GRAPH_BUTTON_DAY".set_pressed(page_design.graph_time == "day")
	$"stock-app/BUY_STOCK_PAGE/TIME_GRAPH_BUTTON_WEEK".set_pressed(page_design.graph_time == "week")
	$"stock-app/BUY_STOCK_PAGE/TIME_GRAPH_BUTTON_MONTH".set_pressed(page_design.graph_time == "month")


func _on_stock_timer_timeout():
	timer_count = timer_count + 1
	if timer_count == 1:
		stock_calculation.calculate_stocks(stocks)
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



func _on_buy_pressed():
	buy_menu.visible = true
	page_design.version = 'buy'



func _on_exit_menu_pressed():
	buy_menu.visible = false


func _on_sell_pressed():
	buy_menu.visible = true
	page_design.version = 'sell'


func _on_confirm_order_button_pressed():
	page_design.confirm_buy = true
	


		

func _on_warning_timer_timeout():
		$"stock-app/BUY_STOCK_PAGE/buy_menu/warning".visible = false
		$"stock-app/BUY_STOCK_PAGE/buy_menu/success".visible = false
		$"stock-app/BUY_STOCK_PAGE/buy_menu/warning_selling2".visible = false
		$"stock-app/BUY_STOCK_PAGE/buy_menu/warning_selling".visible = false



func _on_play_button_pressed():
	$"stock-app/main_menu".visible = false
	$"stock-app/stock_homepage".visible = true
	$"stock-app/Money".visible = true
	$"stock-app/Money_total".visible = true
	$"stock-app/day_Counter".visible = true
	$"stock-app/EXIT".visible = true
	$"stock-app/leaderboard".visible = true



func _on_exit_pressed():
	$"stock-app/EXIT/end_screen".visible = true
	exit.exit_page(page_design.total_portfolio, page_design.day_counter)

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
	




func _on_exit_menu_1_pressed():
	$"stock-app/EXIT/end_screen".visible = false

