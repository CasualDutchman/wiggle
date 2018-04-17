package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.geom.Rectangle;

class Hearts extends Sprite
{
	var bitmaps:Array<Bitmap> = [];
	
	var PlayerID:Int;
	
	public function new(playerId:Int) 
	{
		super();
		
		PlayerID = playerId;
		
		for (i in 0...10)
		{
			var data:BitmapData = Assets.getBitmapData("img/hearts.png");
			bitmaps[i] = new Bitmap(data);
			bitmaps[i].scrollRect = new Rectangle(0, 0, 16, 16);
			bitmaps[i].x = (i * 28);
			bitmaps[i].scaleX = bitmaps[i].scaleY = 1.6;
			addChild(bitmaps[i]);
		}
	}
	
	public function updatehearts(amount:Int)
	{
		for (i in 0...10)
		{
			var newAmount:Int = 0;
			
			if (amount <= i)
			{
				newAmount = 2;
			}
			else
			{
				newAmount = 0;
			}

			
			bitmaps[i].scrollRect = new Rectangle(newAmount * 16, 0, 16, 16);
		}
	}
	
}