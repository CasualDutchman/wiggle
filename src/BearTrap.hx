package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.geom.Rectangle;

class BearTrap extends Sprite
{

	public var Wiggler:Int = Variables.beartrapHitPoints;
	public var ID:Int;
	
	var bitmap:Bitmap;
	
	public function new(id:Int) 
	{
		super();
		ID = id;
		var data:BitmapData = Assets.getBitmapData("img/bearTrap.png");
		bitmap = new Bitmap(data);
		bitmap.scrollRect = new Rectangle(0, 0, 16, 16);
		bitmap.scaleX = bitmap.scaleY = 1.6;
		bitmap.x = -12.8;
		bitmap.y = -15.8;
		addChild(bitmap);
	}
	
	public function setClosed()
	{
		bitmap.scrollRect = new Rectangle(16, 0, 16, 16);
	}
	
}