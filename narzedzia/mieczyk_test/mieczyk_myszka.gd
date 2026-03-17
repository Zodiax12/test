extends Node2D

@onready var hit_box = $HitBox/CollisionShape2D

var moge_bic = true

func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("clik"):#WYWOŁYWANIE ATAKU
		if moge_bic:
			atak()

func atak():#FUNKCJA ATAKOWANIA
	moge_bic = false
	
	hit_box.disabled = false
	print("Skibidi")
	await get_tree().create_timer(0.3).timeout
	hit_box.disabled = true
	
	await get_tree().create_timer(1.7).timeout
	moge_bic = true


func _on_hit_box_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)
	
