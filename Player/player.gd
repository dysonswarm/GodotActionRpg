extends CharacterBody2D

signal healthChanged

@export var speed: int = 35
@export var maxHealth: int = 3
@export var knockbackPower = 500
@onready var animations = $AnimationPlayer

@onready var currentHealth: int = maxHealth

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

func _physics_process(_delta):
	handle_input()
	move_and_slide()
	update_animation()


func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = maxHealth
		
		healthChanged.emit(currentHealth)
		knockback(area.get_parent().velocity)
		
func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity-velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
