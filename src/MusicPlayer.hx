package;

import openfl.Assets;
import openfl.media.Sound;
import openfl.media.SoundChannel;

/*
 * Bruce looked for code to play a sound and gave it
 */
class MusicPlayer 
{
	public var hasMusic:Bool = true;
	
	public var channel:SoundChannel = new SoundChannel();
	
	public var loop_menu:Sound;
	public var loop_game:Sound;
	
	public var menu_select:Sound;
	
	public var chest_Open:Sound;
	public var chest_Close:Sound;
	public var chest_Roll:Sound;
	public var chest_Roll_Finish:Sound;
	
	public var beartrap_Close:Sound;
	
	public var card_pickup:Sound;
	
	public var bomb:Sound;
	
	public var sound_Swoosh:Sound;
	public var sound_Swoosh2:Sound;
	public var sound_walk:Sound;
	
	public var player_Respawn:Sound;
	public var player_Buff:Sound;
	public var player_Debuff:Sound;
	public var player_Teleport:Sound;
	public var player_Heal:Sound;
	public var player_Hit:Sound;
	
	public function new() 
	{
		loop_menu = Assets.getSound("audio/Background_main.wav");
		loop_game = Assets.getSound("audio/background.wav");
		
		menu_select = Assets.getSound("audio/menu_select.wav");
		
		chest_Open = Assets.getSound("audio/Chest open16.wav");
		chest_Close = Assets.getSound("audio/Chest close.wav");
		chest_Roll = Assets.getSound("audio/Chest roll.wav");
		chest_Roll_Finish = Assets.getSound("audio/Chest rol finishl.wav");
		
		beartrap_Close = Assets.getSound("audio/Beartrap close.wav");
		
		card_pickup = Assets.getSound("audio/Keycard pickup.wav");
		
		bomb = Assets.getSound("audio/Bombboom.wav");
		
		sound_Swoosh = Assets.getSound("audio/Single_Swoosh.wav");
		sound_Swoosh2 = Assets.getSound("audio/Single_Swoosh2.wav");
		sound_walk = Assets.getSound("audio/Single_Walksand.wav");
		
		player_Respawn = Assets.getSound("audio/Respawn.wav");
		player_Buff = Assets.getSound("audio/Speed up buff.wav");
		player_Debuff = Assets.getSound("audio/Speed debuff.wav");
		player_Teleport = Assets.getSound("audio/Teleport.wav");
		player_Heal = Assets.getSound("audio/Medpack.wav");
		player_Hit = Assets.getSound("audio/Playerhit.wav");
		
	}
	
	public function playSound(s:Sound, i:Int=0)
	{
		if (hasMusic)
		{
			channel = s.play(i);
		}
	}
	
	public function playSounds(a:Sound, b:Sound)
	{
		if (hasMusic)
		{
			if (Std.random(2) == 0)
			{
				channel = a.play(0);
			}
			else
			{
				channel = b.play(0);
			}
		}
	}
}