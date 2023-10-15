extends CanvasLayer

@onready var stock_data = $stock_homepage/home_button
@onready var stock_calculation = $stock_homepage
var money = "10000"

var recent_button_index = 1
@onready var money_stock = $"Money"

var increase_colour = Color(0, 1, 0)
var decrease_colour = Color(1, 0, 0)
var no_change_colour = Color(255, 255, 255)
var graph_category = ''
var graph_time = 'month'

@onready var graph : Line2D = $"BUY_STOCK_PAGE/stock_lines"

@onready var stock_MEGA = $"BUY_STOCK_PAGE/MEGA_SELECTED"
@onready var stock_LARGE = $"BUY_STOCK_PAGE/LARGE_SELECTED"
@onready var stock_SMALL = $"BUY_STOCK_PAGE/SMALL_SELECTED"
@onready var stock_MICRO = $"BUY_STOCK_PAGE/MICRO_SELECTED"
@onready var stock_MID = $"BUY_STOCK_PAGE/MID_SELECTED"
@onready var stock_INDEX = $"BUY_STOCK_PAGE/INDEX_SELECTED"
@onready var BUY_STOCK_PAGE  = $"BUY_STOCK_PAGE"
@onready var slider = $"BUY_STOCK_PAGE/buy_menu/price_slider"
@onready var categories = stock_data.categories
var maxStocks = 8
var day_counter = 1
var total_portfolio = 10000

var version = 'buy'
var confirm_buy = false

func reset_portfolio():
	for i in range(8):
		i += 1
		var ticker_label = get_node("Control2/ticker" + str(i))
		var shares_label = get_node("Control2/shares" + str(i))
		var value_label = get_node("Control2/value" + str(i))
		var stock_label = get_node("Control2/stock_value" + str(i))
		ticker_label.visible = false
		shares_label.visible = false 
		value_label.visible = false 
		stock_label.visible = false 

# Function to update the stock labels
func updateStockLabels(userStocks, stocks, indexes):
	var totalShares = 0
	var totalValue = 0

	for i in range(userStocks.size()):
		var stockline = get_node("Control2/stockline" + str(i + 1))
		stockline.visible = true

	var l = 1  # Start with the first label (ticker1)

	for ticker in userStocks.keys():
		var ticker_label = get_node("Control2/ticker" + str(l))
		var shares_label = get_node("Control2/shares" + str(l))
		var value_label = get_node("Control2/value" + str(l))
		var stock_label = get_node("Control2/stock_value" + str(l))
		
		ticker_label.visible = true
		shares_label.visible = true
		value_label.visible = true
		stock_label.visible = true

		var value_stock = 0
		ticker_label.text = ticker
		shares_label.text = str(userStocks[ticker]) + " SHARES"

		if ticker in stocks:
			value_stock = userStocks[ticker] * float(stocks[ticker]['Current stock price'])
			value_label.text = "$" + str(value_stock)
			stock_label.text = "$" + str(stocks[ticker]['Current stock price'])
			stock_label.modulate = getStockLabelColor(stocks[ticker]['Stock change'])
		else:
			value_stock = userStocks[ticker] * float(indexes[ticker]['Current stock price'])
			value_label.text = "$" + str(value_stock)
			stock_label.text = "$" + str(indexes[ticker]['Current stock price'])
			stock_label.modulate = getStockLabelColor(indexes[ticker]['Stock change'])

		totalShares += userStocks[ticker]
		totalValue += value_stock
		l += 1

	updateTotalLabel(totalShares, totalValue)
# Function to get the color for stock labels
func getStockLabelColor(stockChange):
	if stockChange == 'Increasing':
		return increase_colour
	elif stockChange == 'Decreasing':
		return decrease_colour
	else:
		return no_change_colour
		
		
# Function to update the total label
func updateTotalLabel(totalShares, totalValue):
	var totalTicker = get_node("Control2/ticker" + str(stock_data.userStocks.size() + 1))
	var totalSharesLabel = get_node("Control2/shares" + str(stock_data.userStocks.size() + 1))
	var totalValueLabel = get_node("Control2/value" + str(stock_data.userStocks.size() + 1))

	totalTicker.visible = true
	totalSharesLabel.visible = true
	totalValueLabel.visible = true

	totalTicker.text = "TOTAL"
	totalSharesLabel.text = str(totalShares) + " SHARES"
	totalValueLabel.text = "$" + str(totalValue)
	
	$"stock_homepage/stock_amount".text = str(totalValue)
	$"stock_homepage/total_portfolio".text = str(float(totalValue) + float(money))
	total_portfolio = float(totalValue) + float(money)

# Function to update the selected stockline controls
func updateSelectedStocklines(recent_button_index):
	for i in range(1, 10):
		var control_name = "Control2/stockline_selected" + str(i)
		var control = get_node(control_name)
		control.visible = i == recent_button_index
		

# Function to update the selected stock buy controls
func updateSelectedStockBuyControls(recent_buy_index, isBuyPageVisible):
	for i in range(1, 10):
		var stock_buy = "BUY_STOCK_PAGE/Stock_buy_selected" + str(i)
		var stock_buys = get_node(stock_buy)
		stock_buys.visible = i == recent_buy_index
		
		if $"BUY_STOCK_PAGE".visible == true:
			stock_buy = "BUY_STOCK_PAGE/Stock_buy_selected" + str(i)
			stock_buys = get_node(stock_buy)
			stock_buys.visible = i == recent_buy_index
		else:
			stock_buy = "Control2/stockline_selected" + str(i)
			stock_buys = get_node(stock_buy)
			stock_buys.visible = i == recent_button_index

# Function to update the money_stock label
func updateMoneyStockLabel(money):
	money_stock.text = '$' + str(money)
	$"stock_homepage/Money_total2".text = str(money)

# Main function to determine the selected category and set stock values
func updateStockValues(stocks ,indexes):
	for l in range(0, 9): 
		if stock_MEGA.visible:
			setStockValues(categories['MEGA'], l ,stocks)
			graph_category = categories['MEGA']
		elif stock_LARGE.visible:
			setStockValues(categories['LARGE'], l ,stocks)
			graph_category = categories['LARGE']
		elif stock_MID.visible:
			setStockValues(categories['MID'], l ,stocks)
			graph_category = categories['MID']
		elif stock_SMALL.visible:
			setStockValues(categories['SMALL'], l ,stocks)
			graph_category = categories['SMALL']
		elif stock_MICRO.visible:
			setStockValues(categories['MICRO'], l ,stocks)
			graph_category = categories['MICRO']
		elif stock_INDEX.visible:
			graph_category = 'false'
			# Convert keys and values of the dictionary into arrays
			var stock_names = indexes.keys()
			var stock_data = indexes.values()

			# Assuming you want to set values for 9 stocks in the BUY_STOCK_PAGE
			for i in range(9):
				var value_label_index = get_node("BUY_STOCK_PAGE/buy_value" + str(i + 1))
				
				if i < stock_names.size():
					var stock_name = stock_names[i]
					var stock_info = stock_data[i]
					
					if stock_info['Stock change'] == 'Increasing':
						value_label_index.modulate = increase_colour
					elif stock_info['Stock change'] == 'Decreasing':
						value_label_index.modulate = decrease_colour
					else:
						value_label_index.modulate = no_change_colour
					
					value_label_index.text = str(stock_info['Current stock price'])
					get_node("BUY_STOCK_PAGE/buy_ticker" + str(i + 1)).text = stock_name
				else:
					value_label_index.text = ""
					get_node("BUY_STOCK_PAGE/buy_ticker" + str(i + 1)).text = ""
		else:
			# Hide all the labels if none of the categories are selected
			for i in range(0, 9):
				get_node("BUY_STOCK_PAGE/buy_value" + str(i + 1)).text = ""
				get_node("BUY_STOCK_PAGE/buy_ticker" + str(i + 1)).text = ""

# Function to set buy_value and buy_ticker for a given category
func setStockValues(category_stocks, index, stocks: Dictionary):
	if index < category_stocks.size():
		var stock_ticker = category_stocks[index]
		
		var value_label = get_node("BUY_STOCK_PAGE/buy_value" + str(index + 1))
		if stocks[stock_ticker]['Stock change'] ==  'Increasing':
			value_label.modulate = increase_colour
		elif stocks[stock_ticker]['Stock change'] == 'Decreasing':
			value_label.modulate = decrease_colour
		else:
			value_label.modulate = no_change_colour
		value_label.text = str(stocks[stock_ticker]['Current stock price'])
		get_node("BUY_STOCK_PAGE/buy_ticker" + str(index + 1)).text = stock_ticker

		
	else:
		# Hide the labels for stocks that don't exist in this category
		get_node("BUY_STOCK_PAGE/buy_value" + str(index + 1)).text = ""
		get_node("BUY_STOCK_PAGE/buy_ticker" + str(index + 1)).text = ""



var maximum_graph_value = 0
var minimum_graph_value = 0
var price_values = 0
var change_in_stock = 0
var dictionary = ''
var stock_ticker = ''
var percentage_change_in_stock = 0
var market_cap = 0
var EPS = 0
var analysis = 0
	
#find maximun value
func findLowestAndHighest(list: Array):


	var lowest = list[0]
	var highest = list[0]

	for i in range(1, list.size()):
		if list[i] < lowest:
			lowest = list[i]
		if list[i] > highest:
			highest = list[i]
	maximum_graph_value = highest
	minimum_graph_value = lowest

func graph_stock(graph_category, recent_button_index, stocks, indexes):
	var button
	if $"BUY_STOCK_PAGE".visible == true:
		button = recent_button_index -  1 
	else:
		button = recent_button_index -  2
	var indexes_key = indexes.keys()
	var addition_sign = ''

	var dictionary
	var stock_ticker
	var market_cap
	var EPS
	var analysis
	if graph_category is String:
		dictionary = indexes
		stock_ticker = indexes_key[button]
		market_cap = '-'
		EPS = '-'
		analysis = '-'
	else:
		dictionary = stocks
		stock_ticker = graph_category[button]
		market_cap = stock_calculation.roundToTwoDecimals(dictionary[stock_ticker]['Current stock price'] * dictionary[stock_ticker]['Shares outstanding'])
		market_cap = str(market_cap) + 'B'
		EPS = stock_calculation.roundToTwoDecimals(dictionary[stock_ticker]['Free cash flow'] / dictionary[stock_ticker]['Shares outstanding'])
		analysis = dictionary[stock_ticker]['Analysis confidence']

	var price_values
	var change_in_stock
	var percentage_change_in_stock
	if graph_time == 'month':
		price_values = dictionary[stock_ticker]['Graph data 1 month']
		change_in_stock = dictionary[stock_ticker]['Current stock price'] - price_values[15]
		percentage_change_in_stock = (change_in_stock / price_values[15]) * 100
	elif graph_time == 'week':
		price_values = dictionary[stock_ticker]['Graph data 1 week']
		change_in_stock = dictionary[stock_ticker]['Current stock price'] - price_values[4]
		percentage_change_in_stock = (change_in_stock / price_values[4]) * 100
	else:
		price_values = dictionary[stock_ticker]['Graph data 1 day']
		var last_value = price_values.size() - 1
		change_in_stock = dictionary[stock_ticker]['Current stock price'] - price_values[last_value]
		percentage_change_in_stock = (change_in_stock / price_values[last_value]) * 100

	graph.add_value(price_values)
	$"BUY_STOCK_PAGE/GRAPH_PRICE".text = str(dictionary[stock_ticker]['Current stock price'])
	$"BUY_STOCK_PAGE/graph_ticker".text = stock_ticker

	percentage_change_in_stock = stock_calculation.roundToTwoDecimals(percentage_change_in_stock)
	change_in_stock = stock_calculation.roundToTwoDecimals(change_in_stock)

	var percentage_increase_graph = $"BUY_STOCK_PAGE/percentage_increase_graph"
	if change_in_stock > 0:
		percentage_increase_graph.modulate = increase_colour
		addition_sign = '+'
	elif change_in_stock < 0:
		percentage_increase_graph.modulate = decrease_colour
	else:
		percentage_increase_graph.modulate = Color(128, 128, 128)
	percentage_increase_graph.text = addition_sign + str(change_in_stock) + ' (' + addition_sign + str(percentage_change_in_stock) + '%)'

	findLowestAndHighest(price_values)
	$"BUY_STOCK_PAGE/STAT_NUMBERS".text = str(price_values[0])
	$"BUY_STOCK_PAGE/STAT_NUMBERS2".text = str(maximum_graph_value)
	$"BUY_STOCK_PAGE/STAT_NUMBERS3".text = str(minimum_graph_value)

	findLowestAndHighest(dictionary[stock_ticker]['Graph data 1 month'])
	$"BUY_STOCK_PAGE/STAT_NUMBERS4".text = str(maximum_graph_value)
	$"BUY_STOCK_PAGE/STAT_NUMBERS5".text = str(minimum_graph_value)
	$"BUY_STOCK_PAGE/STAT_NUMBERS6".text = str(dictionary[stock_ticker]['Volume']) + 'M'
	$"BUY_STOCK_PAGE/STAT_NUMBERS7".text = str(market_cap)
	$"BUY_STOCK_PAGE/STAT_NUMBERS8".text = str(EPS)
	$"BUY_STOCK_PAGE/STAT_NUMBERS10".text = analysis
	$"BUY_STOCK_PAGE/ABOUT".text = dictionary[stock_ticker]['About']

	graph.create_graph()
	graph.add_value(price_values)
	update_buy_menu(stock_ticker, dictionary)

func update_buy_menu(stock_ticker, dictionary):
	$"BUY_STOCK_PAGE/buy_menu"/Buy_ticker.text = stock_ticker
	$"BUY_STOCK_PAGE/buy_menu"/total_cash.text = '$' + str(money)
	$"BUY_STOCK_PAGE/buy_menu"/current_price_label.text = 'Current Buy Price ' + str(dictionary[stock_ticker]['Current stock price'])

	if version == 'buy':
		$"BUY_STOCK_PAGE/buy_menu"/stock_order_amount.text = '+' + str(slider.value) + ' Stocks'
		$"BUY_STOCK_PAGE/buy_menu"/buy_bytton.text = 'BUY THIS STOCK'
		$"BUY_STOCK_PAGE/buy_menu"/total_amount_spent.text = '-' + str(stock_calculation.roundToTwoDecimals(slider.value * dictionary[stock_ticker]['Current stock price']))
		$"BUY_STOCK_PAGE/buy_menu"/total_amount_spent.modulate = no_change_colour if slider.value == 0 else decrease_colour
		var max_slider_value = float(money) / dictionary[stock_ticker]['Current stock price']
		slider.max_value = int(max_slider_value)
		if slider.value != 0 and confirm_buy == true:
			purchase_stock(stock_ticker, slider.value)
			money = float(money) - float(slider.value) * float(dictionary[stock_ticker]['Current stock price'])
			confirm_buy = false

	elif version == 'sell':
		$"BUY_STOCK_PAGE/buy_menu"/stock_order_amount.text = '-' + str(slider.value) + ' Stocks'
		$"BUY_STOCK_PAGE/buy_menu"/buy_bytton.text = 'SELL THIS STOCK'
		$"BUY_STOCK_PAGE/buy_menu"/total_amount_spent.text = '+' + str(stock_calculation.roundToTwoDecimals(slider.value * dictionary[stock_ticker]['Current stock price']))
		$"BUY_STOCK_PAGE/buy_menu"/total_amount_spent.modulate = no_change_colour if slider.value == 0 else increase_colour
		var max_slider_value
		if stock_ticker in stock_data.userStocks:
			max_slider_value = stock_data.userStocks[stock_ticker]
		else: 
			max_slider_value = 0
		slider.max_value = int(max_slider_value)
		if slider.value != 0 and confirm_buy == true:
			sell_stock(stock_ticker, slider.value)
			money = float(money) + float(slider.value) * float(dictionary[stock_ticker]['Current stock price'])
			confirm_buy = false

# Function to purchase a stock
func purchase_stock(ticker, stocks):
	if stock_data.userStocks.has(ticker):
		# If the user already has this stock, add to the existing amount
		stock_data.userStocks[ticker] += stocks
	else:
		# If the user doesn't have this stock, check if there's room for more stocks
		if stock_data.userStocks.size() >= maxStocks:
			# Handle the case where the user has reached the maximum number of stocks
			$"BUY_STOCK_PAGE/buy_menu/warning".visible = true
			$"BUY_STOCK_PAGE/buy_menu/warning/warning_timer".start()
		else:
			# Add the new stock to the user's portfolio
			stock_data.userStocks[ticker] = stocks
			$"BUY_STOCK_PAGE/buy_menu/success".visible = true
			$"BUY_STOCK_PAGE/buy_menu/success/warning_timer".start()

# Function to sell a stock
func sell_stock(ticker, stocks):
	if stock_data.userStocks.has(ticker):
		$"BUY_STOCK_PAGE/buy_menu/warning_selling2".visible = true
		$"BUY_STOCK_PAGE/buy_menu/success/warning_timer".start()
		if stock_data.userStocks[ticker] >= stocks:
			# Subtract the sold stocks from the user's portfolio
			stock_data.userStocks[ticker] -= stocks
			if stock_data.userStocks[ticker] == 0:
				# If the user has no more stocks of this type, remove it from the portfolio
				stock_data.userStocks.erase(ticker)
		else:
			pass
	else:
		$"BUY_STOCK_PAGE/buy_menu/warning_selling".visible = true
		$"BUY_STOCK_PAGE/buy_menu/success/warning_timer".start()

# Define a function to set element visibility based on recent_stock_index
func setElementVisibility(recent_stock_index):
	# Define an array of element paths
	var element_paths = [
		"BUY_STOCK_PAGE/MEGA_SELECTED",
		"BUY_STOCK_PAGE/LARGE_SELECTED",
		"BUY_STOCK_PAGE/MID_SELECTED",
		"BUY_STOCK_PAGE/SMALL_SELECTED",
		"BUY_STOCK_PAGE/MICRO_SELECTED",
		"BUY_STOCK_PAGE/INDEX_SELECTED"
	]

	# Loop through the elements and set visibility
	for i in range(len(element_paths)):
		var element_path = element_paths[i]
		var element = get_node(element_path)

		# Set the visibility based on the index
		element.visible = i + 1 == recent_stock_index
func updateDayCounter():
	$"day_Counter".text = 'DAY: ' + str(day_counter)
	money = stock_calculation.roundToTwoDecimals(float(money))
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
