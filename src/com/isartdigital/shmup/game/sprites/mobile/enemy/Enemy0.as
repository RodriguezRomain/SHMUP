package com.isartdigital.shmup.game.sprites.mobile.enemy 
{
	import com.isartdigital.shmup.game.sprites.mobile.Mobile;
	import com.isartdigital.shmup.game.sprites.mobile.enemy.Enemy;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy0;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Enemy0 extends Enemy 
	{
		var angleMove:Number = 0;
		
		public function Enemy0() 
		{	
			type = 0;
			super();
			hp = 3;
			score = 100;
		}
		
		/**
		 * fait bouger l'énnemi de façon circulaire
		 */
		override protected function move():void 
		{
			super.move();
			if (angleMove == 2 * Math.PI)
				angleMove = 0;
			x += speed * Math.cos(angleMove);
			y += speed * Math.sin(angleMove);
			angleMove += Math.PI / 100;
		}
		
		/**
		 * lance l'explosion de l'énnemi
		 */
		override protected function explode():void 
		{
			super.explode();
			SoundManager.getSound("enemy0Explosion" + Math.floor(Math.random() * 4)).start();
		}
	}

}