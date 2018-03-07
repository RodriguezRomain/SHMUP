package com.isartdigital.utils.sound 
{
	import com.isartdigital.utils.events.SoundFXEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Classe simplifiée pour la manipulation de sons contenus dans des swfs chargés (pas de son externes)
	 * Gère un ENTER_FRAME interne pour une utilisation simplifiée
	 * N'a pas besoin d'être ajouté à la gameLoop mais les sons ne seront pas associés à la pause du jeu.
	 * todo : prendre ne compte le json sound.json pour déterminer les volumes max par son
	 * @author Mathieu ANTHOINE
	 * @author Fabien Sayer
	 */
	public class SoundFX extends EventDispatcher
	{
		/**
		 * vitesse du fade de volume par frame par défaut
		 */
		public static const FADE_SPEED:Number = 0.005;
		
		/**
		 * vitesse du fade de volume par frame
		 */
		protected var fadeSpeed:Number;
		
		/**
		 * son manipulé par la classe SoundFX
		 */
		protected var sound:Sound;
		
		/**
		 * canal du son interne
		 */
		protected var channel:SoundChannel;
		
		/**
		 * position de la lecture
		 */
		protected var position:int = 0;
		
		/**
		 * volume (valeur plus précise du volume que celle stockée par channel)
		 */
		protected var _volume:Number = -1;
		
		/**
		 * permet de bénéficier du ENTER_FRAME sur un objet non graphique
		 */
		protected var framer:Sprite;
		 
		/**
		 * volume principal
		 */
		protected static var _mainVolume:Number = 1;
		
		/**
		 * Toggle pause / resume
		 */
		protected var isPlaying:Boolean = false;
		
		/**
		 * Loop, si 0 considère comme répétition infinie
		 */
		protected var loops:int = 0;
		
		/**
		 * Point de départ du son en millisecondes
		 */
		protected var startTime:int = 0;
		
		/**
		 * liste des sons
		 */
		protected static var list:Vector.<SoundFX> = new Vector.<SoundFX>(); 
		
		/**
		 * Volume initiale paramétré dans sound.json
		 */
		protected var _initialVolume:Number;
		
		/**
		 * Volume que le fadeIn doit atteindre
		 */
		protected var fadeInTargetedVolume:Number;
		
		public function SoundFX(pName:String, pVolume:Number) 
		{
			var lClass:Class = Class(getDefinitionByName(pName));
			sound  			 = Sound(new lClass());
			framer 			 = new Sprite();
			_initialVolume   = volume = pVolume;
			
			list.push(this);
		}
		
		/**
		 * volume principal
		 */
		public static function get mainVolume (): Number {
			return _mainVolume;
		}
		
		/**
		 * Volume initiale paramétré dans sound.json
		 */
		public function get initialVolume():Number {
			return _initialVolume;
		}
		
		/**
		 * volume principal
		 */
		public static function set mainVolume (pVolume:Number): void {
			_mainVolume = Math.max(0, Math.min(pVolume, 1));
			
			for each (var lSFX:SoundFX in list) 
				lSFX.volume = lSFX._volume;
		}
		
		/**
		 * retourne la longueur du son
		 */
		public function get length ():Number {
			return sound.length;
		}
		
		/**
		 * Lance la lecture du son, si le son est déjà en lecture le stop d'abord
		 * @param	pStartTime position de départ en millisecondes
		 * @param	pLoops nombre de répétitions, 0 = infinie
		 */
		public function start (pStartTime:Number = 0, pLoops:int = 1):void {
			startTime = pStartTime;
			loops 	  = pLoops;
			isPlaying = true;
			channel   = sound.play (pStartTime, pLoops);
			
			if (channel == null)
				throw "you are trying to play too many time the same sound in a short time";
			
			position  = channel.position;
			volume    = (_volume != -1) ? _volume : volume;
			
			if (loops == 1) channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			else channel.addEventListener(Event.SOUND_COMPLETE, onLoop);
		}

		/**
		 * Stoppe le son (retour à 0)
		 */
		public function stop ():void {
			if (channel == null) return;
			
			channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			framer.removeEventListener(Event.ENTER_FRAME, doFadeIn);
			framer.removeEventListener(Event.ENTER_FRAME, doFadeOut);
			channel.stop();
			
			isPlaying = false;
		}
		
		/**
		 * Joue le son en boucle infinie
		 * @param	pStartTime position de départ en millisecondes
		 */
		public function loop (pStartTime:Number = 0):void {
			loops = 0;
			start (pStartTime, 0);
		}
		
		/**
		 * Evenement à chaque boucle de son, n'est pas émis si son joué qu'une fois.
		 * @param	pEvent
		 */
		protected function onLoop (pEvent:Event): void {
			loops--;
			
			if (loops == 1 ){
				channel.removeEventListener(Event.SOUND_COMPLETE, onLoop);
				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				start(startTime, loops);
			}
			
			else loop(startTime);
		}
		
		/**
		 * Met le son en pause
		 */
		public function pause ():void {
			if (channel == null) return;
			
			position = channel.position;
			stop();
		}
		
		/**
		 * Relance le son (un son relancé par resume sera lancé en boucle infinie car il n'est pas possible de connaitre le nombre de boucle déjà executées)
		 */
		public function resume ():void {
			start(position, loops);
		}
		
		/**
		 * Alterne pause et resume
		 */
		public function togglePauseResume ():void {
			isPlaying ? pause() : resume();
		}

		/**
		 * volume du son
		 */
		public function get volume ():Number {
			return _volume;
		}
		
		/**
		 * volume du son
		 */
		public function set volume (pVolume:Number):void {
			_volume = pVolume;
			
			if (channel !=null) {
				var lSoundTransform:SoundTransform = new SoundTransform(_volume * _mainVolume);
				channel.soundTransform = lSoundTransform;
			}
		}
		
		/**
		 * Lance un fadeIn depuis le volume actuel jusqu'à pTargetedVolume
		 * @param   pFadeSpeed Incrément de volume à chaque frame (0.005 donne volume += 0.3/seconde à une cadence de 60 fps)
		 * @param   pTargetedVolume Volume sonore à atteindre, si inférieur à 0, prendra pour valeur le volume initial mis en place dans sound.json
		 * @param	pStartTime position de départ en millisecondes, 0 par défaut
		 * @param	pLoops nombre de répétitions, 0 = infinie
		 */
		public function fadeIn (pFadeSpeed:Number = FADE_SPEED, pTargetedVolume:Number = -1, pStartTime:Number = 0, pLoops:int = 0): void {
			startTime = pStartTime;
			loops 	  = pLoops;
			fadeSpeed = pFadeSpeed;
			
			if (pTargetedVolume < 0)
				pTargetedVolume = _initialVolume;
				
			fadeInTargetedVolume = pTargetedVolume;
			
			framer.removeEventListener(Event.ENTER_FRAME, doFadeOut);
			
			if (!isPlaying) {				
				if (channel == null) volume = 0;
				
				loops == 0 ? loop(startTime) : start(startTime, loops);
			}
			
			framer.addEventListener(Event.ENTER_FRAME, doFadeIn);
		}
		
		/**
		 * fait évoluer le son pendant le fadeIn
		 */
		protected function doFadeIn (pEvent:Event): void {	
			volume = Math.min(fadeInTargetedVolume, volume + fadeSpeed);
			
			if (volume >= fadeInTargetedVolume)
				framer.removeEventListener(Event.ENTER_FRAME, doFadeIn);
		}
		
		/**
		 * Lance un fadeOut jusqu'a 0 puis stop le son
		 * @param Décrément de volume à chaque frame (0.005 donne volume += 0.3/seconde à une cadence de 60 fps)
		 */
		public function fadeOut (pFadeSpeed:Number = FADE_SPEED):void {
			fadeSpeed = pFadeSpeed;
			
			if (channel == null) return;
			
			framer.removeEventListener(Event.ENTER_FRAME,doFadeIn);
			framer.addEventListener(Event.ENTER_FRAME,doFadeOut);
		}
		
		/**
		 * fait évoluer le son pendant le fadeOut
		 */
		protected function doFadeOut (pEvent:Event): void {
			volume-= fadeSpeed;
			
			if (volume <= 0) stop();
		}
		
		/**
		 * diffuse l'évenement de fin de son
		 * @param	pEvent Evenement SOUND_COMPLETE diffusé par le canal
		 */
		protected function onSoundComplete (pEvent:Event = null):void {
			dispatchEvent(new SoundFXEvent(SoundFXEvent.COMPLETE));
		}
		
		/**
		 * nettoyage de l'instance de SoundFX
		 */
		public function destroy (): void {
			stop();
			
			framer  = null;
			sound   = null;
			channel = null;
			
			list.splice(list.indexOf(this), 1);
		}
		
	}
}