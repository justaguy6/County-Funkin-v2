package meta.state.menus;

import gameObjects.Clock;
import gameObjects.userInterface.SquareRiser;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import gameObjects.userInterface.AudioVisualizer.BarVisualizer;
import gameObjects.Character;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import gameObjects.userInterface.PhillyGlow.PhillyGlowParticle;
import shaders.ShaderObject;
import meta.data.Song;
import flixel.FlxG;
import flixel.util.FlxColor;
import gameObjects.userInterface.PhillyGlow.PhillyGlowGradient;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import meta.MusicBeat.MusicBeatState;
#if desktop
import hxcodec.VideoSprite;
#end
	
class CachingState extends MusicBeatState{
	var credits:Map<String, String> = [
		"Deceived" => "BUBU AND TACK",
		"Traumatized" => "BUBU AND RIO",
		"Expedited" => "BUBU AND DISSONIFIED",
		"Followed" => "BUBU",
		"Lured" => "BUBU",
		"Pursued" => "DISSONIFIED",
		"Befriended" => "Z SHARP STUDIOS,\nBUBU AND KOBAIKID",
		"Awakened" => "DISSONIFIED",
		"Remembered" => "BUBU, CHASE REDDING, RIO,\nDISSONIFIED AND TACK"
	];
	
    var songName:String;
    public function new(song:String)
    {
        super();
        songName = song;
    }

    override function create() {
        super.create();

		new FlxSound().loadEmbedded(Paths.sound("county-sounds/rumble"));

		var textThing = new FlxText(0, 0, 0, 'NOW PLAYING:\n\n"' + songName.toUpperCase() + '"\n\n' + "BY " + credits[songName] + ".", 60);
		textThing.font = Paths.font("vcr.ttf");
		textThing.alignment = CENTER;
		textThing.screenCenter();
		FlxTween.shake(textThing, 0.004, 99, Y);

		FlxG.camera.filters =[ShaderObject.getShader("vhs")];

        var loading = new FlxTypeText(1000, 630, FlxG.width, "LOADING...", 40);
        loading.font = Paths.font("vcr.ttf");
        loading.sounds = [new FlxSound().loadEmbedded(Paths.sound("county-sounds/typewriter"))];
        add(loading);

        
        new FlxTimer().start(1.5, function(e:FlxTimer)
        {
            loading.start(0.1,false, false, null, function()
            {
                switch (songName)
                {
					case "Befriended":
						FlxG.bitmap.add(Paths.image("county-sprites/befriended/vignette"));
						FlxG.bitmap.add(Paths.image("county-sprites/befriended/intruder"));
						FlxG.bitmap.add(Paths.image("county-sprites/befriended/eyes"));
						FlxG.bitmap.add(Paths.image("backgrounds/befriended/bg"));
						FlxG.bitmap.add(Paths.image("backgrounds/befriended/shine"));
						FlxG.bitmap.add(Paths.image("backgrounds/befriended/TV"));
						FlxG.bitmap.add(Paths.image("backgrounds/befriended/light"));

				                #if desktop
						var beginningIntro:VideoSprite;
						beginningIntro = new VideoSprite(250);
						beginningIntro.openingCallback = beginningIntro.bitmap.stop;
						beginningIntro.playVideo("assets/images/county-sprites/befriended/beginning.mp4");
						add(beginningIntro);
						beginningIntro.scale.set();
                                                #end
						var staticBg = new FlxSprite(-400, 0);
						staticBg.frames = Paths.getSparrowAtlas("county-sprites/befriended/static");
						staticBg.animation.addByPrefix("static", "static", 24, true);
						staticBg.animation.play("static");
						staticBg.scale.set();
						staticBg.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(staticBg);

						var dad = new Character();
						dad.setCharacter(0, 0, "intruderlured_alt");
						dad.playAnim("idle");
						dad.playAnim("singLEFT");
						dad.playAnim("singRIGHT");
						dad.playAnim("singUP");
						dad.playAnim("singDOWN");
						dad.scale.set();
						dad.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(dad);

						var bf = new Character();
						bf.setCharacter(0, 0, "adamyoung");
						bf.playAnim("idle");
						bf.playAnim("singLEFT");
						bf.playAnim("singRIGHT");
						bf.playAnim("singUP");
						bf.playAnim("singDOWN");
						bf.playAnim("singUPmiss");
						bf.playAnim("singLEFTmiss");
						bf.playAnim("singRIGHTmiss");
						bf.playAnim("singDOWNmiss");
						bf.scale.set();
						bf.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(bf);

						var statics = new FlxSprite();
						statics.frames = Paths.getSparrowAtlas("county-sprites/befriended/statics");
						statics.animation.addByPrefix("loop", "static", 24);
						add(statics);
						statics.scrollFactor.set();
						statics.animation.play("loop");
						statics.screenCenter();
						statics.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						statics.scale.set();

						var blackOverlay = new FlxSprite();
						blackOverlay.makeGraphic(3000, 3000, FlxColor.BLACK);
						blackOverlay.scale.set();
						blackOverlay.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(blackOverlay);

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));
					case "Awakened":
						FlxG.bitmap.add(Paths.image("backgrounds/awakened/gradientUnder"));
						FlxG.bitmap.add(Paths.image("backgrounds/awakened/sillouhette"));
						FlxG.bitmap.add(Paths.image("backgrounds/awakened/trees"));
						FlxG.bitmap.add(Paths.image("backgrounds/awakened/light"));
						FlxG.bitmap.add(Paths.image("backgrounds/awakened/church"));

						var shoot = new FlxSprite();
						shoot.frames = Paths.getSparrowAtlas("county-sprites/awakened/shooteffect");
						shoot.animation.addByPrefix("shoot", "static instance 1", 24);
						shoot.scrollFactor.set();
						shoot.screenCenter();
						shoot.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						shoot.animation.play("shoot");
						shoot.scale.set();
						add(shoot);

						var gab = new Character();
						gab.setCharacter(0, 0, "awakenedGabrielAlt");
						gab.playAnim("idle");
						gab.playAnim("singLEFT");
						gab.playAnim("singRIGHT");
						gab.playAnim("singUP");
						gab.playAnim("singDOWN");
						gab.scale.set();
						gab.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(gab);

						var blackOverlay = new FlxSprite();
						blackOverlay.makeGraphic(3000, 3000, FlxColor.BLACK);
						blackOverlay.scale.set();
						blackOverlay.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(blackOverlay);

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));
					case "Remembered":
						FlxG.bitmap.add(Paths.image("county-sprites/remembered/guys"));
						FlxG.bitmap.add(Paths.image("county-sprites/remembered/gals"));
						FlxG.bitmap.add(Paths.image("backgrounds/remembered/computer"));
						FlxG.bitmap.add(Paths.image("county-sprites/remembered/bars"));
						FlxG.bitmap.add(Paths.image("county-sprites/remembered/eyes"));
						FlxG.bitmap.add(Paths.image("county-sprites/remembered/scare"));
						FlxG.bitmap.add(Paths.image("county-sprites/remembered/die"));

						var flash = new FlxSprite();
						flash.frames = Paths.getSparrowAtlas("county-sprites/remembered/flashbacks");
						flash.animation.addByPrefix("flash", "flashbacks", 24);
						flash.scale.set();
						flash.scrollFactor.set();
						flash.animation.play("flash");
						flash.screenCenter();
						flash.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(flash);

						var dad = new Character();
						dad.setCharacter(0, 0, "intruderSketch");
						dad.playAnim("idle");
						dad.playAnim("singLEFT");
						dad.playAnim("singRIGHT");
						dad.playAnim("singUP");
						dad.playAnim("singDOWN");
						dad.scale.set();
						dad.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(dad);

						var adam = new Character();
						adam.setCharacter(0, 0, "alternateAdam");
						adam.playAnim("idle");
						adam.playAnim("singLEFT");
						adam.playAnim("singRIGHT");
						adam.playAnim("singUP");
						adam.playAnim("singDOWN");
						adam.scale.set();
						adam.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(adam);

						var adam = new Character();
						adam.setCharacter(0, 0, "scaredAdam");
						adam.playAnim("idle");
						adam.playAnim("singLEFT");
						adam.playAnim("singRIGHT");
						adam.playAnim("singUP");
						adam.playAnim("singDOWN");
						adam.scale.set();
						adam.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(adam);

						var adam = new Character();
						adam.setCharacter(0, 0, "adam");
						adam.playAnim("idle");
						adam.playAnim("singLEFT");
						adam.playAnim("singRIGHT");
						adam.playAnim("singUP");
						adam.playAnim("singDOWN");
						adam.scale.set();
						adam.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(adam);

						var dad = new Character();
						dad.setCharacter(0, 0, "intruderRemembered");
						dad.playAnim("idle");
						dad.playAnim("singLEFT");
						dad.playAnim("singRIGHT");
						dad.playAnim("singUP");
						dad.playAnim("singDOWN");
						dad.scale.set();
						dad.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(dad);

						var dad = new Character();
						dad.setCharacter(0, 0, "altIntruderRemembered");
						dad.playAnim("idle");
						dad.playAnim("singLEFT");
						dad.playAnim("singRIGHT");
						dad.playAnim("singUP");
						dad.playAnim("singDOWN");
						dad.scale.set();
						dad.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(dad);

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));
					case "Pursued":
						FlxG.bitmap.add(Paths.image("county-sprites/pursued/bars"));
						FlxG.bitmap.add(Paths.image("backgrounds/pursued/bg"));
						FlxG.bitmap.add(Paths.image("backgrounds/pursued/overlay"));
						FlxG.bitmap.add(Paths.image("county-sprites/pursued/redVignette"));
						FlxG.bitmap.add(Paths.image("backgrounds/pursued/ct1"));
						FlxG.bitmap.add(Paths.image("backgrounds/pursued/ct2"));

						var fog = new FlxSprite();
						fog.frames = Paths.getSparrowAtlas("county-sprites/pursued/fog");
						fog.animation.addByPrefix("loop", "fog", 10);
						fog.animation.play("loop");
						fog.scale.set();
						add(fog);

						var thatcher = new Character();
						thatcher.setCharacter(0, 0, "thatcher");
						add(thatcher);
						thatcher.playAnim("idle");
						thatcher.playAnim("singUP");
						thatcher.playAnim("singLEFT");
						thatcher.playAnim("singRIGHT");
						thatcher.playAnim("singDOWN");
						thatcher.playAnim("singUPmiss");
						thatcher.playAnim("singLEFTmiss");
						thatcher.playAnim("singRIGHTmiss");
						thatcher.playAnim("singDOWNmiss");
						thatcher.scale.set();
						thatcher.updateHitbox();

						var alt = new Character();
						alt.setCharacter(0, 0, "pursuedAlt");
						alt.scale.set();
						alt.updateHitbox();
						add(alt);

						alt.playAnim("idle");
						alt.playAnim("singUP");
						alt.playAnim("singLEFT");
						alt.playAnim("singRIGHT");
						alt.playAnim("singDOWN");

						var thatcherCall = new Character();
						thatcherCall.setCharacter(0, 0, "thatcherCall");
						add(thatcherCall);

						thatcherCall.playAnim("idle");
						thatcherCall.playAnim("singUP");
						thatcherCall.playAnim("singLEFT");
						thatcherCall.playAnim("singRIGHT");
						thatcherCall.playAnim("singDOWN");
						thatcherCall.playAnim("singUPmiss");
						thatcherCall.playAnim("singLEFTmiss");
						thatcherCall.playAnim("singRIGHTmiss");
						thatcherCall.playAnim("singDOWNmiss");
						thatcherCall.scale.set();
						thatcherCall.updateHitbox();

						var ruth = new Character();
						ruth.setCharacter(0, 0, "ruth");
						add(ruth);

						ruth.playAnim("idle");
						ruth.playAnim("singUP");
						ruth.playAnim("singLEFT");
						ruth.playAnim("singRIGHT");
						ruth.playAnim("singDOWN");
						ruth.scale.set();
						ruth.updateHitbox();

						var clock = new Clock();
						clock.scale.set();
						clock.active = false;
						add(clock);

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));
					case "Deceived":
						var noah = new Character();
						noah.frames = Paths.getSparrowAtlas("characters/Gabriel");
						noah.animation.addByPrefix('idle', 'idle', 24, false);
						noah.animation.addByPrefix('singUP', 'up', 24, false);
						noah.animation.addByPrefix('singRIGHT', 'left', 24, false);
						noah.animation.addByPrefix('singDOWN', 'down', 24, false);
						noah.animation.addByPrefix('singLEFT', 'right', 24, false);
						noah.scale.set(0, 0);
						noah.updateHitbox();
						noah.flipX = true;
						noah.playAnim("idle");
						noah.playAnim("singUP");
						noah.playAnim("singLEFT");
						noah.playAnim("singRIGHT");
						noah.playAnim("singDOWN");
						add(noah);

						var noah = new Character();
						noah.frames = Paths.getSparrowAtlas("characters/satan");
						noah.animation.addByPrefix('idle', 'idle', 24, false);
						noah.animation.addByPrefix('singUP', 'up', 24, false);
						noah.animation.addByPrefix('singRIGHT', 'left', 24, false);
						noah.animation.addByPrefix('singDOWN', 'down', 24, false);
						noah.animation.addByPrefix('singLEFT', 'right', 24, false);
						noah.scale.set(0, 0);
						noah.updateHitbox();
						noah.flipX = true;
						noah.playAnim("idle");
						noah.playAnim("singUP");
						noah.playAnim("singLEFT");
						noah.playAnim("singRIGHT");
						noah.playAnim("singDOWN");
						add(noah);

						var noah = new Character();
						noah.frames = Paths.getSparrowAtlas("characters/Satan_Front");
						noah.animation.addByPrefix('idle', 'idle', 24, false);
						noah.animation.addByPrefix('singUP', 'up', 24, false);
						noah.animation.addByPrefix('singRIGHT', 'left', 24, false);
						noah.animation.addByPrefix('singDOWN', 'down', 24, false);
						noah.animation.addByPrefix('singLEFT', 'right', 24, false);
						noah.scale.set(0, 0);
						noah.updateHitbox();
						noah.flipX = true;
						noah.playAnim("idle");
						noah.playAnim("singUP");
						noah.playAnim("singLEFT");
						noah.playAnim("singRIGHT");
						noah.playAnim("singDOWN");
						add(noah);

						var noah = new Character();
						noah.frames = Paths.getSparrowAtlas("characters/Gabriel_Front");
						noah.animation.addByPrefix('idle', 'idle', 24, false);
						noah.animation.addByPrefix('singUP', 'up', 24, false);
						noah.animation.addByPrefix('singRIGHT', 'left', 24, false);
						noah.animation.addByPrefix('singDOWN', 'down', 24, false);
						noah.animation.addByPrefix('singLEFT', 'right', 24, false);
						noah.scale.set(0, 0);
						noah.updateHitbox();
						noah.flipX = true;
						noah.playAnim("idle");
						noah.playAnim("singUP");
						noah.playAnim("singLEFT");
						noah.playAnim("singRIGHT");
						noah.playAnim("singDOWN");
						add(noah);

						var noah = new Character();
						noah.setCharacter(0, 0, "noah");
						noah.playAnim("idle");
						noah.playAnim("singUP");
						noah.playAnim("singLEFT");
						noah.playAnim("singRIGHT");
						noah.playAnim("singDOWN");
						noah.playAnim("singUPmiss");
						noah.playAnim("singLEFTmiss");
						noah.playAnim("singRIGHTmiss");
						noah.playAnim("singDOWNmiss");
						add(noah);
						noah.scale.set(0, 0);
						noah.updateHitbox();

						var noah = new Character();
						noah.setCharacter(0, 0, "noahScared");
						noah.playAnim("idle");
						noah.playAnim("singUP");
						noah.playAnim("singLEFT");
						noah.playAnim("singRIGHT");
						noah.playAnim("singDOWN");
						noah.playAnim("singUPmiss");
						noah.playAnim("singLEFTmiss");
						noah.playAnim("singRIGHTmiss");
						noah.playAnim("singDOWNmiss");
						add(noah);
						noah.scale.set(0, 0);
						noah.updateHitbox();

						var suchweakminds = new FlxSprite(200, 250);
						suchweakminds.frames = Paths.getSparrowAtlas("county-sprites/deceived/suchweakminds");
						suchweakminds.animation.addByPrefix("scroll", "scroll");
						suchweakminds.animation.play("scroll");
						suchweakminds.scale.set(0, 0);
						add(suchweakminds);

						FlxG.bitmap.add(Paths.image("backgrounds/deceived/gradient"));
						FlxG.bitmap.add(Paths.image("backgrounds/deceived/sand"));
						FlxG.bitmap.add(Paths.image("backgrounds/deceived/bg"));
						FlxG.bitmap.add(Paths.image("county-sprites/deceived/redVignette"));

						FlxTween.tween(FlxG.camera, {angle: 360}, 0.00000000000000000000000000000000000000000000001);

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));
					case "Lured":
						FlxG.bitmap.add(Paths.image("county-sprites/lured/Adam"));
						FlxG.bitmap.add(Paths.image("county-sprites/lured/Jonah"));
						FlxG.bitmap.add(Paths.image("backgrounds/lured/basement"));
						FlxG.bitmap.add(Paths.image("backgrounds/lured/basement-2"));
						FlxG.bitmap.add(Paths.image("backgrounds/lured/basement-cat"));
						FlxG.bitmap.add(Paths.image("backgrounds/lured/TV"));
						FlxG.bitmap.add(Paths.image("backgrounds/lured/TVlights"));
						FlxG.bitmap.add(Paths.image("backgrounds/lured/TVnotch"));

						var dad = new Character();
						dad.frames = Paths.getSparrowAtlas("characters/intruderlured");
						dad.animation.addByPrefix('idle', 'idle', 24, false);
						dad.animation.addByPrefix('singUP', 'up', 24, false);
						dad.animation.addByPrefix('singRIGHT', 'right', 24, false);
						dad.animation.addByPrefix('singDOWN', 'down', 24, false);
						dad.animation.addByPrefix('singLEFT', 'left', 24, false);
						dad.playAnim("idle");
						dad.playAnim("singUP");
						dad.playAnim("singLEFT");
						dad.playAnim("singRIGHT");
						dad.playAnim("singDOWN");
						dad.scale.set();
						dad.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(dad);

						var dad2 = new Character();
						dad2.frames = Paths.getSparrowAtlas("characters/intruderlured_alt");
						dad2.animation.addByPrefix('idle', 'idle', 24, false);
						dad2.animation.addByPrefix('singUP', 'up', 24, false);
						dad2.animation.addByPrefix('singRIGHT', 'right', 24, false);
						dad2.animation.addByPrefix('singDOWN', 'down', 24, false);
						dad2.animation.addByPrefix('singLEFT', 'left', 24, false);
						dad2.playAnim("idle");
						dad2.playAnim("singUP");
						dad2.playAnim("singLEFT");
						dad2.playAnim("singRIGHT");
						dad2.playAnim("singDOWN");
						dad2.scale.set();
						dad2.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(dad2);

						var staticBg = new FlxSprite(-400, 0);
						staticBg.frames = Paths.getSparrowAtlas("backgrounds/lured/static");
						staticBg.animation.addByPrefix("static", "static", 24, true);
						staticBg.animation.play("static");
						staticBg.scale.set();
						staticBg.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(staticBg);

						var blackOverlay = new FlxSprite();
						blackOverlay.makeGraphic(3000, 3000, FlxColor.BLACK);
						blackOverlay.scrollFactor.set();
						blackOverlay.screenCenter();
						blackOverlay.scale.set();
						blackOverlay.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(blackOverlay);

						FlxTweenPlayState.tween(FlxG.camera, {alpha: 1}, 0.0000000000000000000001);

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));
					case "Followed":
						FlxG.bitmap.add(Paths.image("backgrounds/followed/dooralter"));
						FlxG.bitmap.add(Paths.image("backgrounds/followed/door"));
						FlxG.bitmap.add(Paths.image("county-sprites/followed/vignette"));
						FlxG.bitmap.add(Paths.image("backgrounds/followed/bedroom"));

						var shoot = new FlxSprite();
						shoot.frames = Paths.getSparrowAtlas("county-sprites/followed/shooteffect");
						shoot.animation.addByPrefix("shoot", "static instance 1", 24);
						shoot.scrollFactor.set();
						shoot.screenCenter();
						shoot.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						shoot.animation.play("shoot");
						shoot.scale.set();
						add(shoot);

						var mar2 = new Character();
						mar2.frames = Paths.getSparrowAtlas('characters/MarkFront');
						mar2.animation.addByPrefix('idle', 'idle', 24, false);
						mar2.animation.addByPrefix('singUP', 'up', 24, false);
						mar2.animation.addByPrefix('singRIGHT', 'left', 24, false);
						mar2.animation.addByPrefix('singDOWN', 'down', 24, false);
						mar2.animation.addByPrefix('singLEFT', 'right', 24, false);
						mar2.playAnim("idle");
						mar2.playAnim("singUP");
						mar2.playAnim("singLEFT");
						mar2.playAnim("singRIGHT");
						mar2.playAnim("singDOWN");
						mar2.scale.set();
						mar2.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(mar2);

						var mar = new Character();
						mar.frames = Paths.getSparrowAtlas('characters/mark');
						mar.animation.addByPrefix('idle', 'idle', 24, false);
						mar.animation.addByPrefix('singUP', 'up', 24, false);
						mar.animation.addByPrefix('singRIGHT', 'left', 24, false);
						mar.animation.addByPrefix('singDOWN', 'down', 24, false);
						mar.animation.addByPrefix('singLEFT', 'right', 24, false);
						mar.animation.addByPrefix('shoot', 'shoot', 24, false);
						mar.playAnim("idle");
						mar.playAnim("singUP");
						mar.playAnim("singLEFT");
						mar.playAnim("singRIGHT");
						mar.playAnim("singDOWN");
						mar.playAnim("shoot");
						mar.updateHitbox();
						mar.flipX = true;
						mar.scale.set();
						mar.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(mar);

						var ar = new Character();
						ar.frames = Paths.getSparrowAtlas('characters/N');
						ar.animation.addByPrefix('idle', 'idle', 24, false);
						ar.animation.addByPrefix('singUP', 'up', 24, false);
						ar.animation.addByPrefix('singRIGHT', 'right', 24, false);
						ar.animation.addByPrefix('singDOWN', 'down', 24, false);
						ar.animation.addByPrefix('singLEFT', 'left', 24, false);
						ar.playAnim("idle");
						ar.playAnim("singUP");
						ar.playAnim("singLEFT");
						ar.playAnim("singRIGHT");
						ar.playAnim("singDOWN");
						ar.updateHitbox();
						ar.scale.set();
						add(ar);

						var red = new FlxSprite();
						red.makeGraphic(3000, 3000, FlxColor.RED); // i wonder who's the person with the red outfit in the county funkin team, and American
						red.scrollFactor.set();
						red.screenCenter();
						red.scale.set();
						red.visible = false;
						add(red);


						FlxTweenPlayState.tween(FlxG.camera, {alpha: 1}, 0.0000000000000000000001);

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));
					case "Expedited":
						FlxG.bitmap.add(Paths.image("county-sprites/glow/gradient"));
						FlxG.bitmap.add(Paths.image("county-sprites/glow/particle"));
						
						var dad = new Character();
						dad.frames = Paths.getSparrowAtlas('characters/alt_cesar');
						dad.animation.addByPrefix('idle', 'idle', 24, false);
						dad.animation.addByPrefix('singUP', 'up', 24, false);
						dad.animation.addByPrefix('singRIGHT', 'right', 24, false);
						dad.animation.addByPrefix('singDOWN', 'down', 24, false);
						dad.animation.addByPrefix('singLEFT', 'left', 24, false);
						dad.playAnim("idle");
						dad.playAnim("singUP");
						dad.playAnim("singRIGHT");
						dad.playAnim("singDOWN");
						dad.playAnim("singLEFT");
						dad.updateHitbox();
						dad.scale.set();
						dad.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(dad);

						var whiteFlash = new FlxSprite();
						whiteFlash.makeGraphic(3000, 3000);
						whiteFlash.scrollFactor.set();
						whiteFlash.screenCenter();
						whiteFlash.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						add(whiteFlash);
						whiteFlash.scale.set();

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));
                    case "Traumatized":
						FlxG.bitmap.add(Paths.image("county-sprites/glow/gradient"));
						var pinkOverlay = new FlxSprite(0, -30);
						pinkOverlay.makeGraphic(3000, 3000, 0xffFF83D6);
						pinkOverlay.alpha = 0;
						pinkOverlay.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
                        pinkOverlay.scale.set();
						add(pinkOverlay);

						var blackOverlay = new FlxSprite(0, -30);
						blackOverlay.makeGraphic(3000, 3000, FlxColor.BLACK);
						blackOverlay.alpha = 0.5;
						blackOverlay.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						blackOverlay.scale.set();
						add(blackOverlay);

						var whiteOverlay = new FlxSprite(0, -30);
						whiteOverlay.makeGraphic(3000, 3000, FlxColor.WHITE);
						whiteOverlay.alpha = 0;
						whiteOverlay.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						whiteOverlay.scale.set();
						add(whiteOverlay);

						var edgybar = new FlxSprite();
						edgybar.makeGraphic(1280, 100, FlxColor.BLACK);
						edgybar.scrollFactor.set();
						edgybar.screenCenter(X);
						edgybar.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						edgybar.scale.set();
						add(edgybar);

						var edgybar2 = new FlxSprite();
						edgybar2.makeGraphic(1280, 100, FlxColor.BLACK);
						edgybar2.scrollFactor.set();
						edgybar2.y = FlxG.height - edgybar2.height;
						edgybar2.screenCenter(X);
						edgybar2.antialiasing = !Init.trueSettings.get('Disable Antialiasing');
						edgybar2.scale.set();
						add(edgybar2);

						FlxTweenPlayState.tween(FlxG.camera, {alpha: 1}, 0.00000000001);

						new FlxSound().loadEmbedded(Paths.inst(songName));
						new FlxSound().loadEmbedded(Paths.voices(songName));
                }

				new FlxTimer().start(1.5, function(e:FlxTimer)
				{
                    loading.erase(0.1, false, null, function()
                    {
						new FlxTimer().start(1.5, function(e:FlxTimer)
						{
							FlxG.sound.play(Paths.sound("county-sounds/typewriter"));
							FlxG.sound.play(Paths.sound("county-sounds/rumble"));
							add(textThing);

							new FlxTimer().start(4, function(e:FlxTimer) {
								FlxG.sound.play(Paths.sound("county-sounds/typewriter"));
								textThing.size = 80;
								textThing.text = "3";
								textThing.screenCenter();
								new FlxTimer().start(1, function(e:FlxTimer){
									FlxG.sound.play(Paths.sound("county-sounds/typewriter"));
									textThing.text = "2";
									textThing.screenCenter();
									new FlxTimer().start(1, function(e:FlxTimer){
										FlxG.sound.play(Paths.sound("county-sounds/typewriter"));
									    textThing.text = "1";
										textThing.screenCenter();
										new FlxTimer().start(1, function(e:FlxTimer){
											PlayState.isStoryMode = false;
											PlayState.storyDifficulty = 2;
											PlayState.SONG = Song.loadFromJson(songName.toLowerCase() + "-hard", songName.toLowerCase());
											Main.switchState(this, new PlayState());
								   		});
								    });
								});
							});
						});
                    });
                });
            });
        });
    }
}
