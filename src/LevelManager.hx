package;

class LevelManager 
{

	public function new() {}
	
	public function getlevel(lvl:Int):LevelBase
	{
		switch(lvl)
		{
			case 0: return new Level1(0);
			case 1: return new Level2(1);
			case 2: return new Level3(2);
			
			default : return new Level1(0);
		}
	}
	
}