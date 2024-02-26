package meta.state.menus;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import sys.Http;
import flixel.math.FlxMath;
import flixel.FlxObject;
import shaders.ShaderObject;
import flixel.addons.transition.FlxTransitionableState;
import gameObjects.userInterface.vhsinfo.VHSInfo;
import meta.MusicBeat.MusicBeatState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import openfl.filters.ShaderFilter;
import flixel.FlxG;
import flixel.FlxSprite;

class MainMenuState extends MusicBeatState
{
	static var openedMenu:Bool = false;

	var optionGroup:Array<FlxText> = [];
	var selection:Int = 0;

	var camSELECTION:FlxCamera;

	var move:FlxObject = new FlxObject();

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		super.create();
	
		controls.setKeyboardScheme(None, false);
		
		var camMAIN = new FlxCamera();
		camMAIN.bgColor.alpha = 0;

		var camINFO = new FlxCamera();
		camINFO.bgColor.alpha = 0;

		camSELECTION = new FlxCamera();
		camSELECTION.bgColor.alpha = 0;

		var camWARNING = new FlxCamera();
		camWARNING.bgColor.alpha = 0;

		FlxG.cameras.reset(camMAIN);
		FlxG.cameras.add(camINFO);
		FlxG.cameras.add(camSELECTION);
		FlxG.cameras.add(camWARNING);

		FlxCamera.defaultCameras = [camMAIN];

		camSELECTION.height = 200;
		camSELECTION.y += 260;

		move.camera = camSELECTION;
		camSELECTION.follow(move);

		camMAIN.filters = [ShaderObject.getShader("vhs")];

		if (!openedMenu)
		{
			camMAIN.visible = false;
			camINFO.visible = false;
			camSELECTION.visible = false;

			var warning:FlxText = new FlxText(0, 0, 0, "FLASHING LIGHTS AND SENSITIVE CONTENT AHEAD!\n\nYOU HAVE BEEN WARNED.", 40);
			warning.alignment = CENTER;
			warning.font = Paths.font("vcr.ttf");
			warning.camera = camWARNING;
			warning.alpha = 0;
			warning.screenCenter();
			add(warning);

			new FlxTimer().start(2, function(e:FlxTimer)
			{
				FlxTween.tween(warning, {alpha: 1}, 1, {ease:FlxEase.sineInOut});
				FlxG.sound.play(Paths.sound("county-sounds/inserttape"), 0.1, false, null, true, function()
				{
					warning.visible = false;
					camMAIN.visible = true;
					camINFO.visible = true;
					camSELECTION.visible = true;
					openedMenu = true;
					FlxG.sound.playMusic(Paths.music("county-music/menuCf"));
				});
			});
		}

		var noises = new FlxSprite();
		noises.frames = Paths.getSparrowAtlas("county-sprites/main-menu/static");
		noises.animation.addByPrefix("static", "static");
		noises.animation.play("static");
		noises.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		noises.screenCenter();
		add(noises);

		var bg = new FlxSprite();
		bg.makeGraphic(3000, 3000, 0xff0400F3); // blue????
		bg.screenCenter();
		add(bg);
		bg.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		bg.alpha = 0.65;

		var selectionbar = new FlxSprite(0, 311);
		selectionbar.makeGraphic(350, 70);
		selectionbar.screenCenter(X);
		selectionbar.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		add(selectionbar);

		var arrowLeft = new FlxText(0, selectionbar.y, 0, "<", 65);
		arrowLeft.scrollFactor.set();
		arrowLeft.x = selectionbar.x + selectionbar.width;
		arrowLeft.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		add(arrowLeft);

		var arrowRight = new FlxText(0, selectionbar.y, 0, ">", 65);
		arrowRight.scrollFactor.set();
		arrowRight.x = selectionbar.x - arrowRight.width + 7.3;
		arrowRight.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		add(arrowRight);

		var vignette = new FlxSprite();
		vignette.loadGraphic(Paths.image("county-sprites/main-menu/vignette"));
		vignette.scale.set(1 / (vignette.width / FlxG.width), 1 / (vignette.height / FlxG.height));
		vignette.updateHitbox();
		vignette.scrollFactor.set();
		vignette.screenCenter();
		vignette.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
		add(vignette);

		//
		var moveVal:Float = 50;
		var moveArrow:Void->Void;
		moveArrow = function()
		{
			new FlxTimer().start(1, function(e:FlxTimer)
			{
				arrowRight.x -= moveVal;
				arrowLeft.x += moveVal;

				moveVal = -moveVal;
				moveArrow();
			});
		}
		moveArrow();
		//

		var vhsinfo = new VHSInfo();
		vhsinfo.camera = camINFO;
		add(vhsinfo);

		addSettings();

		move.setPosition(optionGroup[selection].getMidpoint().x, optionGroup[selection].getMidpoint().y + 15);

		#if android
		addVirtualPad(UP_DOWN, A);
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		move.x = FlxMath.lerp(optionGroup[selection].getMidpoint().x, move.x, 1 - Main.framerateAdjust(0.15));
		move.y = FlxMath.lerp(optionGroup[selection].getMidpoint().y + 15, move.y, 1 - Main.framerateAdjust(0.15));
		if (openedMenu)
		{
			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				selection += 1;
			}
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				selection -= 1;
			}
			if (controls.ACCEPT)
			{
				switch (selection)
				{
					case 0:
						FlxG.cameras.remove(camSELECTION);
						Main.switchState(this, new StoryMenuState());
					case 1:
						FlxG.openURL("https://gamebanana.com/mods/389366");
					case 2:
						FlxG.cameras.remove(camSELECTION);
						Main.switchState(this, new OptionsMenuState());
				}
			}
			if (selection > optionGroup.length - 1)
				selection = 0;
			if (selection < 0)
				selection = optionGroup.length - 1;

			for (i in 0...optionGroup.length)
			{
				if (i != selection)
				{
					optionGroup[i].color = FlxColor.WHITE;
					optionGroup[i].alpha = 0.6;
				}
				else
				{
					optionGroup[i].color = FlxColor.BLACK;
					optionGroup[i].alpha = 1;
				}
			}
		}
	}

	function addSettings()
	{
		var options:Array<String> = ["PLAY", "CREDITS", "OPTIONS"];
		var y:Float = 98;
		for (i in 0...options.length)
		{
			var optionText = new FlxText(0, y, 0, options[i], 70);
			optionText.font = Paths.font("vcr.ttf");
			optionText.screenCenter(X);
			optionText.camera = camSELECTION;
			optionGroup.push(optionText);
			add(optionText);
			y += 110;
		}
	}
}
