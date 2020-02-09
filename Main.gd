extends Node

onready var timer_main := $timer_main
onready var btn_fifty := $UI/AppMargins/MainContainer/Counter/counter_buttons/HBoxContainer/btn_fifty
onready var btn_twenty := $UI/AppMargins/MainContainer/Counter/counter_buttons/HBoxContainer/btn_twenty
onready var btn_pause := $UI/AppMargins/MainContainer/Counter/counter_controls/HBoxContainer2/btn_pause
onready var btn_start := $UI/AppMargins/MainContainer/Counter/counter_controls/HBoxContainer2/btn_start
onready var btn_stop := $UI/AppMargins/MainContainer/Counter/counter_controls/HBoxContainer2/btn_stop
onready var label_counter := $UI/AppMargins/MainContainer/Counter/counter_display/CenterContainer/label_counter
onready var counter_progress := $UI/AppMargins/MainContainer/Counter/counter_display/CenterContainer/counter_progress

onready var progress_img_01 := load("res://Assets/progress_01.png")
onready var progress_img_02 := load("res://Assets/progress_02.png")
onready var sfx_work_end := $sfx_work_end
onready var sfx_rest_end := $sfx_rest_end

var minutes := 0
var seconds := 0
var work_delay := 0
var rest_delay := 0
var can_rest := true


func _ready()->void:
	label_counter.text = "00 : 00"
	counter_progress.value = 0
	set_process(false)


func _process(_delta)->void:
	update_counter()


func _on_btn_fifty_pressed()->void:
	work_delay = 50
	set_delay(work_delay)


func _on_btn_twenty_pressed()->void:
	work_delay = 25
	set_delay(work_delay)


func _on_btn_start_pressed():
	set_delay(work_delay)
	start()


func _on_btn_stop_pressed():
	stop()


func _on_btn_pause_toggled(button_pressed):
	if button_pressed:
		set_process(false)
		btn_pause.text = "Resume"
	else:
		set_process(true)
		btn_pause.text = "Pause"


func _on_timer_main_timeout():
	start()


func set_delay(time)->void:
	minutes = time
	seconds = minutes * 60
	timer_main.wait_time = seconds
	label_counter.text = "%d : 00" % minutes
	counter_progress.max_value = seconds


func start()->void:
	check_rest()
	counter_progress.value = counter_progress.max_value
	timer_main.start()
	set_process(true)
	btn_start.disabled = true


func stop()->void:
	set_process(false)
	btn_start.disabled = false
	label_counter.text = "00 : 00"
	counter_progress.value = 0
	can_rest = true


func update_counter()->void:
	var time_left := floor(timer_main.time_left)
	var seconds_left = int(time_left) % 60
	var minutes_left := floor(time_left / 60)
	
	label_counter.text = str("%d : %d" % [minutes_left, seconds_left])
	counter_progress.value = floor(time_left)

func check_rest()->void:
	if not can_rest:
		rest_delay = 5 if work_delay == 25 else 10
		counter_progress.texture_progress = progress_img_02
		set_delay(rest_delay)
		sfx_work_end.play()
		can_rest = true
	else:
		counter_progress.texture_progress = progress_img_01
		set_delay(work_delay)
		sfx_rest_end.play()
		can_rest = false
