package com.isartdigital.utils.events {
	
	import flash.events.Event;

	/**
	 * Classe d'Evenements de chargement associée à la classe AssetsLoader
	 * @author Mathieu ANTHOINE
	 */
	public final class AssetsLoaderEvent extends Event {
		
		public static const PROGRESS:String = "progress";		
		public static const CURRENT_COMPLETE:String = "currentComplete";
		public static const COMPLETE:String = "complete";
		
		public static const ERROR:String = "error";
		
		public var description:String;
		public var currentLoaded:Number=-1;
		public var currentTotal:Number=-1;
		
		public var filesLoaded:Number;
		public var nbFiles:int;
		
		public function AssetsLoaderEvent (pType:String,pDescription:String="",pCurrent:Object=null,pFilesLoaded:int=0,pNbFiles:int=0) {
			super(pType);
			
			description=pDescription;
			
			if (pCurrent!=null) {
				currentLoaded=pCurrent.loaded;
				currentTotal=pCurrent.total;
			}
			
			filesLoaded = pFilesLoaded;
			nbFiles = pNbFiles;
			
		}
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		override public function toString():String {
			if (type=="progress") return formatToString("AssetsLoaderEvent", "type","description","currentLoaded","currentTotal","filesLoaded","nbFiles","bubbles", "cancelable", "eventPhase");
			else if (type=="error") return formatToString("AssetsLoaderEvent", "type","description","bubbles", "cancelable", "eventPhase");
			else return formatToString("AssetsLoaderEvent", "type","bubbles", "cancelable", "eventPhase");
		}
	}
	
}
