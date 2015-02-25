package {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.globalization.StringTools;
	import flash.utils.Timer;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;

	public class UIScore extends FlxGroup {

		public static var instance:UIScore;

		public var timeDisplay:FlxText;
		public var killsDisplay:FlxText;
		public var bestScore:FlxText;

		public static var bestNumSeconds:int = 0;
		public var numSeconds:int = 0;

		public var formattedTime:String = "00:00:00";
		public var formattedBestTime:String = "00:00:00";

		public var elapsedTimeTimer:Timer = new Timer(1000);

		public function UIScore() {

			instance = this;

			timeDisplay = new FlxText(180, 15, 100, "00:00:00");
			timeDisplay.setFormat(null, 18, 0xFFFFFF, "center", 0x000000);
			timeDisplay.scrollFactor.x = timeDisplay.scrollFactor.y = 0;

			killsDisplay = new FlxText(295, 15, 100, "0 kills");
			killsDisplay.setFormat(null, 18, 0xFFFFFF, "center", 0x000000);
			killsDisplay.scrollFactor.x = killsDisplay.scrollFactor.y = 0;

			bestScore = new FlxText(Game.SCREEN_W - 250, 15, 250, "Best: ???");
			bestScore.setFormat(null, 18, 0xFF00FF, "right", 0x000000);
			bestScore.scrollFactor.x = bestScore.scrollFactor.y = 0;

			elapsedTimeTimer.addEventListener(TimerEvent.TIMER, onTimeElapse);
			elapsedTimeTimer.start();

			add(timeDisplay);
			add(killsDisplay);
			add(bestScore);
		}

		public static function reset():void {
			if(!instance) { return; }
			instance.numSeconds = 0;
			instance.elapsedTimeTimer.reset();
			instance.elapsedTimeTimer.start();
		}

		public function onTimeElapse(ev:TimerEvent):void {
			if(!Game.isOver) {
				numSeconds++;
			}

			if(numSeconds > bestNumSeconds) {
				bestNumSeconds = numSeconds;
			}

			formattedBestTime = formatTime(bestNumSeconds);
			formattedTime = formatTime(numSeconds);
		}

		public override function update():void {
			super.update();

			timeDisplay.text = formattedTime;
			killsDisplay.text = Game.numKills + " kills";
			bestScore.text = "Best: " + formattedBestTime + ", " + Game.bestNumKills + " kills";
		}

		public function formatTime(seconds:int):String {

			var hours:String = String(int(seconds / 3600));
			if(hours.length < 2) { hours = "0" + hours; }

			var mins:String = String(int(seconds / 60));
			if(mins.length < 2) { mins = "0" + mins; }

			var secs:String = String(int(seconds % 60));
			if(secs.length < 2) { secs = "0" + secs; }

			return hours+":"+mins+":"+secs;

		}
	}
}
