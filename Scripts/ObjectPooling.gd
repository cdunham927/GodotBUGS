extends Node

export(PackedScene) var objectToPool
export(int) var numToPool

export(float) var totalInPool
export(float) var timeBetweenPrints
var curPrint : float = 0

#Child our pooled objects to this to add to pool 
#Keep track of children and unchild to remove from pool

func _ready():
	for i in numToPool:
		NewPoolItem()
		
#func _process(delta):
	#if curPrint > 0: 
	#	curPrint -= delta
	#else:
	#	curPrint = timeBetweenPrints
	#	print("Total in pool: ", get_child_count())
	
	
func NewPoolItem():
	#Spawn object
	var obj = objectToPool.instance()
	#Add to pool
	self.add_child(obj)
	#Hide obj
	obj.hide()
	
func GetPoolObject():
	var num = get_child_count()
	if num > 0:
		var obj = get_child(0)
		self.remove_child(obj)
		return obj
	else:
		NewPoolItem()
		var obj = get_child(0)
		self.remove_child(obj)
		return obj
