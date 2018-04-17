package;

import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.text.TextField;

class DeadScreen extends Sprite
{
	public var won:Bool;
	public var paused:Bool;
	
	public var button1:Button;
	public var button2:Button;
	
	var scale:Float = 3;
	
	var textField:TextField;
	
	public function new() 
	{
		super();
		var data:BitmapData = Assets.getBitmapData("img/screen.png");
		var bitmap:Bitmap = new Bitmap(data);
		bitmap.scaleX = bitmap.scaleY = scale;
		addChild(bitmap);
		
		textField = new TextField();
		textField.x = textField.y = 20;
		textField.selectable = false;
		addChild(textField);
		
		button1 = new Button("Restart");
		button1.x = 25;
		button1.y = 45;
		addChild(button1);
		
		button2 = new Button("Main Menu");
		button2.x = 25;
		button2.y = 120;
		addChild(button2);
	}
	
	public function setText(str:String)
	{
		textField.text = str;
	}
	
	public function getWidth():Float
	{
		return 100 * scale;
	}
	
	public function getHeigth():Float
	{
		return 70 * scale;
	}
}