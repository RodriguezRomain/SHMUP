package com.isartdigital.shmup.game.sprites.collectable 
{
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class CollectableBomb extends Collectable 
	{
		
		public function CollectableBomb() 
		{
			super();
			
		}
		
		/**
		 * change l'etat du collectible et lance son son
		 */
		override public function pickedUp():void 
		{
			super.pickedUp();
			SoundManager.getSound("powerupBomb").start();
		}
		
	}

}