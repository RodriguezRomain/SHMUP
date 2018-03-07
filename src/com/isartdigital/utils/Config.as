package com.isartdigital.utils {
	import com.isartdigital.utils.loader.AssetsLoader;
	import flash.display.Stage;
	import flash.system.Capabilities;
	
	/**
	 * Classe de configuration
	 * Cette classe contient toutes les variables définies dans le fichier config.json sous forme de propriétés statiques typées.
	 * Certaines variables existent qu'elles aient été définies ou non dans le fichier. Si elles n'ont pas été définies elles prennent la valeur par défaut de la classe
	 * @author Mathieu ANTHOINE
	 */
	public class Config 
	{
		/**
		 * référence vers le stage
		 */
		public static var stage:Stage;
		
		/**
		 * version de l'application
		 */
		public static var version		:String		= "0.0.0";

		/** 
		 * chemin du dossier de langues
		 */
		public static var langPath		: String	= "";
		
		/**
		 * langue courante
		 */
		public static var language		: String;
		
		/**
		 * langues disponibles
		 */
		public static var languages		: Array;
		
		/**
		 * définit si le jeu est en mode "cheat" ou pas (si prévu dans le code du jeu)
		 */
		public static var cheat			: Boolean	= false;
		
		/**
		 * définit si le jeu est en mode "debug" ou pas (si prévu dans le code du jeu)
		 */
		public static var debug			: Boolean	= false;

		/**
		 * définit l'affichage ou non des fps
		 */
		public static var fps			: Boolean	= false;
		
		/**
		 * définit si on autorise le son ou non, les paramètres du son (noms assets, volume master, volume groupe, volume sons) sont définis dans sound.json
		 */
		public static var mainSound			: Boolean	=	true;
		
		/**
		 * force le type de controler
		 */
		public static var controlerType			: String;
		
		public function Config() {}
		
		public static function init(pFile:String,pStage:Stage=null): void {
			stage = pStage;
			
			var lJson : Object = JSON.parse(AssetsLoader.getContent(pFile).toString());
			
			for (var i:String in lJson) {
				Config[i] = lJson[i];
			}
			
			// gestion des textes localisés
			if (languages == null ||languages == []) throw "Pas de langues dans la liste des langues supportées";
			if (language == null || language == "") language = Capabilities.language.substr(0, 2);
			if (languages.indexOf(language) ==-1) language = languages[0];
		}
		
		/**
		 * Retourne une valeur transmise par le fichier config.json
		 * @return la valeur stockée dans la propriété statique dynamique
		 */
		public static function getValue (pName:String): * {
			return Config[pName];
		}
		
	}

}