extends StaticBody2D

@onready var damage_label = $DamageLabel

var zycie = 20

func damage(ile):
	zycie -= ile
	print("OHIO! nie tak mocno")
	
	animuj_tekst_dmg(ile)
	
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if zycie <= 0:
		umieranie()

func animuj_tekst_dmg(ile):
	damage_label.text = str(ile)
	damage_label.modulate.a = 1.0
	damage_label.position = Vector2(randf_range(-20, 20), -40) 
	
	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(damage_label, "position:y", damage_label.position.y - 30, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.tween_property(damage_label, "position:y", damage_label.position.y - 10, 0.4).set_delay(0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	tween.tween_property(damage_label, "modulate:a", 0.0, 0.6)

	tween.finished.connect(func(): if is_instance_valid(damage_label): damage_label.text = "")

func umieranie():
	queue_free()
