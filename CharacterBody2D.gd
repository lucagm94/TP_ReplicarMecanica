extends CharacterBody2D


var maxSpeed:int = 400
var jumpVelocity:int;
const ACCELERATION: int = 250;
const DECELERATION: int = 390;
var canDobleJump:bool = false;
var direction:int;


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	Jump(delta)
	Motion(delta)
	move_and_slide()

func Jump(delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		jumpVelocity = -400
		
	if Input.is_action_just_pressed("largeJump"):
		jumpVelocity = -600
		
	if not is_on_floor():
		$Spritesheet.play("run")
		velocity.y += gravity * delta

	if is_on_floor():
		canDobleJump  = true
		
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("largeJump") and is_on_floor():
		velocity.y = jumpVelocity
		
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("largeJump") and  !is_on_floor() and canDobleJump:
		velocity.y = jumpVelocity
		canDobleJump = false
		
func Motion(delta):
	
	if Input.is_action_pressed("incSpeed"):
		maxSpeed = 600;
		
	if Input.is_action_just_released("incSpeed"):
		maxSpeed = 400

	$Feedback.set_text(str(velocity.x))
	
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
		
	if direction == 0:
		$Spritesheet.play("Idle")
		if velocity.x < 0:
			velocity.x += DECELERATION*delta;
		if velocity.x > 0:
			velocity.x -= DECELERATION*delta;
	
	if direction == 1: 

		$Spritesheet.flip_h = false;
		if is_on_floor():
			$Spritesheet.play("run")
		
		if direction == -1:
			$Spritesheet.flip_h = true
			if is_on_floor():
				$Spritesheet.play("run")





