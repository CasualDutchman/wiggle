package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.events.Event;

class Menu extends Sprite
{
	public var button1:Button;
	public var button2:Button;
	public var button3:Button;
	
	public var button4:Button;
	
	public var menuChannel:SoundChannel;
	public var loopable:Sound = Main.musicPlayer.loop_menu;
	
	var bitmap:Bitmap ;
	
	var xer:Float = 0;
	var xchange:Float = 0.04;
	var yer:Float = 0;
	var ychange:Float = 0.02;
	
	public function new() 
	{
		super();
		
		var data:BitmapData = Assets.getBitmapData("img/screen1.png");
		bitmap = new Bitmap(data);
		bitmap.scaleX = bitmap.scaleY = 6;
		bitmap.x = -200;
		bitmap.y = 10;
		addChild(bitmap);
		
		data = Assets.getBitmapData("img/title1.png");
		bitmap = new Bitmap(data);
		bitmap.scaleX = bitmap.scaleY = 2;
		//bitmap.x = 300;
		//bitmap.y = 17;
		addChild(bitmap);
		
		var globalX:Int = 285;
		
		button1 = new Button("New Game");
		button1.x = globalX;
		button1.y = 150;
		addChild(button1);
		
		button4 = new Button("Select Level");
		button4.x = globalX;
		button4.y = 250;
		addChild(button4);
		
		button2 = new Button("Audio: On");
		button2.x = globalX;
		button2.y = 350;
		button2.addEventListener(MouseEvent.CLICK, soundOnOff);
		addChild(button2);
		
		button3 = new Button("Quit");
		button3.x = globalX;
		button3.y = 700;
		addChild(button3);
		
		Music(true);
		
		var credits:TextField = new TextField();
		credits.selectable = false;
		credits.x = 1020;
		credits.y = 750;
		credits.text = "Credits:\nBruce Woodward\nDiana Portalska\nAlireza Doustdar\nPieter Jagersma";
		credits.textColor = 16777215;
		addChild(credits);
		
		addEventListener (Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function Music(b:Bool)
	{
		if (Main.musicPlayer.hasMusic && b)
		{
			menuChannel = new SoundChannel();
			menuChannel = loopable.play();
		}
		else if (!b)
		{
			menuChannel.stop();
		}
	}
	
	private function soundOnOff(event:MouseEvent)
	{
		Main.musicPlayer.hasMusic = !Main.musicPlayer.hasMusic;
		button2.setText(Main.musicPlayer.hasMusic ? "Audio: On" : "Audio: Off");
		
		if (!Main.musicPlayer.hasMusic)
		{
			menuChannel.stop();
		}
		else
		{
			menuChannel = loopable.play(0);
		}
	}
	
	private function onEnterFrame (event:Event):Void 
	{
		if (menuChannel.position >= loopable.length) {
			menuChannel.stop();
			menuChannel = loopable.play(0);
		}
		
		xer += xchange;
		//yer += ychange;
		
		if (xer > 4){ xchange = -0.08; }
		if (xer < -0.1){ xchange = 0.08; }
		
		//if (yer > 8){ ychange = -0.01; }
		//if (yer < -0.1){ ychange = 0.01; }
		
		bitmap.x = 265 + xer;
		bitmap.y = 35;
	}
}