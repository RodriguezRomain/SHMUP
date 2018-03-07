package com.isartdigital.utils.ui {
	
	import com.isartdigital.utils.Config;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Classe d'Ecran
	 * Toutes Ecrans d'interface héritent de cette classe
	 * @author Mathieu ANTHOINE
	 */
	public class Screen extends Sprite 
	{
		
		public function Screen() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);

		}
		
		/**
		 * 
		 * @param	pEvent
		 */
		protected function init (pEvent:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Config.stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		/**
		 * repositionne les éléments de l'écran
		 * @param	pEvent
		 */
		protected function onResize (pEvent:Event=null): void {
			
		}
		
		/**
		 * nettoie l'instance
		 */
		public function destroy (): void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Config.stage.removeEventListener(Event.RESIZE, onResize);
		}
		
	}

}