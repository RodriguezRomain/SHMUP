package com.isartdigital.utils.loader {

	import com.isartdigital.utils.events.AssetsLoaderEvent;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * Classe de chargement
	 * Cette classe permet de gérer des chargements par lot aussi bien de fichiers textes que de ressources swf ou image
	 * @author Mathieu ANTHOINE
	 */
	public class AssetsLoader extends Sprite {
		
		/**
		 * liste des fichiers chargés
		 */
		protected static var filesLoaded:Object={};
		
		/**
		 * liste des fichiers à charger
		 */
		protected var files:Array;
		
		/**
		 * objet de chargement en cours
		 */
		protected var current:Object;
		
		/**
		 * indice de chargement courant
		 */
		protected var loadingInd : int;
		
		/**
		 * nombre de fichier à charger (initialisé à chaque chargement)
		 */
		protected var nbFiles : int;
		
		/**
		* retourne le contenu chargé pour le chemin de fichier passé en paramètre
		* @param	pFile chemin du fichier
		* @return	contenu du fichier pour un URLLoader, référence d'objet pour un Loader ou undefined si le contenu n'est pas chargé
		*/
		public static function getContent (pFile:String):Object {
			var lAsset : Object  = filesLoaded[pFile];
			
			if (lAsset==null) return null;
			else if (lAsset is URLLoader) return lAsset.data;
			else return lAsset.content;
		}
		
		public function AssetsLoader () {
			files=[];
		}	
		
		/**
		* ajoute un fichier de type texte à la liste de chargement
		* @param	pUrl chaine de caractères spécifiant le nom du fichier
		*/
		public function addTxtFile (pUrl:String):void {

			trace("Loader::addTxtFile "+pUrl);
			
			var lLoader:URLLoader= new URLLoader();
			lLoader.dataFormat=URLLoaderDataFormat.TEXT;
			
			lLoader.addEventListener(Event.COMPLETE,currentLoadComplete);
			lLoader.addEventListener(IOErrorEvent.IO_ERROR , onLoadIOError);
			
			files.push( { name:pUrl, loader:lLoader} );	
			
		}
		
		/**
		* ajoute un fichier de type Display à la liste de chargement
		* @param	pUrl chaine de caractère spécifiant le nom du fichier
		*/
		public function addDisplayFile (pUrl:String):void {
			
			trace("Loader::addDisplayFile = "+pUrl);

			var lLoader:Loader= new Loader();

			lLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,currentLoadComplete);
			lLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR ,onLoadIOError);
			
			files.push( { name:pUrl, loader:lLoader } );
		}
		

		/**
		* propage l'évenement diffusé par les loaders
		* @param	pEvent
		*/
		protected function currentLoadComplete (pEvent:Event = null):void {
			
			trace("load complete = "+current.name);
			
			filesLoaded[current.name] = current.loader;
			
			var lLoader:EventDispatcher = current.loader;
			
			if (lLoader is URLLoader) {
				URLLoader(lLoader).removeEventListener(Event.COMPLETE, currentLoadComplete);
				URLLoader(lLoader).removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
			} else {
				Loader(lLoader).contentLoaderInfo.removeEventListener(Event.COMPLETE, currentLoadComplete);
				Loader(lLoader).contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
			}
			
			dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.CURRENT_COMPLETE, current.name));
			
			current=null;
			
			loadNext();
		}
		
		/**
		 * déclenché si erreur pendant le chargement
		 * Cette méthode est réduite à sa plus simple expression, dans un Loader solide, il faudrait traiter les différents cas et par exemple poursuivre le chargement quand c'est possible
		 * @param	pEvent Erreur IO
		 */
		public function onLoadIOError (pEvent:IOErrorEvent):void {
			trace (pEvent);
		}
				
		/**
		* lance le chargement du contenu
		*/
		public function load ():void {
			
			addEventListener(Event.ENTER_FRAME,loadProgress);

			loadingInd = -1;
			nbFiles = files.length;
			
			loadNext();
		}
		
		
		/**
		* Charge le fichier suivant
		*/
		protected function loadNext ():void {			
			while (files.length) {
				current = files.shift();
				loadingInd++;
				
				if (current.loader is URLLoader) current.loader.load (new URLRequest (current.name));
				else current.loader.load (new URLRequest (current.name),new LoaderContext(false, ApplicationDomain.currentDomain));
				
				return;
			}
			
			removeEventListener(Event.ENTER_FRAME,loadProgress);
			
			dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.COMPLETE));
			
		}	
		
		/**
		 * gere le chargement et déclenche les evenements correspondants
		 * @param	pEvent
		 */
		protected function loadProgress(pEvent:Event) : void {
			
			var lCurrent:Object={};
			
			if (current.loader is URLLoader) {
				lCurrent.loaded=current.loader.bytesLoaded;
				lCurrent.total = current.loader.bytesTotal;				
			} else {
				lCurrent.loaded=current.loader.contentLoaderInfo.bytesLoaded;
				lCurrent.total = current.loader.contentLoaderInfo.bytesTotal;			
			}
			
			var lFilesLoaded:Number = lCurrent.total ? loadingInd + (lCurrent.loaded / lCurrent.total) : loadingInd;
				
			dispatchEvent(new AssetsLoaderEvent(AssetsLoaderEvent.PROGRESS,current.name,lCurrent,lFilesLoaded,nbFiles));
			
		}
		
		public function destroy() : void {
			removeEventListener(Event.ENTER_FRAME,loadProgress);
		}
		
	}
	
}
