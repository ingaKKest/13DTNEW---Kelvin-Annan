extends Sprite2D



class_name LeaderboardManager

var leaderboard_data = [] # An array to store leaderboard data




func _ready():
	load_leaderboard()
	# Sort the leaderboard before displaying it



	# Display the leaderboard when the game starts or as needed
func load_leaderboard():
	var config = ConfigFile.new()
	if config.load("user://leaderboard.cfg") == OK:
		leaderboard_data = config.get_section_keys("leaderboard")
	else:
		leaderboard_data = []

# Save leaderboard data to a configuration file for future reference in the user's directory.
func save_leaderboard():
	var config = ConfigFile.new()
	for entry in leaderboard_data:
		config.set_value("leaderboard", entry, "")
	config.save("user://leaderboard.cfg")


# Add a new entry to the leaderboard with a name, score, and day counter, and then save the updated leaderboard data.
func add_entry(name, score, day_counter):
	var entry = name + ":" + str(score) + ":" + str(day_counter)
	leaderboard_data.append(entry)
	save_leaderboard()
	
# Display the leaderboard entries on the UI, with sorting of the top 12 entries.
func display_leaderboard():
	var l = 1
	for i in leaderboard_data:
		if l > 12:
			break  # Stop sorting after the top 12 entries
		var entry_parts = i.split(":")
		if entry_parts.size() >= 3:
			var score = float(entry_parts[1])
			var leaderboard_name = entry_parts[0]
			var day_counter = int(entry_parts[2])
			var total_value = get_node("total_value" + str(l))
			var leaderboard_node = get_node("name" + str(l))
			var day_count = get_node("day_count" + str(l))
			total_value.text = str(score)
			leaderboard_node.text = str(leaderboard_name)
			day_count.text = str(str(day_counter) + str(" Days"))
			l += 1
	leaderboard_sort()
	

# resets leaderboard
func reset_leaderboard():
	leaderboard_data.clear()
	save_leaderboard()


# Sort the leaderboard entries based on score and day counter, ensuring the highest score and lowest day counter are at the top.
func leaderboard_sort():
	for i in range(len(leaderboard_data)):
		for j in range(i + 1, len(leaderboard_data)):
			var entry1 = leaderboard_data[i].split(":")
			var entry2 = leaderboard_data[j].split(":")
			
			var score1 = float(entry1[1])
			var score2 = float(entry2[1])
			
			var day_counter1 = int(entry1[2])
			var day_counter2 = int(entry2[2])
			
			if score1 < score2 or (score1 == score2 and day_counter1 > day_counter2):
				# Swap the entries
				var temp = leaderboard_data[i]
				leaderboard_data[i] = leaderboard_data[j]
				leaderboard_data[j] = temp





var buy_stocks_leaderboard_button = false

# gives signal to activate buy stocks button
func _on_buy_stocks_2_pressed():
	buy_stocks_leaderboard_button = true

# gives signal to activate the home button
var home_button_leaderboard_button = false
func _on_home_button_3_pressed():
	home_button_leaderboard_button = true
