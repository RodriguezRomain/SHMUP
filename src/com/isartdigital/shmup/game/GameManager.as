package com.isartdigital.shmup.game {
	
	import com.isartdigital.shmup.Shmup;
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.controller.ControllerKey;
	import com.isartdigital.shmup.controller.ControllerPad;
	import com.isartdigital.shmup.controller.ControllerTouch;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.layers.ScrollingLayer;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.shmup.game.sprites.collectable.Collectable;
	import com.isartdigital.shmup.game.sprites.mobile.Player;
	import com.isartdigital.shmup.game.sprites.mobile.enemy.Enemy;
	import com.isartdigital.shmup.game.sprites.shoot.Shoot;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy;
	import com.isartdigital.shmup.game.sprites.shoot.shootplayer.ShootPlayer;
	import com.isartdigital.shmup.ui.GameOver;
	import com.isartdigital.shmup.ui.PauseScreen;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.shmup.ui.WinScreen;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.Monitor;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.game.StateObject;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Manager (Singleton) en charge de gérer le déroulement d'une partie
	 * @author Mathieu ANTHOINE
	 */
	public class GameManager
	{
		/**
		 * jeu en pause ou non
		 */
		protected static var isPause:Boolean = true;
		protected static var lastPause:Boolean = false;
		
		/**
		 * compte le nombre de frames durant la hit pause
		 */
		protected static var hitPauseCount:int = 0;
		protected static var hitPauseFrames:int = 15;
		protected static var isHitPause:Boolean = false;
		
		/**
		 * score actuel du joueur
		 */
		public static var score:uint = 0;
		
		/**
		 * controlleur
		 */
		protected static var controller:Controller;
		
		protected static var scrollingLayers:Vector.<ScrollingLayer> = new Vector.<ScrollingLayer>();

		public function GameManager() { }

		/**
		 * Démarre le jeu
		 */
		public static function start (): void {
			// Lorsque la partie démarre, le type de controleur déterminé est actionné
			if (Controller.type == Controller.PAD) controller = ControllerPad.getInstance();
			else if (Controller.type == Controller.TOUCH) controller = ControllerTouch.getInstance();
			else controller = ControllerKey.getInstance();

			Monitor.getInstance().addButton("Game Over",cheatGameOver);
			Monitor.getInstance().addButton("Win", cheatWin);
			Monitor.getInstance().addButton("Colliders", cheatCollider);
			Monitor.getInstance().addButton("Renderers", cheatRenderer);

			UIManager.startGame();
			
			// TODO: votre code d'initialisation commence ici
			var lClass:Class = getDefinitionByName("Background1") as Class;
			var lScollingLayer:ScrollingLayer;
			
			GameStage.getInstance().getGameContainer().addChild(lScollingLayer = new lClass());
			lScollingLayer.init(0.5, GameLayer.getInstance());
			lScollingLayer.start();
			scrollingLayers.push(lScollingLayer);
			
			
			lClass = getDefinitionByName("Background2") as Class;
			GameStage.getInstance().getGameContainer().addChild(lScollingLayer = new lClass());
			lScollingLayer.init(0.6, GameLayer.getInstance())
			lScollingLayer.start();
			scrollingLayers.push(lScollingLayer);
			
			
			GameStage.getInstance().getGameContainer().addChild(GameLayer.getInstance());
			GameLayer.getInstance().init(5);
			GameLayer.getInstance().start();
			scrollingLayers.push(GameLayer.getInstance());
			
			GameLayer.getInstance().addChild(Player.getInstance());
			Player.getInstance().x = GameLayer.getInstance().getScreenLimits().right / 3;
			Player.getInstance().y = GameLayer.getInstance().getScreenLimits().bottom / 2;
			Player.getInstance().start();
			
			lClass = getDefinitionByName("Foreground") as Class;
			GameStage.getInstance().getGameContainer().addChild(lScollingLayer = new lClass());
			lScollingLayer.init(1.25, GameLayer.getInstance());
			lScollingLayer.start();
			scrollingLayers.push(lScollingLayer);
			
			Collectable.init();
			resume();
			
			SoundManager.getSound("uiLoop").stop();
			SoundManager.getSound("levelLoop").loop();
			SoundManager.getSound("ambienceLoop").loop();
			
			Shmup.getInstance().stage.quality = StageQuality.MEDIUM;
			
			Config.stage.addEventListener(KeyboardEvent.KEY_DOWN, shortcuts);
		}
		
		// ==== Mode Cheat =====
		
		protected static function cheatCollider (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			if (StateObject.colliderAlpha < 1) StateObject.colliderAlpha = 1; else StateObject.colliderAlpha = 0;
		}
		
		protected static function cheatRenderer (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			if (StateObject.rendererAlpha < 1) StateObject.rendererAlpha = 1; else StateObject.rendererAlpha = 0;
		}
		
		protected static function cheatGameOver (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			Player.getInstance().destroy();
			gameOver();
		}
		
		protected static function cheatWin (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			win();
		}
		
		/**
		 * ammene le joueur au point du niveau correspondant a la touche appuyée
		 */
		protected static function shortcuts(pEvent:KeyboardEvent):void 
		{
			if (pEvent.charCode == Keyboard.B && Player.getInstance().x < 28500)
			{
				GameStage.getInstance().x = -27000;
				Player.getInstance().x = 27174;
			}
		}
		
		/**
		 * boucle de jeu (répétée à la cadence du jeu en fps)
		 * @param	pEvent
		 */
		protected static function gameLoop (pEvent:Event): void {
			// TODO: votre code de gameloop commence ici
			UIManager.update();
			
			for (var i:int = 0; i < scrollingLayers.length; i++)
			{
				scrollingLayers[i].doAction();
			}
			Player.getInstance().doAction();
			for (i = Obstacle.list.length - 1; i >= 0; i--)
				Obstacle.list[i].doAction();
			for (i = Enemy.list.length - 1; i >= 0; i--)
				Enemy.list[i].doAction();
			for (i = Shoot.list.length - 1; i >= 0; i--)
				Shoot.list[i].doAction();
			for (i = Collectable.list.length - 1; i >= 0; i--)
			{
				Collectable.list[i].doAction();
			}
			if (controller.pause && !lastPause)
			{
				UIManager.addScreen(PauseScreen.getInstance());
				pause();
			}
			lastPause = controller.pause;
		}

		/**
		 * pause le jeu et affiche l'écran de game over
		 */
		public static function gameOver ():void {
			pause();
			UIManager.addScreen(GameOver.getInstance());
		}
		
		/**
		 * pause le jeu et affiche l'écran de victoire
		 */
		public static function win():void {
			pause();
			UIManager.addScreen(WinScreen.getInstance());
		}
		
		/**
		 * met le jeu en pause
		 */
		public static function pause (): void {
			if (!isPause) {
				isPause = true;
				Player.getInstance().pause();
				for (var i:int = Obstacle.list.length - 1; i >= 0; i--)
					Obstacle.list[i].pause();
				for (i = Enemy.list.length - 1; i >= 0; i--)
					Enemy.list[i].pause();
				for (i = ShootPlayer.list.length - 1; i >= 0; i--)
					ShootPlayer.list[i].pause();
				for (i = ShootEnemy.list.length - 1; i >= 0; i--)
				{
					ShootEnemy.list[i].pause();
				}
				for (i = Collectable.list.length - 1; i >= 0; i--)
				{
					Collectable.list[i].pause();
				}
				Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
				Config.stage.addEventListener(Event.ENTER_FRAME, pauseLoop);
			}
			lastPause = controller.pause;
		}
		
		/**
		 * verifie si le jeu est toujours en pause
		 */
		static protected function pauseLoop(pEvent:Event):void 
		{
			if (isHitPause)
			{
				hitPause();
			}
			else if (controller.pause && !lastPause)
			{
				UIManager.closeScreens();
				resume();
			}
			lastPause = controller.pause;
		}
		
		/**
		 * redémarre le jeu après une pause
		 */
		public static function resume (): void {
			// donne le focus au stage pour capter les evenements de clavier
			Config.stage.focus = Config.stage;
			if (isPause) {
				isPause = false;
				Player.getInstance().resume();
				for (var i:int = Obstacle.list.length - 1; i >= 0; i--)
					Obstacle.list[i].resume();
				for (i = Enemy.list.length - 1; i >= 0; i--)
					Enemy.list[i].resume();
				for (i = ShootPlayer.list.length - 1; i >= 0; i--)
					ShootPlayer.list[i].resume();
				for (i = ShootEnemy.list.length - 1; i >= 0; i--)
					ShootEnemy.list[i].resume();
				for (i = Collectable.list.length - 1; i >= 0; i--)
					Collectable.list[i].resume();
				Config.stage.addEventListener (Event.ENTER_FRAME, gameLoop);
				Config.stage.removeEventListener(Event.ENTER_FRAME, pauseLoop);
			}
			lastPause = controller.pause;
		}
		
		/**
		 * lance la hitpause
		 */
		public static function hitPause():void 
		{
			pause();
			isHitPause = true;
			if (hitPauseCount == hitPauseFrames)
			{
				resume();
				hitPauseCount = 0;
				isHitPause = false;
			}
			else
				hitPauseCount++;
		}
		
		/**
		 * determine si le jeu est en pause ou non
		 * @return etat de la pause
		 */
		static public function get pauseState():Boolean
		{
			return isPause;
		}
		
		/**
		 * détruit l'instance unique, met sa référence interne à null et détruit les éléments du jeu
		 */
		public static function destroy (): void {
			score = 0;
			Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
			Config.stage.removeEventListener(Event.ENTER_FRAME, pauseLoop);
			Monitor.getInstance().clear();
			GameLayer.getInstance().destroy();
			while (GameStage.getInstance().getGameContainer().numChildren > 0)
			{
				GameStage.getInstance().getGameContainer().removeChildAt(0);
			}
			
			Shmup.getInstance().stage.quality = StageQuality.HIGH;
		}

	}
}