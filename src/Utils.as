package {
	import org.flixel.FlxSprite;

	public class Utils {

		public static function wrapOnBounds(spr:FlxSprite):void {
			if(spr.x < 0) { spr.x = Game.SCREEN_W - 1; }
			else if(spr.x > Game.SCREEN_W) { spr.x = 1;}
			if(spr.y < 0) { spr.y = Game.SCREEN_H - 1; }
			else if(spr.y > Game.SCREEN_H) { spr.y = 1; }
		}

		public static function killOutOfBounds(spr:FlxSprite):Boolean {
			if(spr.x < 0 || spr.x > Game.SCREEN_W || spr.y < 0 || spr.y > Game.SCREEN_H) {
				spr.kill();
				return true;
			}

			return false;
		}

	}
}
