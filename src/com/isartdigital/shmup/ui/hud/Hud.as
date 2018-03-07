package com.isartdigital.shmup.ui.hud 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.sprites.mobile.Player;
	import com.isartdigital.shmup.ui.PauseScreen;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Classe en charge de gérer les informations du Hud
	 * @author Mathieu ANTHOINE
	 */
	public class Hud extends Screen 
	{
		
		/**
		 * instance unique de la classe Hud
		 */
		protected static var instance: Hud;
		
		public var mcTopLeft:MovieClip;
		public var mcTopCenter:MovieClip;
		public var mcTopRight:MovieClip;
		public var mcBottomRight:MovieClip;
		
		protected var score:TextField;
	
		public function Hud() 
		{
			super();
			if (!Config.debug && Controller.type != Controller.TOUCH) {
				removeChild(mcBottomRight);
				mcBottomRight = null;
			}
			mcTopRight.btnPause.addEventListener(MouseEvent.CLICK, btnClick);
			mcTopRight.mcGuide1.visible = false;
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Hud {
			if (instance == null) instance = new Hud();
			return instance;
		}
		
		/**
		 * lance ou arrete la pause à l'appui sur le bouton du hud
		 */
		protected function btnClick(pEvent:MouseEvent):void 
		{
			if (GameManager.pauseState)
			{
				UIManager.closeScreens();
				GameManager.resume();
			}
			else
			{
				UIManager.addScreen(PauseScreen.getInstance());
				GameManager.pause();
			}
			SoundManager.getSound("click").start();
		}
		
		/**
		 * met à jour les éléments du hud
		 */
		public function update():void 
		{
			hp();
			bombs();
		}
		
		/**
		 * met à jour le score
		 */
		public function scoreUpdate():void
		{
			TweenLite.to(Hud.getInstance().mcTopCenter, 0.5, {scaleX:2, scaleY:2, colorTransform:{color:0xFFFFFF, tintAmount:1},  onComplete:revertLook});
			mcTopCenter.txtScore.text = GameManager.score;
		}
		
		protected function revertLook():void 
		{
			TweenLite.to(Hud.getInstance().mcTopCenter, 0.5, {scaleX:1, scaleY:1, colorTransform:{color:0xCCAF07}})
		}
		
		/**
		 * met à jour la barre de vie
		 */
		protected function hp():void 
		{
			var lHpBar:MovieClip = mcTopLeft.mcHealthBar.mcBar;
			
			TweenLite.to(lHpBar, 1, {x:0 - (lHpBar.width + lHpBar.width * (0 - Player.getInstance().health / 100))});
		}
		
		/**
		 * met à jour les icones de bombes
		 */
		protected function bombs():void 
		{
			var lClip:MovieClip;
			
			mcTopLeft.mcGuide0.visible = false;
			mcTopLeft.mcGuide1.visible = false;
			if (Player.getInstance().bombs > 0)
			{
				mcTopLeft.mcGuide0.visible = true;
				if (Player.getInstance().bombs > 1)
					mcTopLeft.mcGuide1.visible = true;
			}
		}
		
		/**
		 * repositionne les éléments du Hud
		 * @param	pEvent
		 */
		override protected function onResize (pEvent:Event=null): void {
			UIManager.setPosition(mcTopLeft, UIPosition.TOP_LEFT);
			UIManager.setPosition(mcTopCenter, UIPosition.TOP);
			UIManager.setPosition(mcTopRight, UIPosition.TOP_RIGHT);
			if (mcBottomRight!=null) UIManager.setPosition(mcBottomRight, UIPosition.BOTTOM_RIGHT);
		}

		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			mcTopRight.btnPause.removeEventListener(MouseEvent.CLICK, btnClick);
			instance = null;
			super.destroy();
		}

	}
}