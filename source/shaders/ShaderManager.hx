package shaders;

import flixel.math.FlxMath;
import shaders.codes.ChromaticAberration;
import shaders.codes.Bloom;
import openfl.display.BitmapData;
import shaders.codes.Distort;
import shaders.codes.Glitch;
import shaders.codes.Vhs;
import openfl.filters.ShaderFilter;
import openfl.Lib;
import openfl.utils.Assets;

class ShaderManager {
    public var translatedShader:Map<String, ShaderFilter>;

    var vhs = new Vhs();
	var glitch = new Glitch();
	var block = new Distort();
	var bloom = new Bloom();
	var chrom = new ChromaticAberration();

    public function new() {
		vhs.iTime.value = [0];
		vhs.iResolution.value = [0, 0, 0];

		glitch.iTime.value = [0];
		glitch.isDad.value = [false];

		block.intensity.value = [0];
		block.abstractstuff.input = Assets.getBitmapData("assets/images/county-sprites/abstract.png");

		bloom.intensity.value = [0];

		chrom.amount.value = [0];

        //////////////////////////////////////////////

        translatedShader = [
            "vhs" => new ShaderFilter(vhs),
		    "glitch" => new ShaderFilter(glitch),
			"block" => new ShaderFilter(block),
			"bloom" => new ShaderFilter(bloom),
			"chrom" => new ShaderFilter(chrom)
        ];
    }

	public function update(elapsed:Float) {
		if (bloom.tween)
			bloom.intensity.value[0] = FlxMath.lerp(bloom.intensity.value[0], 0, elapsed / (1 / 60) * 0.05);

		if (chrom.tween)
			chrom.amount.value[0] = FlxMath.lerp(chrom.amount.value[0], 0, elapsed / (1 / 60) * 0.05);

		vhs.iTime.value[0] += elapsed;
		vhs.iResolution.value = [Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, 0];

		glitch.iTime.value[0] += elapsed;
	}
}
