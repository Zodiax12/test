extends CharacterBody2D

enum State { WANDERING, CHASING, ATTACKING }

@export var speed: float = 70.0
@export var chase_speed: float = 130.0
@export var rotation_speed: float = 5.0
@export var attack_range: float = 40.0
@export var damage: int = 10
@export var attack_rate: float = 1.0

var current_state = State.WANDERING
var wander_direction: Vector2 = Vector2.RIGHT
var player = null
var can_attack: bool = true

@onready var ray_cast = $RayCast2D

func _ready():
	wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _physics_process(delta):
	print(current_state, " | Player: ", player)
	match current_state:
		State.WANDERING:
			patrol_logic(delta)
		State.CHASING, State.ATTACKING:
			chase_and_attack_logic(delta)
	
	move_and_slide()

func patrol_logic(delta):
	if is_on_wall() or (ray_cast and ray_cast.is_colliding()):
		wander_direction = wander_direction.rotated(deg_to_rad(randf_range(90, 180)))
	
	velocity = wander_direction * speed
	look_at_smooth(global_position + velocity, delta)

func chase_and_attack_logic(delta):
	if not player:
		current_state = State.WANDERING
		return

	var dist = global_position.distance_to(player.global_position)
	
	if dist <= attack_range:
		velocity = Vector2.ZERO
		if can_attack:
			attack_player()
	else:
		# Bieganie za graczem
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * chase_speed
	
	look_at_smooth(player.global_position, delta)

func attack_player():
	can_attack = false
	print("Zombie bije gracza!")
	
	if player.has_method("take_damage"):
		player.take_damage(damage)
	
	await get_tree().create_timer(attack_rate).timeout
	can_attack = true

func look_at_smooth(target_pos, delta):
	var direction = target_pos - global_position
	if direction.length() > 0.5:
		rotation = lerp_angle(rotation, direction.angle(), rotation_speed * delta)

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		current_state = State.CHASING

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
		current_state = State.WANDERING
