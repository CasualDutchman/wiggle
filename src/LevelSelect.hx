package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;

class LevelSelect extends Sprite
{

	var widthGrid:Int = 7;
	var heightGrid:Int = 3;
	
	var Title:TextField = new TextField();
	
	public var Buttons:Array<ButtonLevelSelect> = [];
	
	public var back:Button;
	
	public function new() 
	{
		super();
		
		Title.width = 400;
		Title.x = 100;
		Title.y = 30;
		Title.text = "Select your Level";
		Title.textColor = 16777215;
		Title.setTextFormat(new TextFormat(null, 30));
		addChild(Title);
		
		for (y in 0...heightGrid)
		{
			for (x in 0...widthGrid)
			{
				var id:Int = (y * widthGrid) + x;
				Buttons[id] = new ButtonLevelSelect(id + 1);
				Buttons[id].x = 100 + ((Buttons[id].getWidth() + 10) * x);
				Buttons[id].y = 70 + ((Buttons[id].getHeigth() + 10) * y);
				Buttons[id].setClickable(isClickable(id));
				addChild(Buttons[id]);
			}
		}
		
		back = new Button("Back");
		back.x = 100;
		back.y = 350;
		addChild(back);
	}
	
	public function update()
	{
		for (y in 0...heightGrid)
		{
			for (x in 0...widthGrid)
			{
				var id:Int = (y * widthGrid) + x;
				Buttons[id].setClickable(isClickable(id));
			}
		}
	}
	
	function isClickable(i:Int):Bool
	{
		if (i == 0)
		{
			return true;
		}
		if (Main.user.LevelScore[i - 1] > 0)
		{
			return true;
		}
		return false;
	}
}