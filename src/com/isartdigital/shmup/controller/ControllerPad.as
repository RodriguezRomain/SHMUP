package com.isartdigital.shmup.controller 
{
	import com.isartdigital.utils.Config;
	import flash.events.Event;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	
	/**
	 * Controleur Pad
	 * @author Mathieu ANTHOINE
	 */
	public class ControllerPad extends Controller 
	{
		/**
		 * instance unique de la classe ControllerPad
		 */
		protected static var instance: ControllerPad;
		
		protected static const A			: String	= Config["padFire"];
		protected static const B			: String	= Config["padSpecial"];
		protected static const X			: String	= Config["padBomb"];
		protected static const RB			: String	= Config["padGod"];
		protected static const START		: String	= Config["padPause"];
		protected static const HORIZONTAL	: String 	= Config["padHorizontalAxis"];
		protected static const VERTICAL		: String	= Config["padVerticalAxis"];
		
		protected static var device: GameInputDevice;
		
		protected static const MIN_VALUE:Number = 0.15;
		
		/**
		 * tableau stockant l'etat des touches et sticks du pad
		 */
		protected var controls:Object = new Object();
		
		public function ControllerPad() 
		{
			super();
			var lLength:int=device.numControls;
			for (var i:int=0;i<lLength;i++) device.getControlAt(i).addEventListener(Event.CHANGE,pressPad);
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): ControllerPad {
			if (instance == null) instance = new ControllerPad();
			return instance;
		}
		
		public static function init (pDevice:GameInputDevice):void {
			device = pDevice;
			device.enabled = true;
		}
		
		protected function pressPad (pEvent:Event): void {
			var lPad:GameInputControl = GameInputControl(pEvent.target);
			controls[lPad["id"]] = lPad["value"]; // écriture en tableau pour faire passer l'ASDoc qui ne reconnait pas .id .value
		}
		
		override public function get fire (): Boolean {
			return Boolean(controls[ControllerPad.A]);
		}
		
		override public function get bomb (): Boolean {
			return Boolean(controls[ControllerPad.X]);
		}
		
		override public function get special (): Boolean {
			return Boolean(controls[ControllerPad.B]);
		}
		
		override public function get pause (): Boolean {
			return Boolean(controls[ControllerPad.START]);
		}
		
		override public function get god (): Boolean {
			return Boolean(controls[ControllerPad.RB]);
		}
		
		override public function get left (): Number {
			if (isNaN(controls[ControllerPad.HORIZONTAL]) || controls[ControllerPad.HORIZONTAL] > -MIN_VALUE) return 0;
			return -controls[ControllerPad.HORIZONTAL];
		}
		
		override public function get right (): Number {
			if (isNaN(controls[ControllerPad.HORIZONTAL]) || controls[ControllerPad.HORIZONTAL] < MIN_VALUE) return 0;
			return controls[ControllerPad.HORIZONTAL];
		}
		
		override public function get up (): Number {
			if (isNaN(controls[ControllerPad.VERTICAL]) || controls[ControllerPad.VERTICAL] < MIN_VALUE) return 0;
			return controls[ControllerPad.VERTICAL];
		}
		
		override public function get down (): Number {
			if (isNaN(controls[ControllerPad.VERTICAL]) || controls[ControllerPad.VERTICAL] > -MIN_VALUE) return 0;
			return -controls[ControllerPad.VERTICAL];
		}
		
		override public function destroy():void 
		{
			var lLength:int=device.numControls;
			for (var i:int=0;i<lLength;i++) device.getControlAt(i).removeEventListener(Event.CHANGE,pressPad);
			
			instance = null;
		}

	}
}