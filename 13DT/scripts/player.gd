extends CharacterBody3D

@onready var camera_mount = $camera_mount
@onready var animation_player = $visuals/mixamo_base/AnimationPlayer
@onready var visuals = $visuals
@onready var phone = $phone
@onready var phone_to_do = $"phone/To-do"
@onready var phone_message = $phone/Message
@onready var phone_stock = $phone/stock
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
var SPEED = 3
const JUMP_VELOCITY = 4.5

var walking_speed = 3
var running_speed = 5

var phonePictures = [phone_to_do,phone_message,phone_stock]
var currentPictureIndex = 0
var phone_activated = false

var running = false
var is_locked = false

var money = "10000"

# Economy multipliers for each category
var economyMultipliers = {
	'Mega': 5,
	'Large': 3,
	'Mid': 2,
	'Small': 1,
	'Micro': 1
}

@export var sens_horizontal = .5
@export var sens_vertical = .5
# colour for changing stock prices 
var increase_colour = Color(0, 1, 0)
var decrease_colour = Color(1, 0, 0)
var no_change_colour = Color(255, 255, 255)
var rotation_speed = 10
var totalEconomy = 0
var economyGrowthRate = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var stocks_owned = [{"ticker" : "APPL", "value": 150.25, "shares": 10},
 {"ticker" : "TSLA", "value": 3500.75, "shares": 20}
]

var stocks = {
	'APPL': {
		'Free cash flow': 97.5,
		'Excess capital': 22,
		'Growth rate 1-5 years': 7.96,
		'Growth rate 6-10 years': 16.0,
		'Shares outstanding': 15.8,
		'Industry outlook': 10,
		'Confidence level': 10,
		'Analysis confidence': 6,
		'Industry': 'consumer electronics',
		'Current stock price': 193.73,
		'Company News Value': 0,
		'Graph data 1 month': [193.73, 193.99, 190.69, 190.54, 189.77, 188.08, 188.61, 190.68, 191.81, 191.33, 192.46, 193.97, 189.59, 189.25, 188.06, 185.27],
		'Graph data 1 week': [193.73, 193.99, 190.69, 190.54, 189.77],
		'Stock change': 'None'
	},
	'GOOG': {
		'Free cash flow': 60,
		'Excess capital': 21.9,
		'Growth rate 1-5 years': 18.0,
		'Growth rate 6-10 years': 36.0,
		'Shares outstanding': 6.82,
		'Industry outlook': 3,
		'Confidence level': 4,
		'Analysis confidence': 8,
		'Industry': 'communication services',
		'Current stock price': 124.08,
		'Company News Value': 0,
		'Graph data 1 month': [124.08, 125.06, 125.70, 124.83, 119.62, 117.71, 116.87, 120.14, 120.93, 122.63, 120.56, 120.97, 120.01, 121.08, 119.01, 119.09],
		'Graph data 1 week': [124.08, 125.06, 125.70, 124.83, 119.62],
		'Stock change': 'None'
 
	},
	'MSFT': {
		'Free cash flow': 59.6,
		'Excess capital': 15.9,
		'Growth rate 1-5 years': 12.8,
		'Growth rate 6-10 years': 25.0,
		'Shares outstanding': 7.4,
		'Industry outlook': 10,
		'Confidence level': 2,
		'Analysis confidence': 7,
		'Industry': 'software',
		'Current stock price': 359.49,
		'Company News Value': 0,
		'Graph data 1 month': [359.49, 345.73, 345.24, 342.66, 337.20, 332.47, 331.83, 337.22, 341.27, 338.15, 337.99, 340.54, 335.05, 335.85, 334.57, 328.60],
		'Graph data 1 week': [359.49, 345.73, 345.24, 342.66, 337.20],
		'Stock change': 'None'
	},
	'AMZN': {
		'Free cash flow': 25.9,
		'Excess capital': 54,
		'Growth rate 1-5 years': 72.4,
		'Growth rate 6-10 years': 42.4,
		'Shares outstanding': 10.26,
		'Industry outlook': 9,
		'Confidence level': 8,
		'Analysis confidence': 5,
		'Industry': 'internet retail',
		'Current stock price': 132.82,
		'Company News Value': 0,
		'Graph data 1 month': [132.83, 133.56, 134.68, 134.30, 130.80, 128.78, 127.13, 129.78, 128.36, 130.38, 130.22, 130.36, 127.90, 129.04, 129.18, 127.33],
		'Graph data 1 week': [132.83, 133.56, 134.68, 134.30, 130.80],
		'Stock change': 'None'
	},
	'TSLA': {
		'Free cash flow': 7.5,
		'Excess capital': 16.9,
		'Growth rate 1-5 years': 10.85,
		'Growth rate 6-10 years': 21.0,
		'Shares outstanding': 3.17,
		'Industry outlook': 10,
		'Confidence level': 10,
		'Analysis confidence': -2,
		'Industry': 'auto manufacturers',
		'Current stock price': 293.34,
		'Company News Value': 0,
		'Graph data 1 month': [293.34, 290.38, 281.38, 277.90, 271.99, 269.79, 269.61, 274.43, 276.54, 282.48, 279.82, 261.77, 257.50, 256.24, 250.21, 241.05],
		'Graph data 1 week': [293.34, 290.38, 281.38, 277.90, 271.99],
		'Stock change': 'None'
	},
	'NVDA': {
		'Free cash flow': 3.8,
		'Excess capital': 3.8,
		'Growth rate 1-5 years': 19.0,
		'Growth rate 6-10 years': 38.0,
		'Shares outstanding': 2.47,
		'Industry outlook': 7,
		'Confidence level': 4,
		'Analysis confidence': 3,
		'Industry': 'semiconductors',
		'Current stock price': 474.94,
		'Company News Value': 0,
		'Graph data 1 month': [474.94, 464.61, 454.69, 459.77, 439.02, 424.05, 421.80, 425.03, 421.03, 423.17, 424.13, 423.02, 408.22, 411.17, 418.76, 406.32],
		'Graph data 1 week': [474.94, 464.61, 454.69, 459.77, 439.02],
		'Stock change': 'None'
	},
	'META': {
		'Free cash flow': 19.04,
		'Excess capital': 15.6,
		'Growth rate 1-5 years': 19.25,
		'Growth rate 6-10 years': 38.5,
		'Shares outstanding': 2.59,
		'Industry outlook': 3,
		'Confidence level': 7,
		'Analysis confidence': 3,
		'Industry': 'communication services',
		'Current stock price': 312.05,
		'Company News Value': 0,
		'Graph data 1 month': [312.05, 310.62, 308.87, 313.41, 309.34, 298.29, 294.10, 290.53, 291.99, 294.37, 286.02, 286.98, 281.53, 285.29, 287.05, 278.47],
		'Graph data 1 week': [312.05, 310.62, 308.87, 313.41, 309.34],
		'Stock change': 'None'
	},
	'V': {
		'Free cash flow': 17.7,
		'Excess capital': 18.7,
		'Growth rate 1-5 years': 13.04,
		'Growth rate 6-10 years': 26.08,
		'Shares outstanding': 2.06,
		'Industry outlook': 8,
		'Confidence level': 6,
		'Analysis confidence': 5,
		'Industry': 'finance',
		'Current stock price': 240.77,
		'Company News Value': 0,
		'Graph data 1 month': [240.77, 243.99, 243.16, 243.31, 242.21, 240.55, 238.16, 236.45, 238.88, 239.45, 237.97, 237.48, 234.32, 227.96, 227.34, 226.30],
		'Graph data 1 week': [240.77, 243.99, 243.16, 243.31, 242.21],
		'Stock change': 'None'
	},
	'WMT': {
		'Free cash flow': 12.24,
		'Excess capital': 9,
		'Growth rate 1-5 years': 5.36,
		'Growth rate 6-10 years': 10.6,
		'Shares outstanding': 2.69,
		'Industry outlook': 1,
		'Confidence level': 2,
		'Analysis confidence': 2,
		'Industry': 'retail',
		'Current stock price': 154.57,
		'Company News Value': 0,
		'Graph data 1 month': [154.57, 154.85, 154.66, 154.13, 155.04, 154.65, 154.88, 153.49, 157.11, 158.11, 158.20, 157.18, 154.28, 155.33, 154.49, 155.05],
		'Graph data 1 week': [154.57, 154.85, 154.66, 154.13, 155.04],
		'Stock change': 'None'
	},
	'NKE': {
		'Free cash flow': 3.8,
		'Excess capital': 7.12,
		'Growth rate 1-5 years': 15.1,
		'Growth rate 6-10 years': 30.2,
		'Shares outstanding': 1.54,
		'Industry outlook': 8,
		'Confidence level': 8,
		'Analysis confidence': 2,
		'Industry': 'apparel',
		'Current stock price': 109.72,
		'Company News Value': 0,
		'Graph data 1 month': [109.72, 108.71, 107.95, 107.84, 107.76, 107.39, 105.78, 104.46, 105.10, 107.10, 109.11, 110.37, 113.37, 113.03, 113.61, 111.74],
		'Graph data 1 week': [109.72, 108.71, 107.95, 107.84, 107.76],
		'Stock change': 'None'
	},
	'TMUS': {
		'Free cash flow': 0.55,
		'Excess capital': 4.6,
		'Growth rate 1-5 years': 65.4,
		'Growth rate 6-10 years': 64.4,
		'Shares outstanding': 1.22,
		'Industry outlook': 2,
		'Confidence level': 5,
		'Analysis confidence': 6,
		'Industry': 'telephone',
		'Current stock price': 138.45,
		'Company News Value': 0,
		'Graph data 1 month': [138.45, 138.00, 139.68, 140.69, 140.89, 140.02, 138.34, 138.97, 139.16, 139.56, 139.33, 138.90, 136.84, 136.27, 136.17, 134.85],
		'Graph data 1 week': [138.45, 138.00, 139.68, 140.69, 140.89],
		'Stock change': 'None'
	},
	'DIS': {
		'Free cash flow': 1.9,
		'Excess capital': 13,
		'Growth rate 1-5 years': 22.0,
		'Growth rate 6-10 years': 44.0,
		'Shares outstanding': 1.83,
		'Industry outlook': 9,
		'Confidence level': -2,
		'Analysis confidence': 1,
		'Industry': 'entertainment',
		'Current stock price': 85.95,
		'Company News Value': 0,
		'Graph data 1 month': [85.95, 85.56, 88.62, 90.47, 90.15, 89.49, 88.10, 88.64, 88.74, 89.79, 90.50, 89.28, 88.95, 88.83, 89.06, 88.70],
		'Graph data 1 week': [85.95, 85.56, 88.62, 90.47, 90.15],
		'Stock change': 'None'
	},
	'INTC': {
		'Free cash flow': 4.5,
		'Excess capital': 4,
		'Growth rate 1-5 years': 6.62,
		'Growth rate 6-10 years': 12.0,
		'Shares outstanding': 4.17,
		'Industry outlook': 7,
		'Confidence level': 2,
		'Analysis confidence': 4,
		'Industry': 'semiconductor',
		'Current stock price': 34.50,
		'Company News Value': 0,
		'Graph data 1 month': [34.50, 34.37, 33.15, 33.87, 33.98, 33.30, 32.74, 31.85, 31.97, 32.51, 33.62, 33.44, 32.91, 33.57, 34.10, 33.34],
		'Graph data 1 week': [34.50, 34.37, 33.15, 33.87, 33.98],
		'Stock change': 'None'
	},
	'VZ': {
		'Free cash flow': 10.4,
		'Excess capital': 4,
		'Growth rate 1-5 years': -0.73,
		'Growth rate 6-10 years': -1.4,
		'Shares outstanding': 4.21,
		'Industry outlook': 4,
		'Confidence level': 1,
		'Analysis confidence': 1,
		'Industry': 'communication services',
		'Current stock price': 32.27,
		'Company News Value': 0,
		'Graph data 1 month': [32.27, 31.46, 34.01, 34.64, 34.86, 34.99, 35.14, 35.90, 37.13, 37.48, 37.28, 37.19, 36.99, 36.82, 36.55],
		'Graph data 1 week': [32.27, 31.46, 34.01, 34.64, 34.86],
		'Stock change': 'None'
	},
	'BA': {
		'Free cash flow': 2,
		'Excess capital': 14,
		'Growth rate 1-5 years': 93.8,
		'Growth rate 6-10 years': 53.8,
		'Shares outstanding': 0.6,
		'Industry outlook': 3,
		'Confidence level': 4,
		'Analysis confidence': 4,
		'Industry': 'defense',
		'Current stock price': 211.57,
		'Company News Value': 0,
		'Graph data 1 month': [211.57, 211.87, 213.12, 216.85, 217.11, 218.76, 213.31, 212.10, 212.62, 213.31, 210.92, 211.16, 211.83, 210.72, 209.43, 205.58],
		'Graph data 1 week': [211.57, 211.87, 213.12, 216.85, 217.11],
		'Stock change': 'None'
		
	},
	'IBM': {
		'Free cash flow': 9,
		'Excess capital': 8,
		'Growth rate 1-5 years': 3.1,
		'Growth rate 6-10 years': 6.2,
		'Shares outstanding': 0.9,
		'Industry outlook': 7,
		'Confidence level': -2,
		'Analysis confidence': 1,
		'Industry': 'technology',
		'Current stock price': 135.36,
		'Company News Value': 0,
		'Graph data 1 month)': [135.36, 134.24, 133.40, 133.92, 132.84, 134.44, 132.90, 132.08, 132.16, 134.24, 133.67, 133.81, 134.06, 131.76, 132.34, 131.34],
		'Graph data 1 week': [135.36, 134.24, 133.40, 133.92, 132.84],
		'Stock change': 'None'
	},
	'GE': {
		'Free cash flow': 4.43,
		'Excess capital': 18,
		'Growth rate 1-5 years': 27.0,
		'Growth rate 6-10 years': 54.0,
		'Shares outstanding': 1.09,
		'Industry outlook': 1,
		'Confidence level': 2,
		'Analysis confidence': 1,
		'Industry': 'machinery',
		'Current stock price': 111.06,
		'Company News Value': 0,
		'Graph data 1 month': [111.06, 111.14, 110.28, 111.28, 111.20, 111.22, 110.53, 108.27, 107.37, 108.65, 108.28, 109.85, 107.74, 107.05, 104.92, 104.45],
		'Graph data 1 week': [111.06, 111.14, 110.28, 111.28, 111.20],
		'Stock change': 'None'
	},
	'ABNB': {
		'Free cash flow': 3.4,
		'Excess capital': 12.1,
		'Growth rate 1-5 years': 22.0,
		'Growth rate 6-10 years': 44.0,
		'Shares outstanding': 0.634,
		'Industry outlook': 7,
		'Confidence level': -10,
		'Analysis confidence': -10,
		'Industry': 'travel',
		'Current stock price': 146.53,
		'Company News Value': 0,
		'Graph data 1 month ': [146.53, 145.36, 143.34, 140.09, 137.02, 137.54, 131.71, 130.32, 128.16, 131.69, 132.35, 128.16, 125.10, 127.63, 127.89, 123.13],
		'Graph data 1 week': [146.53, 145.36, 143.34, 140.09, 137.02],
		'Stock change': 'None'
	},
	'DBX': {
		'Free cash flow': 0.76,
		'Excess capital': 0.232,
		'Growth rate 1-5 years': 12.07,
		'Growth rate 6-10 years': 24.0,
		'Shares outstanding': 0.347,
		'Industry outlook': 7,
		'Confidence level': 2,
		'Analysis confidence': 2,
		'Industry': 'software',
		'Current stock price': 28.03,
		'Company News Value': 0,
		 'Graph data 1 month': [
			28.03, 27.81, 27.29, 27.78, 27.55, 27.50, 27.36, 26.97, 26.73, 26.59,
			26.63, 26.67, 26.72, 26.72, 26.14, 25.83
		],
		'Graph data 1 week': [28.03, 27.81, 27.29, 27.78, 27.55],
		'Stock change': 'None'
		
	},
	'MNDY': {
		'Free cash flow': 0.008137,
		'Excess capital': 0.885,
		'Growth rate 1-5 years': 47.32,
		'Growth rate 6-10 years': 47.32,
		'Shares outstanding': 0.047,
		'Industry outlook': 7,
		'Confidence level': 5,
		'Analysis confidence': 5,
		'Industry': 'software',
		'Current stock price': 186.72,
		'Company News Value': 0,
		'Graph data 1 month': [
			186.72, 184.57, 174.56, 179.05, 175.91, 175.26, 166.34, 161.86, 163.67,
			167.57, 166.82, 171.22, 169.11, 172.72, 168.11, 163.88
		],
		'Graph data 1 week': [186.72, 184.57, 174.56, 179.05, 175.91],
		'Stock change': 'None'
	},
	'HAS': {
		'Free cash flow': 0.45,
		'Excess capital': 0.8,
		'Growth rate 1-5 years': 0.27,
		'Growth rate 6-10 years': 0.57,
		'Shares outstanding': 0.14,
		'Industry outlook': 9,
		'Confidence level': 2,
		'Analysis confidence': 2,
		'Industry': 'leisure',
		'Current stock price': 63.20,
		'Company News Value': 0,
		'Graph data 1 month': [
			63.20, 64.00, 64.10, 65.37, 64.89, 64.81, 64.08, 64.56, 64.30, 64.24,
			64.79, 64.77, 63.83, 63.265, 62.60, 60.98
		],
		'Graph data 1 week': [63.20, 64.00, 64.10, 65.37, 64.89],
		'Stock change': 'None'
	},
	'SOFI': {
		'Free cash flow': 0.1,
		'Excess capital': 1.86,
		'Growth rate 1-5 years': 123.5,
		'Growth rate 6-10 years': 123.5,
		'Shares outstanding': 0.9,
		'Industry outlook': 8,
		'Confidence level': 6,
		'Analysis confidence': 2,
		'Industry': 'finance',
		'Current stock price': 9.57,
		'Company News Value': 0,
		'Graph data 1 month': [
			9.57, 9.48, 9.08, 9.16, 9.20, 9.07, 8.71, 8.05, 8.10, 8.38, 8.52, 8.34,
			8.71, 8.87, 8.64, 8.20
		],
		'Graph data 1 week': [9.57, 9.48, 9.08, 9.16, 9.20],
		'Stock change': 'None'
		
		
	},
	'RL': {
		'Free cash flow': 0.19,
		'Excess capital': 1.7,
		'Growth rate 1-5 years': 12.5,
		'Growth rate 6-10 years': 24.0,
		'Shares outstanding': 0.066,
		'Industry outlook': 9,
		'Confidence level': 7,
		'Analysis confidence': -3,
		'Industry': 'apparel',
		'Current stock price': 128.34,
		'Company News Value': 0,
		'Graph data 1 month': [
			128.34, 125.99, 125.38, 126.68, 129.40, 130.85, 128.75, 122.55, 123.69,
			124.55, 123.69, 123.30, 123.11, 122.06, 121.50, 118.71
		],
		'Graph data 1 week': [128.34, 125.99, 125.38, 126.68, 129.40],
		'Stock change': 'None'
	},
	'SKX': {
		'Free cash flow': 0.19,
		'Excess capital': 0.6,
		'Growth rate 1-5 years': 28.0,
		'Growth rate 6-10 years': 52.0,
		'Shares outstanding': 0.155,
		'Industry outlook': 9,
		'Confidence level': 5,
		'Analysis confidence': 7,
		'Industry': 'apparel',
		'Current stock price': 53.9,
		'Company News Value': 0,
		'Graph data 1 month': [
			53.90, 52.90, 52.23, 52.52, 52.22, 52.03, 51.90, 51.50, 52.45, 52.54,
			53.50, 52.66, 50.33, 50.45, 50.32, 50.27
		],
		'Graph data 1 week': [53.90, 52.90, 52.23, 52.52, 52.22],
		'Stock change': 'None'
	},
 'CROX': {
		'Free cash flow': 0.5,
		'Excess capital': 0.2,
		'Growth rate 1-5 years': 10.0,
		'Growth rate 6-10 years': 20.0,
		'Shares outstanding': 0.061,
		'Industry outlook': 9,
		'Confidence level': 3,
		'Analysis confidence': 2,
		'Industry': 'apparel',
		'Current stock price': 127.34,
		'Graph data 1 month': [
			127.34, 127.10, 124.04, 125.99, 126.42, 120.44, 117.37, 112.43, 111.43,
			114.26, 117.06, 112.44, 108.21, 107.13, 107.08, 104.79
		],
		'Graph data 1 week': [127.34, 127.10, 124.04, 125.99, 126.42],
		'Stock change': 'None'
	},
	'VFC': {
		'Free cash flow': 1,
		'Excess capital': 0.8,
		'Growth rate 1-5 years': 1.62,
		'Growth rate 6-10 years': 3.2,
		'Shares outstanding': 0.38,
		'Industry outlook': 9,
		'Confidence level': 2,
		'Analysis confidence': 2,
		'Industry': 'apparel',
		'Current stock price': 19.50,
		'Graph data 1 month': [
			19.50, 19.11, 19.19, 19.63, 19.53, 19.27, 18.61, 18.66, 18.58, 18.97,
			19.14, 19.09, 19.20, 18.79, 19.13, 18.44
		],
		'Graph data 1 week': [19.50, 19.11, 19.19, 19.63, 19.53],
		'Stock change': 'None'
	},
	'MAT': {
		'Free cash flow': 0.3,
		'Excess capital': 0.761,
		'Growth rate 1-5 years': 5.0,
		'Growth rate 6-10 years': 10.0,
		'Shares outstanding': 0.34,
		'Industry outlook': 9,
		'Confidence level': 3,
		'Analysis confidence': 3,
		'Industry': 'leisure',
		'Current stock price': 20.87,
		'Graph data 1 month': [
			21.04, 20.87, 21.49, 21.44, 21.82, 21.83, 21.58, 20.99, 20.48, 19.91,
			20.00, 20.04, 19.54, 19.20, 18.98, 18.45
		],
		'Graph data 1 week': [21.04, 20.87, 21.49, 21.44, 21.82],
		'Stock change': 'None'
	},
	'JACK': {
		'Free cash flow': 0.13,
		'Excess capital': 0.18,
		'Growth rate 1-5 years': 8.8,
		'Growth rate 6-10 years': 16.0,
		'Shares outstanding': 0.02,
		'Industry outlook': 2,
		'Confidence level': 5,
		'Analysis confidence': 5,
		'Industry': 'restaurants',
		'Current stock price': 97.76,
		'Graph data 1 month': [
			96.83, 97.76, 96.62, 97.72, 96.96, 97.39, 96.31, 96.10, 94.68, 95.70,
			95.83, 97.33, 97.53, 95.50, 92.70, 90.65
		],
		'Graph data 1 week': [96.83, 97.76, 96.62, 97.72, 96.96],
		'Stock change': 'None'
	},
	'ZIP': {
		'Free cash flow': 0.118,
		'Excess capital': 0.22,
		'Growth rate 1-5 years': 10.0,
		'Growth rate 6-10 years': 20.0,
		'Shares outstanding': 0.1,
		'Industry outlook': 2,
		'Confidence level': 5,
		'Analysis confidence': 4,
		'Industry': 'industrials',
		'Current stock price': 18.82,
		'Graph data 1 month': [
			18.95, 18.92, 18.70, 18.54, 19.00, 18.68, 18.27, 18.13, 17.85, 17.63,
			17.65, 17.82, 17.76, 18.01, 17.37, 16.99
		],
		'Graph data 1 week': [18.95, 18.92, 18.70, 18.54, 19.00],
		'Stock change': 'None'
	},
	'CAKE': {
		'Free cash flow': 0.048,
		'Excess capital': 0.114,
		'Growth rate 1-5 years': 36.0,
		'Growth rate 6-10 years': 72.0,
		'Shares outstanding': 0.048,
		'Industry outlook': 2,
		'Confidence level': 2,
		'Analysis confidence': 2,
		'Industry': 'restaurants',
		'Current stock price': 36.07,
		'Graph data 1 month': [
			36.07, 36.50, 36.16, 36.18, 36.05, 35.95, 36.15, 36.21, 36.00, 35.80,
			35.88, 35.95, 35.78, 35.84, 35.65, 35.49
		],
		'Graph data 1 week': [36.07, 36.50, 36.16, 36.18, 36.05],
		'Stock change': 'None'
	},
	'PEB': {
		'Free cash flow': 0.28,
		'Excess capital': 0.05,
		'Growth rate 1-5 years': 9.0,
		'Growth rate 6-10 years': 18.0,
		'Shares outstanding': 0.125,
		'Industry outlook': 7,
		'Confidence level': 3,
		'Analysis confidence': 3,
		'Industry': 'real estate',
		'Current stock price': 14.26,
		'Graph data 1 month': [
			14.26, 14.29, 14.08, 14.03, 14.22, 14.22, 14.42, 14.50, 14.27, 14.09,
			14.17, 14.36, 14.06, 14.12, 13.77, 13.61
		],
		'Graph data 1 week': [14.26, 14.29, 14.08, 14.03, 14.22],
		'Stock change': 'None'
	},
	'BOWL': {
		'Free cash flow': 0.1,
		'Excess capital': 0.09,
		'Growth rate 1-5 years': 150.0,
		'Growth rate 6-10 years': 70.0,
		'Shares outstanding': 0.16,
		'Industry outlook': 8,
		'Confidence level': 7,
		'Analysis confidence': 7,
		'Industry': 'leisure',
		'Current stock price': 10.38,
		'Graph data 1 month': [
			10.82, 10.38, 11.36, 11.63, 11.78, 11.63, 11.59, 11.51, 11.30, 11.06,
			11.38, 11.33, 11.64, 11.39, 11.30, 11.46
		],
		'Graph data 1 week': [10.82, 10.38, 11.36, 11.63, 11.78],
		'Stock change': 'None'
	},
	'CMPR': {
		'Free cash flow': 0.1,
		'Excess capital': 0.123,
		'Growth rate 1-5 years': 20.0,
		'Growth rate 6-10 years': 40.0,
		'Shares outstanding': 0.026,
		'Industry outlook': 3,
		'Confidence level': 3,
		'Analysis confidence': 3,
		'Industry': 'communication services',
		'Current stock price': 66.31,
		'Graph data 1 month': [
			66.31, 65.48, 64.25, 64.85, 65.00, 65.16, 64.96, 64.77, 63.24, 62.57,
			62.60, 64.06, 63.60, 63.49, 63.20, 62.06
		],
		'Graph data 1 week': [66.31, 65.48, 64.25, 64.85, 65.00],
		'Stock change': 'None'
	},
	'EAT': {
		'Free cash flow': 0.1,
		'Excess capital': 0.014,
		'Growth rate 1-5 years': 7.3,
		'Growth rate 6-10 years': 14.6,
		'Shares outstanding': 0.044,
		'Industry outlook': 2,
		'Confidence level': 3,
		'Analysis confidence': 3,
		'Industry': 'restaurants',
		'Current stock price': 38.49,
		'Graph data 1 month': [
			39.60, 38.49, 37.36, 37.96, 38.10, 38.26, 38.06, 37.87, 36.34, 35.67,
			35.70, 37.06, 36.60, 36.49, 36.20, 35.80
		],
		'Graph data 1 week': [39.60, 38.49, 37.36, 37.96, 38.10],
		'Stock change': 'None'
	},
	'SAND': {
		'Free cash flow': 0.06,
		'Excess capital': 0.07,
		'Growth rate 1-5 years': 10.0,
		'Growth rate 6-10 years': 20.0,
		'Shares outstanding': 0.29,
		'Industry outlook': 3,
		'Confidence level': 6,
		'Analysis confidence': 6,
		'Industry': 'basic materials',
		'Current stock price': 5.58,
		'Graph data 1 month': [
			5.61, 5.58, 5.51, 5.57, 5.57, 5.57, 5.28, 5.26, 5.18, 4.96, 5.02, 5.28,
			5.12, 5.00, 4.91, 4.99
		],
		'Graph data 1 week': [5.61, 5.58, 5.51, 5.57, 5.57],
		'Stock change': 'None'
	},
	'OPK': {
		'Free cash flow': 0.005,
		'Excess capital': 0.15,
		'Growth rate 1-5 years': 12.0,
		'Growth rate 6-10 years': 24.0,
		'Shares outstanding': 0.75,
		'Industry outlook': 6,
		'Confidence level': 5,
		'Analysis confidence': 5,
		'Industry': 'healthcare',
		'Current stock price': 2.17,
		'Graph data 1 month': [
			2.15, 2.17, 2.12, 2.09, 2.09, 2.15, 2.15, 2.11, 2.05, 2.06, 2.10, 2.13,
			2.17, 1.955, 1.72, 1.66
		],
		'Graph data 1 week': [2.15, 2.17, 2.12, 2.09, 2.09],
		'Stock change': 'None'
	},
	'GPMT': {
		'Free cash flow': 0.06,
		'Excess capital': 0.14,
		'Growth rate 1-5 years': 4.91,
		'Growth rate 6-10 years': 10.0,
		'Shares outstanding': 0.05,
		'Industry outlook': 7,
		'Confidence level': 3,
		'Analysis confidence': 3,
		'Industry': 'Real Estate',
		'Current stock price': 5.63,
		'Graph data 1 month': [
			5.77, 5.63, 5.59, 5.57, 5.66, 5.59, 5.42, 5.33, 5.23, 5.13, 5.20, 5.27,
			5.30, 5.50, 5.39, 5.32
		],
		'Graph data 1 week': [5.77, 5.63, 5.59, 5.57, 5.66],
		'Stock change': 'None'
	},
	'LE': {
		'Free cash flow': 0.045,
		'Excess capital': 0.03,
		'Growth rate 1-5 years': 20.0,
		'Growth rate 6-10 years': 40.0,
		'Shares outstanding': 0.032,
		'Industry outlook': 8,
		'Confidence level': -2,
		'Analysis confidence': -2,
		'Industry': 'Apparel',
		'Current stock price': 8.72,
		'Graph data 1 month': [
			181.325, 181.275, 180.125, 180.175, 176.90, 176.875, 178.825, 177.20,
			177.00, 174.575, 174.95, 176.825, 181.50, 179.75, 179.625, 179.30
		],
		'Graph data 1 week': [181.325, 181.275, 180.125, 180.175, 176.90],
		'Stock change': 'None'
	},
	'GHL': {
		'Free cash flow': 0.026,
		'Excess capital': 0.1,
		'Growth rate 1-5 years': 144.35,
		'Growth rate 6-10 years': 75.0,
		'Shares outstanding': 0.018,
		'Industry outlook': 7,
		'Confidence level': -4,
		'Analysis confidence': -4,
		'Industry': 'Finance',
		'Current stock price': 14.77,
		'Graph data 1 month': [
			14.74, 14.77, 14.74, 14.75, 14.74, 14.73, 14.74, 14.69, 14.67, 14.65,
			14.65, 14.65, 14.65, 14.65, 14.62, 14.61
		],
		'Graph data 1 week': [14.74, 14.77, 14.74, 14.75, 14.74],
		'Stock change': 'None'
	},
	'III': {
		'Free cash flow': 0.007,
		'Excess capital': 0.03,
		'Growth rate 1-5 years': 10.0,
		'Growth rate 6-10 years': 20.0,
		'Shares outstanding': 0.048,
		'Industry outlook': 6,
		'Confidence level': 8,
		'Analysis confidence': 8,
		'Industry': 'Technology',
		'Current stock price': 5.48,
		'Graph data 1 month': [
			5.40, 5.48, 5.35, 5.35, 5.39, 5.39, 5.31, 5.25, 5.29, 5.22, 5.21, 5.33,
			5.36, 5.35, 5.25, 5.11
		],
		'Graph data 1 week': [5.40, 5.48, 5.35, 5.35, 5.39],
		'Stock change': 'None'
	},
	'RBB': {
		'Free cash flow': 0.091,
		'Excess capital': 0.083,
		'Growth rate 1-5 years': -8.0,
		'Growth rate 6-10 years': -16.0,
		'Shares outstanding': 0.018,
		'Industry outlook': 7,
		'Confidence level': 7,
		'Analysis confidence': 7,
		'Industry': 'Finance',
		'Current stock price': 13.55,
		'Graph data 1 month': [
			14.44, 13.55, 13.10, 12.63, 12.92, 12.58, 12.22, 12.11, 12.34, 11.63,
			11.96, 11.87, 11.94, 12.15, 11.98, 12.15
		],
		'Graph data 1 week': [14.44, 13.55, 13.10, 12.63, 12.92],
		'Stock change': 'None'
	},
	'PRTS': {
		'Free cash flow': 0.002,
		'Excess capital': 0.018,
		'Growth rate 1-5 years': 15.0,
		'Growth rate 6-10 years': 30.0,
		'Shares outstanding': 0.055,
		'Industry outlook': 7,
		'Confidence level': 7,
		'Analysis confidence': 7,
		'Industry': 'Internet Retail',
		'Current stock price': 4.47,
		'Graph data 1 month': [
			4.73, 4.47, 4.49, 4.52, 4.65, 4.66, 4.47, 4.27, 4.35, 4.23, 4.29, 4.21,
			4.25, 4.39, 4.32, 4.23
		],
		'Graph data 1 week': [4.73, 4.47, 4.49, 4.52, 4.65],
		'Stock change': 'None'
	},
	'FUSB': {
		'Free cash flow': 0.011,
		'Excess capital': 0.03,
		'Growth rate 1-5 years': 62.0,
		'Growth rate 6-10 years': 62.0,
		'Shares outstanding': 0.005,
		'Industry outlook': 7,
		'Confidence level': 2,
		'Analysis confidence': 2,
		'Industry': 'Finance',
		'Current stock price': 8.50,
		'Graph data 1 month': [
			8.795, 8.50, 8.51, 8.50, 8.50, 8.40, 8.50, 8.47, 8.50, 8.48, 8.71, 9.10,
			8.55, 8.54, 8.54, 8.4783
		],
		'Graph data 1 week': [8.795, 8.50, 8.51, 8.50, 8.50],
		'Stock change': 'None'
	},
	'CRTO': {
		'Free cash flow': 0.171,
		'Excess capital': 0.448,
		'Growth rate 1-5 years': -5.0,
		'Growth rate 6-10 years': -10.0,
		'Shares outstanding': 0.056,
		'Industry outlook': 3,
		'Confidence level': 2,
		'Analysis confidence': 2,
		'Industry': 'Communication Services',
		'Current stock price': 34.10,
		'Graph data 1 month': [
			33.74, 34.10, 34.18, 34.01, 34.57, 34.57, 34.40, 33.90, 33.37, 33.49,
			33.64, 33.92, 33.74, 33.61, 33.47, 33.02
		],
		'Graph data 1 week': [33.74, 34.10, 34.18, 34.01, 34.57],
		'Stock change': 'None'
	},
	'SNEX': {
		'Free cash flow': 1.131,
		'Excess capital': 7.4,
		'Growth rate 1-5 years': 19.0,
		'Growth rate 6-10 years': 38.0,
		'Shares outstanding': 19.93,
		'Industry outlook': 7,
		'Confidence level': 10,
		'Analysis confidence': 10,
		'Industry': 'Finance',
		'Current stock price': 90.62,
		'Graph data 1 month': [
			90.35, 90.62, 89.27, 88.71, 90.82, 89.97, 87.03, 82.92, 82.31, 82.44,
			82.50, 83.47, 83.08, 83.38, 82.08, 83.56
		],
		'Graph data 1 week': [90.35, 90.62, 89.27, 88.71, 90.82],
		'Stock change': 'None'
	}
}

var indexes = {
	'S&P500': {
		'Current stock price': 4554.98,
		'Average rate of return': 10.0,
		'Stock change': 'None'
	},
	'NZX50': {
		'Current stock price': 11944.54,
		'Average rate of return': 7.0,
		'Stock change': 'None'
	},
	'SWTSX': {
		'Current stock price': 77.28,
		'Average rate of return': 12.13,
		'Stock change': 'None'
	},
	'VTSAX': {
		'Current stock price': 110.28,
		'Average rate of return': 12.22,
		'Stock change': 'None'
	},
	'FZROX': {
		'Current stock price': 15.96,
		'Average rate of return': 10.81,
		'Stock change': 'None'
	},
	'FITLX': {
		'Current stock price': 20.23,
		'Average rate of return': 12.89,
		'Stock change': 'None'
	},
	'BASMX': {
		'Current stock price': 20.86,
		'Average rate of return': 11.27,
		'Stock change': 'None'
	},
	'FSKAX': {
		'Current stock price': 126.41,
		'Average rate of return': 12.19,
		'Stock change': 'None'
	},
	'VFTAX': {
		'Current stock price': 42.96,
		'Average rate of return': 13.89,
		'Stock change': 'None'
	}
}




var recent_button_index = 1
var recent_stock_index = 1
var recent_buy_index = 1

func _ready():
	var totalShares = 0
	var totalValue = 0
	if stock_homepage.visible == true:
		$"stock-app/Control2".visible = true
		for i in range(stocks_owned.size()):
			var stockline = get_node("stock-app/Control2/stockline" + str(i+1))
			var ticker = get_node("stock-app/Control2/ticker" + str(i+1))
			var shares = get_node("stock-app/Control2/shares" + str(i+1))
			var value = get_node("stock-app/Control2/value" + str(i+1))
			stockline.visible = true
			ticker.visible = true
			shares.visible = true
			value.visible = true

			ticker.text = stocks_owned[i]["ticker"]
			shares.text = str(stocks_owned[i]["shares"]) + " SHARES"
			value.text = "$" + str(stocks_owned[i]["value"])

			totalShares += stocks_owned[i]["shares"]
			totalValue += stocks_owned[i]["value"]

		var totalTicker = get_node("stock-app/Control2/ticker" + str(stocks_owned.size() + 1))
		var totalSharesLabel = get_node("stock-app/Control2/shares" + str(stocks_owned.size() + 1))
		var totalValueLabel = get_node("stock-app/Control2/value" + str(stocks_owned.size() + 1))
		totalTicker.visible = true
		totalSharesLabel.visible = true
		totalValueLabel.visible = true

		totalTicker.text = "TOTAL"
		totalSharesLabel.text = str(totalShares) + " SHARES"
		totalValueLabel.text = "$" + str(totalValue)
	else: 
		$"stock-app/Control2".visible = false


		
	money_stock.text = money

		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED




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
			visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
			camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_horizontal))
			


	# Set all stockline_selected controls to invisible
	for i in range(1, 13):
		var control_name = "stock-app/Control2/stockline_selected" + str(i)
		var control = get_node(control_name)
		control.visible = i == recent_button_index
		
	for i in range(1, 10):
		var stock_buy = "stock-app/BUY_STOCK_PAGE/Stock_buy_selected" + str(i)
		var stock_buys = get_node(stock_buy)
		stock_buys.visible = i == recent_buy_index
	
			# Check which category is selected and set the stock values accordingly
	if  stock_MEGA.visible == true:
		setStockValues(categories['MEGA'], 0, stocks)
		setStockValues(categories['MEGA'], 1, stocks)
		setStockValues(categories['MEGA'], 2, stocks)
		setStockValues(categories['MEGA'], 3, stocks)
		setStockValues(categories['MEGA'], 4, stocks)
		setStockValues(categories['MEGA'], 5, stocks)
		setStockValues(categories['MEGA'], 6, stocks)
		setStockValues(categories['MEGA'], 7, stocks)
		setStockValues(categories['MEGA'], 8, stocks)
	elif stock_LARGE.visible == true:
		setStockValues(categories['LARGE'], 0, stocks)
		setStockValues(categories['LARGE'], 1, stocks)
		setStockValues(categories['LARGE'], 2, stocks)
		setStockValues(categories['LARGE'], 3, stocks)
		setStockValues(categories['LARGE'], 4, stocks)
		setStockValues(categories['LARGE'], 5, stocks)
		setStockValues(categories['LARGE'], 6, stocks)
		setStockValues(categories['LARGE'], 7, stocks)
		setStockValues(categories['LARGE'], 8, stocks)
	elif stock_MID.visible:
		setStockValues(categories['MID'], 0, stocks)
		setStockValues(categories['MID'], 1, stocks)
		setStockValues(categories['MID'], 2, stocks)
		setStockValues(categories['MID'], 3, stocks)
		setStockValues(categories['MID'], 4, stocks)
		setStockValues(categories['MID'], 5, stocks)
		setStockValues(categories['MID'], 6, stocks)
		setStockValues(categories['MID'], 7, stocks)
		setStockValues(categories['MID'], 8, stocks)
	elif stock_SMALL.visible:
		setStockValues(categories['SMALL'], 0, stocks)
		setStockValues(categories['SMALL'], 1, stocks)
		setStockValues(categories['SMALL'], 2, stocks)
		setStockValues(categories['SMALL'], 3, stocks)
		setStockValues(categories['SMALL'], 4, stocks)
		setStockValues(categories['SMALL'], 5, stocks)
		setStockValues(categories['SMALL'], 6, stocks)
		setStockValues(categories['SMALL'], 7, stocks)
		setStockValues(categories['SMALL'], 8, stocks)
	elif stock_MICRO.visible:
		setStockValues(categories['MICRO'], 1, stocks)
		setStockValues(categories['MICRO'], 2, stocks)
		setStockValues(categories['MICRO'], 3, stocks)
		setStockValues(categories['MICRO'], 4, stocks)
		setStockValues(categories['MICRO'], 5, stocks)
		setStockValues(categories['MICRO'], 6, stocks)
		setStockValues(categories['MICRO'], 7, stocks)
		setStockValues(categories['MICRO'], 8, stocks)
	elif stock_INDEX.visible:
# Convert keys and values of the dictionary into arrays
		var stock_names = indexes.keys()
		var stock_data = indexes.values()


	# Assuming you want to set values for 9 stocks in the BUY_STOCK_PAGE
		for i in range(9):
			var value_label_index = get_node("stock-app/BUY_STOCK_PAGE/buy_value" + str(i + 1))
			if indexes[stock_names[i]]['Stock change'] == 'Increasing':
				value_label_index.modulate = increase_colour
			elif indexes[stock_names[i]]['Stock change'] == 'Decreasing':
				value_label_index.modulate = decrease_colour
			else:
				value_label_index.modulate = no_change_colour
			value_label_index.text = str(stock_data[i]['Current stock price'])
			get_node("stock-app/BUY_STOCK_PAGE/buy_ticker" + str(i + 1)).text = stock_names[i]
		# Add more elif blocks for other categories if needed
	else:
		# Hide all the labels if none of the categories are selected
		for i in range(0, 9):
			get_node("stock-app/BUY_STOCK_PAGE/buy_value" + str(i + 1)).text = ""
			get_node("stock-app/BUY_STOCK_PAGE/buy_ticker" + str(i + 1)).text = ""


	# Determine the visibility based on the recent_stock_index
	if recent_stock_index == 1:
		$"stock-app/BUY_STOCK_PAGE/MEGA_SELECTED".visible = true
		$"stock-app/BUY_STOCK_PAGE/LARGE_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MID_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/SMALL_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MICRO_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/INDEX_SELECTED".visible = false
	if recent_stock_index == 2:
		$"stock-app/BUY_STOCK_PAGE/MEGA_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/LARGE_SELECTED".visible = true
		$"stock-app/BUY_STOCK_PAGE/MID_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/SMALL_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MICRO_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/INDEX_SELECTED".visible = false
	if recent_stock_index == 3:
		$"stock-app/BUY_STOCK_PAGE/MEGA_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/LARGE_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MID_SELECTED".visible = true
		$"stock-app/BUY_STOCK_PAGE/SMALL_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MICRO_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/INDEX_SELECTED".visible = false
	if recent_stock_index == 4:
		$"stock-app/BUY_STOCK_PAGE/MEGA_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/LARGE_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MID_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/SMALL_SELECTED".visible = true
		$"stock-app/BUY_STOCK_PAGE/MICRO_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/INDEX_SELECTED".visible = false
	if recent_stock_index == 5:
		$"stock-app/BUY_STOCK_PAGE/MEGA_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/LARGE_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MID_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/SMALL_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MICRO_SELECTED".visible = true
		$"stock-app/BUY_STOCK_PAGE/INDEX_SELECTED".visible = false
	if recent_stock_index == 6:
		$"stock-app/BUY_STOCK_PAGE/MEGA_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/LARGE_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MID_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/SMALL_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/MICRO_SELECTED".visible = false
		$"stock-app/BUY_STOCK_PAGE/INDEX_SELECTED".visible = true




	
func _physics_process(delta):
	if !animation_player.is_playing():
		is_locked = false

	if Input.is_action_just_pressed("kick"):
		if animation_player.current_animation != "kick":
			animation_player.play("kick")
			is_locked = true

	if Input.is_action_pressed("run"):
		SPEED = running_speed
		running = true
	else:
		SPEED = walking_speed
		running = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if animation_player.current_animation != "phone_libary/jump":
			animation_player.play("phone_libary/jump")
			is_locked = true
			velocity.y = JUMP_VELOCITY
		else:
			is_locked = false

	# Handle Phone animation.
	if Input.is_action_just_pressed("phone"):
		phone.visible = !phone.visible
		if phone.visible:
			phone_activated = true
			phone_to_do.visible = true
		else:
			phone_activated = false

	if phone_activated:
		if Input.is_action_just_pressed("phone_right"):
			currentPictureIndex += 1
			if currentPictureIndex >= phonePictures.size():
				currentPictureIndex = 0
			if currentPictureIndex == 0:
				phone_to_do.visible = true
				phone_message.visible = false
				phone_stock.visible = false
			elif currentPictureIndex == 1:
				phone_to_do.visible = false
				phone_message.visible = true
				phone_stock.visible = false
			elif currentPictureIndex == 2:
				phone_to_do.visible = false
				phone_message.visible = false
				phone_stock.visible = true
			
		elif Input.is_action_just_pressed("phone_left"):
			currentPictureIndex -= 1
			if currentPictureIndex < 0:
				currentPictureIndex = phonePictures.size() - 1
			if currentPictureIndex == 0:
				phone_to_do.visible = true
				phone_message.visible = false
				phone_stock.visible = false
			elif currentPictureIndex == 1:
				phone_to_do.visible = false
				phone_message.visible = true
				phone_stock.visible = false
			elif currentPictureIndex == 2:
				phone_to_do.visible = false
				phone_message.visible = false
				phone_stock.visible = true
		elif Input.is_action_just_pressed("phone_click"):
			if currentPictureIndex == 0:
				pass
			elif currentPictureIndex == 1:
				pass
			elif currentPictureIndex == 2:
				stock_app.visible = true
			
			
	# Add the gravity.
	if !is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !is_locked:
			if running:
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")

			visuals.rotation.y = lerp_angle(visuals.rotation.y, position.angle_to(position + direction) + deg_to_rad(-90), delta * rotation_speed)

			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		if !is_locked:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")

		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


# Create a list of categories and their corresponding stocks (ticker symbols)
var categories = {
	'MEGA': ['APPL', 'GOOG', 'MSFT', 'AMZN', 'TSLA', 'NVDA', 'META', 'V', 'WMT'],
	'LARGE': ['NKE', 'TMUS', 'DIS', 'INTC', 'VZ', 'BA', 'IBM', 'GE', 'ABNB'],
	'MID': ['DBX', 'MNDY', 'HAS', 'SOFI', 'RL', 'SKX', 'CROX', 'VFC', 'MAT'],
	'SMALL': ['JACK', 'ZIP', 'CAKE', 'PEB', 'BOWL', 'CMPR', 'EAT', 'SAND', 'OPK'],
	'MICRO' : ['GPMT', 'LE', 'GHL', 'III', "RBB", "PRTS", "FUSB", "CRTO", "SNEX"]
	# Add more categories as needed
}

# Define the chance percentages for each news value for each stock category
var megaCapChances = [0.0001, 0.01, 0.09, 0.80, 0.09, 0.01, 0.0001]
var largeCapChances = [0.001, 0.02, 0.15, 0.66, 0.15, 0.02, 0.001]
var midCapChances = [0.001, 0.05, 0.25, 0.40, 0.25, 0.05, 0.001]
var microCapChances = [0.1, 0.15, 0.30, 0.40, 0.30, 0.15, 0.1]



func calculate_stocks(stocks: Dictionary) -> void:
	assignNewsValuesToStocks(stocks)
	calculateEconomy()


	for ticker in stocks:
		# Extract values from the stocks dictionary for the current stock
		var current_FCF = stocks[ticker]['Free cash flow']
		var growth_rate_5_years = stocks[ticker]['Growth rate 1-5 years'] / 100
		var growth_rate_10_years = stocks[ticker]['Growth rate 6-10 years'] / 100
		var shares_outstanding = stocks[ticker]['Shares outstanding']
		var excess_capital = stocks[ticker]['Excess capital']
		var stock_value = stocks[ticker]['Current stock price']
		var news_value = stocks[ticker]['Company News Value']
		# Assign the company news value to each stock
		# Calculate the 1-day stock change using the calculate_stock_change function
		var stock_change_1_day = calculate_stock_change(current_FCF, growth_rate_5_years, growth_rate_10_years, shares_outstanding, excess_capital, stock_value)
		stock_change_1_day = (stock_value * (float(news_value) /100) ) + stock_change_1_day
		stock_change_1_day = roundToTwoDecimals(stock_change_1_day)
		# Adjust stock_change_1_day based on the company news value
		if stock_change_1_day > 0:
			stocks[ticker]['Stock change'] = 'Increasing'
		elif stock_change_1_day < 0:
			stocks[ticker]['Stock change'] = 'Decreasing'
		else:
			stocks[ticker]['Stock change'] = 'None'
		stocks[ticker]['Current stock price'] = stock_value + stock_change_1_day


# round numbers to two decimals
func roundToTwoDecimals(number: float) -> float:
	return round(number * 100) / 100

# Function to set buy_value and buy_ticker for a given category
func setStockValues(category_stocks, index, stocks: Dictionary):
	if index < category_stocks.size():
		var stock_ticker = category_stocks[index]

		var value_label = get_node("stock-app/BUY_STOCK_PAGE/buy_value" + str(index + 1))
		if stocks[stock_ticker]['Stock change'] ==  'Increasing':
			value_label.modulate = increase_colour
		elif stocks[stock_ticker]['Stock change'] == 'Decreasing':
			value_label.modulate = decrease_colour
		else:
			value_label.modulate = no_change_colour
		value_label.text = str(stocks[stock_ticker]['Current stock price'])
		get_node("stock-app/BUY_STOCK_PAGE/buy_ticker" + str(index + 1)).text = stock_ticker
	else:
		# Hide the labels for stocks that don't exist in this category
		get_node("stock-app/BUY_STOCK_PAGE/buy_value" + str(index + 1)).text = ""
		get_node("stock-app/BUY_STOCK_PAGE/buy_ticker" + str(index + 1)).text = ""


func calculate_stock_change(current_FCF: float, growth_rate_5_years: float, growth_rate_10_years: float, shares_outstanding: float, excess_capital, stock_value) -> float:
	# Calculate Free Cash Flow for each year
	var FCF_year_1 = current_FCF
	var FCF_year_2 = FCF_year_1 + (FCF_year_1 * growth_rate_5_years)
	var FCF_year_3 = FCF_year_2 + (FCF_year_2 * growth_rate_5_years)
	var FCF_year_4 = FCF_year_3 + (FCF_year_3 * growth_rate_5_years)
	var FCF_year_5 = FCF_year_4 + (FCF_year_4 * growth_rate_5_years)
	var FCF_year_6 = FCF_year_5 + (FCF_year_5 * growth_rate_10_years)
	var FCF_year_7 = FCF_year_6 + (FCF_year_6 * growth_rate_10_years)
	var FCF_year_8 = FCF_year_7 + (FCF_year_7 * growth_rate_10_years)
	var FCF_year_9 = FCF_year_8 + (FCF_year_8 * growth_rate_10_years)
	var FCF_year_10 = FCF_year_9 + (FCF_year_9 * growth_rate_10_years)

	# Calculate Present Value for each year
	var PV_year_1 = FCF_year_1 / (pow(1.1, 1))
	var PV_year_2 = FCF_year_2 / (pow(1.1, 2))
	var PV_year_3 = FCF_year_3 / (pow(1.1, 3))
	var PV_year_4 = FCF_year_4 / (pow(1.1, 4))
	var PV_year_5 = FCF_year_5 / (pow(1.1, 5))
	var PV_year_6 = FCF_year_6 / (pow(1.1, 6))
	var PV_year_7 = FCF_year_7 / (pow(1.1, 7))
	var PV_year_8 = FCF_year_8 / (pow(1.1, 8))
	var PV_year_9 = FCF_year_9 / (pow(1.1, 9))
	var PV_year_10 = FCF_year_10 / (pow(1.1, 10))


	var free_cash_flow_10_year_total = (FCF_year_10 * 15)

	var PV_total =  free_cash_flow_10_year_total / (pow(1.1, 10))
	#Calculate 10-year Total PV
	var PV_10_year_total = (PV_year_1 + PV_year_2 + PV_year_3 + PV_year_4 + PV_year_5 +
							PV_year_6 + PV_year_7 + PV_year_8 + PV_year_9 + PV_year_10 + PV_total) 
	# Calculate Intrinsic Value (Market Cap)
	var intrinsic_value = PV_10_year_total + excess_capital


	# Calculate New 365-day Stock Value
	var new_365_day_stock_value = intrinsic_value / shares_outstanding
	# Calculate 1-day Stock Change)
	var current_stock_value = stock_value
	var stock_change_1_day = (new_365_day_stock_value - current_stock_value) / 100

	return stock_change_1_day


# Combine all chances into a dictionary for easy access based on stock category
var chanceDict = {
	'Mega': megaCapChances,
	'Large': largeCapChances,
	'Mid': midCapChances,
	'Micro': microCapChances
}

# Separate the stocks into their respective categories
var stocksByCategory = {
	'Mega': [],
	'Large': [],
	'Mid': [],
	'Micro': []
}

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
	if totalEconomy <= -180:
		economyGrowthRate = -10
	elif totalEconomy <= -90:
		economyGrowthRate = -5
	elif totalEconomy <= -60:
		economyGrowthRate = -2
	elif totalEconomy <= -30:
		economyGrowthRate = 0
	elif totalEconomy <= -15:
		economyGrowthRate = 2
	elif totalEconomy <= 20:
		economyGrowthRate = 5
	else:
		economyGrowthRate = 10
	
	return economyGrowthRate

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
			
# updates stock price
func updateCurrentStockPrices(index_dict, economy):
	for index in index_dict:
		var current_stock_price = index_dict[index]['Current stock price']
		var average_rate_of_return = index_dict[index]['Average rate of return']

		# Calculate the new current stock price using the formula
		var new_current_stock_price = (1 + average_rate_of_return / 100) * current_stock_price * (1 + economy / 100)
		var one_day_index_increase = current_stock_price + (new_current_stock_price/ 365)
		# Update the dictionary with the new current stock price
		one_day_index_increase = roundToTwoDecimals(one_day_index_increase)
		index_dict[index]['Current stock price'] = one_day_index_increase
		if one_day_index_increase > 0:
			index_dict[index]['Stock change'] =  'Increasing'
		elif one_day_index_increase < 0:
			index_dict[index]['Stock change'] =  'Decreasing'
		else:
			index_dict[index]['Stock change'] = 'None'


func _on_home_indicator_pressed():
	stock_app.visible = false

	
func _on_stockline_1_pressed():
	recent_button_index = 2

func _on_stockline_2_pressed():
	recent_button_index = 3

func _on_stockline_3_pressed():
	recent_button_index = 4

func _on_stockline_4_pressed():
	recent_button_index = 5

func _on_stockline_5_pressed():
	recent_button_index = 6

func _on_stockline_6_pressed():
	recent_button_index = 7

func _on_stockline_7_pressed():
	recent_button_index = 8
	
func _on_stockline_8_pressed():
	recent_button_index = 9
	
func _on_stockline_9_pressed():
	recent_button_index = 10
	
func _on_stockline_10_pressed():
	recent_button_index = 11

func _on_stockline_11_pressed():
	recent_button_index = 12
	
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


func _on_home_button_2_pressed():
	stock_homepage.visible = true
	BUY_STOCK_PAGE.visible = false
	stock_homepage_lines.visible = true

func _on_stock_select_first_pressed():
	recent_button_index = 1


func _on_button_pressed():
	calculate_stocks(stocks)
	updateCurrentStockPrices(indexes, economyGrowthRate)

