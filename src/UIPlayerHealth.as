package {

	import flash.display.Sprite;

	public class UIPlayerHealth extends Sprite {

		public static var instance:UIPlayerHealth;

		public var health:Number = 0;
		public var maxHealth:Number = 0;

		public var baseW:Number = 150;
		public var baseH:Number = 24;
		public var padding:Number = 5;

		public function UIPlayerHealth() {
			instance = this;
		}

		public static function updateHealth(health:Number, maxHealth:Number):void {
			instance.health = health;
			instance.maxHealth = maxHealth;
			instance.redraw();
		}

		public function redraw():void {

			var percent:Number = health / maxHealth;

			graphics.beginFill(0x33333);
			graphics.drawRect(0, 0, baseW, baseH);
			graphics.endFill();

			var innerW:Number = baseW - (padding * 2);
			var innerH:Number = baseH - (padding * 2);


			graphics.beginFill(0x000000);
			graphics.drawRect(padding, padding, innerW, innerH);
			graphics.endFill();

			graphics.beginFill(0xFF0000);
			graphics.drawRect(padding, padding, innerW * percent, innerH);
			graphics.endFill();

		}
	}
}
