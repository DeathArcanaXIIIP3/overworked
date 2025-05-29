extends Node

signal ACABOU_O_TEMPO        # Sinal gerado ao atingir o limite n

var n: int = 5                    # limite de tempo
var contador: int = 0            # valor atual
var intervalo: float = 1.0       # segundos entre contagens
var timer: Timer                 # referência ao Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = intervalo
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_temporizar)
	timer.start()

func _temporizar():
	contador += 1
	print("Contador:", contador)
	if contador == n:
		emit_signal("ACABOU_O_TEMPO")
		print("Acabou o ciclo, n = ", n)
		contador=0;

	
