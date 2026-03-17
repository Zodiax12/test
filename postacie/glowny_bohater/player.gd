extends Area2D
@export var speed = 200 
var screen_size
var magik = load("res://grafiki/szczur_transform.png")

func _ready():
	screen_size = get_viewport_rect().size
	$Sprite2D.hide()

func _process(delta):
	var velocity = Vector2.ZERO	

	if Input.is_action_pressed("move_right"):
		velocity.x +=1
	if Input.is_action_pressed("move_left"):
		velocity.x -=1
	if Input.is_action_pressed("move_down"):
		velocity.y +=1
	if Input.is_action_pressed("move_up"):
		velocity.y -=1
		
	if Input.is_action_pressed("transform"):
		$Sprite2D.texture = magik
		$Sprite2D.show()
		$AnimatedSprite2D.hide()
		$mieczyk_myszka.hide() 
	if velocity.x != 0:
		$Sprite2D.flip_v = false
		$Sprite2D.flip_h = velocity.x > 0
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.play()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x > 0
	
