extends KinematicBody2D

signal health_set
signal health_update

const FIREBALL = preload("res://src/scenes/fireball.tscn")

var cur_state = BossData.State.CHASE
var player_pos
var dir
var distance


var can_melee = true
var can_range = true
var can_chase = true
var can_block = true
var can_tackle = true

var velocity = Vector2()
var speed = 300
var tackle_speed = 20
var melee_distance = 75
var tackle_distance = 300
var range_distance = 300
var max_health = 500
var health 
 


onready var melee_cooldown = $melee
onready var ranged_cooldown = $ranged
onready var tackle_cooldown = $tackle
onready var block_cooldown = $block
onready var melee_hitbox = $melee_hitbox/CollisionShape2D
onready var anim = $AttackPlayer
onready var holder = $holder


func _ready():
	health = max_health
	emit_signal("health_update", health)
	$cooldown.start()
func _physics_process(delta):
	if get_node("/root/world/Player"):
		player_pos = get_node("/root/world/Player").global_position
		dir = (player_pos - global_position).normalized()
		distance = (player_pos - global_position).length()
	if player_pos.x - global_position.x <0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	match cur_state:
		BossData.State.CHASE:
			chase(delta)
		BossData.State.MELEE:
			melee()
		BossData.State.RANGED:
			ranged()
		BossData.State.TACKLE:
			tackle(delta)
		BossData.State.BLOCKED:
			block()
	if $cooldown.is_stopped():
		action_selection()
		$cooldown.start()

func action_selection():
	var total_prob = 0
	for name in BossData.actions:
		total_prob +=  BossData.actions[name]
	randomize()
	var random = randi()%(total_prob + 1)
	var prev_prob= 0
	for name in BossData.actions:
		prev_prob += BossData.actions[name]
		if random <= prev_prob:
			cur_state = name
			break
	
		

func chase(delta):
	if distance > (melee_distance + 1):
		position += dir*speed*delta
	elif distance < melee_distance:
		cur_state = BossData.State.MELEE



func melee():
	if can_melee:
		anim.play("attack")
		$AnimationPlayer.play("aura")
		yield(anim, "animation_finished")
		can_melee = false
		melee_cooldown.start()
		cur_state = BossData.State.CHASE
	else:
		cur_state = BossData.State.CHASE
	

func ranged():
	if FIREBALL && can_range:
		var fireball = FIREBALL.instance()
		get_tree().current_scene.add_child(fireball)
		fireball.global_position = holder.global_position
		var fireball_rotation = holder.global_position.direction_to(player_pos).angle()
		fireball.rotation = fireball_rotation
		ranged_cooldown.start()
		can_range = false
		cur_state = BossData.State.CHASE
	elif can_melee && distance < melee_distance:
		cur_state = BossData.State.MELEE
	else:
		cur_state = BossData.State.CHASE

func tackle(delta):
	if can_tackle:
		position += tackle_speed*dir
		anim.play("attack")
		yield(anim, "animation_finished")
		can_tackle = false
		tackle_cooldown.start()
		cur_state = BossData.State.CHASE
		velocity = Vector2()
	elif can_melee && distance < melee_distance:
		cur_state = BossData.State.MELEE
	else:
		cur_state = BossData.State.CHASE

func block():
	if can_block:
		anim.play("block")
		$AnimatedSprite.visible = true
		yield(anim, "animation_finished")
		$AnimatedSprite.visible = false
		block_cooldown.start()
		can_block = false
		cur_state = BossData.State.CHASE
	elif can_melee && distance < melee_distance:
		cur_state = BossData.State.MELEE
	else:
		cur_state = BossData.State.CHASE

func _on_melee_timeout():
	can_melee = true


func _on_tackle_timeout():
	can_tackle = true


func _on_ranged_timeout():
	can_range = true

func take_dmg(dmg):
	health -= 50
	emit_signal("health_update", health)
	if health<=0:
		die()

func die():
	queue_free()
	PlayerData.won = true
	PlayerData.save_fight_data()
	PlayerData.won()
	get_tree().change_scene("res://src/scenes/tryagain.tscn")
	

func _on_hurtbox_area_entered(area):
	var who = area.name
	if who == "melee":
		PlayerData.damage_dealt += 50
		take_dmg(50)
		get_parent().get_node("ScreenShake").screen_shake(0.5, 4 , 100)
	elif who == "kunai":
		PlayerData.damage_dealt += 20
		take_dmg(20)
		get_parent().get_node("ScreenShake").screen_shake(0.5, 4 , 100)
		




func _on_block_timeout():
	can_block = true 
	$hurtbox/CollisionShape2D.disabled = false


