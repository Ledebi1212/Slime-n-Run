extends Camera2D

@export var MenuOpen: AudioStreamWAV
@export var MenuSelect: AudioStreamWAV
@export_file_path var QuitTo: String

var WindowSize
var SizeMult = 1
var menu: bool = false
var menuCooldown = 0
var menuSoundDelay = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu = false
	$MenuControl/MenuLayer.visible = false
	get_tree().paused = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	menuCooldown -= 1
	menuSoundDelay -= 1
	
	WindowSize = get_viewport_rect().size
	if WindowSize.x > 1500:
		SizeMult = 2
	elif WindowSize.x > 1000:
		SizeMult = 1.5
	else:
		SizeMult = 1
	
	$UI/ButtonAnchor/JumpButtonContainer.scale = Vector2.ONE * SizeMult
	$UI/ButtonAnchor/MoveButtonContainer.scale = Vector2.ONE * SizeMult
	$UI/ButtonAnchor/PauseButtonContainer.scale = Vector2.ONE * SizeMult
	
	$MenuControl/MenuLayer/ButtonHolder/MenuBack.scale = Vector2.ONE * 5 * SizeMult
	
	if Input.is_action_just_released("Gameplay.Pause") and menuCooldown < 1:
		if menu:
			menu = false
			$MenuControl/MenuLayer.visible = false
			get_tree().paused = false
			$AudioStreamPlayer2D.stream = MenuSelect
			$AudioStreamPlayer2D.play()
			
		else:
			menu = true
			$MenuControl/MenuLayer.visible = true
			get_tree().paused = true
			menuSoundDelay = 16
			$AudioStreamPlayer2D.stream = MenuOpen
			$AudioStreamPlayer2D.play()
			
		menuCooldown = 45
		
	if menuSoundDelay == 1:
		$AudioStreamPlayer2D.stream = MenuOpen
		$AudioStreamPlayer2D.play()
		
	if Input.is_action_just_pressed("Gameplay.ToggleSettings"):
		$AudioStreamPlayer2D.stream = MenuSelect
		$AudioStreamPlayer2D.play()
		
	if Input.is_action_just_pressed("Gameplay.Quit"):
		$AudioStreamPlayer2D.stream = MenuSelect
		$AudioStreamPlayer2D.play()
	
	if Input.is_action_just_pressed("Gameplay.Restart"):
		$AudioStreamPlayer2D.stream = MenuSelect
		$AudioStreamPlayer2D.play()
	if Input.is_action_just_released("Gameplay.Restart"):
		get_tree().reload_current_scene()
		
	if Input.is_action_just_released("Gameplay.Quit"):
		get_tree().change_scene_to_file(QuitTo)
