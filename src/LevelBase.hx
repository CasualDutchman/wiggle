package;

import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.media.SoundChannel;
import openfl.media.Sound;

enum StateOfGame
{
	MENU;
	RUNNING;
	DEAD;
	PAUSED;
}

class LevelBase extends Sprite
{
	public var state:StateOfGame = StateOfGame.MENU;
	
	var p1Ready:Bool;
	var p2Ready:Bool;
	
	var pressPause:Bool;
	
	public var level:Sprite;
	
	public var ID:Int;
	
	public var deadScreen = new DeadScreen();
	
	public var map:Array<Array<Int>> = new Array<Array<Int>>(); //contains all the IDs of the tiles
	public var textmap:Array<TextField> = []; 
	public var walkMap:Array<Array<Int>> = new Array<Array<Int>>(); // contains 0 and 1s. 1 is walkable, 0 is not
	
	public var tigerWalkMap:Array<Array<Int>> = new Array<Array<Int>>(); // contains 0 and 1s. 1 is walkable, 0 is not for the tiger 
	public var tigerNodeMap:Array<Array<TigerNode>> = new Array<Array<TigerNode>>(); 
	
	public var spawnPoints:Array<Point> = []; //contains spawnpoints for items
	public var bearTraps:Array<BearTrap> = []; //contains all beartraps in the game
	public var walls:Array<Wall> = []; //contains all walls in the game
	public var tigers:Array<Tiger> = []; //contains all tigers in the game
	
	private var keys:Array<Bool> = [];
	
	var spawnLoc:Array<Int> = [];  //contains spawnlocations for the player
	public var chests:Array<Chest> = []; //contains all chests in the game
	var itemLoc:Array<Int> = [];  //contains all spawnlocations for chests
	var exitLoc:Array<Int> = [];  //contains all exit locations for the player
	
	public var players:Array<Player> = [];
	public var hearts:Array<Hearts> = [];
	
	var player:Player;
	var player2:Player;
	public var blind:Blind;
	
	var explain:ExplainScreen = new ExplainScreen();
	
	public var PlayerDead:Int = 0;
	
	var scale:Float = 1.28;
	
	public var gameChannel:SoundChannel;
	public var loopable:Sound;
	
	var widthSprite = 25;
	var heightSprite = 25;
	
	public function new(i:Int) 
	{
		super();
		
		ID = i;
		
		createMap();
		createWalkMap();
		createTigerWalkMap();
		createSpawnPoints();
		displayMap();
		addChests();
		addPlayer();
		addExit();
		
		blind = new Blind();
		addChild(blind);
		if (!Main.DebugBlind)
		{
			level.mask = blind;
		}
		
		addHearts();
		
		if (Main.Showcase)
		{
			addBearTrap();
			addBearTrap();
			addBearTrap();
			
			addWall();
			addWall();
			addWall();
			
			addTiger();
		}
		
		addChild(explain);
		
		gameChannel = new SoundChannel();
		loopable = Main.musicPlayer.loop_game;
		
		if (Main.musicPlayer.hasMusic)
		{
			gameChannel = loopable.play(0);
		}
		
		//this.addEventListener(Event.ENTER_FRAME, onUpdate);
	}
	
	/*
	 * Resume game when paused
	 */
	public function resumeGame()
	{
		if (Main.musicPlayer.hasMusic)
		{
			gameChannel = loopable.play();
		}
		deadScreen.paused = false;
		removeChild(deadScreen);
		
		state = StateOfGame.RUNNING;
	}
	
	/*
	 * if the game is paused return true
	 */
	public function isPaused():Bool
	{
		return state == StateOfGame.PAUSED;
	}
	
	/*
	 * Create the map, used in the children classe
	 */
	public function createMap(){}
	
	/*
	 * Displays the map created in the createMap() function
	 */
	public function displayMap()
	{
		level = new Sprite();
		addChild(level);
		
		var data:BitmapData = Assets.getBitmapData("img/TILES_new3.png");
		var missing:BitmapData = Assets.getBitmapData("img/missing.png");
		var bitmap:Bitmap;
		
		var spriteX = Math.floor(data.width / widthSprite);
		var spriteY = Math.floor(data.height / heightSprite);
		
		
		for (y in 0...map.length)
		{
			for (x in 0...map[y].length)
			{
				if (getMapTileID(x, y) == 100)
				{
					spawnLoc.push(Math.floor(x * (widthSprite * scale)));
					spawnLoc.push(Math.floor(y * (heightSprite * scale)));
					map[y][x] = 79;
				}
				
				if (getMapTileID(x, y) >= 102)
				{
					itemLoc.push(Math.floor(x * (widthSprite * scale)));
					itemLoc.push(Math.floor(y * (heightSprite * scale)));
					map[y][x] = 79;
				}
				
				if (getMapTileID(x, y) == 101)
				{
					exitLoc.push(Math.floor(x * (widthSprite * scale)));
					exitLoc.push(Math.floor(y * (heightSprite * scale)));
					map[y][x] = 14;
				}
				
				if (map[y][x] < (spriteX * spriteY))
				{
					bitmap = new Bitmap(data);
					bitmap.scrollRect = new Rectangle((getMapTileID(x, y) % spriteX) * widthSprite, Math.floor(getMapTileID(x, y)  / spriteX) * heightSprite, widthSprite, heightSprite);
				}
				else
				{
					bitmap = new Bitmap(missing);
				}
				
				bitmap.x = x * (widthSprite * scale);
				bitmap.y = y * (heightSprite * scale);
				bitmap.scaleX = bitmap.scaleY = scale;
				level.addChild(bitmap);
			}
		}
		
		//displays all the areas the player can walk on
		if (Main.DebugWalkable)
		{
			var otherScale = scale / 2;
		
			for (y in 0...walkMap.length)
			{
				for (x in 0...walkMap[y].length)
				{
					if (walkMap[y][x] == 1)
					{
						bitmap = new Bitmap(missing);
						
						bitmap.x = x * (widthSprite * otherScale);
						bitmap.y = y * (heightSprite * otherScale);
						bitmap.scaleX = bitmap.scaleY = otherScale + 0.5;
						addChild(bitmap);
					}
				}
			}
		}
		
		//displays all the points where a wall, beartrap, tiger can spawn and where the player can be teleported to
		if (Main.DebugSpawnpoint)
		{
			var otherScale:Float = 1 / 16;
			var ranger:Float = 32;
			
			for (i in 0...spawnPoints.length)
			{
				bitmap = new Bitmap(missing);
				
				//bitmap.x = x * (widthSprite * otherScale);
				//bitmap.y = y * (heightSprite * otherScale);
				bitmap.x = spawnPoints[i].x - (ranger / 2);
				bitmap.y = spawnPoints[i].y - (ranger / 2);
				bitmap.scaleX = bitmap.scaleY = otherScale * ranger;
				addChild(bitmap);
			}
		}
		
		//displays all walkable areas for the tiger
		if (Main.DebugTigerWalkable)
		{
			for (y in 0...tigerWalkMap.length)
			{
				for (x in 0...tigerWalkMap[y].length)
				{
					if (tigerWalkMap[y][x] == 1)
					{
						bitmap = new Bitmap(missing);
						
						bitmap.x = x * (widthSprite * scale);
						bitmap.y = y * (heightSprite * scale);
						bitmap.scaleX = bitmap.scaleY = 0.5;
						addChild(bitmap);
					}
				}
			}
		}
	}
	
	/*
	 * Get the id from the map
	 */
	public function getMapTileID(x:Int, y:Int):Float
	{
		return map[y][x];		
	}
	
	/*
	 * Adds gates on the exits //TODO
	 */
	private function addExit()
	{
		var data:BitmapData = Assets.getBitmapData("img/gate_animation_right_left.png");
		var bitmapGate:Bitmap = new Bitmap(data);
		bitmapGate.scrollRect = new Rectangle(0, 0, 53, 70);
		bitmapGate.x = exitLoc[0] - 5;
		bitmapGate.y = exitLoc[1] - 20;
		bitmapGate.scaleX = bitmapGate.scaleY = 1.3;
		level.addChild(bitmapGate);
		
		var dat2:BitmapData = Assets.getBitmapData("img/gate_animation_right_left.png");
		var bitmapGate2:Bitmap = new Bitmap(dat2);
		bitmapGate2.scrollRect = new Rectangle(53, 70, 53, 70);
		bitmapGate2.x = exitLoc[4] + 5;
		bitmapGate2.y = exitLoc[5] - 20;
		bitmapGate2.scaleX = bitmapGate2.scaleY = 1.3;
		level.addChild(bitmapGate2);
	}
	
	/*
	 * Adds the chests to the map
	 */
	private function addChests()
	{
		var i:Int = Std.int(itemLoc.length / 2);
		
		for (k in 0...i)
		{
			var id:Int = k * 2;
			
			if (Std.random(Variables.levelChestMaxRandom) < Variables.levelChestChance)
			{
				var chest:Chest = new Chest(itemLoc[id] + ((widthSprite * scale) / 2), itemLoc[id+1] + ((widthSprite * scale) / 2));
				chest.ID = Std.random(4);
				chests.push(chest);
				chest.x = itemLoc[id] + ((widthSprite * scale) / 2);
				chest.y = itemLoc[id+1] + ((widthSprite * scale) / 2);
				level.addChild(chest);
			}
		}
	}
	
	/*
	 * Adds the player to the map
	 */
	private function addPlayer()
	{
		players[0] = new Player(0, this);
		player = players[0];
		player.x = spawnLoc[0] + ((widthSprite * scale) / 2);
		player.y = spawnLoc[1] + (heightSprite * scale) - 8;
		addChild(player);
		
		players[1] = new Player(1, this);
		player2 = players[1];
		player2.x = spawnLoc[2] + ((widthSprite * scale) / 2);
		player2.y = spawnLoc[3] + (heightSprite * scale) - 8;
		addChild(player2);
		
		player.setPlayers(players);
		player2.setPlayers(players);
		
		for (c in chests)
		{
			c.players = players;
		}
	}
	
	/*
	 * Adds the hearts that display the players' health
	 */
	function addHearts()
	{
		hearts[0] = new Hearts(0);
		hearts[0].x = 20;
		hearts[0].y = 20;
		addChild(hearts[0]);
		
		hearts[1] = new Hearts(1);
		hearts[1].x = 1240;
		hearts[1].y = 20;
		addChild(hearts[1]);
	}
	
	/*
	 * Called every frame. Handles the players position, unblind spots and the pause/resume funtions
	 */
	public function Update(event:Event)
	{
		if (Main.musicPlayer.hasMusic)
		{
			if (gameChannel.position >= loopable.length) {
				gameChannel.stop();
				gameChannel = loopable.play(0);
			}
		}
		
		if (state == StateOfGame.RUNNING)
		{
			player.update(keys);
			player2.update(keys);
			
			blind.update(player, player2);
			
			if (player.Dead)
			{
				Main.musicPlayer.playSound(Main.musicPlayer.player_Respawn);
				player.x = spawnLoc[0] + ((widthSprite * scale) / 2);
				player.y = spawnLoc[1] + (heightSprite * scale) - 8;
				player.Health = 10;
				hearts[0].updatehearts(player.Health);
				player.removeKey();
				player.Dead = false;
			}
			if (player2.Dead)
			{
				Main.musicPlayer.playSound(Main.musicPlayer.player_Respawn);
				player2.x = spawnLoc[2] + ((widthSprite * scale) / 2);
				player2.y = spawnLoc[3] + (heightSprite * scale) - 8;
				player2.Health = 10;
				hearts[1].updatehearts(player2.Health);
				player2.removeKey();
				player2.Dead = false;
			}
			if (player.Win)
			{
				PlayerDead = 3;
				state = StateOfGame.DEAD;
			}
			if (player2.Win)
			{
				PlayerDead = 4;
				state = StateOfGame.DEAD;
			}
			
			if (PlayerDead != 0)
			{
				gameChannel.stop();
				
				for (t in tigers)
				{
					removeTiger(t);
				}
				
				deadScreen.x = (stage.stageWidth - deadScreen.getWidth()) / 2;
				deadScreen.y = (stage.stageHeight - deadScreen.getHeigth()) / 2;
				deadScreen.setText(PlayerDead <= 2 ? "Player " + Math.floor(PlayerDead / 2) + " died!" : "Player " + Math.floor(PlayerDead / 2) + " won!");
				
				deadScreen.won = PlayerDead > 2;
				
				deadScreen.button1.setText("Restart");
				
				if (deadScreen.won)
				{
					//deadScreen.button1.setText("Next");
				}
				
				addChild(deadScreen);
			}
			
			if (keys[81] && !pressPause)
			{
				gameChannel.stop();
				deadScreen.x = (stage.stageWidth - deadScreen.getWidth()) / 2;
				deadScreen.y = (stage.stageHeight - deadScreen.getHeigth()) / 2;
				deadScreen.setText("Paused");
				deadScreen.button1.setText("Resume");
				deadScreen.paused = true;
				addChild(deadScreen);
				pressPause = true;
				state = StateOfGame.PAUSED;
			}
		}
		else if(state == StateOfGame.MENU)
		{
			if ((keys[player.keyMapping[0][4]]) && !p1Ready)
			{
				explain.P1Ready.text = "Player 1 is ready!";
				p1Ready = true;
			}
			
			if (keys[player.keyMapping[1][4]] && !p2Ready)
			{
				explain.P2Ready.text = "Player 2 is ready!";
				p2Ready = true;
			}
			
			if (p1Ready && p2Ready)
			{
				removeChild(explain);
				state = StateOfGame.RUNNING;
			}
		}
		else if (state == StateOfGame.PAUSED)
		{
			if (keys[81] && !pressPause)
			{
				if (Main.musicPlayer.hasMusic)
				{
					gameChannel = loopable.play();
				}
				
				removeChild(deadScreen);
				deadScreen.paused = false;
				pressPause = true;
				state = StateOfGame.RUNNING;
			}
		}
		
		if (!keys[81])
		{
			pressPause = false;
		}
	}
	
	/*
	 * returns a point converted from worldspace to the tile map
	 */
	public function getPoint(x:Float, y:Float):Point
	{
		return new Point(x / (widthSprite * (scale / 2)), y / (widthSprite * (scale / 2)));
	}
	
	/*
	 * returns true if the tile is a hole tile
	 */
	public function isHole(x:Float, y:Float):Bool
	{
		var id:Int = map[Math.floor(y / (widthSprite * scale))][Math.floor(x / (widthSprite * scale))];
		if (id == 71 || id == 72 || id == 74 || id == 77)
		{
			return true;
		}
		return false;
	}
	
	/*
	 * returns true if the tile is a walkable tile
	 */
	public function canPlayerWalkHere(x:Float, y:Float):Bool
	{		
		return walkMap[Math.floor(y / (widthSprite * (scale / 2)))][Math.floor(x / (widthSprite * (scale / 2)))] == 1;
	}
	
	/*
	 * returns true if there is path in from of the player
	*/
	public function canPlayerEscape(player:Player, x:Float, y:Float):Bool
	{
		if (player.y == (player.y + y))
		{
			for (xDif in 0...Positive(x) + 2)
			{
				if (canPlayerWalkHere(player.x + (x + xDif), player.y))
				{
					return true;
				}
			}
		}
		else if (player.x == (player.x + x))
		{
			for (yDif in 0...Positive(y) + 2)
			{
				if (canPlayerWalkHere(player.x, player.y + (y + yDif)))
				{
					return true;
				}
			}
		}
		return false;
	}
	
	/*
	 * returns a positive number (e.g. -10 = 10, 5 = 5)
	 */
	function Positive(f:Float):Int
	{
		if (f < 0)
		{
			f = f * (-1);
		}
		return Math.floor(f);
	}
	
	/*
	 * returns true is the tile is a exit
	 */
	public function isExit(x:Float, y:Float):Bool
	{
		for (i in 0...Std.int(exitLoc.length / 2))
		{
			if (x > exitLoc[i] && x < exitLoc[i] + (widthSprite * scale) && y > exitLoc[i+1] && y < exitLoc[i+1] + (widthSprite * scale))
			{
				return true;
			}
		}
		
		return false;
	}
	
	/*
	 * returns the chest if the player is standing on a chest
	 */
	public function isChest(x:Float, y:Float):Chest
	{
		for (chest in chests)
		{
			if (x > chest.LocX - Variables.chestPickupRange && x < chest.LocX + Variables.chestPickupRange && y > chest.LocY - Variables.chestPickupRange && y < chest.LocY + Variables.chestPickupRange + 10)
			{
				return chest;
			}
		}
		return null;
	}
	
	/*
	 * Add a tiger to a random position on the map
	 */
	public function addTiger()
	{
		var ran:Point = spawnPoints[Std.random(spawnPoints.length)];
		var tiger:Tiger = new Tiger(tigerWalkMap, ran.x / 32, ran.y / 32, tigerNodeMap);
		tiger.x = ran.x;
		tiger.y = ran.y;
		level.addChild(tiger);
		tigers.push(tiger);
	}
	
	/*
	 * Add a beartrap to a random position on the map
	 */
	public function addBearTrap()
	{
		var random:Int = Std.random(spawnPoints.length);
		var trap:BearTrap = new BearTrap(bearTraps.length + 1);
		trap.x = spawnPoints[random].x;
		trap.y = spawnPoints[random].y;
		level.addChild(trap);
		bearTraps.push(trap);
	}
	
	/*
	 * Add a wall to a random pisition on the map
	 */
	public function addWall()
	{
		var random:Int = Std.random(spawnPoints.length);
		var wall:Wall = new Wall();
		wall.x = spawnPoints[random].x;
		wall.y = spawnPoints[random].y;
		level.addChild(wall);
		walls.push(wall);
	}
	
	/*
	 * returns the tiger is the positions has a tiger in it
	 */
	public function isTiger(x:Float, y:Float):Tiger
	{
		for (tiger in tigers)
		{
			if (x > (tiger.LocX * 32) - Variables.tigerRange && x < (tiger.LocX * 32) + Variables.tigerRange && y > (tiger.LocY * 32) - Variables.tigerRange && y < (tiger.LocY * 32) + Variables.tigerRange)
			{
				return tiger;
			}
		}
		return null;
	}
	
	/*
	 * returns the beartrap is the positions has a beartrap in it
	 */
	public function isBearTrap(player:Player):BearTrap
	{
		for (trap in bearTraps)
		{
			if (player.x > trap.x - 18 && player.x < trap.x + 18 && player.y > trap.y - 18 && player.y < trap.y + 18)
			{
				return trap;
			}
		}
		return null;
	}
	
	/*
	 * returns the wall is the positions has a wall in it
	 */
	public function isWall(x:Float, y:Float):Wall
	{
		for (wall in walls)
		{
			if (x > wall.x - 18 && x < wall.x + 18 && y > wall.y - 18 && y < wall.y + 18)
			{
				return wall;
			}
		}
		return null;
	}
	
	/*
	 * removes the tiger given
	 */
	public function removeTiger(tiger:Tiger)
	{
		tigers.remove(tiger);
		level.removeChild(tiger);
	}
	
	/*
	 * removes the beartrap given
	 */
	public function removeBearTrap(trap:BearTrap)
	{
		bearTraps.remove(trap);
		level.removeChild(trap);
	}
	
	/*
	 * removes the wall given
	 */
	public function removeWall(wall:Wall)
	{
		walls.remove(wall);
		level.removeChild(wall);
	}
	
	/*
	 * removes the item given
	 */
	public function removeItem(item:Item)
	{
		removeChild(item);
	}
	
	/*
	 * Creates a walkmap, a tile map where the player can walk
	 */
	public function createWalkMap()
	{
		for (y in 0...map.length)
		{
			for (x in 0...map[y].length)
			{
				if (walkMap[y * 2] == null)
				{
					walkMap.push([]);
					walkMap.push([]);
				}
				
				walkMap[y * 2].push(getWalkable(Std.int(getMapTileID(x, y)), 0));  
				walkMap[y * 2].push(getWalkable(Std.int(getMapTileID(x, y)), 1));
				walkMap[(y * 2) + 1].push(getWalkable(Std.int(getMapTileID(x, y)), 2)); 
				walkMap[(y * 2) + 1].push(getWalkable(Std.int(getMapTileID(x, y)), 3));
			}
		}
	}
	
	/*
	 * Creates a walkmap, a tile map where the tiger can walk
	 */
	function createTigerWalkMap()
	{
		for (y in 0...map.length)
		{
			for (x in 0...map[0].length)
			{
				if (tigerWalkMap[y] == null)
				{
					tigerWalkMap.push([]);
				}
				
				if (tigerNodeMap[y] == null)
				{
					tigerNodeMap.push([]);
				}
				
				if (isSpawnPointable(Std.int(getMapTileID(x, y)), true))
				{
					tigerWalkMap[y][x] = 1;
					
					tigerNodeMap[y][x] = new TigerNode( isSpawnPointable(Std.int(getMapTileID(x, y - 1)), true) ? 1 : 0,
														isSpawnPointable(Std.int(getMapTileID(x + 1, y)), true) ? 1 : 0,
														isSpawnPointable(Std.int(getMapTileID(x, y + 1)), true) ? 1 : 0,
														isSpawnPointable(Std.int(getMapTileID(x - 1, y)), true) ? 1 : 0
														);
				}
				else
				{
					tigerWalkMap[y][x] = 0;
				}
			}
		}
	}
	
	/*
	 * Creates a map of points items can spawn
	 */
	function createSpawnPoints()
	{
		for (y in 0...map.length)
		{
			for (x in 0...map[0].length)
			{
				if (isSpawnPointable(Std.int(getMapTileID(x, y))))
				{
					spawnPoints.push(new Point((x * (widthSprite * scale)) + 16, (y * (widthSprite * scale)) + 16));
				}
			}
		}
	}
	
	/*
	 * registers all keypresses down
	 */
	public function keyDown(event:KeyboardEvent)
	{
		keys[event.keyCode] = true;
	}
	
	/*
	 * registers all keypresses up
	 */
	public function keyUp(event:KeyboardEvent)
	{
		keys[event.keyCode] = false;
	}
	
	/*
	 * returns true if the id is a point where items can spawn
	 */
	function isSpawnPointable(id:Int, tiger:Bool=false):Bool
	{	
		if (id == 0 || id == 1 || id == 7 || id == 8 || id == 14 || id == 15 || id == 21 || id == 22 || id == 30 || id == 31 || id == 37 || id == 38 || id == 65 || id == 66 || id == 42 || id == 43 || id == 49 || id == 50 || id == 26 || id == 27 || id == 46 || (tiger && id == 102) || (tiger && id == 100))
		{
			return true;
		}
		return false;
	}
	
	/*
	 * returns true if the id is a point where player can walk
	 */
	function getWalkable(id:Int, part:Int):Int
	{
		if (id == 100 || id == 101 || id == 102)
		{
			id = 0;
		}
		
		if (id == 0 || id == 1 || id == 7 || id == 8 || id == 14 || id == 15 || id == 21 || id == 22 || id == 65 || id == 66 || id == 30 || id == 31 || id == 37 || id == 38 || id == 24 || id == 25 || id == 26 || id == 27 || id == 40 || id == 41 || id == 46 || id == 47 || id == 48 || id == 53 || id == 54 || id == 55 || id == 66)
		{
			switch(part)
			{
				case 0: return 1;
				case 1: return 1;
				case 2: return 1;
				case 3: return 1;
				default: return 0;
			}
		}
		else if (id == 2 || id == 3 || id == 4 || id == 5 || id == 6 || id == 9 || id == 10 || id == 11 || id == 12 || id == 13 || id == 16 || id == 17 || id == 18 || id == 19 || id == 20 || id == 23 || id == 32 || id == 33 || id == 34 || id == 39 || id == 44 || id == 45 || id == 51 || id == 52 || id == 56 || id == 57 || id == 58 || id == 59 || id == 60 || id == 61 || id == 62 || id == 63 || id == 64)
		{
			switch(part)
			{
				case 0: return 0;
				case 1: return 0;
				case 2: return 0;
				case 3: return 0;
				default: return 0;
			}
		}
		else if (id == 65)
		{
			switch(part)
			{
				case 0: return 1;
				case 1: return 1;
				case 2: return 1;
				case 3: return 1;
				default: return 0;
			}
		}
		else if (id == 28 || id == 42)
		{
			switch(part)
			{
				case 0: return 1;
				case 1: return 1;
				case 2: return 1;
				case 3: return 0;
				default: return 0;
			}
		}
		else if (id == 29 || id == 43)
		{
			switch(part)
			{
				case 0: return 1;
				case 1: return 1;
				case 2: return 0;
				case 3: return 1;
				default: return 0;
			}
		}
		else if (id == 35 || id == 49)
		{
			switch(part)
			{
				case 0: return 1;
				case 1: return 0;
				case 2: return 1;
				case 3: return 1;
				default: return 0;
			}
		}
		else if (id == 36 || id == 50)
		{
			switch(part)
			{
				case 0: return 0;
				case 1: return 1;
				case 2: return 1;
				case 3: return 1;
				default: return 0;
			}
		}
		else{
			return 0;
		}
	}
}