package;

import flash.geom.Point;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.geom.Rectangle;

class Wall extends Sprite
{
	public var hitPoints:Int = Variables.wallHitPoints;
	
	var bitmap:Bitmap;
	
	public function new() 
	{
		super();
		var data:BitmapData = Assets.getBitmapData("img/items.png");
		bitmap = new Bitmap(data);
		bitmap.scrollRect = new Rectangle(9 * 16, 0, 16, 16);
		bitmap.scaleX = 2;
		bitmap.scaleY = 2.4;
		bitmap.x = -16;
		bitmap.y = -20;
		addChild(bitmap);
	}
	
}