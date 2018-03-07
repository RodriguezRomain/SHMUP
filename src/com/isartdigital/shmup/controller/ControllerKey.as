package com.isartdigital.shmup.controller 
{
	import com.isartdigital.utils.Config;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 * Controleur clavier
	 * @author Mathieu ANTHOINE
	 */
	public class ControllerKey extends Controller
	{
		/**
		 * instance unique de la classe ControllerKey
		 */
		protected static var instance: ControllerKey;
		
		/**
		 * tableau stockant l'etat appuyé ou non des touches
		 */
		protected var keys:Array = new Array();
		protected var names:Vector.<String> = new <String>["keyBomb", "keySpecial", "keyFire", "keyGod", "keyPause", "keyUp", "keyDown", "keyLeft", "keyRight"];
		
		public function ControllerKey() 
		{
			super();
			Config.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPress);
			Config.stage.addEventListener(KeyboardEvent.KEY_UP, keyUnpress);
			for (var i:String in names)
				keys[i] = 0;
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): ControllerKey {
			if (instance == null) instance = new ControllerKey();
			return instance;
		}
		
		protected function keyPress(pEvent: KeyboardEvent):void 
		{
			for (var i:int = 0; i < names.length; i++)
			{
				if (pEvent.keyCode == Keyboard[Config[names[i]]])
					keys[names[i]] = 1;
			}
		}
		
		protected function keyUnpress(pEvent: KeyboardEvent):void 
		{
			for (var i:int = 0; i < names.length; i++)
			{
				if (pEvent.keyCode == Keyboard[Config[names[i]]])
					keys[names[i]] = 0;
			}
		}
		
		override public function get bomb():Boolean 
		{
			return keys["keyBomb"];
		}
		
		override public function get special():Boolean 
		{
			return keys["keySpecial"];
		}
		
		override public function get fire():Boolean 
		{
			return keys["keyFire"];
		}
		
		override public function get god():Boolean 
		{
			return keys["keyGod"];
		}
		
		override public function get pause():Boolean 
		{
			return keys["keyPause"];
		}
		
		override public function get down():Number 
		{
			return keys["keyDown"];
		}
		
		override public function get left():Number 
		{
			return keys["keyLeft"];
		}
		
		override public function get right():Number 
		{
			return keys["keyRight"];
		}
		
		override public function get up():Number 
		{
			return keys["keyUp"];
		}

		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			Config.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPress);
			Config.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUnpress);
			instance = null;
		}
	}
}