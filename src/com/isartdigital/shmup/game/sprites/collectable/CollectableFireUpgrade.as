package com.isartdigital.shmup.game.sprites.collectable 
{
	import com.isartdigital.utils.sound.SoundManager;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class CollectableFireUpgrade extends Collectable 
	{
		
		public function CollectableFireUpgrade() 
		{
			super();
		}
		
		/**
		 * change l'etat du collectible et lance son son
		 */
		override public function pickedUp():void 
		{
			super.pickedUp();
			SoundManager.getSound("powerupFireUpgrade").start();
		}
	}

}