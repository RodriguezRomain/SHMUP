package com.isartdigital.shmup.game.sprites.shoot.shootplayer 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.mobile.Player;
	import com.isartdigital.shmup.game.sprites.shoot.Shoot;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy;
	import com.isartdigital.shmup.ui.PopInScore;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Special extends StateObject 
	{
		
		/**
		 * instance unique de la classe Special
		 */
		protected static var instance: Special;
		
		protected static var isActive: Boolean = false;
		protected var activeTimer:Timer = new Timer(250, 1);
		
		protected var cooldown:Timer = new Timer(500, 1);
		protected var isCooling: Boolean = false;
		
		protected var color:uint = 0;
		
		protected var score:uint = 100;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Special {
			if (instance == null) instance = new Special();
			return instance;
		}		
	
		public function Special() 
		{
			super();
			start();
			
			cooldown.addEventListener(TimerEvent.TIMER_COMPLETE, endCooldown);
			activeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, endActivation);
		}
		
		/**
		 * met le special en état actif si il n'est pas en cooldown
		 */
		public function activate():void 
		{
			if (!isCooling)
			{
				isActive = true;
				setState("active");
				activeTimer.start();
				SoundManager.getSound("special").stop();
				SoundManager.getSound("special").start();
			}
		}
		
		/**
		 * retourne le spécial à l'état par defaut
		 */
		protected function endActivation(pEvent:TimerEvent):void 
		{
			isActive = false;
			setState("default");
			activeTimer.reset();
			isCooling = true;
			cooldown.start();
		}
		
		/**
		 * met fin à la période de cooldown
		 */
		protected function endCooldown(pEvent:TimerEvent):void 
		{
			isCooling = false;
			cooldown.reset();
		}
		
		/**
		 * si le spécial est actif les shoot entrant en contact avec lui sont absorbés
		 */
		override protected function doActionNormal():void 
		{
			var lShoot: ShootEnemy;
			var lCoord:Point;
			
			if (isActive)
			{
				for (var i:int = ShootEnemy.list.length - 1; i >= 0; i--)
				{
					lShoot = ShootEnemy.list[i];
					if (CollisionManager.hasCollision(hitBox, lShoot.hitBox))
					{	
						lCoord = GameLayer.getInstance().globalToLocal(localToGlobal(new Point(x, y)));
						
						GameManager.score += score;
						Hud.getInstance().scoreUpdate();
						PopInScore.createPopIn(score, lCoord.x, lCoord.y)
						
						Player.getInstance().shot = lShoot.type;
						color = Shoot.getColor(lShoot.type);
						setState("active");
						lShoot.destroy();
					}
				}
			}
		}
		
		/**
		 * change l'état de l'objet et change sa couleur selon son type
		 */
		override protected function setState(pState:String, pLoop:Boolean = false, pStart:uint = 1):void 
		{
			var lColorTransform: ColorTransform;
			
			super.setState(pState, pLoop, pStart);
			if (color != 0)
			{
				lColorTransform = new ColorTransform();
				lColorTransform.color = color
				renderer.getChildByName("mcBottom").transform.colorTransform = lColorTransform;
				renderer.getChildByName("mcTop").transform.colorTransform = lColorTransform;
			}
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy():void 
		{
			cooldown.removeEventListener(TimerEvent.TIMER_COMPLETE, endCooldown);
			activeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, endActivation);
			instance = null;
			super.destroy();
		}

	}
}