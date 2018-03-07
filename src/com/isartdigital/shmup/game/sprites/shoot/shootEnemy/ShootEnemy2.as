package com.isartdigital.shmup.game.sprites.shoot.shootEnemy 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.mobile.Player;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class ShootEnemy2 extends ShootEnemy 
	{
		/**
		 * timer avant ciblage
		 */
		protected var launchTimer:Timer = new Timer(1000, 1);
		
		public function ShootEnemy2() 
		{
			damageType = 0;
			super();
			_damage = 25;
			speed = 15;
			
			launchTimer.addEventListener(TimerEvent.TIMER_COMPLETE, target);
			launchTimer.start();
		}
		
		/**
		 * change la rotation afin que le shoot soit face au joueur
		 */
		protected function target(pEvent:TimerEvent):void 
		{	
			var target:Point = new Point(Player.getInstance().x - x, Player.getInstance().y - y);
			
			rotation = Math.atan2(target.y, target.x) * 180 / Math.PI;
		}
		
		/**
		 * met le timer et l'animation de l'objet en pause
		 */
		override public function pause():void 
		{
			launchTimer.stop();
			super.pause();
		}
		
		/**
		 * relance le timer si il n'etait pas fini ansi que les animation du shoot
		 */
		override public function resume():void 
		{
			super.resume();
			if (launchTimer.currentCount < 1)
				launchTimer.start();
		}
		
		/**
		 * détruit l'objet
		 */
		override public function destroy():void 
		{
			launchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, target);
			super.destroy();
		}
		
	}

}