package meta.subState;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.Boyfriend;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.Conductor.BPMChangeEvent;
import meta.data.Conductor;
import meta.state.*;
import meta.state.menus.*;

class GameOverSubstate extends MusicBeatSubState
{
	var white:FlxSprite;
	var text:FlxText;

	var flashingTime:Float = 0;
	public function new()
	{
		super();

		white = new FlxSprite();
		white.makeGraphic(663, 250);
		white.screenCenter();
		add(white);

		text = new FlxText(0, 0, 0, "FOOTAGE IS CORRUPTED\nPLEASE GO BACK", 54);
		text.alignment = CENTER;
		text.font = Paths.font("vcr.ttf");
		text.color = FlxColor.BLACK;
		text.screenCenter();
		add(text);

		#if android
		addVirtualPad(NONE, B);
		#end

		camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		flashingTime -= elapsed;
		if (flashingTime <= 0)
		{
			white.visible = !white.visible;
			text.visible = !text.visible;

			flashingTime = 1;
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deaths = 0;

			Main.switchState(this, new StoryMenuState());
		}
	}

	override function beatHit()
	{
		super.beatHit();
	}
}
