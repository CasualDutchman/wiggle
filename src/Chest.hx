package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.events.Event;
import openfl.geom.Rectangle;

/*
 * Alizera gave the the array for the randomizing for the chect's content
 */
class Chest extends Sprite
{
	public var players:Array<Player> = [];
	
	var randomNumberArray:Array<Int> = [];
	var next:Int = -1;
	
	var timer:Float;
	var slowingTimer:Float = 1;
	var randomTimer:Int;
	
	var prevSlow:Int;
	
	var bombtimer:Int;
	var isBbomb:Bool;
	var bombSound:Bool;
	
	public var LocX:Float;
	public var LocY:Float;
	
	public var bitmap:Bitmap;
	public var bitmapItem:Bitmap;
	
	public var random:Int;
	
	public var canPickUp:Bool = false;
	public var canOpen:Bool = true;
	var opened:Bool;
	
	public static var ID:Int;
	
	public var currentPlayer:Player;
	
	public function new(x:Float=0, y:Float=0) 
	{
		super();
		
		LocX = x;
		LocY = y;
		
		var data:BitmapData = Assets.getBitmapData("img/chest animation.png");
		bitmap = new Bitmap(data);
		bitmap.scrollRect = new Rectangle(0, 0, 35, 50);
		bitmap.x = -18;
		bitmap.y = -35;
		addChild(bitmap);
		
		var dataItem:BitmapData = Assets.getBitmapData("img/items.png");
		bitmapItem = new Bitmap(dataItem);
		bitmapItem.scaleX = bitmapItem.scaleY = 2;
		bitmapItem.x = -18;
		bitmapItem.y = -35;
		bitmapItem.scrollRect = new Rectangle(0, 0, 1, 1);
		addChild(bitmapItem);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	public function pickUpChest(player:Player):Int
	{
		Main.musicPlayer.playSound(Main.musicPlayer.chest_Open);
		slowingTimer = 1;
		timer = 0;
		randomTimer = Std.int(Variables.chestTimeToRespawn * 1000);
		randomNumberArray = GetNewRandomNumberArray();
		currentPlayer = player;
		players = player.currentLevel.players;
		canOpen = false;
		isBbomb = false;
		bombSound = false;
		prevSlow = 0;
		bitmap.scrollRect = new Rectangle(35, 0, 35, 50);
		return random;
	}
	
	public function pickUpItem(player:Player)
	{
		if (opened && canPickUp)
		{
			if (random == Item.speedDebuff || random == Item.visionDebuff)
			{
				currentPlayer.pickUpItem(new Item(random));
				removeItem();
			}
			else
			{
				player.pickUpItem(new Item(random));
				removeItem();
			}
			
			if (random == Item.bearTrap)
			{
				player.currentLevel.addBearTrap();
				removeItem();
			}
			
			if (random == Item.wall)
			{
				player.currentLevel.addWall();
				removeItem();
			}
			
			if (random == Item.tiger)
			{
				player.currentLevel.addTiger();
				removeItem();
			}
		}
	}
	
	function removeItem()
	{
		bitmapItem.scrollRect = new Rectangle(0, 0, 1, 1);
		currentPlayer = null;
		canPickUp = false;
	}
	
	/*
	 * updates the chest
	 */
	public function update(event:Event)
	{
		if (canOpen)
		{
			timer = 0;
		}
		else
		{
			if (slowingTimer >= Variables.chestTimeToShowFinalItem)
			{
				if (!opened)
				{
					if (randomNumberArray[Math.floor((timer / slowingTimer) % 11)] == Item.bomb)
					{
						isBbomb = true;
					}
					Main.musicPlayer.playSound(Main.musicPlayer.chest_Roll_Finish);
					bitmapItem.scrollRect = new Rectangle(randomNumberArray[Math.floor((timer / slowingTimer) % 11)] * 16, 0, 16, 16);
					random = randomNumberArray[Math.floor((timer / slowingTimer) % 11)];
					opened = true;
					canPickUp = true;
				}
			}
			else
			{	
				slowingTimer += 0.02;
				
				if (Math.floor(timer / slowingTimer) != prevSlow)
				{
					Main.musicPlayer.playSound(Main.musicPlayer.chest_Roll);
					prevSlow = Math.floor(timer / slowingTimer);
				}
				
				bitmapItem.scrollRect = new Rectangle(randomNumberArray[Math.floor((timer / slowingTimer) % 11)] * 16, 0, 16, 16);
			}
			
			if (isBbomb)
			{
				if (!bombSound)
				{
					Main.musicPlayer.playSound(Main.musicPlayer.bomb);
					bombSound = true;
				}
				
				bombtimer++;
				if (bombtimer > (Variables.chestBombTimer * 60))
				{
					for (p in players)
					{
						var range:Float = Variables.chestBombRange;
						if (p.x > LocX - (32 * range) && p.x < LocX + (32 * range) && p.y < LocY + (32 * range) && p.y > LocY - (32 * range))
						{
							p.damagePlayer(Variables.chestBombDamage);
						}
					}
					removeItem();
					isBbomb = false;
					bombtimer = 0;
				}
			}
			
			if (timer >= randomTimer)
			{
				Main.musicPlayer.playSound(Main.musicPlayer.chest_Close);
				canOpen = true;
				randomTimer = Std.int(Variables.chestTimeToRespawn * 1000) + Std.random(500);
				bitmap.scrollRect = new Rectangle(0, 0, 35, 50);
				bitmapItem.scrollRect = new Rectangle(0, 0, 1, 1);
				opened = false;
			}
			else
			{
				timer++;
			}
		}
	}
	
	/*
	 * makes a random array for the chest to use
	 */
	function GetNewRandomNumberArray():Array<Int>
	{
		if (Main.Showcase)
		{
			next++;
			return [next, next, next, next, next, next, next, next, next, next, next];
		}
		
		var numbers:Array<Int> = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		//var numbers:Array<Int> = [Item.accessCard, Item.accessCard, Item.accessCard];
		var newarray:Array<Int> = [];
		
		for (num in 0...numbers.length)
		{
			var i:Int = numbers[Std.random(numbers.length)];
			newarray.push(i);
			numbers.remove(i);
		}
		
		return newarray;
	}
}