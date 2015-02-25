package {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.flixel.FlxCamera;

	import org.flixel.FlxEmitter;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;

	public class Game extends FlxState {

		[Embed(source="../assets/backdrop_2.jpg")]
		public static var BACKDROP:Class;

		[Embed(source="../assets/debris.png")]
		public static var DEBRIS:Class;

		public var player:Player;
		public var backdrop:FlxSprite;

		public var uiScore:UIScore;

		public static var bestNumKills:int = 0;
		public static var numKills:int = 0;
		public static var isOver:Boolean = false;

		public static var $attachments:FlxGroup;
		public static var $players:FlxGroup;
		public static var $enemies:FlxGroup;
		public static var $projectiles:FlxGroup;

		public static var debrisEmitter:FlxEmitter;

		public static const SCREEN_W:int = 1024;
		public static const SCREEN_H:int = 768;

		public var enemySpawnTimer:Timer;

		public override function create():void {
			super.create();

			$attachments = new FlxGroup();
			$players = new FlxGroup();
			$enemies = new FlxGroup();
			$projectiles = new FlxGroup();

			enemySpawnTimer = new Timer(6500);

			isOver = false;
			numKills = 0;
			UIScore.reset();

			backdrop = new FlxSprite(0, 0, BACKDROP);
			backdrop.scrollFactor = new FlxPoint(0,0);
			uiScore = new UIScore();

			debrisEmitter = new FlxEmitter();
			debrisEmitter.makeParticles(Game.DEBRIS, 50, 16, true);

			player = new Player();
			player.x = SCREEN_W / 2;
			player.y = SCREEN_H / 2;

			$players.add(player);
			$attachments.add(player.thrusterBack);
			$attachments.add(player.thrusterLeft);
			$attachments.add(player.thrusterRight);

			this.add(backdrop);
			this.add($attachments);
			this.add($players);
			this.add($enemies);
			this.add($projectiles);
			this.add(debrisEmitter);
			this.add(uiScore);

			enemySpawnTimer.addEventListener(TimerEvent.TIMER, onEnemySpawnTimer);
			enemySpawnTimer.start();
		}

		public override function update():void {
			super.update();
			//this.updateCamera();
			this.checkCollisions();
			this.checkReset();
		}

		public function updateCamera():void {
			if(!FlxG.camera) {
				trace("no camera!");
				return;
			}

			FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON);
			backdrop.angle = FlxG.camera.angle;
		}

		public function checkReset():void {
			if(Game.isOver && FlxG.keys.justReleased("SPACE")) {
				$enemies.kill();

				enemySpawnTimer.reset();
				enemySpawnTimer.stop();

				FlxG.resetState();
			}
		}

		public function checkCollisions():void {
			FlxG.overlap($projectiles, $enemies, Projectile.handleCollision);
			FlxG.overlap($projectiles, $players, Projectile.handleCollision);
			FlxG.overlap($projectiles, $projectiles, Projectile.handleSelfCollision);
		}

		public function onEnemySpawnTimer(ev:TimerEvent):void {

			var x:Number = FlxG.random() * Game.SCREEN_W;
			var y:Number = FlxG.random() * Game.SCREEN_H;

			$enemies.add(new Enemy(x, y));
		}

		public static function emitDebris(x:Number, y:Number, frequency:Number = 15, lifespan:Number = 1.5, amount:Number = 150):void {
			debrisEmitter.x = x;
			debrisEmitter.y = y;
			debrisEmitter.start(true, lifespan, amount, frequency);
		}
	}
}
