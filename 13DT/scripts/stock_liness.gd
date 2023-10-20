extends Line2D


@export var graph_width : float = 25
@export var graph_height : float = 25
@export var graph_max_points : int = 0 # Zero for unlimited graph-points
@export var grow : bool = false

var graph : Array

# Create a graph by processing and generating data points based on the provided graph values.
func create_graph() -> void:
	var length : int = len(graph)


	var points_ = []

	var maximum : float = graph[0]
	var minimum : float = graph[0]

	if length == 1:
		graph.append(graph[0])
		length += 1

	for value in graph:

		if value > maximum:
			maximum = value
		if value < minimum:
			minimum = value

	if minimum == maximum:
		minimum -= 1.0
		maximum += 1.0

	for index in range(length):
		points_.append(Vector2(
			0.0,
			lerp(graph_height, 0.0, (graph[index] - minimum) / (maximum - minimum))))
		if grow and graph_max_points:
			points_[-1].x = lerp(0.0, graph_width, index / float(graph_max_points - 1))
		else:
			points_[-1].x = lerp(0.0, graph_width, index / float(length - 1))
			
	points = points_

# Pop values from the graph data if the maximum number of points is reached, ensuring the graph stays within the specified limit.
func pop_values() -> void:
	if graph_max_points != 0:
		if len(graph) > graph_max_points:
			graph.pop_front()
			pop_values()

# Reverse the order of elements in the input list and return a new list with the reversed order.
func reverse_list(input_list):
	var reversed_list = []
	for i in range(input_list.size() - 1, -1, -1):
		reversed_list.append(input_list[i])
	return reversed_list
	
# Add a value to the graph by first reversing the list, updating the graph data, and managing the number of graph points.
func add_value(value):
		value = reverse_list(value)
		graph = value
		pop_values()
