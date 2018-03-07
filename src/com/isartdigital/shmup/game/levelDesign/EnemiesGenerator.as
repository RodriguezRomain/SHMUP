package com.isartdigital.shmup.game.levelDesign 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.mobile.enemy.Boss;
	import com.isartdigital.shmup.game.sprites.mobile.enemy.Enemy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe qui permet de générer des classes d'ennemis
	 * TODO: S'inspirer de la classe ObstacleGenerator pour le développement
	 * @author Mathieu ANTHOINE
	 */
	public class EnemiesGenerator extends GameObjectsGenerator 
	{
		
		public function EnemiesGenerator() 
		{
			super();
			
		}

		/**
		 * crée l'ennemi correspondant au générateur
		 */
		override public function generate (): void {
			var lNum:String = getQualifiedClassName(this).substr( -1);
			
			var lClass:Class 
			
			if (lNum != "n")
				lClass = getDefinitionByName("com.isartdigital.shmup.game.sprites.mobile.enemy.Enemy" + lNum) as Class;
			else
			{
				lClass = Boss;
			}
			var lEnemy:Enemy = new lClass();
			
			lEnemy.x = x;
			lEnemy.y = y;
			lEnemy.start();
			parent.addChild(lEnemy);
			
			super.generate();
		}
	}

}