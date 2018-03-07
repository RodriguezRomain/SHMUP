package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.sprites.mobile.enemy.Enemy;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Shield extends StateObject 
	{
		protected static var instance: Shield;
		/**
		 * indique si le bouclier explose
		 */
		protected var isDestroyed: Boolean = false;
		/**
		 * indique si le bouclier est actif
		 */
		public var isActive:Boolean = false;
		
		public static function getInstance (): Shield {
			if (instance == null) instance = new Shield();
			return instance;
		}		
		
		public function Shield() 
		{
			super();
			SoundManager.getSound("shield").start();
		}
		
		/**
		 * verifie si les collisions et la destruction à chaque frame
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (isDestroyed && isAnimEnd())
				destroy();
			if (!isDestroyed)
				collisionTest();
		}
		
		/**
		 * effectue les tests de collision
		 */
		protected function collisionTest():void 
		{
			collision(Enemy);
			collision(Obstacle);
			collision(ShootEnemy);
		}
		
		/**
		 * met l'etat de l'objet à "explosion"
		 */
		override public function hit(pDamage:int = 0):void 
		{
			isDestroyed = true;
			setState("explosion");
			SoundManager.getSound("shieldExplosion").start();
		}
		
		/**
		 * detruit l'objet
		 */
		override public function destroy():void 
		{
			instance = null;
			super.destroy();
		}
		
	}

}