package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.geom.Rectangle;

/*
 * Diana gave me code to display a item
 */
class Item extends Sprite
{
	public static var itemID:Int = 0;
	public static var accessCard:Int = itemID;
	public static var medkit:Int = ++itemID;
	public static var teleportation:Int = ++itemID;
	public static var speedBuff:Int = ++itemID;
	public static var speedDebuff:Int = ++itemID;
	public static var visionBuff:Int = ++itemID;
	public static var visionDebuff:Int = ++itemID;
	public static var bearTrap:Int = ++itemID;
	public static var tiger:Int = ++itemID;
	public static var wall:Int = ++itemID;
	public static var bomb:Int = ++itemID;
	
	var sizeX = 20;
	var sizeY = 20;
	
	public var LocX:Float;
	public var LocY:Float;
	
	public var ID:Int;
	public var Amount:Int = 1;
	
	public function new(id:Int, x:Float=0, y:Float=0) 
	{
		ID = id;
		LocX = x;
		LocY = y;
		
		super();
		
		var data:BitmapData = Assets.getBitmapData("img/items.png");
		var bitmap:Bitmap = new Bitmap(data);
		bitmap.scrollRect = new Rectangle(ID * 16, 0, 16, 16);
		bitmap.scaleX = bitmap.scaleY = 2;
		bitmap.x = -16;
		bitmap.y = -16;
		addChild(bitmap);
	}
}