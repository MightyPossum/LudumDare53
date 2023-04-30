extends Node

var PlayerRoutes : Array
var PlanetArray : Array
var PathwayArray : Array
var LocationArray : Dictionary
var LocationDistances : Dictionary
var DistanceCosts : Dictionary

var win : bool = false
var lose : bool = false

var Cash : int = 0
var Materials : int = 0

var LocationNames : Dictionary
var LocationPrettyName : Dictionary

var AvailableFleet : Dictionary
var VesselList : Dictionary

var routeIDTracker : int = 1
