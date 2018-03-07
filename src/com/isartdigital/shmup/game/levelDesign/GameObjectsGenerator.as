package com.isartdigital.shmup.game.levelDesign 
{
	import com.isartdigital.utils.Config;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe mère des générateurs d'objets dans le levelDesign
	 * @author Mathieu ANTHOINE
	 */
	public class GameObjectsGenerator extends MovieClip 
	{
		
		public function GameObjectsGenerator() 
		{
			super();
			if (!Config.debug) visible = false;
		}
		
		/**
		 * TODO: Fonction qui doit être appelée quand on souhaite générer des GameObjects dans le GameLayer
		 * Faire en sorte que le GameLayer teste quand les Generator doivent s'activer
		 * l'idéal serait quelques centaines de pixels avant le bord droit de l'écran
		 */
		public function generate (): void {
			trace ("GENERATE", getQualifiedClassName(this));
			destroy();
		}
		
		public function destroy (): void {
			parent.removeChild(this);
		}
		
		
		
	}

}