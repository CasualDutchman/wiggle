package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextField;

class ExplainScreen extends Sprite
{

	public var P1Ready:TextField;
	public var P2Ready:TextField;
	
	var text:Array<String> = ["Keycard : You need 3 to open the exits",
								"Medkit : You heal " + Variables.itemMedkitHealing + " hearts",
								"Portalgun : Teleported to a random location",
								"Speed buff : Stacks to gain more speed",
								"Speed debuff : drains your speed",
								"Vision buff : Stacks to gain more vision",
								"Vision debuff : drains your vision",
								"Beartrap : spawns a beartrap at a random location, deals 1 damage, needs " + Variables.beartrapHitPoints + " hits to get out",
								"Tiger : spawns a tiger at a random location, deals 5 damage",
								"Wall : spawns a wall at a random location, needs " + Variables.wallHitPoints + " hits to be destroyed",
								"Bomb : Run! deals " + Variables.chestBombDamage + " damage in a " + Variables.chestBombRange + " tile radius from chest"];
	
	public function new() 
	{
		super();
		
		var BG:Sprite = new Sprite();
		BG.graphics.beginFill(0);
		BG.graphics.drawRect(0, 0, 2000, 1100);
		//BG.graphics.drawCircle(0, 0, radius);
		BG.graphics.endFill();
		
		addChild(BG);
		
		var textField:TextField = new TextField();
		textField.width = 1000;
		textField.scaleX = textField.scaleY = 2;
		textField.text = "Open chests to get:";
		textField.x = 180;
		textField.y = 40;
		textField.textColor = 16777215;
		textField.selectable = false;
		addChild(textField);
		
		textField = new TextField();
		textField.width = 1000;
		textField.scaleX = textField.scaleY = 2;
		if (Main.Controller)
		{
			textField.text = "Controls:\n[Left Stick]: Walk\n[Right Stick]: Wiggle\n[Right Triggers]: Open chests";
		}
		else
		{
			textField.text = "Player 1 controls:\n[WASD]: Walk\n[E]: Wiggle\n[F]: Open chests";
		}
		textField.x = 1000;
		textField.y = 40;
		textField.textColor = 16777215;
		textField.selectable = false;
		addChild(textField);
		
		if (!Main.Controller)
		{
			textField = new TextField();
			textField.width = 1000;
			textField.scaleX = textField.scaleY = 2;
			textField.text = "Player 2 controls:\n[Arrows]: Walk\n[num 0]: Wiggle\n[num 1]: Open chests";
			textField.x = 1000;
			textField.y = 240;
			textField.textColor = 16777215;
			textField.selectable = false;
			addChild(textField);
		}
		
		for (i in 0...11)
		{
			var data:BitmapData = Assets.getBitmapData("img/items.png");
			var bitmap:Bitmap = new Bitmap(data);
			bitmap.scrollRect = new Rectangle(i * 16, 0, 16, 16);
			bitmap.scaleX = bitmap.scaleY = 3;
			bitmap.x = 180;
			bitmap.y = 70 + (i * 50);
			addChild(bitmap);
			
			textField = new TextField();
			textField.width = 1000;
			textField.scaleX = textField.scaleY = 2;
			textField.text = text[i];
			textField.x = 240;
			textField.y = 75 + (i * 50);
			textField.textColor = 16777215;
			textField.selectable = false;
			addChild(textField);
		}
		
		P1Ready = new TextField();
		P1Ready.width = 1000;
		P1Ready.scaleX = P1Ready.scaleY = 2;
		P1Ready.text = "Player 1 Wiggle to get ready";
		P1Ready.x = 350;
		P1Ready.y = 700;
		P1Ready.textColor = 16777215;
		P1Ready.selectable = false;
		addChild(P1Ready);
		
		P2Ready = new TextField();
		P2Ready.width = 1000;
		P2Ready.scaleX = P2Ready.scaleY = 2;
		P2Ready.text = "Player 2 Wiggle to get ready";
		P2Ready.x = 900;
		P2Ready.y = 700;
		P2Ready.textColor = 16777215;
		P2Ready.selectable = false;
		addChild(P2Ready);
	}
	
}