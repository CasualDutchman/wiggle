package;

/**
 * ...
 * @author ...
 */
class Level3 extends LevelBase
{

	public function new(i:Int) 
	{
		super(i);
	}
	
	override public function createMap() 
	{
		super.createMap();
		
		map.push([11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11]);
		map.push([11, 0 , 1 , 1 , 1 , 2 , 11, 0 , 1 , 2 , 11, 11, 11]);
		map.push([11, 3 , 4 , 4 , 14, 12, 1 , 13, 14, 5 , 11, 11, 11]);
		map.push([11, 3 , 4 , 4 , 4 , 4 , 4 , 4 , 4 , 5 , 11, 11, 11]);
		map.push([11, 3 , 4 , 4 , 15, 20, 21, 22, 23, 5 , 11, 11, 11]);
		map.push([11, 6 , 7 , 7 , 7 , 7 , 7,  7 , 7 , 8 , 11, 11, 11]);
		map.push([11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11]);
		map.push([11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11]);
	}
}