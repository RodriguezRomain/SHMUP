package com.isartdigital.utils.text 
{

	import com.isartdigital.utils.Config;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * Classe permettant de gérer des textes localisés
	 * Chaque instance de la classe contient un champ texte dont le contenu est automatiquement mis à jour à la création de l'instance 
	 * @author Mathieu ANTHOINE
	 */
	public class LocalizedTextField extends Sprite 
	{

		protected static var texts:XML;
		
		protected static var defaultLanguage:Boolean;
		
		public function LocalizedTextField() 
		{
			super();
			
			if (texts == null) throw Error("/!\\ Textes localisés non disponibles");
			
			var lText:TextField;
			var lContent:String;
			
			for (var i:int = 0; i < numChildren; i++) {
				if (getChildAt(i) is TextField) {
					lText = TextField(getChildAt(i));
					lContent = lText.text;
					
					if (lContent.charAt(0) == "*") lContent = lContent.substr(1);
					
					// comportement étrange du mode multiline qui ajoute un saut de ligne à la fin des chaines, pour la comparaison on le supprime
					if (lText.multiline && lContent.charAt(lContent.length-1) == "\r") lContent=lContent.substr(0, lContent.length - 1);
					
					if (defaultLanguage) lText.text = lContent;
					else {
						lText.text = texts.file.body["trans-unit"].(source==lContent).target;
					}
				}
			}
			
		}
		
		/**
		 * Initialisation de la classe
		 * @param	pTexts fichier de localisation sous forme de chaine de caractères
		 */
		public static function init(pTexts: String): void {
			defaultLanguage = Config.language == Config.languages[0];
			texts = new XML(pTexts);
		}
		
		
	}

}