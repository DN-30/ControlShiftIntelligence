extends KinematicBody2D

signal health_set
signal health_update
var state = MOVE
const MAX_SPEED = 200
const ACCELERATION = 30
const JUMP_VELOCITY = -400.0
const KUNAI = preload("res://src/scenes/kunai.tscn")
onready var holder = $kunai
onready var hurtbox = $hitbox
onready var hurtshape = $hitbox/melee/CollisionShape2D
onready var anim = $AnimationPlayer
var motion = Vector2()
var max_health = 5
var health
var knockback = Vector2()
var Boss_pos
var dir
var can_range = true
var can_heal = true


enum{
	MOVE,
	ATTACK,
	HEAL,
	RANGED
}
func _ready():
	health = max_health
	emit_signal("health_set", health , max_health)
func _physics_process(delta):
	if get_node("/root/world/Boss"):
		Boss_pos = get_node("/root/world/Boss").global_position
		dir = (global_position - Boss_pos).normalized()
	match state:
		MOVE:
			movement()
		RANGED:
			ranged_attack()
		HEAL:
			heal()
		ATTACK:
			attack()
	move_and_slide(motion)

func heal():
	health +=2
	if health > max_health:
		health = max_health
	emit_signal("health_update", health)
	$healcooldown.start()
	can_heal = false
	state = MOVE


func attack():
		motion.x = lerp(motion.x, 0.0, 0.2)
		motion.y = lerp(motion.y, 0.0, 0.2)
		hurtshape.disabled = false
		$AnimationPlayer2.play("attack")
		$melee_timer.start()
		state = MOVE
func movement():
	if Input.is_action_just_pressed("heal") && can_heal:
		state = HEAL
		PlayerData.heal_count += 1
		PlayerData.attack_pattern.append("heal")
	if Input.is_action_just_pressed("mouse") && can_range:
		state = RANGED
		PlayerData.ranged_count +=1
		PlayerData.attack_pattern.append("range")
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		PlayerData.melee_count +=1
		PlayerData.attack_pattern.append("melee")
	if Input.is_action_pressed("right") :
		$Sprite.flip_h = false
		$sword.flip_h = false
		$sword.position.x = 40
		$sword.position.y = 0
		motion.x = min(MAX_SPEED, motion.x + ACCELERATION)
		hurtbox.position.x = 50
		hurtbox.rotation_degrees = 0
		hurtbox.position.y = 0

	elif Input.is_action_pressed("left"):
		motion.x = max(-MAX_SPEED, motion.x - ACCELERATION)
		$Sprite.flip_h = true
		$sword.flip_h = true
		$sword.position.x = -40
		$sword.position.y = 0
		hurtbox.position.x = -50
		hurtbox.rotation_degrees = 0
		hurtbox.position.y = 0

	else:
		motion.x = lerp(motion.x,0.0,0.2)
	if Input.is_action_pressed("down") :
		motion.y = min(MAX_SPEED, motion.y + ACCELERATION)
		$sword.position.x = 0
		$sword.position.y = 40
		hurtbox.position.x = 0
		hurtbox.rotation_degrees = 90
		hurtbox.position.y = 50

	elif Input.is_action_pressed("up"):
		motion.y = max(-MAX_SPEED, motion.y - ACCELERATION)
		$sword.position.x = 0
		$sword.position.y = -40
		hurtbox.position.x = 0
		hurtbox.rotation_degrees= 90
		hurtbox.position.y = -50

	else:
		motion.y = lerp(motion.y,0.0,0.2)
	
	
	move_and_slide(motion)

func ranged_attack():
	if KUNAI:
		var kunai = KUNAI.instance()
		get_tree().current_scene.add_child(kunai)
		kunai.global_position = holder.global_position
		var kunai_rotation = holder.global_position.direction_to((get_global_mouse_position() + Vector2(rand_range(-1, 1), rand_range(-1, 1)))).angle()
		kunai.rotation = kunai_rotation
		$kunai_cooldown.start()
		can_range = false
		state = MOVE
		
func take_dmg(dmg):
	health -= dmg
	emit_signal("health_update", health)
	if health <=0:
		die()

func die():
	queue_free()
	PlayerData.won = false
	PlayerData.save_fight_data()
	PlayerData.won()
	get_tree().change_scene("res://src/scenes/tryagain.tscn")

#func knockback(knockback_strength):
#	knockback  += knockback_strength*((global_position-Boss_pos).normalized())
#	move_and_slide(knockback)
#	yield(anim , "animation_finished")
#	knockback = Vector2()
#



func _on_melee_timer_timeout():
	hurtshape.disabled = true


func _on_hurtbox_area_entered(area):
	var who = area.name
	if who == "melee_hitbox":
		take_dmg(1)
		PlayerData.damage_taken += 1
		get_parent().get_node("ScreenShake").screen_shake(0.5, 10 , 100)
	elif who == "fireball":
		take_dmg(2)
		PlayerData.damage_taken += 2
		get_parent().get_node("ScreenShake").screen_shake(0.5, 10 , 100)



func _on_healcooldown_timeout():
	can_heal = true
	



func _on_kunai_cooldown_timeout():
	can_range = true

