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

class ButtonLevelSelect extends Sprite
{
	private var buttonWidth = 20;
	private var buttonHeigth = 20;
	
	private var scaler:Float = 4;
	
	var bitmap:Bitmap;
	
	var textField:TextField;
	
	public var clickable:Bool;
	public var ID:Int;
	
	public function new(i:Int, b:Bool = true) 
	{
		super();
		clickable = b;
		ID = i;
		
		var data:BitmapData = Assets.getBitmapData("img/button_Select.png");
		bitmap = new Bitmap(data);
		bitmap.scrollRect = new Rectangle(0, !clickable ? buttonHeigth * 2 : 0, buttonWidth, buttonHeigth);
		bitmap.scaleX = bitmap.scaleY = scaler;
		addChild(bitmap);
		
		if (clickable)
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		textField = new TextField();
		textField.width = (buttonWidth * scaler) / 2;
		textField.height = (buttonHeigth * scaler) / 2;
		textField.text = i + "";
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
	
	public function setClickable(b:Bool)
	{
		clickable = b;
		
		bitmap.scrollRect = new Rectangle(0, !b ? buttonHeigth * 2 : 0, buttonWidth, buttonHeigth);
		
		if (b)
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		else
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
	}
	
	public function getWidth():Float
	{
		return buttonWidth * scaler;
	}
	
	public function getHeigth():Float
	{
		return buttonHeigth * scaler;
	}
}