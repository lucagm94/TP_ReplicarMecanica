extends CharacterBody2D


var maxSpeed:int = 400
var jumpVelocity:int;
const ACCELERATION: int = 250;
const DECELERATION: int = 390;
var canDobleJump:bool = false;
var direction:int;
var estado: String;


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	jump(delta)
	motion(delta)
	$Feedback.set_text(str(canDobleJump))
	animations()
	move_and_slide()

func jump(delta):
	
	
	if Input.is_action_just_pressed("ui_accept"):
		jumpVelocity = -400
		
	if Input.is_action_just_pressed("largeJump"):
		jumpVelocity = -600
		
	if not is_on_floor():
		velocity.y += gravity * delta
		estado = "jump"

	if is_on_floor():
		canDobleJump  = true
		estado = "idle"
		
	if Input.is_action_just_pressed("ui_accept")  and is_on_floor() or Input.is_action_just_pressed("largeJump") and is_on_floor():
		velocity.y = jumpVelocity 
		
	if Input.is_action_just_pressed("ui_accept") and canDobleJump and !is_on_floor():
		canDobleJump = false
		velocity.y = jumpVelocity
		
	
	if Input.is_action_just_pressed("largeJump") and canDobleJump and !is_on_floor():
		velocity.y = jumpVelocity
		canDobleJump = false

func motion(delta):
	
	if Input.is_action_pressed("incSpeed"):
		maxSpeed = 1000;
		
	if Input.is_action_just_released("incSpeed"):
		maxSpeed = 400
		
	if Input.is_action_pressed("ui_left"):
		direction = -1
		
		if velocity.x > -maxSpeed:
			velocity.x += ACCELERATION*direction*delta
		
		if velocity.x < -maxSpeed:
			velocity.x -= ACCELERATION*direction*delta
			
	if Input.is_action_pressed("ui_right"):
		direction = 1
		if velocity.x < maxSpeed:
			velocity.x += ACCELERATION*direction*delta
		
		if velocity.x > maxSpeed:
			velocity.x -= ACCELERATION*direction*delta
			
	if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		direction = 0;
		if estado != "jump":
			estado = "idle"
		
	if direction == 0:
		if velocity.x < 0:
			velocity.x += DECELERATION*delta;
		if velocity.x > 0:
			velocity.x -= DECELERATION*delta;

func animations():
	
	if direction == 1: 
		$Spritesheet.flip_h = false;
		if estado != "jump":
			estado = "run"
			
	if direction == -1:
		$Spritesheet.flip_h = true
		if estado != "jump":
			estado = "run"
		
	if estado == "idle":
		$Spritesheet.play("idle")

	if estado == "run" && estado != "jump":
		$Spritesheet.play("run")
				
	if estado == "jump":
		$Spritesheet.play("jump")




