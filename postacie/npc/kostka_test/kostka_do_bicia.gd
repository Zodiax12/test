extends StaticBody2D

var zycie = 2

func damage(ile):
	zycie -= ile
	print("OHIO! nie tak mocno")
	
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if zycie <= 0:
		umieranie()

func umieranie():
	queue_free()
