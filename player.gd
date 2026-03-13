class_name Player extends Resource


signal name_set(name: String)
signal health_updated(health: int)
signal lost


@export var name: String:
	set(value):
		name = value
		name_set.emit(name)

@export var health := 10:
	set(value):
		health = maxi(0, value)
		health_updated.emit(health)
		if health == 0:
			lost.emit()
