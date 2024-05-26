extends CharacterBody2D

@export var speed: int = 35
@onready var animations = $AnimationPlayer

func handle_input():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

func update_animation():
	if velocity.length() == 0:
		animations.stop()
	else:
		var direction = "down"
		if velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
		elif velocity.y < 0: direction = "up"
		
		animations.play("walk_" + direction)
		
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)

func _physics_process(_delta):
	handle_input()
	move_and_slide()
	handleCollision()
	update_animation()


func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		print_debug("hitbox " + area.get_parent().name)
