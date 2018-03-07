package com.isartdigital.shmup.game.sprites.mobile.enemy 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.mobile.enemy.Enemy;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy2;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Enemy2 extends Enemy 
	{
		var angle:Number = Math.PI / 4;
		
		public function Enemy2() 
		{
			type = 2;
			super();
			hp = 15;
			score = 300;
		}
		
		/**
		 * fait bouger  l'ennemi en alterant sa direction
		 */
		override protected function move():void 
		{
			super.move();
			
			if (y <= GameLayer.getInstance().getScreenLimits().bottom / 2.5 || y >= GameLayer.getInstance().getScreenLimits().bottom - GameLayer.getInstance().getScreenLimits().bottom / 2.5)
				angle *= -1;
			x += speed  * Math.cos(angle);
			y += speed  * Math.sin(angle);
		}
		
		/**
		 * tire une salve de balles
		 */
		override protected function shoot():void 
		{
			super.shoot();
			for (var i:int = 0; i < 6; i++)
				createShot(ShootEnemy2, collider.getChildByName("mcWeapon" + i) as MovieClip);
			SoundManager.getSound("missile").start();
			setState("fire");
		}
		
		/**
		 * lance un hit pause puis l'explosion de l'ennemi
		 */
		override protected function explode():void 
		{
			super.explode();
			GameManager.hitPause();
			SoundManager.getSound("enemyExplosion").start();
		}
	}

}