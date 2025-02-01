extends CharacterBody2D

var speed = 300.0
var jump_speed = -400.0

var is_attacking = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction.
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
	
	if not is_attacking:
		move_and_slide()

func _process(delta):
	$AnimatedSprite2D.play()
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
			
	# animation playing
	if is_attacking:
		$AnimatedSprite2D.animation = "attack"
	
	else:
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			# See the note below about the following boolean assignment.
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = "idle"
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false




func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		is_attacking = false
