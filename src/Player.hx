package;

import flash.geom.Point;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.TextField;

class Player extends Sprite
{
	//mapping of keys for multiple players, order: up, down, left, right, wiggle, openChest
	public var keyMapping:Array<Array<Int>> = [[87, 83, 65, 68, 69, 70], [38, 40, 37, 39, 96, 97]];
	//mapping of keys for multiple players with controller, order: wiggle left, wiggle right
	var ControllerKeymapWiggle:Array<Array<Int>> = [[79, 80], [75, 76]]; // [O, P] [K, L]
	var iconmap:Array<Int> = [0, 5, 3];
	
	public var Players:Array<Player> = [];
	
	var framePos:Array<Int> = [0, 1, 2, 3];
	
	public var Inventory:Array<Item> = [];
	var InventoryText:Array<ItemIcon> = [];
	
	public var Health:Int = 10;
	
	var orientation:Int = 0;
	
	public var playerID:Int;
	
	var bitmap:Bitmap;
	var wiggleBitmap:Bitmap;
	var left:Bool;
	
	var controllerLeft:Bool;
	var controllerRight:Bool;
	
	var animationTimer:Int;
	var wiggleTimer:Int;
	
	var holdAttacked:Bool;
	var holdAttackedControllerLeft:Bool;
	var holdAttackedControllerRight:Bool;
	var holdUse:Bool;
	var holdChest:Bool;
	
	var isTrapped:Bool;
	var damagedByBeartrap:Bool;
	var bearTrap:BearTrap;
	
	var attackTimer:Int;
	var attackTimerControllerLeft:Int;
	var attackTimerControllerRight:Int;
	
	var chestTimer:Int;
	
	public var currentLevel:LevelBase;
	
	var hitCooldown:Float = 1;
	
	var canWalk:Bool;
	
	public var Dead:Bool;
	public var Win:Bool;
	
	var playedsound:Bool;
	var walksounded:Int;
	
	var wid = 20;
	var hei = 30;
	var scaler = 1.6;
	
	var PowerUpVision:Int = 0;
	var PowerUpSpeed:Int = 0;
	
	public function new(i:Int, lvl:LevelBase) 
	{
		super();
		playerID = i;
		currentLevel = lvl;
		
		var data:BitmapData = Assets.getBitmapData(playerID == 0 ? "img/oldguynew.png" : "img/fatguynew.png");
		var Wdata:BitmapData = Assets.getBitmapData(playerID == 0 ? "img/wiggleSprite_2.png" : "img/wiggleSprite.png");
		
		bitmap = new Bitmap(data);
		bitmap.scrollRect = new Rectangle(0, 0, wid, hei);
		bitmap.x = -((wid * scaler) / 2);
		bitmap.y = (-(hei * scaler)) + 4;
		bitmap.scaleX = bitmap.scaleY = scaler;
		addChild(bitmap);
		
		wiggleBitmap = new Bitmap(Wdata);
		wiggleBitmap.scrollRect = new Rectangle(0, 0, wid, hei);
		wiggleBitmap.x = -((wid * scaler) / 2);
		wiggleBitmap.y = (-(hei * scaler)) + 4;
		wiggleBitmap.scaleX = wiggleBitmap.scaleY = scaler;
		addChild(wiggleBitmap);
		
		for (i in 0...3)
		{
			InventoryText[i] = new ItemIcon(playerID, iconmap[i]);
			InventoryText[i].x = playerID == 0 ? 30 : 1495;
			InventoryText[i].y = 70 + (i * 40);
			currentLevel.addChild(InventoryText[i]);
		}
	}
	
	/*
	 * damages the player and updates the hearts
	 */
	public function damagePlayer(amount:Int)
	{
		Main.musicPlayer.playSound(Main.musicPlayer.player_Hit);
		if (Health - amount <= 0)
		{
			Health = 0;
		}
		else if (Health - amount >= 0)
		{
			Health -= amount;
		}
		currentLevel.hearts[playerID].updatehearts(Health);
	}
	
	/*
	 * heals the player and updates the hearts
	 */
	public function healPlayer(amount:Int)
	{
		Main.musicPlayer.playSound(Main.musicPlayer.player_Heal);
		if (Health + amount >= 10)
		{
			Health = 10;
		}
		else if (Health + amount <= 10)
		{
			Health += amount;
		}
		currentLevel.hearts[playerID].updatehearts(Health);
	}
	
	/*
	 * updates the player. updates position, direction of looking, if it stands on something
	 */
	public function update(keys:Array<Bool>)
	{
		var time:Int = 10;
		
		bitmap.scrollRect = new Rectangle(framePos[Math.floor(animationTimer / time)] * wid, orientation * 30, wid, hei);
		wiggleBitmap.scrollRect = new Rectangle(framePos[Math.floor(wiggleTimer / time)] * wid, orientation * 30, wid, hei);
		
		if (keys[keyMapping[playerID][0]] || keys[keyMapping[playerID][1]] || keys[keyMapping[playerID][2]] || keys[keyMapping[playerID][3]])
		{
			if (canWalk)
			{
				animationTimer++;
				wiggleTimer++;
				
				walksounded++;
				
				if (walksounded >= 20)
				{
					walksounded = 0;
					
				}
				if (walksounded == 1)
				{
					Main.musicPlayer.playSound(Main.musicPlayer.sound_walk);
				}
			}
			else 
			{
				animationTimer = 0;
				wiggleTimer = 0;
			}
		}
		else
		{
			walksounded = 0;
			animationTimer = 0;
			wiggleTimer = 0;
			canWalk = false;
		}
		
		if (currentLevel.isTiger(this.x, this.y) != null)
		{
			currentLevel.removeTiger(currentLevel.isTiger(this.x, this.y));
			damagePlayer(5);
		}
		
		if (hitCooldown > 1 + (PowerUpVision / 5))
		{
			hitCooldown -= 0.04;
		}
		
		currentLevel.blind.biggerView(playerID, hitCooldown);
		
		if (animationTimer > (time * 4))
		{
			animationTimer  = 0;
		}
		
		if (wiggleTimer > (time * 4))
		{
			wiggleTimer  = 0;
		}
		
		if (currentLevel.isExit(this.x, this.y))
		{
			if (hasItem(Item.accessCard, 3))
			{
				Win = true;
			}
		}
		
		//TODO ====================
		
		if (!currentLevel.canPlayerWalkHere(this.x, this.y))
		{
			//Health = 0;
		}
		
		if (Health <= 0)
		{
			Dead = true;
		}
		
		//=====================
		
		if (currentLevel.isBearTrap(this) != null)
		{
			bearTrap = currentLevel.isBearTrap(this);
			this.x = bearTrap.x;
			this.y = bearTrap.y;
			bearTrap.setClosed();
			isTrapped = true;
			if (!damagedByBeartrap)
			{
				Main.musicPlayer.playSound(Main.musicPlayer.beartrap_Close);
				damagePlayer(1);
				damagedByBeartrap = true;
			}
		}
		
		if (keys[keyMapping[playerID][0]]) // UP
		{
			if (currentLevel.canPlayerWalkHere(this.x, this.y - 2) && !isTrapped && currentLevel.isWall(this.x, this.y - 2) == null)
			{
				this.y -= 2 + clampZero((PowerUpSpeed / 4) - (hitCooldown / 2));
				canWalk = true;
			}
			else if (currentLevel.isHole(this.x, this.y - 3))
			{
				this.y -= Variables.playerFallingDis;
				canWalk = true;
			}
			else { canWalk = false; }
			orientation = 1;
		}
		if (keys[keyMapping[playerID][1]]) // DOWN
		{
			if (currentLevel.canPlayerWalkHere(this.x, this.y + 2) && !isTrapped && currentLevel.isWall(this.x, this.y + 2) == null)
			{
				this.y += 2 + clampZero((PowerUpSpeed / 4) - (hitCooldown / 2));
				canWalk = true;
			}
			else if (currentLevel.isHole(this.x, this.y + 3))
			{
				this.y += Variables.playerFallingDis;
				canWalk = true;
			}
			else { canWalk = false; }
			orientation = 0;
		}
		if (keys[keyMapping[playerID][2]]) // LEFT
		{
			if (currentLevel.canPlayerWalkHere(this.x - 2, this.y) && !isTrapped && currentLevel.isWall(this.x - 2, this.y) == null)
			{
				this.x -= 2 + clampZero((PowerUpSpeed / 4) - (hitCooldown / 2));
				canWalk = true;
			}
			else if (currentLevel.isHole(this.x - 3, this.y))
			{
				this.x -= Variables.playerFallingDis;
				canWalk = true;
			}
			else { canWalk = false; }
			orientation = 3;
		}
		if (keys[keyMapping[playerID][3]]) // RIGHT
		{
			if (currentLevel.canPlayerWalkHere(this.x + 2, this.y) && !isTrapped && currentLevel.isWall(this.x + 2, this.y) == null)
			{
				this.x += 2 + clampZero((PowerUpSpeed / 4) - (hitCooldown / 2));
				canWalk = true;
			}
			else if (currentLevel.isHole(this.x + 3, this.y))
			{
				this.x += Variables.playerFallingDis;
				canWalk = true;
			}
			else { canWalk = false; }
			orientation = 2;
		}
		
		if (!Main.Controller)
		{
			if (keys[keyMapping[playerID][4]] && !holdAttacked) // USE
			{
				if (!holdUse)
				{
					Main.musicPlayer.playSounds(Main.musicPlayer.sound_Swoosh, Main.musicPlayer.sound_Swoosh2);
					if (isTrapped)
					{
						bearTrap.Wiggler--;
						if (bearTrap.Wiggler <= 0)
						{
							isTrapped = false;
							currentLevel.removeBearTrap(bearTrap);
							damagedByBeartrap = false;
						}
					}
					
					var wall:Wall = currentLevel.isWall(this.x + (orientation == 2 ? 2 : (orientation == 3 ? -2 : 0)), this.y + (orientation == 0 ? 2 : (orientation == 1 ? -2 : 0)));
					
					if (wall != null)
					{
						wall.hitPoints--;
						if (wall.hitPoints < 0)
						{
							currentLevel.removeWall(wall);
						}
					}
				}
				
				holdUse = true;
				
				PushPlayerAway();
				
				if (hitCooldown + Variables.playerWiggleIncreaseVision < (Variables.playerVisionMaxDefault + (PowerUpVision / 2)))
				{
					hitCooldown += Variables.playerWiggleIncreaseVision;
				}
				
				wiggleTimer = left ? time : time * 3;
				
				attackTimer++;
				if (attackTimer > 5)
				{
					holdAttacked = true;
				}
			}
			else if (!keys[keyMapping[playerID][4]])
			{
				holdAttacked = false;
				holdUse = false;
				attackTimer = 0;
				
				playedsound = false;
				
				left = !left;
			}
		}
		if (keys[keyMapping[playerID][5]] && !holdChest) // USE
		{
			if (currentLevel.isChest(this.x, this.y) != null)
			{
				var chest:Chest = currentLevel.isChest(this.x, this.y);
				
				if (chest.canOpen)
				{
					chest.pickUpChest(this);
				}
				else if (chest.canPickUp)
				{
					chest.pickUpItem(this);
				}
			}
			chestTimer++;
			if (chestTimer > 2)
			{
				holdChest = true;
			}
		}
		else if (!keys[keyMapping[playerID][5]])
		{
			holdChest = false;
		}
		
		if (Main.Controller)
		{
			if (controllerLeft)
			{
				if (keys[ControllerKeymapWiggle[playerID][0]] && !holdAttackedControllerLeft)
				{
					if (!holdUse)
					{
						Main.musicPlayer.playSounds(Main.musicPlayer.sound_Swoosh, Main.musicPlayer.sound_Swoosh2);
						if (isTrapped)
						{
							bearTrap.Wiggler -= 2;
							if (bearTrap.Wiggler <= 0)
							{
								isTrapped = false;
								currentLevel.removeBearTrap(bearTrap);
								damagedByBeartrap = false;
							}
						}
						
						var wall:Wall = currentLevel.isWall(this.x + (orientation == 2 ? 2 : (orientation == 3 ? -2 : 0)), this.y + (orientation == 0 ? 2 : (orientation == 1 ? -2 : 0)));
					
						if (wall != null)
						{
							wall.hitPoints--;
							if (wall.hitPoints < 0)
							{
								currentLevel.removeWall(wall);
							}
						}
					}
					
					holdUse = true;
					
					PushPlayerAway();
					
					if (hitCooldown + Variables.playerWiggleIncreaseVision < (Variables.playerVisionMaxDefault + (PowerUpVision / 2)))
					{
						hitCooldown += Variables.playerWiggleIncreaseVision;
					}
					
					wiggleTimer = left ? time : time * 3;
					
					attackTimerControllerLeft++;
					if (attackTimerControllerLeft > 4)
					{
						holdAttackedControllerLeft = true;
						controllerLeft = false;
					}
				}
				if (!keys[ControllerKeymapWiggle[playerID][0]])
				{
					//controllerLeft = false;
					holdAttackedControllerLeft = false;
					holdUse = false;
					attackTimerControllerLeft = 0;
					
					playedsound = false;
					
					left = !left;
				}
			}
			else
			{
				if (keys[ControllerKeymapWiggle[playerID][1]] && !holdAttackedControllerRight)
				{
					if (!holdUse)
					{
						Main.musicPlayer.playSounds(Main.musicPlayer.sound_Swoosh, Main.musicPlayer.sound_Swoosh2);
						if (isTrapped)
						{
							bearTrap.Wiggler--;
							if (bearTrap.Wiggler <= 0)
							{
								isTrapped = false;
								currentLevel.removeBearTrap(bearTrap);
								damagedByBeartrap = false;
							}
						}
						
						var wall:Wall = currentLevel.isWall(this.x + (orientation == 2 ? 2 : (orientation == 3 ? -2 : 0)), this.y + (orientation == 0 ? 2 : (orientation == 1 ? -2 : 0)));
					
						if (wall != null)
						{
							wall.hitPoints--;
							if (wall.hitPoints < 0)
							{
								currentLevel.removeWall(wall);
							}
						}
					}
					
					holdUse = true;
					
					PushPlayerAway();
					
					if (hitCooldown + Variables.playerWiggleIncreaseVision < (Variables.playerVisionMaxDefault + (PowerUpVision / 2)))
					{
						hitCooldown += Variables.playerWiggleIncreaseVision;
					}
					
					wiggleTimer = left ? time : time * 3;
					
					attackTimerControllerRight++;
					if (attackTimerControllerRight > 4)
					{
						holdAttackedControllerRight = true;
						controllerLeft = true;
					}
				}
				if (!keys[ControllerKeymapWiggle[playerID][1]])
				{
					//controllerLeft = true;
					holdAttackedControllerRight = false;
					holdUse = false;
					attackTimerControllerRight = 0;
					
					playedsound = false;
					
					left = !left;
				}
			}
		}
	}
	
	function clampZero(f:Float):Float
	{
		if (f < -2)
		{
			f = -2;
		}
		return f;
	}
	
	/*
	 * remove a key from the player's inventory
	 */
	public function removeKey()
	{
		for (i in 0...Inventory.length)
		{
			if (Inventory[i].ID == Item.accessCard)
			{
				Inventory.remove(Inventory[i]);
			}
		}
		refreshInventoryDisplay();
	}
	
	/*
	 * returns the amount of items in the inventory
	 */
	private function getItemPos(item:Int):Int
	{
		var got:Int = 0;
		for (itemm in Inventory)
		{
			if (itemm.ID == item)
			{
				got++;
			}
		}
		return got;
	}
	
	/*
	 * returns true if the player has a amount of items
	 */
	function hasItem(item:Int, amount:Int=1):Bool
	{
		return getItemPos(item) >= amount;
	}
	
	/*
	 * called when a items in picked from a chest
	 */
	public function pickUpItem(item:Item)
	{
		
		if (item.ID == Item.accessCard)
		{
			Main.musicPlayer.playSound(Main.musicPlayer.card_pickup);
			Inventory.push(item);			
		}
		if (item.ID == Item.teleportation)
		{
			Main.musicPlayer.playSound(Main.musicPlayer.player_Teleport);
			var newTeleport:Point = currentLevel.spawnPoints[Std.random(currentLevel.spawnPoints.length)];
			if (Std.random(5) == 0)
			{
				Players[playerID == 0 ? 1 : 0].x = newTeleport.x;
				Players[playerID == 0 ? 1 : 0].y = newTeleport.y;
			}
			else
			{
				this.x = newTeleport.x;
				this.y = newTeleport.y;
			}
		}
		if (item.ID == Item.medkit)
		{
			if (Health < 10)
			{
				healPlayer(Variables.itemMedkitHealing);
			}
		}
		if (item.ID == Item.visionBuff)
		{
			Main.musicPlayer.playSound(Main.musicPlayer.player_Buff);
			PowerUpVision++;
		}
		if (item.ID == Item.visionDebuff)
		{
			Main.musicPlayer.playSound(Main.musicPlayer.player_Debuff);
			PowerUpVision--;
		}
		if (item.ID == Item.speedBuff)
		{
			Main.musicPlayer.playSound(Main.musicPlayer.player_Buff);
			PowerUpSpeed++;
		}
		if (item.ID == Item.speedDebuff)
		{
			Main.musicPlayer.playSound(Main.musicPlayer.player_Debuff);
			PowerUpSpeed--;
		}
		refreshInventoryDisplay();
	}
	
	/*
	 * refreshes the display of buffs
	 */
	private function refreshInventoryDisplay()
	{
		for (i in 0...InventoryText.length)
		{
			if (i == 0)
			{
				InventoryText[i].setText(getItemPos(0));
			}
			if (i == 1)
			{
				InventoryText[i].setText(PowerUpVision);
			}
			if (i == 2)
			{
				InventoryText[i].setText(PowerUpSpeed);
			}
			
		}
	}
	
	/*
	 * Called when the wiggle button is pressed. Pushes other player away and helps the player move when stuck
	 */
	function PushPlayerAway() : Player
	{
		var thisPlayer:Player = Players[playerID];
		var otherPlayer:Player = Players[playerID == 0 ? 1 : 0];
		
		var difference: Int  = 20;
		var range:Int = 50;
		var ranger:Float = 50;
		var pushSpeed:Int = 10;
		
		if (orientation == 1)
		{
			if (!currentLevel.canPlayerWalkHere(this.x, this.y) && currentLevel.canPlayerEscape(this, 0, -ranger)) //&& currentLevel.canPlayerWalkHere(this.x, this.y - ranger))
			{
				this.y -= 3;
			}
			
			if (otherPlayer.x >= thisPlayer.x - difference && otherPlayer.x <= thisPlayer.x + difference && otherPlayer.y <= thisPlayer.y && otherPlayer.y >= thisPlayer.y - range)
			{
				otherPlayer.y -= pushSpeed;
			}
		}
		else if (orientation == 0)
		{
			if (!currentLevel.canPlayerWalkHere(this.x, this.y) && currentLevel.canPlayerEscape(this, 0, ranger)) // && currentLevel.canPlayerWalkHere(this.x, this.y + ranger))
			{
				this.y += 3;
			}
			
			if (otherPlayer.x >= thisPlayer.x - difference && otherPlayer.x <= thisPlayer.x + difference && otherPlayer.y <= thisPlayer.y + range && otherPlayer.y >= thisPlayer.y)
			{
				otherPlayer.y += pushSpeed;
			}
		}
		else if (orientation == 3)
		{
			if (!currentLevel.canPlayerWalkHere(this.x, this.y) && currentLevel.canPlayerEscape(this, -ranger, 0)) // && currentLevel.canPlayerWalkHere(this.x - ranger, this.y))
			{
				this.x -= 3;
			}
			
			if (otherPlayer.x >= thisPlayer.x - range && otherPlayer.x <= thisPlayer.x && otherPlayer.y <= thisPlayer.y + difference && otherPlayer.y >= thisPlayer.y - difference)
			{
				otherPlayer.x -= pushSpeed;
			}
		}
		else if (orientation == 2)
		{
			if (!currentLevel.canPlayerWalkHere(this.x, this.y) && currentLevel.canPlayerEscape(this, ranger, 0)) // && currentLevel.canPlayerWalkHere(this.x + ranger, this.y))
			{
				this.x += 3;
			}
			
			if (otherPlayer.x >= thisPlayer.x && otherPlayer.x <= thisPlayer.x + range && otherPlayer.y <= thisPlayer.y + difference && otherPlayer.y >= thisPlayer.y - difference)
			{
				otherPlayer.x += pushSpeed;
			}
		}
		return null;
	}
	
	/*
	 * Set the array of players to use
	 */
	public function setPlayers(p:Array<Player>)
	{
		Players = p;
	}
}