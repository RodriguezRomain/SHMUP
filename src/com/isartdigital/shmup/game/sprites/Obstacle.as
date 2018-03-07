package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.sprites.shoot.Shoot;
	import com.isartdigital.utils.game.StateObject;
	
	/**
	 * Classe Obstacle
	 * Cette classe hérite de la classe StateObject elle possède donc une propriété renderer représentation graphique
	 * de l'obstacle et une propriété collider servant de boite de collision de l'Obstacle
	 * @author Mathieu ANTHOINE
	 */
	public class Obstacle extends StateObject 
	{
		
		public static var list:Vector.<Obstacle> = new Vector.<Obstacle>();
		protected var isDead:Boolean = false;
		
		/**
		 * Constructeur de la classe Object
		 * @param	pAsset Nom de la classe du Generateur de l'Obstacle. Ce nom permet d'identifier l'Obstacle et le créer en conséquence
		 */
		public function Obstacle(pAsset:String) 
		{
			assetName = pAsset;
			list.push(this);
			super();
		}
		
		/**
		 * tests de collision et de fin d'animation
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (isAnimEnd())
			{
				setState("default", true);
				if (isDead)
				{
					destroy();
				}
			}
			if (!isDead)
				collisionTests();
		}
		
		/**
		 * retourne l'etat de l'obstacle
		 * @return etat de l'objet (détruit ou non)
		 */
		public function get dead():Boolean
		{
			return isDead;
		}
		
		/**
		 * teste les collisions avec les shoots
		 */
		override protected function collisionTests():void 
		{
			super.collisionTests();
			collision(Shoot);
		}
		
		/**
		 * met l'obstacle dans l'état destructible si il est destructible
		 */
		override public function hit(pDamage:int = 0):void 
		{
			super.hit(pDamage);
			if (assetName == "ObstacleB" && !isDead)
			{
				isDead = true;
				setState("explosion");
			}
		}
		
		/**
		 * detruit l'objet
		 */
		override public function destroy():void 
		{
			trace(assetName + " destroyed");
			parent.removeChild(this);
			list.splice(list.indexOf(this), 1);
			super.destroy();
		}

	}

}