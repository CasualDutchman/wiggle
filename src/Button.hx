package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;

import openfl.events.MouseEvent;

import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

class Button extends Sprite
{
	private var buttonWidth = 60;
	private var buttonHeigth = 20;
	
	private var scaler:Float = 4;
	
	var bitmap:Bitmap;
	
	var textField:TextField;
	
	public function new(text:String) 
	{
		super();
		var data:BitmapData = Assets.getBitmapData("img/button1.png");
		bitmap = new Bitmap(data);
		bitmap.scrollRect = new Rectangle(0, 0, buttonWidth, buttonHeigth);
		bitmap.scaleX = bitmap.scaleY = scaler;
		addChild(bitmap);
		
		addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		
		textField = new TextField();
		textField.width = buttonWidth * scaler;
		textField.height = buttonHeigth * scaler;
		textField.text = text;
		textField.setTextFormat(new TextFormat(null, 30));
		textField.y = ((buttonHeigth * scaler) - textField.textHeight) / 2;
		textField.x = ((buttonWidth * scaler) - textField.textWidth) / 2;
		textField.selectable = false;
		addChild(textField);
	}
	
	public function mouseOver(event:MouseEvent)
	{
		bitmap.scrollRect = new Rectangle(0, buttonHeigth, buttonWidth, buttonHeigth);
	}
	
	public function mouseOut(event:MouseEvent)
	{
		bitmap.scrollRect = new Rectangle(0, 0, buttonWidth, buttonHeigth);
	}
	
	public function setText(text:String)
	{
		textField.text = text;
		textField.setTextFormat(new TextFormat(null, 30));
		textField.y = ((buttonHeigth * scaler) - textField.textHeight) / 2;
		textField.x = ((buttonWidth * scaler) - textField.textWidth) / 2;
	}
}