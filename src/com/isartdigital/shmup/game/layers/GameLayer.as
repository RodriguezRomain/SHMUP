package com.isartdigital.shmup.game.layers 
{
	import com.isartdigital.shmup.game.levelDesign.GameObjectsGenerator;
	import com.isartdigital.utils.game.StateObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	//import com.isartdigital.utils.Debug;
	
	/**
	 * Classe "plan de jeu", elle contient tous les éléments du jeu, Generateurs, Player, Ennemis, shoots...
	 * @author Mathieu ANTHOINE
	 */
	public class GameLayer extends ScrollingLayer 
	{
		
		/**
		 * instance unique de la classe GameLayer
		 */
		protected static var instance: GameLayer;
		protected var _speed:Number = 5;
		protected var generators:Vector.<GameObjectsGenerator> = new Vector.<GameObjectsGenerator>();
		protected var shake:Timer = new Timer(1000, 1);
		protected var isShaking:Boolean = false;
		protected var shakeAmount:uint = 30;
		
		public function GameLayer() 
		{
			super();
			setScreenLimits();
			shake.addEventListener(TimerEvent.TIMER_COMPLETE, stopShake);
		}
		
		/**s
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameLayer {
			if (instance == null) instance = new GameLayer();
			return instance;
		}
		
		/**
		 * initialise le tableau de générators
		 */
		override public function init(pSpeed:Number, pRef:ScrollingLayer = null):void 
		{
			_speed = pSpeed;
			for (var i:int=0; i<numChildren;i++){
				generators.push(getChildAt(i));
			}
			generators.sort(function(pA:GameObjectsGenerator, pB: GameObjectsGenerator){return pA.x < pB.x? -1: 1});
		}
		
		/**
		 * renvoie la vitesse du GameLayer
		 */
		public function get speed():Number
		{
			return _speed;
		}
		
		/**
		 * met à jour la vitesse du GameLayer
		 */
		public function set speed(pSpeed:Number):void 
		{
			_speed = pSpeed;
		}
		
		/**
		 * commence un screen shake
		 */
		public function startShake(pTime:uint = 1000, pShakeAmount:uint =30):void 
		{
			if (!isShaking)
			{
				shake.delay = pTime;
				shakeAmount = pShakeAmount;
				isShaking = true;
				shake.start();
			}
		}
		
		/**
		 * met fin au screen shake
		 */
		protected function stopShake(pEvent:TimerEvent):void 
		{
			y = 0;
			isShaking = false;
			shake.reset();
		}

		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
			shake.removeEventListener(TimerEvent.TIMER_COMPLETE, stopShake);
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				if (getChildAt(0) is StateObject)
					StateObject(getChildAt(0)).destroy();
			}
			super.destroy();
		}
		
		/**
		 * effectue le scrolling du GameLayer ainsi que l'éventuel screen shake
		 */
		override protected function doActionNormal():void 
		{
			setScreenLimits();
			x -= speed;
			if (generators.length > 0 && screenLimits.contains(generators[0].x - generators[0].width / 2, generators[0].y))
			{
				generators[0].generate();
				generators.splice(0, 1);
			}
			
			if (isShaking)
			{
				y = 0 + ( -shakeAmount / 2 + Math.random() * shakeAmount);
			}
		}
	}
}