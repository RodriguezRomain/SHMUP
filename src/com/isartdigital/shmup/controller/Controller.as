package com.isartdigital.shmup.controller 
{
	/**
	 * Classe définissant ce que les controleurs doivent retourner aux objets qui les manipulent
	 * @author Mathieu ANTHOINE
	 */
	public class Controller 
	{


		public static const PAD:String = "pad";
		public static const KEYBOARD:String = "keyboard";
		public static const TOUCH:String = "touch";
		
		/**
		 * type de controle actuel dans le jeu
		 */
		public static var type:String = KEYBOARD;
		
		public function Controller() 
		{
			
		}
		
		/**
		 * retourne si l'action fire est activée ou non
		 * fonction getter: est utilisé comme une propriété ( questionner fire et non fire() )
		 */
		public function get fire (): Boolean {
			return false;
		}
		
		/**
		 * retourne si l'action bomb est activée ou non
		 * fonction getter: est utilisé comme une propriété ( questionner bomb et non bomb() )
		 */
		public function get bomb (): Boolean {
			return false;
		}
		
		/**
		 * retourne si l'action special est activée ou non
		 * fonction getter: est utilisé comme une propriété ( questionner special et non special() )
		 */
		public function get special (): Boolean {
			return false;
		}
		
		/**
		 * retourne si l'action pause est activée ou non
		 * fonction getter: est utilisé comme une propriété ( questionner pause et non pause() )
		 */
		public function get pause (): Boolean {
			return false;
		}
		
		/**
		 * retourne si l'action fire est activée ou non
		 * fonction getter: est utilisé comme une propriété ( questionner god et non god() )
		 */
		public function get god (): Boolean {
			return false;
		}
		
		/**
		 * retourne la valeur actuelle l'action left qui peut prendre une valeur numérique entre 0 (pas d'action) et 1 (action maximale)
		 * fonction getter: est utilisé comme une propriété ( questionner left et non left() ) 
		 */
		public function get left (): Number {
			return 0;
		}
		
		/**
		 * retourne la valeur actuelle l'action right qui peut prendre une valeur numérique entre 0 (pas d'action) et 1 (action maximale)
		 * fonction getter: est utilisé comme une propriété ( questionner right et non right() ) 
		 */
		public function get right (): Number {
			return 0;
		}
		
		/**
		 * retourne la valeur actuelle l'action up qui peut prendre une valeur numérique entre 0 (pas d'action) et 1 (action maximale)
		 * fonction getter: est utilisé comme une propriété ( questionner up et non up() )
		 */
		public function get up (): Number {
			return 0;
		}
		
		/**
		 * retourne la valeur actuelle l'action down qui peut prendre une valeur numérique entre 0 (pas d'action) et 1 (action maximale)
		 * fonction getter: est utilisé comme une propriété ( questionner down et non down() )
		 */
		public function get down (): Number {
			return 0;
		}
		
		public function destroy (): void {
			
		}
	}

}