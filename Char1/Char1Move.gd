extends CharacterBody2D

var speed = 300.0
var jump_speed = -400.0

var is_attacking = false
var is_dashing = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction.
	if not is_dashing:
		direction = Input.get_axis("left", "right")
		velocity.x = direction * speed
	
	if is_dashing:
		velocity.x = direction * 1000
	
	if not is_attacking:
		move_and_slide()

func _process(delta):
	$AnimatedSprite2D.play()
	if Input.is_action_just_pressed("dash"):
		is_dashing = true
	
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
			
	# animation playing
	if is_attacking:
		$AnimatedSprite2D.animation = "attack"
		
	elif is_dashing:
		$AnimatedSprite2D.animation = "dash"
	
	else:
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			# See the note below about the following boolean assignment.
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = "idle"
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = false




func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
	if $AnimatedSprite2D.animation == "dash":
		is_dashing = false
