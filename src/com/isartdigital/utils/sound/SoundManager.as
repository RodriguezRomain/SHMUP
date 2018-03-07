package com.isartdigital.utils.sound 
{
	import com.isartdigital.shmup.Shmup;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.loader.AssetsLoader;
	import com.isartdigital.utils.sound.SoundFX;
	import flash.events.Event;
	/**
	 * ...
	 * @author Mathieu ANTHOINE
	 */
	public class SoundManager 
	{
		
		/**
		 * instance unique de la classe SoundManager
		 */

		protected static var isInit:Boolean;
		protected static var list:Vector.<Object>;
		
		public function SoundManager() 
		{
			
		}
		
		/**
		 * Créé les instances de chaque son et les stock en interne pour les rendre accessible via getSound
		 */
		protected static function init():void{
			if (isInit) return;
			
			isInit = true;
			list = new Vector.<Object>();
			
			var lJson : Object = JSON.parse(AssetsLoader.getContent(Shmup.SOUND_PATH).toString());
			SoundFX.mainVolume	=	lJson.volumes.master * int(Config.mainSound);
			
			var i:String;
			
			// FXS
			var lFxs : Object = lJson.files.fxs;

			for (i in lFxs) {
				addSound(i, new SoundFX(lFxs[i].asset, (lFxs[i].volume) * lJson.volumes.fxs));
			}
			
			// MUSICS
			var lMusics : Object = lJson.files.musics;
			
			for (i in lMusics) {
				addSound(i, new SoundFX(lMusics[i].asset, (lMusics[i].volume) * lJson.volumes.musics));
			}
		}
		
		/**
		 * ajoute un son à la liste
		 * @param	pName identifiant du son
		 * @param	pSound son
		 */
		protected static function addSound (pName:String, pSound:SoundFX):void {
			list.push({"name":pName, "soundFX":pSound});
		}
		
		/**
		 * retourne une référence vers le son par l'intermédiaire de son identifiant
		 * @param	pName identifiant du son
		 * @return le son
		 */
		public static function getSound(pName:String): SoundFX {
			if (!isInit) init();
			for (var i:int = list.length - 1; i >= 0; i--){
				if (list[i].name == pName) return list[i].soundFX;
			}
			throw "\rL'identifiant " + pName + " de son n'existe pas dans la liste de son !";
		}
		
		/**
		 * Stoppe l'intégralité des sons
		 */
		public static function stopSounds():void{
			for (var i:int = list.length - 1; i >= 0; i--){
				list[i].soundFX.stop();
			}			
		}
		
		/**
		 * Détuit l'intégralité des sons
		 */
		public static function destroySounds(pEvent:Event=null): void {
			isInit = false;
			for (var i:int = list.length - 1; i >= 0; i--){
				list[i].soundFX.destroy();
				list.pop();
			}
		}
	}
}