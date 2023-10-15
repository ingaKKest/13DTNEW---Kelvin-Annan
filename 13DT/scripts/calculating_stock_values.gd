extends Sprite2D

@onready var stock_data = $home_button
@onready var stocks = stock_data.stocks


# Separate the stocks into their respective categories
var stocksByCategory = {
	'Mega': [],
	'Large': [],
	'Mid': [],
	'Micro': []
}
func roundToTwoDecimals(number: float) -> float:
	return round(number * 100) / 100

var totalEconomy = 0
var economyGrowthRate = 0

#Define the chance percentages for each news value for each stock category
var megaCapChances = [0.0001, 0.01, 0.09, 0.80, 0.09, 0.01, 0.0001]
var largeCapChances = [0.001, 0.02, 0.15, 0.66, 0.15, 0.02, 0.001]
var midCapChances = [0.001, 0.05, 0.25, 0.40, 0.25, 0.05, 0.001]
var microCapChances = [0.1, 0.15, 0.30, 0.40, 0.30, 0.15, 0.1]
# Combine all chances into a dictionary for easy access based on stock category
var chanceDict = {
	'Mega': megaCapChances,
	'Large': largeCapChances,
	'Mid': midCapChances,
	'Micro': microCapChances
}

func set_momentum_levels(stocks):
	for ticker in stocks:
		stocks[ticker]['momentum_level'] = 1
		
# Helper function to update stock and index data at the end of the day
func end_of_day(index_dict, stocks):
	# Update index data
	for index in index_dict.keys():
		# Reset 'Graph data 1 day' to the current stock price
		index_dict[index]['Graph data 1 day'] = [index_dict[index]['Current stock price']]

		# Update 'Graph data 1 month' and 'Graph data 1 week'
		index_dict[index]['Graph data 1 month'].pop_back()
		index_dict[index]['Graph data 1 month'].insert(0, index_dict[index]['Current stock price'])
		index_dict[index]['Graph data 1 week'].pop_back()
		index_dict[index]['Graph data 1 week'].insert(0, index_dict[index]['Current stock price'])

	# Update stock data
	for ticker in stocks.keys():
		# Update 'Graph data 1 month' and 'Graph data 1 week'
		stocks[ticker]['Graph data 1 month'].pop_back()
		stocks[ticker]['Graph data 1 month'].insert(0, stocks[ticker]['Current stock price'])
		stocks[ticker]['Graph data 1 week'].pop_back()
		stocks[ticker]['Graph data 1 week'].insert(0, stocks[ticker]['Current stock price'])

@onready var momentum_level_percentages = stock_data.momentum_level_percentages

# Helper function to get the weight for a category
func getWeightForCategory(category):
	match category:
		'Mega':
			return 10
		'Large':
			return 5
		'Mid':
			return 2
		'Micro':
			return 1
		_:
			return 1

# Helper function to get the category of a stock
func getStockCategory(stockSymbol):
	if stocksByCategory['Mega'].find(stockSymbol) != -1:
		return 'Mega'
	elif stocksByCategory['Large'].find(stockSymbol) != -1:
		return 'Large'
	elif stocksByCategory['Mid'].find(stockSymbol) != -1:
		return 'Mid'
	elif stocksByCategory['Micro'].find(stockSymbol) != -1:
		return 'Micro'
	else:
		return 'Small'
		
func calculateEconomy():
	totalEconomy = 0
	# Iterate over each stock and calculate its contribution to the economy
	for stockSymbol in stocks.keys():
		var stockData = stocks[stockSymbol]
		var category = getStockCategory(stockSymbol)
		var newsValue = stockData['Company News Value']

		# Apply the weight based on the category
		var weight = getWeightForCategory(category)
		totalEconomy += newsValue * weight
	
	var growthRateMap = {
		-180: -10,
		-90: -5,
		-60: -2,
		-30: 0,
		-15: 2,
		20: 5
	}

	# Find the corresponding economyGrowthRate value in the map
	economyGrowthRate = 10  # Default value
	for threshold in growthRateMap.keys():
		if totalEconomy <= threshold:
			economyGrowthRate = growthRateMap[threshold]
			break
	
	return economyGrowthRate

# Function to assign company news value to each stock based on chance and stock category
func assignNewsValuesToStocks(stocks: Dictionary) -> void:
	var currentCategory = 'Mega'
	var stockIndex = 1

	# Iterate over the stocks and assign the company news value based on the chance percentages
	for stockSymbol in stocks.keys():
		var chanceArray = chanceDict[currentCategory]
		var newsValue = assignNewsValue(chanceArray)
		stocks[stockSymbol]['Company News Value'] = newsValue

		# Move to the next stock category after processing 9 stocks in the current category
		if stockIndex % 9 == 0:
			stockIndex = 1
			if currentCategory == 'Mega':
				currentCategory = 'Large'
			elif currentCategory == 'Large':
				currentCategory = 'Mid'
			elif currentCategory == 'Mid':
				currentCategory = 'Micro'
		else:
			stockIndex += 1

		# Store stocks in the corresponding category list
		stocksByCategory[currentCategory].append(stockSymbol)

# Helper function to assign a company news value based on the chance percentages
func assignNewsValue(chances):
	var rand = randf()
	var total = 0.0
	for i in range(chances.size()):
		total += chances[i]
		if rand < total:
			return getNewsValueByIndex(i)

	# In case the random number is larger than the total chances, return the last value
	return getNewsValueByIndex(chances.size() - 1)

# Helper function to map the index to the corresponding news value
func getNewsValueByIndex(index):
	var newsValues = [-25, -5, -2, 0, 2, 5, 25]
	return newsValues[index]
	
# Calculates new stock values based on predicated data
func calculate_stocks(stocks: Dictionary) -> void:
	assignNewsValuesToStocks(stocks)
	calculateEconomy()
	# for loop to edit every stock in the dictionary
	for ticker in stocks:
		# Extract values from the stocks dictionary for the current stock
		var current_FCF = stocks[ticker]['Free cash flow']
		var growth_rate_5_years = stocks[ticker]['Growth rate 1-5 years'] / 100
		var growth_rate_10_years = stocks[ticker]['Growth rate 6-10 years'] / 100
		var shares_outstanding = stocks[ticker]['Shares outstanding']
		var excess_capital = stocks[ticker]['Excess capital']
		var stock_value = stocks[ticker]['Current stock price']
		var news_value = stocks[ticker]['Company News Value']
		var month_graph_values = stocks[ticker]['Graph data 1 month']
		# Assign the company news value to each stock
		# Calculate the 1-day stock change using the calculate_stock_change function
		var stock_change_1_day = calculate_stock_change(current_FCF, growth_rate_5_years, growth_rate_10_years, shares_outstanding, excess_capital, stock_value)
		stock_change_1_day = (stock_value * (float(news_value) /100) ) + stock_change_1_day
		stock_change_1_day =  roundToTwoDecimals(stock_change_1_day)
		# Adjust stock_change_1_day based on the company news value
		if stock_change_1_day > 0:
			stocks[ticker]['Stock change'] = 'Increasing'
		elif stock_change_1_day < 0:
			stocks[ticker]['Stock change'] = 'Decreasing'
		else:
			stocks[ticker]['Stock change'] = 'None'
			
		#set new calculated values into the dictionary 
		stocks[ticker]['Current stock price'] = stock_value + stock_change_1_day
		stocks[ticker]['Graph data 1 day'] = [stocks[ticker]['Graph data 1 day'][0]]
		stocks[ticker]['Graph data 1 day'].insert(0, (stocks[ticker]['Current stock price']))
		

		
func calculate_stock_change(
	current_FCF: float,
	growth_rate_5_years: float,
	growth_rate_10_years: float,
	shares_outstanding: float,
	excess_capital: float,
	stock_value: float) -> float:

	# Calculate Free Cash Flow for each year
	var FCF_years = []
	for i in range(10):
		current_FCF *= (1 + growth_rate_5_years if i < 5 else 1 + growth_rate_10_years)
		FCF_years.append(current_FCF)

	# Calculate Present Value for each year
	var PV_years = []
	for i in range(10):
		var present_value = FCF_years[i] / pow(1.1, i + 1)
		PV_years.append(present_value)

	# Calculate the total Free Cash Flow for 10 years and its present value
	var free_cash_flow_10_year_total = FCF_years[9] * 15
	var PV_total = free_cash_flow_10_year_total / pow(1.1, 10)

 # Calculate the total present value over 10 years
	var PV_10_year_total = 0
	for i in range(10):
		PV_10_year_total += PV_years[i]
	PV_10_year_total += PV_total

	# Calculate the intrinsic value (Market Cap)
	var intrinsic_value = PV_10_year_total + excess_capital

	# Calculate the new 365-day Stock Value
	var new_365_day_stock_value = intrinsic_value / shares_outstanding

	# Calculate the 1-day Stock Change
	var stock_change_1_day = (new_365_day_stock_value - stock_value) / 500

	return stock_change_1_day
	
# updates stock price
func updateCurrentStockPrices(index_dict):
	for index in index_dict:
		var current_stock_price = index_dict[index]['Current stock price']
		var average_rate_of_return = index_dict[index]['Average rate of return']

		# Calculate the new current stock price using the formula
		var new_current_stock_price = (1 + average_rate_of_return / 100) * current_stock_price * (1 + economyGrowthRate / 100)
		var one_day_index_increase = current_stock_price + (new_current_stock_price/ 2500)
		# Update the dictionary with the new current stock price
		one_day_index_increase = roundToTwoDecimals(one_day_index_increase)
		index_dict[index]['Current stock price'] = one_day_index_increase
		if one_day_index_increase > 0:
			index_dict[index]['Stock change'] =  'Increasing'
		elif one_day_index_increase < 0:
			index_dict[index]['Stock change'] =  'Decreasing'
		else:
			index_dict[index]['Stock change'] = 'None'

		index_dict[index]['Graph data 1 day'].insert(0, (one_day_index_increase))


func day_values(stocks: Dictionary, categories: Dictionary, momentum_level_percentages: Dictionary):
	for category in ['MEGA', 'LARGE', 'MID', 'SMALL', 'MICRO']:
		for ticker in categories[category]:
				update_stock(ticker, category)

func update_stock(ticker, category):
	var percentage = get_stock_value()
	var momentum_level = stocks[ticker]['momentum_level']

	if momentum_level < 4:
		var thresholds = [50, 60, 70, 80, 90]
		for level in range(momentum_level + 1, 5):
			if percentage > thresholds[level - 1]:
				momentum_level = level
				stocks[ticker]['Stock change'] = 'Increasing'
			else:
				momentum_level = 0
				stocks[ticker]['Stock change'] = 'Decreasing'

	var stock_change = stock_percentages(momentum_level_percentages, [category], str(momentum_level))
	stocks[ticker]['stock_value_change'] = float(stock_change) / 100

	if stocks[ticker]['Stock change'] == 'Decreasing':
		stocks[ticker]['stock_value_change'] = 1 - stocks[ticker]['stock_value_change']

	elif stocks[ticker]['Stock change'] == 'Increasing':
		stocks[ticker]['stock_value_change'] = 1 + stocks[ticker]['stock_value_change']

	var stock_price = stocks[ticker]['Current stock price'] * stocks[ticker]['stock_value_change']
	stocks[ticker]['Current stock price'] = roundToTwoDecimals(stock_price)
	stocks[ticker]['Graph data 1 day'].insert(0, stocks[ticker]['Current stock price'])

func get_stock_value():
	return randf() * 100.0

func stock_percentages(momentum_level_percentages, index, level):
	var stock_percentage = get_stock_value()
	level = int(level) + 1
	level = str(level)

	var change = 0
	index = index[0]
	var thresholds = [60, 80, 90, 95, 97, 99]
	for i in range(thresholds.size()):
		if stock_percentage <= thresholds[i]:
			change = momentum_level_percentages[index][level][i]
			break
	return change

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
