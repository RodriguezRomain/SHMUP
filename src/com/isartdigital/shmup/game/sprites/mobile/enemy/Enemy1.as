package com.isartdigital.shmup.game.sprites.mobile.enemy 
{
	import com.isartdigital.shmup.game.sprites.mobile.enemy.Enemy;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy1;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Enemy1 extends Enemy 
	{
		var moveTimer:Timer = new Timer(2000, 0);
		var ascending:Boolean = false;
		
		public function Enemy1() 
		{
			type = 1;
			super();
			weaponCooldown.delay = 1000;
			hp = 10;
			score = 200;
			moveTimer.addEventListener(TimerEvent.TIMER, changeDir);
			moveTimer.start();
		}
		
		/**
		 * bouge l'énnemi verticalement en alternant la direction
		 */
		override protected function move():void 
		{
			super.move();
			if (ascending)
			{
				y -= speed;
			}
			else
			{
				y += speed;
			}
		}
		
		/**
		 * change la direction du mouvement
		 */
		protected function changeDir(pEvent:TimerEvent):void 
		{
			if (ascending)
				ascending = false;
			else
				ascending = true;
		}
		
		/**
		 * tire une salve de balles
		 */
		override protected function shoot():void 
		{
			super.shoot();
			for (var i:int = 0; i < 3; i++)
				createShot(ShootEnemy1, collider.getChildByName("mcWeapon" + i) as MovieClip);
			SoundManager.getSound("enemyShoot").start();
			setState("fire");
		}
		
		/**
		 * lance l'explosion de l'énnemi
		 */
		override protected function explode():void 
		{
			super.explode();
			SoundManager.getSound("enemyExplosion").start();
		}
		
	}

}