package;

import lime.utils.AssetType as LimeAssetType;
import lime.utils.Assets;
import flixel.graphics.FlxGraphic;
#if sys
import sys.io.File;
import sys.FileSystem;
import polymod.backends.PolymodAssets;
#end
import openfl.display.BitmapData;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function lua(key:String,?library:String)
	{
		return getPath('data/$key.lua', TEXT, library);
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		#if sys
		if(Assets.exists(image(key, library)))
			return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
		else
			return getSparrowAtlasSYS(key, library);
		#else
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
		#end
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	#if sys
	inline static public function getSparrowAtlasSYS(key:String, ?library:String)
	{
		var path = pathStyleSYS(key, library);

		var imageDataRaw = PolymodAssets.getBytes(path + ".png");
		var imageData = BitmapData.fromBytes(imageDataRaw);

		var xmlData = PolymodAssets.getText(path + ".xml");

		return FlxAtlasFrames.fromSparrow(imageData, xmlData);
	}

	inline static public function imageSYS(key:String, ?library:String)
	{
		var path = pathStyleSYS(key, library);

		var imageDataRaw = PolymodAssets.getBytes(path + ".png");
		var imageData = BitmapData.fromBytes(imageDataRaw);

		return imageData;
	}

	inline static public function getPackerAtlasSYS(key:String, ?library:String)
	{
		var path = pathStyleSYS(key, library);

		var imageDataRaw = PolymodAssets.getBytes(path + ".png");
		var imageData = BitmapData.fromBytes(imageDataRaw);

		var txtData = File.getContent(path + ".txt");

		return FlxAtlasFrames.fromSpriteSheetPacker(imageData, txtData);
	}

	inline static public function jsonSYS(key:String, ?library:String)
	{
		return pathStyleSYS(key + ".json", library, "data");
	}

	inline static public function voicesSYS(song:String)
	{
		return 'assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function instSYS(song:String)
	{
		return 'assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	// path stuff lol for system
	inline static public function pathStyleSYS(key:String, ?library:String, ?dataType:String = "images")
	{
		if(library != null)
			library = library + "/";
		else
			library = "";

		return "assets/" + library + dataType + "/" + key;
	}
	#end
}
