package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.geom.Rectangle;
import openfl.text.TextField;

class ItemIcon extends Sprite
{

	var textF:TextField;
	
	public function new(playerid:Int, id:Int) 
	{
		super();
		
		var data:BitmapData = Assets.getBitmapData("img/items.png");
		var bitmap:Bitmap = new Bitmap(data);
		bitmap.scrollRect = new Rectangle(id * 16, 0, 16, 16);
		bitmap.scaleX = bitmap.scaleY = 2;
		bitmap.x = -16;
		bitmap.y = -16;
		addChild(bitmap);
		
		textF = new TextField();
		textF.x = playerid == 0 ? 20 : -35;
		textF.y = -10;
		textF.textColor = 16777215;
		textF.text = "x 0";
		addChild(textF);
	}
	
	public function setText(n:Int)
	{
		textF.text = "x " + n;
	}
	
}