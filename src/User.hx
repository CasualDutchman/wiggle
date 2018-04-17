package;

/**
 * ...
 * @author ...
 */
class User 
{
	
	public var LevelScore:Array<Int> = [];
	
	public function new() 
	{
		load();
	}
	
	public function setScoreForLevel(i:Int, score:Int)
	{
		LevelScore[i] = score;
	}
	
	function load()
	{
		
	}
	
	public function save()
	{
		
	}
	
}