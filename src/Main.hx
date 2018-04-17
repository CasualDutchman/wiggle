package;

import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.events.Event;

import openfl.system.System;

import openfl.events.MouseEvent;

import openfl.events.GameInputEvent;
import openfl.ui.GameInputControl;
import openfl.ui.GameInputDevice;
import openfl.ui.GameInput;

import openfl.media.SoundChannel;
import openfl.media.Sound;

import openfl.display.StageDisplayState;

import openfl.display.FPS;

enum GameState
{
	MENU;
	RUNNING;
}

/*
 * Alizera 	Contribution: Chest
 * Diana 	Contribution: Item
 * Bruce 	Contribution: Musicplayer
 * Pieter 	Contribution: Everything else
 */

class Main extends Sprite 
{
	public static var DebugWalkable:Bool = false;
	public static var DebugBlind:Bool = false;
	public static var DebugSpawnpoint:Bool = false;
	public static var DebugTigerWalkable:Bool = false;
	
	public static var Controller:Bool = true;
	
	public static var Showcase:Bool = false;
	
	var currentLevelID:Int = 0;
	var currentLevel:LevelBase;
	
	var menu:Menu;
	var levelSelect:LevelSelect;
	var levelManager:LevelManager;
	public static var musicPlayer:MusicPlayer;
	
	public static var user:User;
	
	public var instance:Main;
	
	var state:GameState = GameState.MENU;
	
	public function new() 
	{
		super();
		
		instance = this;
		
		var fps:FPS = new FPS(0, 0, 0xffffff);
		//addChild(fps);
		
		stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		
		user = new User();
		musicPlayer = new MusicPlayer();
		
		menu = new Menu();
		menu.x = (stage.stageWidth - 800) / 2;
		
		levelSelect = new LevelSelect();
		levelManager = new LevelManager();
		
		addMenu();
	}
	
	/*
	 * Called when clicked on the 'Start game' button
	 */
	public function startGame(event:MouseEvent)
	{
		menu.Music(false);
		
		removeMenu();
		displayLevel(currentLevelID);
		state = GameState.RUNNING;
	}
	
	/*
	 * Called when clicked on the 'Restart' or 'Resume' button in the game
	 */
	public function restartGame(event:MouseEvent)
	{
		/*
		if (currentLevel.deadScreen.won)
		{
			removeLevel(currentLevelID);
			user.LevelScore[currentLevelID] = 1;
			currentLevelID++;
			displayLevel(currentLevelID);
		}
		else
		{
		*/
		if (!currentLevel.isPaused())
		{
			removeLevel(currentLevelID);
			displayLevel(currentLevelID);
		}
		else
		{
			currentLevel.resumeGame();
		}
			
		musicPlayer.playSound(musicPlayer.menu_select);
	}
	
	/*
	 * Called when clicked on the 'Main menu' button in game
	 */
	public function gotoMain(event:MouseEvent)
	{
		if (currentLevel.deadScreen.won)
		{
			user.LevelScore[currentLevelID] = 1;
			currentLevelID++;
		}
		removeLevel(currentLevelID);
		addMenu();
		state = GameState.MENU;
		menu.Music(true);
		
		musicPlayer.playSound(musicPlayer.menu_select);
	}

	public function options(event:MouseEvent)
	{
		musicPlayer.playSound(musicPlayer.menu_select);
	}
	
	/*
	 * Called when clicked on the 'Quit' button
	 */
	public function quit(event:MouseEvent)
	{
		user.save();
		System.exit(0);	
	}
	
	/*
	 * Called when clicked on the 'Select level' button
	 */
	public function gotoSelectLevel(event:Event)
	{
		musicPlayer.playSound(musicPlayer.menu_select);
		
		removeMenu();
		addLevelSelect();
	}
	
	/*
	 * Add the menu to the screen
	 */
	public function addMenu()
	{		
		if (user.LevelScore[0] != 0)
		{
			menu.button1.setText("Continue");
		}
		
		menu.button1.addEventListener(MouseEvent.CLICK, startGame);
		menu.button2.addEventListener(MouseEvent.CLICK, options);
		menu.button3.addEventListener(MouseEvent.CLICK, quit);
		menu.button4.addEventListener(MouseEvent.CLICK, gotoSelectLevel);
		
		addChild(menu);
	}
	
	/*
	 * Remove the menu from the screen
	 */
	public function removeMenu()
	{
		menu.button1.removeEventListener(MouseEvent.CLICK, startGame);
		menu.button2.removeEventListener(MouseEvent.CLICK, options);
		menu.button3.removeEventListener(MouseEvent.CLICK, quit);
		menu.button4.removeEventListener(MouseEvent.CLICK, gotoSelectLevel);
		
		removeChild(menu);
	}
	
	/*
	 * Add the level selection screen
	 */
	public function addLevelSelect()
	{
		levelSelect.update();
		
		for (button in levelSelect.Buttons)
		{
			if (button.clickable)
			{
				button.addEventListener(MouseEvent.CLICK, toLevel);
			}
		}
		
		levelSelect.back.addEventListener(MouseEvent.CLICK, returnToMain);
		
		addChild(levelSelect);
	}
	
	/*
	 * Return to the main menu and remove the level selection
	 */
	function returnToMain(event:MouseEvent)
	{
		musicPlayer.playSound(musicPlayer.menu_select);
		addMenu();
		removeLevelSelect();
	}
	
	/*
	 * Go to a level from the level selection screen
	 */
	function toLevel(event:MouseEvent)
	{
		menu.Music(false);
		var button:ButtonLevelSelect = event.currentTarget; //event.target;
		currentLevelID = button.ID - 1;
		displayLevel(button.ID - 1);
		
		removeLevelSelect();
	}
	
	/*
	 * Remove the level selection screen
	 */
	public function removeLevelSelect()
	{
		removeChild(levelSelect);
	}
	
	/*
	 * This creates the level and add functions to the button
	 */
	public function displayLevel(lvl:Int)
	{
		currentLevel = levelManager.getlevel(lvl);
		
		addChild(currentLevel);

		currentLevel.deadScreen.button1.addEventListener(MouseEvent.CLICK, restartGame);
		currentLevel.deadScreen.button2.addEventListener(MouseEvent.CLICK, gotoMain);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, currentLevel.keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, currentLevel.keyUp);
		currentLevel.addEventListener(Event.ENTER_FRAME, currentLevel.Update);
	}
	
	/*
	 * This removes the level and removes the functions to the button
	 */
	public function removeLevel(lvl:Int)
	{
		currentLevel.deadScreen.button1.removeEventListener(MouseEvent.CLICK, restartGame);
		currentLevel.deadScreen.button2.removeEventListener(MouseEvent.CLICK, gotoMain);
		
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, currentLevel.keyDown);
		stage.removeEventListener(KeyboardEvent.KEY_UP, currentLevel.keyUp);
		currentLevel.removeEventListener(Event.ENTER_FRAME, currentLevel.Update);
		
		removeChild(currentLevel);
		
		currentLevel = null;
	}
}
