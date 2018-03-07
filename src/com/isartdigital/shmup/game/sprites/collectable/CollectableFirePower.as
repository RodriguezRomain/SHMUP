package com.isartdigital.shmup.game.sprites.collectable 
{
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class CollectableFirePower extends Collectable 
	{
		
		public function CollectableFirePower() 
		{
			super();
			
		}
		
		/**
		 * change l'etat du collectible et lance son son
		 */
		override public function pickedUp():void 
		{
			super.pickedUp();
			SoundManager.getSound("powerupFirePower").start();
		}
		
	}

}