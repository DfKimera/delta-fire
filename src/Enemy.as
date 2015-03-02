package {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.flixel.FlxG;

	import org.flixel.FlxSprite;
	import org.flixel.FlxU;

	public class Enemy extends FlxSprite {

		[Embed(source="../assets/enemy_ship.png")]
		public static var SPRITE:Class;

		public var aiTickTimer:Timer = new Timer(2000);
		public var aiFireTimer:Timer = new Timer(500);

		public var isInitialized:Boolean = false;

		public var dx:Number;
		public var dy:Number;
		public var targetAngle:Number;
		public var speed:Number;

		public var speedLimit:Array = [5, 15];
		public var bulletSpeed:Number = 6;
		public var bulletDamage:Number = 5;

		public function Enemy(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			this.health = 20;

			aiTickTimer.addEventListener(TimerEvent.TIMER, onAITick);
			aiFireTimer.addEventListener(TimerEvent.TIMER, onAIFire);

			loadGraphic(SPRITE);
		}

		public function onFirstFrame():void {
			isInitialized = true;
			aiTickTimer.start();
			aiFireTimer.start();
			onAITick(null);
		}

		public function onAITick(ev:TimerEvent):void {
			if(!alive) return;

			speed = speedLimit[0] + FlxG.random() * (speedLimit[1] - speedLimit[0]);
			this.setTargetAngle(FlxG.random() * 360);
		}

		public function onAIFire(ev:TimerEvent):void {
			if(!alive) return;

			var target:Player = Game.$players.getFirstAlive() as Player;

			if(!(target is Player)) {
				return;
			}

			var angle:Number = FlxU.getAngle(this.getMidpoint(), target.getMidpoint());

			new Projectile(x, y, angle, bulletSpeed, bulletDamage, false);
		}

		public function setTargetAngle(angle:Number):void {
			targetAngle = angle;
			var phi:Number = (targetAngle - 90) * (Math.PI / 180);
			dx = Math.cos(phi);
			dy = Math.sin(phi);
		}

		public override function update():void {
			super.update();

			if(!alive) return;

			if(!isInitialized) {
				onFirstFrame();
				return;
			}

			this.handleMovement();
			this.checkBounds();
		}

		public function handleMovement():void {
			this.x += dx;
			this.y += dy;
		}

		public function checkBounds():void {
			//Utils.wrapOnBounds(this);
		}

		public override function kill():void {

			Game.emitDebris(x, y, 100, 5);
			Game.$enemies.remove(this);

			super.kill();

			aiTickTimer.stop();
			aiFireTimer.stop();

			aiTickTimer = null;
			aiFireTimer = null;

			Game.numKills++;

			if(Game.numKills > Game.bestNumKills) {
				Game.bestNumKills = Game.numKills;
			}

			this.destroy();
		}
	}
}
