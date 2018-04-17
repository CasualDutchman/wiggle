package;

import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author me
 */
class Blind extends Sprite
{

	var mask_p1:Sprite;
	var mask_p2:Sprite;

	var radius:Int = 40;
	
	public function new() 
	{
		super();
		
		mask_p1 = new Sprite();
		
		if (!Main.DebugBlind)
		{
			mask_p1.graphics.beginFill(0xFFFFFF);
			mask_p1.graphics.drawCircle(0, 0, radius);
			mask_p1.graphics.endFill();
			
			addChild(mask_p1);
		}
		mask_p2 = new Sprite();
		
		if (!Main.DebugBlind)
		{
			mask_p2.graphics.beginFill(0xFFFFFF);
			mask_p2.graphics.drawCircle(0, 0, radius);
			mask_p2.graphics.endFill();
			
			addChild(mask_p2);
		}
	}
	
	/*
	 * Called every frame to set the circles on the players.
	 */
	public function update(s1:Sprite, s2:Sprite):Void
	{
		mask_p1.x = s1.x;
		mask_p1.y = s1.y - 20;
		mask_p2.x = s2.x;
		mask_p2.y = s2.y - 20;
	}
	
	/*
	 * Make the circles bigger
	 */
	public function biggerView(i:Int, size:Float):Void
	{
		if (i == 0)
		{
			mask_p1.scaleX = mask_p1.scaleY = size;
		}
		else if (i == 1)
		{
			mask_p2.scaleX = mask_p2.scaleY = size;
		}
	}
}