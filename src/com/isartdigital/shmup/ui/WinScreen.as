package com.isartdigital.shmup.ui 
{
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * Ecran de Victoire (Singleton)
	 * @author Mathieu ANTHOINE
	 */
	public class WinScreen extends EndScreen 
	{
		/**
		 * instance unique de la classe WinScreen
		 */
		protected static var instance: WinScreen;
		
		public function WinScreen() 
		{
			super();
			SoundManager.getSound("winJingle").start();
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): WinScreen {
			if (instance == null) instance = new WinScreen();
			return instance;
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		*/
		override public function destroy (): void {
			instance = null;
			super.destroy();
		}
		
	}

}