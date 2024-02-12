extends Node2D

const TILE_SIZE : int = 16
var fighters = []

class Item:
	var name : String
	var type : String
	var healing : int
