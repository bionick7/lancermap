@tool
extends Button

@export var codepoint: int:
	set(x): 
		codepoint = x
		text = String.chr(x)
