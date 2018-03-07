package com.isartdigital.shmup.ui 
{
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * Classe Game OVer (Singleton)
	 * @author Mathieu ANTHOINE
	 */
	public class GameOver extends EndScreen 
	{
		/**
		 * instance unique de la classe GameOver
		 */
		protected static var instance: GameOver;
		
		public function GameOver() 
		{
			super();
			SoundManager.getSound("gameoverJingle").start();
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameOver {
			if (instance == null) instance = new GameOver();
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