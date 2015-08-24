{SpeechSynth} = require "SpeechSynth"

$ = 
	animal: null
	narrator: new SpeechSynth volume: 1, rate: .85, pitch: 1, voice: "Samantha"
	images: ["africanelephant", "cheetah", "waterbuffalo", "giraffe", "lion", "meerkat", "rhinoceros", "zebra", "honeybadger"]
	layers: []
	
$.text = {africanelephant: "Male African elephants can weigh up to seven and a half tons.", cheetah: "When cheetahs are running full speed, their stride is 21 feet", waterbuffalo: "African water buffaloes a very dangerous, goring and killing over 200 people per year.", giraffe: "The name 'giraffe' has its earliest known origins in an Arabic word that means 'fast walker'", lion: "Lions spend much of their time resting and are inactive for about 20 hours per day.", meerkat: "Meerkats forage in a group with one 'sentry' on guard watching for predators while the others search for food.", rhinoceros: "Rhinoceros horns are not made of bone, but of keratin, the same material found in your hair and fingernails.", zebra: "Each zebra has a unique pattern of black and white stripes.", honeybadger: "This is the honey badger. He don\'t care."}

# Create image squares
imageCount = 0
[0..2].map (row) ->
	[0..2].map (col) ->
		image = new Layer 
			width: 200
			height: 200
			x: (col * (200 + 25)) + (Canvas.width - ((200 * 3) + (25 * 2)))/2
			y: (row * (200 + 25)) + (Canvas.height - ((200 * 3) + (25 * 2)))/2
			name: "#{$.images[col + imageCount]}"
			image: "images/#{$.images[col + imageCount]}.jpg"
			
		image.perspective = 200
			
		$.layers.push(image)
			
		# ––– EVENTS
		# Make sure ignoreEvents is false
		image.ignoreEvents = false
		
		# – MOUSEDOWN
		# I'm using mousedown because TouchStart in Studio triggers on hover
		# Hence why I use regex to get the name from the DIV
		
		image._element.onmousedown = (e) ->
			# Grab the string of the name and use it to reference the layer
			regex = /\bname="(\w+)/
			$.animal = this["outerHTML"].match(regex)[1]
			
			for layer in Framer.CurrentContext._layerList
				$.animal = layer if layer.name is $.animal
			
			$.animal.animate
				properties:
					scaleX: 1.02
					scaleY: .98
				curve: "spring(350, 40, 0)"
				
			for layer in $.layers when layer isnt $.animal
				layer.animate
					properties:
						opacity: .35
					curve: "spring(350, 40, 0)"
				
			# Speak
			$.narrator.text = $.text["#{$.animal.name}"]
			$.narrator.speak()	
						
		# – MOUSEUP	
		image._element.onmouseup = (e) ->
			$.animal.animate
				properties:
					scaleX: 1
					scaleY: 1
					rotationX: 0
				curve: "spring(350, 40, 0)"
				
			for layer in $.layers when layer isnt $.animal
				layer.animate
					properties:
						opacity: 1
					curve: "spring(350, 40, 0)"
					
			# Cancel
			$.narrator.cancel()
				
	# Increment in array
	imageCount += 3	
	
# Re-center on window size change	
window.onresize = ->
	imageCount = 0
	[0..2].map (row) ->
		[0..2].map (col) ->
			$.layers[col + imageCount].props =  
				width: 200
				height: 200
				x: (col * (200 + 25)) + (Canvas.width - ((200 * 3) + (25 * 2)))/2
				y: (row * (200 + 25)) + (Canvas.height - ((200 * 3) + (25 * 2)))/2	
	
		# Increment in array
		imageCount += 3
	
	
	
