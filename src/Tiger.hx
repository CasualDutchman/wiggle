package;

import flash.geom.Point;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.geom.Rectangle;

import openfl.events.Event;

class Tiger extends Sprite
{
	var walkable:Array<Array<Int>> = new Array<Array<Int>>();
	var intersections:Array<Array<TigerNode>> = new Array<Array<TigerNode>>();
	
	
	var left:Int = 0;
	var right:Int = 2;
	var up:Int = 1;
	var down:Int = 3;
	
	var direction:Int = 0;
	var prefDirection:Int = 0;
	
	public var LocX:Int;
	public var LocY:Int;
	
	var speedX:Int = 1;
	var speedY:Int;
	
	var timer:Int;
	
	var bitmap:Bitmap;
	
	public function new(array:Array<Array<Int>>, x:Float, y:Float, nodes:Array<Array<TigerNode>>) 
	{
		super();

		LocX = Std.int(x);
		LocY = Std.int(y);
		
		walkable = array;
		intersections = nodes;
		
		var data:BitmapData = Assets.getBitmapData("img/tiger sprite sheet2.png");
		bitmap = new Bitmap(data);
		bitmap.scrollRect = new Rectangle(0, 0, 32, 32);
		bitmap.scaleX = bitmap.scaleY = 2;
		bitmap.x = -16;
		bitmap.y = -16;
		addChild(bitmap);
		
		addEventListener(Event.ENTER_FRAME, update);
	}

	/*
	 * updates the tiger
	 */
	public function update(event:Event)
	{
		
		timer++;
		if (timer >= Variables.tigerUpdate)
		{
			if (speedX == 1)
			{
				if (walkable[LocY][LocX + 1] == 0)
				{
					for(i in 0...intersections[LocY][LocX].accessable.length)
					{
						if (intersections[LocY][LocX].accessable[i] == 1)
						{
							getOrientation(i);
							break;
						}
					}
				}
				
				if (Std.random(3) == 0)
				{
					if (walkable[LocY - 1][LocX] == 1)
					{
						goUp();
					}
				}
				
				if (Std.random(3) == 0)
				{
					if (walkable[LocY + 1][LocX] == 1)
					{
						goDown();
					}
				}
			}
			if (speedY == 1)
			{
				if (walkable[LocY + 1][LocX] == 0)
				{
					for(i in 0...intersections[LocY][LocX].accessable.length)
					{
						if (intersections[LocY][LocX].accessable[i] == 1)
						{
							getOrientation(i);
							break;
						}
					}
				}
				
				if (Std.random(3) == 0)
				{
					if (walkable[LocY][LocX + 1] == 1)
					{
						goRight();
					}
				}
				if (Std.random(3) == 0)
				{
					if (walkable[LocY][LocX - 1] == 1)
					{
						goLeft();
					}
				}
			}
			
			if (speedX == -1)
			{
				if (walkable[LocY][LocX - 1] == 0)
				{
					for(i in 0...intersections[LocY][LocX].accessable.length)
					{
						if (intersections[LocY][LocX].accessable[i] == 1)
						{
							getOrientation(i);
							break;
						}
					}
				}
				
				if (Std.random(3) == 0)
				{
					if (walkable[LocY + 1][LocX] == 1)
					{
						goDown();
					}
				}
				if (Std.random(3) == 0)
				{
					if (walkable[LocY - 1][LocX] == 1)
					{
						goUp();
					}
				}
			}
			if (speedY == -1)
			{
				if (walkable[LocY - 1][LocX] == 0)
				{
					for(i in 0...intersections[LocY][LocX].accessable.length)
					{
						if (intersections[LocY][LocX].accessable[i] == 1)
						{
							getOrientation(i);
							break;
						}
					}
				}
				
				if (Std.random(3) == 0)
				{
					if (walkable[LocY][LocX - 1] == 1)
					{
						goLeft();
					}
				}
				if (Std.random(3) == 0)
				{
					if (walkable[LocY][LocX + 1] == 1)
					{
						goRight();
					}
				}
			}
			
			bitmap.scrollRect = new Rectangle(Math.floor(direction / 2) * 32, Math.floor(direction % 2) * 32, 32, 32);
			
			LocX += speedX;
			this.x = LocX * 32;
			
			LocY += speedY;
			this.y = LocY * 32;
			
			timer = 0;
		}
	}
	
	function goUp()
	{
		direction = down;
		speedX = 0;
		speedY = -1;
	}
	function goRight()
	{
		direction = right;
		speedX = 1;
		speedY = 0;
	}
	function goDown()
	{
		direction = up;
		speedX = 0;
		speedY = 1;
	}
	function goLeft()
	{
		direction = left;
		speedX = -1;
		speedY = 0;
	}
	function getOrientation(i:Int)
	{
		if (i == 0)
		{
			goUp();
		}
		else if (i == 1)
		{
			goRight();
		}
		else if (i == 2)
		{
			goDown();
		}
		else if (i == 3)
		{
			goLeft();
		}
	}
	
}