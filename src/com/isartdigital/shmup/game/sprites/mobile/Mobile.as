package com.isartdigital.shmup.game.sprites.mobile 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.shoot.Shoot;
	import com.isartdigital.shmup.game.sprites.shoot.shootplayer.ShootPlayer;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Mobile extends StateObject 
	{
		protected var speed:Number;
		protected var hp:int;
		protected var shootLevel:int = 0;
		protected var shotType:int = -1;
		protected var weaponCooldown:Timer = new Timer(2000, 1);
		protected var isCooling:Boolean = false;
		protected var isDead:Boolean = false;
		
		public function Mobile() 
		{
			super();
			weaponCooldown.addEventListener(TimerEvent.TIMER_COMPLETE, endCooldown);
		}
		
		/**
		 * actions de l'objet mobile à chaque frames
		 */
		override protected function doActionNormal():void 
		{
			if (!isDead)
			{
				gameActions();
			}
			else if (isAnimEnd()) 
			{
				isKilled();
			}
		}
		
		/**
		 * effectue les mouvements et les tests de collisions
		 */
		protected function gameActions():void 
		{
			if (isAnimEnd())
			{
				setState("default", true);
			}
			move();
			super.doActionNormal();
			collisionTests();
		}
		
		/**
		 * compense les mouvements du GameLayer
		 */
		protected function move():void 
		{
			x += GameLayer.getInstance().speed;
		}
		
		/**
		 * lance le cooldown de tir
		 */
		protected function shoot():void 
		{
			weaponCooldown.start();
			isCooling = true;
		}
		
		/**
		 * crée un shoot et met sa rotation à celle de la weapon
		 * @param Class du shoot
		 * @param weapon tirant le shoot
		 */
		protected function createShot(pClass:Class, pWeapon:MovieClip):Shoot
		{
			var lShoot:Shoot;
			var lGlobalCoord:Point;
			var lLocalCoord:Point;
			var lWeapon:MovieClip;
			
			lShoot = new pClass();
			lGlobalCoord = localToGlobal(new Point(pWeapon.x, pWeapon.y));
			lLocalCoord = parent.globalToLocal(lGlobalCoord);
			lShoot.x = lLocalCoord.x + pWeapon.width;
			lShoot.y = lLocalCoord.y;
			lShoot.rotation = pWeapon.rotation;
			lShoot.start();
			GameLayer.getInstance().addChildAt(lShoot, 1);
			return (lShoot);
		}
		
		/**
		 * détruit l'objet
		 */
		protected function isKilled():void 
		{
			destroy();
		}
		
		/**
		 * inflige les dégats en parametres, si l'objet à toujours des hp il est mis en état hurt sinon en état explosion
		 */
		override public function hit(pDamage:int = 0):void 
		{
			super.hit(pDamage);
			hp -= pDamage
			if (hp > 0)
				setState("hurt");
			if (hp <= 0 && !isDead)
			{
				isDead = true;
				explode();
			}
		}
		
		/**
		 * lance l'explosion de l'objet
		 */
		protected function explode():void 
		{
			setState("explosion");
		}
		
		/**
		 * retourne une variable indiquant si l'objet est mort ou non
		 */
		public function get dead():Boolean
		{
			return isDead;
		}
		
		/**
		 * met fin au cooldown
		 */
		protected function endCooldown(pEvent:TimerEvent):void 
		{
			isCooling = false;
			weaponCooldown.reset();
		}
		
		/**
		 * met le cooldown et les animations en pause
		 */
		override public function pause():void 
		{
			weaponCooldown.stop();
			super.pause();
		}
		
		/**
		 * relance le cooldown et les animations
		 */
		override public function resume():void 
		{
			super.resume();
			if (isCooling)
				weaponCooldown.start();
		}
		
		/**
		 * détruit l'objet
		 */
		override public function destroy():void 
		{
			weaponCooldown.removeEventListener(TimerEvent.TIMER_COMPLETE, endCooldown);
			super.destroy();
		}
	}

}