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
	public class CreditScreen extends Screen 
	{
		
		/**
		 * instance unique de la classe SpecialScreen
		 */
		protected static var instance: CreditScreen;
		
		public var btnNext:SimpleButton;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): CreditScreen {
			if (instance == null) instance = new CreditScreen();
			return instance;
		}		
	
		public function CreditScreen() 
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
			UIManager.addScreen(TitleCard.getInstance());
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