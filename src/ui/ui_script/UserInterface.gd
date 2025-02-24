extends Control

onready var healthfull = $Heart_full
onready var healthempty = $Heart_empty





func _on_Player_health_set(health, max_health):
	$Heart_empty.rect_size.x = 22 * max_health
	$Heart_full.rect_size.x = 22 * health


func _on_Player_health_update(health):
	$Heart_full.rect_size.x = health * 22


func _on_Boss_health_update(health):
	$healthbar.value = health
