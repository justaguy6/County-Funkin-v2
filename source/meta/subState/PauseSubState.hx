package meta.subState;

import gameObjects.userInterface.vhsinfo.VHSInfo;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.font.Alphabet;
import meta.state.*;
import meta.state.menus.*;
import sys.thread.Mutex;
import sys.thread.Thread;

class PauseSubState extends MusicBeatSubState
{
	var vhsinfo:VHSInfo;
	var pauseMusic:FlxSound;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound();
		pauseMusic.loadEmbedded(Paths.music("county-music/menuCf"), true);
		pauseMusic.play();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.4;
		bg.scrollFactor.set();
		add(bg);

	//	vhsinfo = new VHSInfo(true);
	//	add(vhsinfo);

		camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];

		#if android
		addVirtualPad(LEFT_RIGHT, A);
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_LEFT_P)
			vhsinfo.changePauseOption(-1);
		if (controls.UI_RIGHT_P)
			vhsinfo.changePauseOption(1);
		if (controls.ACCEPT)
		{
			pauseMusic.stop();
			switch (vhsinfo.returnSelectedOption())
			{
				case "RESUME":
					close();
				case "RESTART":
					Main.switchState(this, new PlayState());
				case "QUIT":
					Main.switchState(this, new StoryMenuState());
			}
		}
	}
}
