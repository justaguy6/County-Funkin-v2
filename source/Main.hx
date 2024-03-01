package;

import openfl.events.ErrorEvent;
import openfl.errors.Error;
import haxe.Json;
import sys.Http;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import lime.app.Application;
import meta.*;
import meta.data.PlayerSettings;
import meta.data.dependency.Discord;
import meta.data.dependency.FNFTransition;
import meta.data.dependency.FNFUIState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.UncaughtErrorEvent;
import lime.system.System;

typedef CrashContent = {
	var content:String;
} 

// Here we actually import the states and metadata, and just the metadata.
// It's nice to have modularity so that we don't have ALL elements loaded at the same time.
// at least that's how I think it works. I could be stupid!
class Main extends Sprite
{
	// class action variables
	public static var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var mainClassState:Class<FlxState> = Init; // Determine the main class state of the game
	public static var framerate:Int = 120; // How many frames per second the game should run at.

	public static var gameVersion:String = '0.3.1';

	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var infoCounter:Overlay; // initialize the heads up display that shows information before creating it.

	// heres gameweeks set up!

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	// calls a function to set the game up
	public function new()
	{
		super();

		/**
			ok so, haxe html5 CANNOT do 120 fps. it just cannot.
			so here i just set the framerate to 60 if its complied in html5.
			reason why we dont just keep it because the game will act as if its 120 fps, and cause
			note studders and shit its weird.
		**/

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, killCua);

		#if (html5 || neko)
		framerate = 60;
		#end

		// simply said, a state is like the 'surface' area of the window where everything is drawn.
		// if you've used gamemaker you'll probably understand the term surface better
		// this defines the surface bounds

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
			// this just kind of sets up the camera zoom in accordance to the surface width and camera zoom.
			// if set to negative one, it is done so automatically, which is the default.
		}

		FlxTransitionableState.skipNextTransIn = true;

		// here we set up the base game
		var gameCreate:FlxGame;
		#if android
		gameCreate = new FlxGame(gameWidth, gameHeight, mainClassState, #if (flixel < "5.0.0") zoom, #end framerate, framerate, skipSplash);
		#else
		addChild(new FlxGame(1280, 720, Init, 60, 60, true, false));
                #end
		// default game FPS settings, I'll probably comment over them later.
		// addChild(new FPS(10, 3, 0xFFFFFF));

		// begin the discord rich presence

		// test initialising the player settings
		PlayerSettings.init();

		infoCounter = new Overlay(0, 0);
		addChild(infoCounter);
	}

	public static function framerateAdjust(input:Float)
	{
		return FlxG.elapsed / (1 / 60) * input;
	}

	/*  This is used to switch "rooms," to put it basically. Imagine you are in the main menu, and press the freeplay button.
		That would change the game's main class to freeplay, as it is the active class at the moment.
	 */
	public static var lastState:FlxState;

	public static function switchState(curState:FlxState, target:FlxState)
	{
		// Custom made Trans in
		mainClassState = Type.getClass(target);
		if (!FlxTransitionableState.skipNextTransIn)
		{
			curState.openSubState(new FNFTransition(0.35, false));
			FNFTransition.finishCallback = function()
			{
				FlxG.switchState(target);
			};
			return trace('changed state');
		}
		FlxTransitionableState.skipNextTransIn = false;
		// load the state
		FlxG.switchState(target);
	}

	public static function updateFramerate(newFramerate:Int)
	{
		// flixel will literally throw errors at me if I dont separate the orders
		if (newFramerate > FlxG.updateFramerate)
		{
			FlxG.updateFramerate = newFramerate;
			FlxG.drawFramerate = newFramerate;
		}
		else
		{
			FlxG.drawFramerate = newFramerate;
			FlxG.updateFramerate = newFramerate;
		}
	}

	function killCua(e:UncaughtErrorEvent):Void
	{
		var msg:String = "Cua SUCKS and county CRASHED here are the LOGS go FIX IT NUMBSKULL \n(Running on version 2.2)\n\n";
		var stacks:Array<StackItem> = CallStack.exceptionStack(true);

		for (stack in stacks)
		{
			switch (stack)
			{
				case FilePos(s, file, line, column):
					msg += 'CALLED IN "' + file + '" IN LINE ' + Std.int(line) + "\n";
				default:
					trace("kys");
			}
		}
		msg += "\nTHROWED BACK: " + e.error;

		var parsedLog:CrashContent;
		parsedLog = {
			content: "```hx\n" + msg + "\n```"
		}

		var http = new Http("");
		http.setHeader("Content-Type", "application/json");
		http.setPostData(Json.stringify(parsedLog));
		http.request(true);

		Application.current.window.alert("Something went wrong!\n\nA report has been automatically sent into the County Funkin' development server.\n\nYou may also send a bug report via the County Funkin' twitter account.", "County Farted and Shat Itself");
		Sys.exit(1);
	}
}
