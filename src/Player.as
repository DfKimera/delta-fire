package {

	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class Player extends FlxSprite {

		[Embed(source="../assets/ship_player.png")]
		public static var SPRITE:Class;

		[Embed(source="../assets/ship_thrust_back.png")]
		public static var THRUSTER_BACK:Class;
		[Embed(source="../assets/ship_thrust_left.png")]
		public static var THRUSTER_LEFT:Class;
		[Embed(source="../assets/ship_thrust_right.png")]
		public static var THRUSTER_RIGHT:Class;

		public var maxHealth:int = 100;

		public var thrusterBack:FlxSprite;
		public var thrusterLeft:FlxSprite;
		public var thrusterRight:FlxSprite;

		public var forwardThrust:Number = 0;
		public var sideThrust:Number = 0;

		public var turnSpeed:Number = 200;
		public var moveSpeed:Number = 145;
		public var baseMaxVelocity:Number = 100;

		public var fireRateMin:Number = 5;
		public var fireRateCurrent:int = 5;

		public function Player() {
			loadGraphic(SPRITE);

			thrusterBack = new FlxSprite(x, y, THRUSTER_BACK);
			thrusterLeft = new FlxSprite(x, y, THRUSTER_LEFT);
			thrusterRight = new FlxSprite(x, y, THRUSTER_RIGHT);

			thrusterBack.origin = this.origin;

			this.health = maxHealth;
			this.maxVelocity = new FlxPoint(100, 100);
			this.maxAngular = 200;

			this.angularDrag = turnSpeed * 1.33;
			this.drag.x = this.drag.y = moveSpeed * 1.33;
		}

		public override function update():void {
			super.update();

			this.checkMovement();
			this.checkBounds();
			this.checkWeapons();
			this.moveAttachments();
			this.autoHeal();

			UIPlayerHealth.updateHealth(health, maxHealth);
		}

		public function autoHeal():void {
			if(this.health < this.maxHealth) {
				this.health += 0.1;
			}
		}

		public function moveAttachments():void {
			thrusterBack.x = thrusterLeft.x = thrusterRight.x = x;
			thrusterBack.y = thrusterLeft.y = thrusterRight.y = y;
			thrusterBack.angle = thrusterLeft.angle = thrusterRight.angle = angle;
		}

		public function checkMovement():void {

			thrusterBack.visible = FlxG.keys.W || FlxG.keys.UP;
			thrusterLeft.visible = false; //FlxG.keys.A;
			thrusterRight.visible = false; //FlxG.keys.D;

			var boostRatio:Number = (FlxG.keys.SHIFT) ? 1.75 : 1;
			maxVelocity.x = baseMaxVelocity * boostRatio;
			maxVelocity.y = baseMaxVelocity * boostRatio;

			if(FlxG.keys.W || FlxG.keys.UP) {
				forwardThrust = -(moveSpeed * boostRatio);
			} else if(FlxG.keys.S || FlxG.keys.DOWN) {
				forwardThrust = (moveSpeed * boostRatio);
			} else {
				forwardThrust = 0;
			}

			if(FlxG.keys.A) {
				sideThrust = -(moveSpeed * boostRatio);
			} else if(FlxG.keys.D) {
				sideThrust = +(moveSpeed * boostRatio);
			} else {
				sideThrust = 0;
			}

			var theta:Number = (angle + 90) * (Math.PI / 180);
			var sinTheta:Number = Math.sin(theta);
			var cosTheta:Number = Math.cos(theta);

			acceleration.x = (cosTheta * forwardThrust) + (sinTheta * sideThrust);
			acceleration.y = (sinTheta * forwardThrust) - (cosTheta * sideThrust);

			if(FlxG.keys.LEFT) {
				angularAcceleration = -turnSpeed;
			} else if(FlxG.keys.RIGHT) {
				angularAcceleration = +turnSpeed;
			} else {
				angularAcceleration = 0;
			}

		}

		/*public function checkMovement():void {
			if(FlxG.keys.W) {
				velocity.y = -speed;
			} else if(FlxG.keys.S) {
				velocity.y = +speed;
			} else {
				velocity.y /= decay;
			}

			if(FlxG.keys.A) {
				velocity.x = -speed;
			} else if(FlxG.keys.D) {
				velocity.x = +speed;
			} else {
				velocity.x /= decay;
			}
		}*/

		public function checkBounds():void {
			//Utils.wrapOnBounds(this);
		}

		public override function hurt(damage:Number):void {
			super.hurt(damage);

			if(damage > 0) {
				FlxG.shake(damage / 5000);
			}
		}

		public override function kill():void {
			Game.emitDebris(x, y, 200, 5);
			FlxG.shake(10);

			super.kill();

			Game.isOver = true;
		}

		/*public function checkWeapons():void {

			if(!FlxG.keys.any()) {
				fireRateCurrent = 5;
			}

			if(fireRateMin > fireRateCurrent) {
				fireRateCurrent++;
				return;
			}

			fireRateCurrent = 0;

			if(FlxG.keys.pressed("UP") && FlxG.keys.pressed("RIGHT")) { fireWeapon(45); return }
			if(FlxG.keys.pressed("UP") && FlxG.keys.pressed("LEFT")) { fireWeapon(314); return }
			if(FlxG.keys.pressed("DOWN") && FlxG.keys.pressed("RIGHT")) { fireWeapon(135); return }
			if(FlxG.keys.pressed("DOWN") && FlxG.keys.pressed("LEFT")) { fireWeapon(225); return }

			if(FlxG.keys.pressed("UP")) { fireWeapon(0); return }
			if(FlxG.keys.pressed("RIGHT")) { fireWeapon(90); return }
			if(FlxG.keys.pressed("DOWN")) { fireWeapon(180); return }
			if(FlxG.keys.pressed("LEFT")) { fireWeapon(270); return }

			fireRateCurrent = 5;
		}*/

		public function checkWeapons():void {
			if(!FlxG.keys.any()) {
				fireRateCurrent = 5;
			}

			if(fireRateMin > fireRateCurrent) {
				fireRateCurrent++;
				return;
			}

			fireRateCurrent = 0;

			if(FlxG.keys.pressed("SPACE")) {
				fireWeapon(angle);
				return;
			}

			fireRateCurrent = 5;
		}



		public function fireWeapon(angle:Number):void {
			var pos:FlxPoint = getMidpoint();
			new Projectile(pos.x, pos.y, angle, true);
		}
	}
}
