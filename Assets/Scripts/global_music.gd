extends AudioStreamPlayer
#MainPlayer es self. Si editamos 'volume_db' es al valor de MainPlayer
#SecondPlayer es una variable dentro de MainPlayer. Para acceder a sus datos 
#privados debemos hacer 'second_player.volume_db', por ejemplo

#Se crea un segundo AudioStreamPlayer para hacer los fadings
@onready var second_player = AudioStreamPlayer.new()
var fading: bool = false


func _ready():
	#Se añade el segundo AudioStreamPlayer a escena
	add_child(second_player)
	
	#Se carga por defecto un track y se reproduce al abrir el juego (opcional)
	#stream = load("res://Assets/art/MenuBGM.mp3") 
	play()


#Acciones que se realizan a lo largo de toda la ejecución
func _process(delta):

	#Si hay que hacer un fading a otro track...
	if fading:
		#...El SecondPlayer aumenta su volumen poco a poco, mientras que el
		#MainPlayer reduce su volumen poco a poco
		second_player.volume_db += 30*delta
		volume_db -= 30*delta

		#Cuando el SecondPlayer alcanza el volumen estandar (0dB)...
		if second_player.volume_db >= 0:
			#...Se silencia SecondPlayer y se pone MainPlayer a volumen estandar
			second_player.volume_db = -60
			volume_db = 0

			#Se traspasa el trabajo de SecondPlayer a MainPlayer y se empieza a reproducir
			stream = second_player.stream
			play(second_player.get_playback_position())

			second_player.stop()
			fading = false


#Se carga el track "Silence" y se hace un fading desde ActualTrack->Silence
func stop_music():
	second_player.stream = load ("res://Assets/art/silence.ogg")
	second_player.volume_db = -60
	second_player.play()

	fading = true


#Carga el track de la música por defecto al iniciar partida (microgame obsolete)
func start_music():
	stream = load("res://Assets/art/GameBGM.mp3") 
	play()


#Se comparte un nombre de track y hace un fading a esa canción.
#ActualTrack->NewTrack
func play_song(song_name):
	second_player.stream = load ("res://Assets/art/" + song_name + ".mp3")
	second_player.volume_db = -60
	second_player.play()

	fading = true


''' # TEORÍA DE POR QUÉ HACER ASÍ EL CÓDIGO (MainPlayer & SecondPlayer)
Una implementación que podría ser más intuitiva a priori sería reproducir algo
en MainPlayer y cuando quisiésemos reproducir otra cosa, usar SecondPlayer y
hacer fade a MainPlayer.
El problema de complejidad detrás de eso es que cada vez que quisiésemos 
reproducir una música distinta necesitaríamos revisar quién está reproduciendo
ahora y hacer fading al otro reproductor (el código necesitaría tener tantos
casos como reproductores hubiese. Best case: 2, lo cual es peor que ahora).
En cambio, con esta implementación, siempre reproduce MainPlayer y SecondPlayer
solo se usa para hacer las transiciones. 

En un juego de bajo scoping como los que tengo en mente no impactará en el 
rendimiento (podría hacerse de la forma inicialmente propuesta), pero creo que 
es mejor acostumbrarse a trabajar con soluciones más óptimas y escalables.
'''
