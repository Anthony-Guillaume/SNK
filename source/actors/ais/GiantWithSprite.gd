extends Node2D

signal death()

var player
var stats : ActorStats
# TEMPORARY BEFORE EXPORT FEATURE GODOT 4.0
export var baseHealth : float = 100
export var baseSpeed : float = 300
export var maxHealth : float = 100
export var maxSpeed : float = 500
#

var currentHurtBox : Area2D = null
var damage : float = 50
var canAttack : bool = true
var pushForce : float = 1200

onready var animation : AnimationPlayer = $AnimationPlayer
onready var foreArmLeftHurtBox : Area2D = $Chest/ArmLeft/ForeArmLeft/Hurtbox
onready var foreArmRightHurtBox : Area2D = $Chest/ArmRight/ForeArmRight/Hurtbox
onready var hitbox : KinematicBody2D = $Chest/Head/SolidHitbox



func _ready() -> void:
	setStats()
	foreArmLeftHurtBox.connect("body_entered", self, "_on_body_entered", [foreArmLeftHurtBox])
	foreArmRightHurtBox.connect("body_entered", self, "_on_body_entered", [foreArmRightHurtBox])
	animation.connect("animation_finished", self, "_on_attack_finished")
	player = get_parent().get_node("BasePlayer")

func setStats() -> void:
	var health : Attribute = Attribute.new(baseHealth, 0, maxHealth)
	var runSpeed : Attribute = Attribute.new(baseSpeed, 0, maxSpeed)
	stats = ActorStats.new(health, runSpeed)
	stats.health.connect("valueChanged", self, "_on_health_changed")
	hitbox.stats = stats

func _on_health_changed(value : float) -> void:
	if value < 0.1:
		emit_signal("death")

func _physics_process(_delta : float) -> void:
	if currentHurtBox != null:
		return
	if player.global_position.distance_to(hitbox.global_position) < 150:
		leftSwing()
	else:
		leftStrike()

func _on_body_entered(target, area : Area2D) -> void:
	if area == currentHurtBox and target == player:
		ActorStatusHandler.applyDamage(stats, target.stats, damage)
#		pushAway(target)
		currentHurtBox = null

func _on_attack_finished(_animationName : String) -> void:
	currentHurtBox = null

func leftSwing() -> void:
	currentHurtBox = foreArmLeftHurtBox
	animation.play("punch_left")

func leftStrike() -> void:
	currentHurtBox = foreArmLeftHurtBox
	animation.play("strike_left_hand")

func pushAway(target : Actor) -> void:
	var direction : Vector2 = currentHurtBox.global_position.direction_to(target.global_position)
	target.velocity += direction * pushForce
