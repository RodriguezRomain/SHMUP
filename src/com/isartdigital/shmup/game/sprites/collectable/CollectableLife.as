package com.isartdigital.shmup.game.sprites.collectable 
{
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class CollectableLife extends Collectable 
	{
		
		public function CollectableLife() 
		{
			super();
		}
		
		/**
		 * change l'etat du collectible et lance son son
		 */
		override public function pickedUp():void 
		{
			super.pickedUp();
			SoundManager.getSound("powerupLife").start();
		}
		
	}

}