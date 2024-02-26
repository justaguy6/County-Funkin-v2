package meta.state.menus;

import shaders.ShaderObject;
import meta.data.Song;
import gameObjects.userInterface.vhsinfo.VHSInfo;
import meta.MusicBeat.MusicBeatState;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import openfl.filters.ShaderFilter;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var noises:FlxSprite;

	var selection:Int = 0;
	var songList:Array<String> = [
		"Deceived",
		"Expedited",
		"Followed",
		"Traumatized",
		"Lured",
		"Befriended",
		"Pursued",
		"Awakened",
		"Remembered"
	];

	var camMAIN:FlxCamera;
	var camINFO:FlxCamera;

	var whiteNoise:FlxSound;

	var songBanner:FlxSprite;
	var logNum:FlxText;
	var songName:FlxText;

	override function create()
	{
		super.create();
		camMAIN = new FlxCamera();
		camMAIN.bgColor.alpha = 0;

		camINFO = new FlxCamera();
		camINFO.bgColor.alpha = 0;
		FlxG.cameras.reset(camMAIN);
		FlxG.cameras.add(camINFO);

		whiteNoise = new FlxSound();
		whiteNoise.loadEmbedded(Paths.sound("county-sounds/whiteNoiseThing"));

		FlxCamera.defaultCameras = [camMAIN];

		camMAIN.filters = [ShaderObject.getShader("vhs")];

		songBanner = new FlxSprite();
		add(songBanner);

		logNum = new FlxText(0, 280, 0, "", 45);
		add(logNum);

		songName = new FlxText(0, 400, 0, "", 60);
		add(songName);

		var blueoverlay = new FlxSprite();
		blueoverlay.makeGraphic(3000, 3000, 0xff0400F3);
		blueoverlay.screenCenter();
		add(blueoverlay);
		blueoverlay.alpha = 0.06;

		var vignette = new FlxSprite();
		vignette.loadGraphic(Paths.image("county-sprites/story-menu/vignette"));
		vignette.scale.set(1 / (vignette.width / FlxG.width), 1 / (vignette.height / FlxG.height));
		vignette.updateHitbox();
		vignette.scrollFactor.set();
		vignette.screenCenter();
		add(vignette);

		var arrowLeft = new FlxText(10, 0, 0, "<", 35);
		arrowLeft.scrollFactor.set();
		arrowLeft.screenCenter(Y);
		arrowLeft.camera = camINFO;
		arrowLeft.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		add(arrowLeft);

		var arrowRight = new FlxText(0, 0, 0, ">", 35);
		arrowRight.scrollFactor.set();
		arrowRight.screenCenter(Y);
		arrowRight.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		arrowRight.x = FlxG.width - arrowRight.width - 10;
		arrowRight.camera = camINFO;
		add(arrowRight);

		noises = new FlxSprite();
		noises.frames = Paths.getSparrowAtlas("county-sprites/story-menu/static");
		noises.animation.addByPrefix("static", "static");
		noises.animation.play("static");
		noises.alpha = 0;
		noises.camera = camINFO;
		add(noises);

		var vhsinfo = new VHSInfo();
		vhsinfo.camera = camINFO;
		add(vhsinfo);

		switchSong(0);

		#if android
		addVirtualPad(LEFT_RIGHT, A_B);
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.LEFT_P)
			switchSong(-1);
		if (controls.RIGHT_P)
			switchSong(1);
		if (controls.BACK)
			Main.switchState(this, new MainMenuState());
		if (controls.ACCEPT)
			Main.switchState(this, new CachingState(songList[selection]));
	}

	function switchSong(value:Int)
	{
		whiteNoise.stop();
		whiteNoise.play();
		whiteNoise.volume = 0.05;
		whiteNoise.fadeOut();

		selection += value;
		if (selection > songList.length - 1)
			selection = 0;
		if (selection < 0)
			selection = songList.length - 1;
		noises.alpha = 1;
		FlxTween.cancelTweensOf(noises);
		FlxTween.tween(noises, {alpha: 0}, 0.8);
	
		songBanner.loadGraphic("assets/images/county-sprites/story-menu/storyframes/" + songList[selection].toLowerCase() + ".png");
		songBanner.scale.set(1 / (songBanner.width / FlxG.width), 1 / (songBanner.height / FlxG.height));
		songBanner.updateHitbox();
		songBanner.screenCenter();
		songBanner.alpha = 0.7;

		logNum.text = "LOG #" + (selection + 1);
		logNum.font = Paths.font("vcr.ttf");
		logNum.camera = camINFO;
		logNum.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
		logNum.screenCenter(X);

		songName.text = '"' + songList[selection].toUpperCase() + '"';
		songName.font = Paths.font("vcr.ttf");
		songName.screenCenter(X);
		songName.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
		songName.camera = camINFO;
	}
}
