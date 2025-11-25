extends Panel

@onready var master_slider = $VBoxContainer/MasterVolume/HSlider
@onready var music_slider = $VBoxContainer/MusicVolume/HSlider
@onready var sfx_slider = $VBoxContainer/SFXVolume/HSlider
@onready var fullscreen_check = $VBoxContainer/FullscreenCheck
@onready var vsync_check = $VBoxContainer/VsyncCheck

func _ready() -> void:
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	vsync_check.toggled.connect(_on_vsync_toggled)
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	
	load_settings()

func load_settings():
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0)) * 100
	fullscreen_check.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	vsync_check.button_pressed = DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED

func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))

func _on_music_volume_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Music")
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value / 100.0))

func _on_sfx_volume_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("SFX")
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value / 100.0))

func _on_fullscreen_toggled(toggled: bool) -> void:
	if toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_vsync_toggled(toggled: bool) -> void:
	if toggled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_back_pressed() -> void:
	# Tenta chamar diferentes callbacks dependendo do contexto
	if get_parent().has_method("_on_back_to_menu"):
		get_parent()._on_back_to_menu()
	elif get_parent().has_method("_on_options_back"):
		get_parent()._on_options_back()

func connect_back_button(callback: Callable) -> void:
	# Remove a conexão antiga se existir
	if $VBoxContainer/BackButton.pressed.is_connected(_on_back_pressed):
		$VBoxContainer/BackButton.pressed.disconnect(_on_back_pressed)
	# Conecta o novo callback
	$VBoxContainer/BackButton.pressed.connect(callback)
