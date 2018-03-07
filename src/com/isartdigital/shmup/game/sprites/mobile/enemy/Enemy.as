package com.isartdigital.shmup.game.sprites.mobile.enemy 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.shmup.game.sprites.collectable.Collectable;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableBomb;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableFirePower;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableFireUpgrade;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableLife;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableShield;
	import com.isartdigital.shmup.game.sprites.mobile.Mobile;
	import com.isartdigital.shmup.game.sprites.shoot.Shoot;
	import com.isartdigital.shmup.game.sprites.shoot.shootplayer.ShootPlayer;
	import com.isartdigital.shmup.ui.PopInScore;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Enemy extends Mobile
	{
		public static var list:Vector.<Enemy> = new Vector.<Enemy>();
		
		/**
		 * type de l'ennemi
		 */
		protected var type:int;
		
		/**
		 * score que vaut l'ennemi
		 */
		protected var score:uint;
		
		/**
		 * indique si le collectible à été ramassé
		 */
		protected var collectableRolled: Boolean = false;
		
		public function Enemy() 
		{
			super();
			list.push(this);
			speed = 5;
		}
		
		/**
		 * lance les actions du super puis tire si l'ennemi n'est pas en cooldown
		 */
		override protected function gameActions():void 
		{
			super.gameActions();
			if (!isCooling)
				{
					shoot();
				}
		}
		
		/**
		 * bouge l'ennemi vers l'avant
		 */
		override protected function move():void 
		{
			super.move();
			x -= speed;
		}
		
		/**
		 * met à jour le score, crée un popin de score et met l'ennemi à l'état explosion
		 */
		override protected function explode():void 
		{	
			GameManager.score += score;
			Hud.getInstance().scoreUpdate();
			PopInScore.createPopIn(score, x, y);
			super.explode();
		}
		
		/**
		 * lance la prise de dégat et crée un collectible si ça n'a pas deja été fait
		 */
		override public function hit(pDamage:int = 0):void 
		{
			super.hit(pDamage);
			if (hp <= 0 && !collectableRolled)
			{
				Collectable.spawn(x,y);
				collectableRolled = true;
			}
		}
		
		/**
		 * detruit l'ennemi
		 */
		override public function destroy():void 
		{
			list.splice(list.indexOf(this), 1);
			super.destroy();
		}
		
		/**
		 * effectue les tests de collisions
		 */
		override protected function collisionTests():void 
		{
			var lShoot:ShootPlayer;
			
			for (var i:int = ShootPlayer.list.length - 1; i >= 0; i--)
			{
				lShoot = ShootPlayer.list[i];
				if (CollisionManager.hasCollision(hitBox, lShoot.hitBox, hitBoxes, lShoot.hitPoints) && !lShoot.dead)
				{
					if (lShoot.type == type)
					{
						hit(lShoot.damage * 2);
					}
					else
						hit(lShoot.damage);
					lShoot.hit();
				}
			}
			collision(Obstacle,9);
		}
		
	}

}