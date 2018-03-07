package com.isartdigital.utils.game 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import flash.display.Sprite;
	/**
	 * Classe de base des objets interactifs dans le jeu
	 * expose de façon publique sa méthode doAction qui peut faire référence à différentes méthodes prévues (doActionVoid, doActionNormal) ou spécifiques définies par ses classes filles
	 * Par convention le changement de référence de doAction se fait via des méthodes setMode (setModeVoid, setModeAction) qui peuvent aussi contenir des paramètres d'initialisation
	 * @author Mathieu ANTHOINE
	 */
	public class GameObject extends Sprite
	{
		
		/**
		 * méthode appelée à chaque gameLoop. Elle peut faire référence à différentes méthodes au cours du temps
		 */
		public var doAction:Function;
		
		public function GameObject() 
		{
			super();
			setModeVoid();	
		}
			
		/**
		 * applique le mode "ne fait rien"
		 */
		protected function setModeVoid (): void {
			doAction = doActionVoid;
		}
		
		/**
		 * fonction vidé destinée à maintenir la référence de doAction sans rien faire
		 */
		protected function doActionVoid (): void {}

		
		/**
		 * applique le mode normal (mode par defaut)
		 */
		protected function setModeNormal(): void {
			doAction = doActionNormal;
		}
		
		/**
		 * fonction destinée à appliquer un comportement par defaut
		 */
		protected function doActionNormal (): void 
		{
			if ( x + width / 2 < GameLayer.getInstance().getScreenLimits().left || x - width / 2 > GameLayer.getInstance().getScreenLimits().right)
			{
				destroy();
			}
		}
		
		/**
		 * Activation
		 */
		public function start (): void {
			setModeNormal();
		}
		
		/**
		 * nettoie et détruit l'instance
		 */
		public function destroy (): void {
			setModeVoid();
			if (parent != null) parent.removeChild (this);
		}

		
	}

}