package com.isartdigital.shmup.ui 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class PauseScreen extends Screen 
	{
		
		/**
		 * instance unique de la classe PauseScreen
		 */
		protected static var instance: PauseScreen;
		
		public var btnResume:SimpleButton;
		public var btnQuit:SimpleButton;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): PauseScreen {
			if (instance == null) instance = new PauseScreen();
			return instance;
		}		
	
		public function PauseScreen() 
		{
			super();
			
		}
		
		override protected function init(pEvent:Event):void
		{
			super.init(pEvent);
			btnResume.addEventListener(MouseEvent.CLICK, onClickResume);
			btnQuit.addEventListener(MouseEvent.CLICK, onClickQuit);
		}
		
		protected function onClickResume(pEvent:MouseEvent):void 
		{
			GameManager.resume();
			UIManager.closeScreens();
			SoundManager.getSound("click").start();
		}
		
		protected function onClickQuit(pEvent:MouseEvent):void 
		{
			while (GameStage.getInstance().getHudContainer().numChildren > 0) {
				GameStage.getInstance().getHudContainer().removeChildAt(0);
			}
			SoundManager.getSound("levelLoop").stop();
			SoundManager.getSound("ambienceLoop").stop();
			UIManager.addScreen(TitleCard.getInstance());
			GameManager.destroy();
			SoundManager.getSound("click").start();
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy():void
		{
			btnResume.removeEventListener(MouseEvent.CLICK, onClickResume);
			btnQuit.removeEventListener(MouseEvent.CLICK, onClickQuit);
			instance = null;
			super.destroy();
		}

	}
}