package com.isartdigital.utils.game {
	
	import com.isartdigital.utils.Config;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Classe en charge de mettre en place la structure graphique du jeu (conteneurs divers)
	 * et la gestion du redimensionnement de la zone de jeu en fonction du contexte
	 * @author Mathieu ANTHOINE
	 */
	public class GameStage extends Sprite 
	{
		
		/**
		 * instance unique de la classe GameStage
		 */
		protected static var instance: GameStage;
		
		/**
		 * largeur minimum pour le contenu visible
		 */
		public static const SAFE_ZONE_WIDTH: int = 2048;

		/**
		 * hauteur minimum pour le contenu visible
		 */
		public static const SAFE_ZONE_HEIGHT: int = 1366;
		
		/**
		 * conteneur des pop-in
		 */
		protected var popinContainer:Sprite;
		
		/**
		 * conteneur du Hud
		 */
		protected var hudContainer:Sprite;
		
		/**
		 * conteneur des écrans d'interface
		 */
		protected var screensContainer:Sprite;
		
		/**
		 * conteneur du jeu
		 */
		protected var gameContainer:Sprite;
		
		public function GameStage() 
		{
			super();	
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameStage {
			if (instance == null) instance = new GameStage();
			return instance;
		}
		
		public function init (pCallBack:Function): void {
			
			gameContainer = new Sprite();
			
			addChild(gameContainer);
			
			hudContainer = new Sprite();
			addChild(hudContainer);
			
			screensContainer = new Sprite();
			addChild(screensContainer);
			screensContainer.x = SAFE_ZONE_WIDTH / 2;
			screensContainer.y = SAFE_ZONE_HEIGHT / 2;
			
			popinContainer = new Sprite();
			addChild(popinContainer);
			popinContainer.x = SAFE_ZONE_WIDTH / 2;
			popinContainer.y = SAFE_ZONE_HEIGHT / 2;
			
			Config.stage.addEventListener(Event.RESIZE, resize);
			resize();
			
			pCallBack();
			
		}
		
		/**
		 * Redimensionne la scène du jeu en fonction de la taille disponible pour l'affichage
		 * @param	pEvent
		 */
		protected function resize (pEvent:Event=null): void {
			
			var lRatio:Number = Math.round(10000 * Math.min(Config.stage.stageWidth / SAFE_ZONE_WIDTH, Config.stage.stageHeight / SAFE_ZONE_HEIGHT)) / 10000;
			
			scaleX = scaleY = lRatio;
			
			x = (Config.stage.stageWidth-SAFE_ZONE_WIDTH*scaleX) / 2;
			y = (Config.stage.stageHeight - SAFE_ZONE_HEIGHT * scaleY) / 2;
			
		}
		
		/**
		 * accès en lecture au conteneur de jeu
		 * @return gameContainer
		 */
		public function getGameContainer (): Sprite {
			return gameContainer;
		}
		
		/**
		 * accès en lecture au conteneur d'écrans
		 * @return screensContainer
		 */
		public function getScreensContainer (): Sprite {
			return screensContainer;
		}
		
		/**
		 * accès en lecture au conteneur de hud
		 * @return hudContainer
		 */
		public function getHudContainer (): Sprite {
			return hudContainer;
		}
		
		/**
		 * accès en lecture au conteneur de PopIn
		 * @return popinContainer
		 */
		public function getPopInContainer (): Sprite {
			return popinContainer;
		}
				
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		public function destroy (): void {
			Config.stage.removeEventListener(Event.RESIZE, resize);
			instance = null;
		}

	}
}