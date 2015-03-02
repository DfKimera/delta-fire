package {
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxParticle;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;

	public class Projectile extends FlxSprite {

		[Embed(source="../assets/bullet.png")]
		public static var SPRITE_ENEMY:Class;

		[Embed(source="../assets/bullet_friendly.png")]
		public static var SPRITE_FRIENDLY:Class;

		public var dx:Number = 0;
		public var dy:Number = 0;
		public var speed:Number = 10;
		public var damage:Number = 10;

		public var isFriendly:Boolean = false;

		public function Projectile(x:Number, y:Number, angle:Number, speed:Number, damage:Number, isFriendly:Boolean) {
			this.angle = angle;
			this.x = x;
			this.y = y;
			this.speed = speed;
			this.damage = damage;
			this.isFriendly = isFriendly;

			var phi:Number = (angle - 90) * (Math.PI / 180);

			dx = Math.cos(phi) * speed;
			dy = Math.sin(phi) * speed;

			var bulletSprite:Class = (isFriendly) ? SPRITE_FRIENDLY : SPRITE_ENEMY;
			loadGraphic(bulletSprite, false, false, 4, 8);

			Game.$projectiles.add(this);
		}

		public function checkBounds():void {
			var outOfBounds:Boolean = Utils.killOutOfBounds(this);
			if(outOfBounds) { Game.$projectiles.remove(this); this.alive = false; }
		}

		public override function update():void {
			if(!alive) {
				this.destroy();
				return;
			}

			super.update();

			x += dx;
			y += dy;

			this.checkBounds();
		}

		public override function kill():void {
			super.kill();
		}

		public static function handleCollision(projectile:Projectile, target:FlxSprite):void {
			if(projectile.isFriendly == (target is Enemy)) {

				Game.emitDebris(target.x, target.y, 10, 0.5);
				Game.$projectiles.remove(projectile);

				projectile.kill();
				target.hurt(projectile.damage);
				projectile.destroy();

			}
		}

		public static function handleSelfCollision(proj1:Projectile, proj2:Projectile):void {
			/*proj1.kill();
			proj2.kill();

			proj1.destroy();
			proj2.destroy();*/
		}
	}
}
