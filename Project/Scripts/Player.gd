extends CharacterBody2D

@export var jump: AudioStreamWAV
@export var deathZoneY: float

const speed = 320
const maxSpeed = 320
const friction = 0.2
const jumpSpeed = -640

var jumpBuffer
var nextDirAnimation = "Idle"
var nextAnimation = "Idle"
var direction = 0
var Jumps = 1
var JumpActive = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		clamp(velocity.y, -640, 400)
	
	# The Buffer for the Jump Input
	if Input.is_action_pressed("Gameplay.Jump"):
		jumpBuffer += 1
	else:
		jumpBuffer = 1
	
	# Handle jump.
	if Input.is_action_pressed("Gameplay.Jump") and jumpBuffer < 15 and !JumpActive and (is_on_floor() or Jumps):
		if is_on_floor():
			velocity.y = jumpSpeed
		else:
			velocity.y = jumpSpeed * 0.8
		
		Jumps -= 1
		
		JumpActive = true
		playSound(jump)
	
	if Input.is_action_just_released("Gameplay.Jump"): JumpActive = false
	
	if not Input.is_action_pressed("Gameplay.Jump") and velocity.y < 0:
		velocity.y = clamp(velocity.y - jumpSpeed / 16, -640, 0)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	direction = 0
	if Input.is_action_pressed("Gameplay.Left") and not Input.is_action_pressed("Gameplay.Right"): direction = -1
	elif Input.is_action_pressed("Gameplay.Right") and not Input.is_action_pressed("Gameplay.Left"): direction = 1
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * friction)
	
	if position.y > deathZoneY:
		get_tree().reload_current_scene()
	
	PowerUpSubroutine()
	
	move_and_slide()
	animate(direction, velocity.y)

func animate(dir: float, velY: float) -> void:
	
	if direction == -1:
		nextDirAnimation = "Left"
	elif direction == 1:
		nextDirAnimation = "Right"
	
	if velocity.y < 0:
		nextAnimation = nextDirAnimation + "Jump"
	else:
		nextAnimation = nextDirAnimation
	
	$AnimatedSprite2D.play(nextAnimation)

func playSound(soundPath) -> void:
	$AudioStreamPlayer2D.stream = soundPath
	$AudioStreamPlayer2D.play()

func PowerUpSubroutine() -> void:
	if is_on_floor():
		if Global.DoubleJump:
			Jumps = 1
		else:
			Jumps = 0
	
	print("Dash: ", Global.Dash, ", Double Jump: ", Global.DoubleJump, ", Jumps Left: ", Jumps)
