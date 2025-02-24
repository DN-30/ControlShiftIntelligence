extends Node
var file_path = "res://src/json/fight_data.json"
var melee_count = 0
var ranged_count = 0
var heal_count = 0
var damage_dealt = 0
var damage_taken = 0 
var attack_pattern = []
var dataset = []
var won = true
var string = "YOU WON"

func save_fight_data():

	var fight_data = {
		"fight_id" : OS.get_unix_time(),
		"melee_usage" : melee_count,
		"ranged_usage" : ranged_count,
		"heal_usage" : heal_count,
		"damage_dealt" : damage_dealt,
		"damage_taken" : damage_taken,
		"type_of_player" : behaviour(),
		"attack_pattern" : attack_pattern,
		"result_of_match" : won()
	}
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, File.READ)
		var json_text = file.get_as_text()
		file.close()
		var parsed_txt = JSON.parse(json_text)
		dataset.append(parsed_txt.result)
		dataset.append(fight_data)
		file.open(file_path, File.WRITE)
		file.store_string(JSON.print(dataset, '\t'))
		file.close()
	else:
		file.open(file_path, File.WRITE)
		file.store_string(JSON.print(fight_data))
		file.close()
		
		
		
	
		
		

	
	melee_count = 0
	ranged_count = 0
	heal_count = 0
	damage_dealt = 0
	damage_taken = 0 
	attack_pattern = []
	dataset = []

func behaviour():
	var aggressive = melee_count * 2 + ranged_count - heal_count*3
	var defensive = heal_count*3 -melee_count - ranged_count
	if aggressive > defensive:
		return "aggressive"
	elif aggressive < defensive:
		return "defensive"
	else:
		return "balanced"
		

func run_python_script():
	# Get the absolute path of the "src" folder
	var src_dir = ProjectSettings.globalize_path("res://src")
	
	# Move one level up to the project root (parent folder of "src")
	var project_root = src_dir.get_base_dir()
	
	# Construct the relative path to the venv Python executable
	var python_exe = OS.get_executable_path().get_base_dir().plus_file("venv/Scripts/python.exe")
	var python_script_path = OS.get_executable_path().get_base_dir().plus_file("ai/gamepy.py")


	# Run the Python script
	var output = []
	var exit_code = OS.execute(python_exe, [python_script_path], true, output)

	# Print output for debugging
	for line in output:
		print(line)

	# Check if script executed successfully
	if exit_code == 0:
		print("Python script executed successfully")
		return exit_code
	else:
		print("Error executing Python script. Exit code:", exit_code)

func erase_json():
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(JSON.print("Player_Data", '\n'))
	file.close()
	

func won():
	if won:
		string = "YOU WON"
		return "Player WON"
	else:
		string = "YOU DIED"
		return "Boss WON"

