package com.isartdigital.utils.events 
{
	import flash.events.Event;
	
	/**
	 * Classe d'Evenements associée à la classe SoundFX.
	 * @author Mathieu ANTHOINE
	 */
	public class SoundFXEvent extends Event 
	{
		
		/**
		 * diffusé à la fin de la lecture d'un son
		 */
		public static const COMPLETE:String = "complete";
		
		public function SoundFXEvent(pType:String) 
		{
			super(pType);
		}
		
		
		
	}

}