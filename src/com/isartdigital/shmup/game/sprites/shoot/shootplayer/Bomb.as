package com.isartdigital.shmup.game.sprites.shoot.shootplayer 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.mobile.enemy.Enemy;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy;
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Bomb extends ShootPlayer 
	{
		/**
		 * inflige des dégats aux ennemis, détruit leurs shoots et lance l'animation de la bombe
		 */
		public function Bomb(pType:int=-1) 
		{
			super(pType);
			_damage = 20;
			speed = 0;
			
			for (var i:int = Enemy.list.length - 1; i >= 0; i--)
			{
				Enemy.list[i].hit(damage);
			}
			for (i = ShootEnemy.list.length - 1; i >= 0; i--)
			{
				ShootEnemy.list[i].hit();
			}
			alpha = 0.5;
			scaleX = 2;
			scaleY = 2;
			GameLayer.getInstance().startShake();
			SoundManager.getSound("bomb").start();
			renderer.play();
		}
		
		/**
		 * detruit la bombe lorsque son animation est finie
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (isAnimEnd())
			{
				destroy();
			}
		}
		
	}

}