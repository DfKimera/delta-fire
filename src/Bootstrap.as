package {

	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.FlxU;
	import org.flixel.system.FlxDebugger;

	[SWF(width="1024", height="768", backgroundColor="#000000", frameRate="30")]
	public class Bootstrap extends FlxGame {

		public var uiPlayerHealth:UIPlayerHealth;

	    public function Bootstrap() {
		    super(Game.SCREEN_W, Game.SCREEN_H, Game, 1, 30, 30);

		    FlxG.debug = true;
		    forceDebugger = true;

		    uiPlayerHealth = new UIPlayerHealth();
		    uiPlayerHealth.x = 15;
		    uiPlayerHealth.y = 15;
		    parent.addChild(uiPlayerHealth);
	    }
	}
}
