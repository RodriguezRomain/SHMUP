package com.isartdigital.shmup.ui 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class SpecialScreen extends Screen 
	{
		
		/**
		 * instance unique de la classe SpecialScreen
		 */
		protected static var instance: SpecialScreen;
		
		public var btnNext:SimpleButton;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): SpecialScreen {
			if (instance == null) instance = new SpecialScreen();
			return instance;
		}		
	
		public function SpecialScreen() 
		{
			super();
			
		}
		
		override protected function init(pEvent:Event):void 
		{
			super.init(pEvent);
			btnNext.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick (pEvent:MouseEvent) : void {
			SoundManager.getSound("click").start();
			GameManager.start();
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy():void 
		{
			instance = null;
			super.destroy();
		}

	}
}