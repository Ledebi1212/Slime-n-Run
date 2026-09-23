extends Control

@export var Menu: AudioStreamWAV
@export var MenuSelect: AudioStreamWAV
@export var NextScene: PackedScene

var WindowSize
var SizeMult = 1

var MenuSoundDelay = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	MenuSoundDelay -= 1
	
	WindowSize = get_viewport_rect().size
	if WindowSize.x > 1500:
		SizeMult = 2
	elif WindowSize.x > 1000:
		SizeMult = 1.5
	else:
		SizeMult = 1
	
	$UILayer/UIContainer.scale = Vector2.ONE * SizeMult
	
	if Input.is_action_just_pressed("Gameplay.Start"):
		MenuSoundDelay = 16
		$AudioStreamPlayer2D.stream = MenuSelect
		$AudioStreamPlayer2D.play()
	
	if Input.is_action_just_pressed("Gameplay.ToggleSettings"):
		$AudioStreamPlayer2D.stream = MenuSelect
		$AudioStreamPlayer2D.play()
	
	if Input.is_action_just_pressed("Gameplay.Quit"):
		$AudioStreamPlayer2D.stream = Menu
		$AudioStreamPlayer2D.play()
	
	if Input.is_action_just_released("Gameplay.Start"):
		get_tree().change_scene_to_packed(NextScene)
	
	if Input.is_action_just_released("Gameplay.QuitGame"):
		if OS.has_feature("web"):
			JavaScriptBridge.eval("window.location.href = 'https://github.com/Ledebi1212/Slime-n-Run'")
		else:
			get_tree().quit()
	
	if MenuSoundDelay == 1:
		$AudioStreamPlayer2D.stream = MenuSelect
		$AudioStreamPlayer2D.play()
