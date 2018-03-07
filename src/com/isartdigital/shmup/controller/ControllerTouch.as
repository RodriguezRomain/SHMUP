package com.isartdigital.shmup.controller 
{

	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.GameStage;
	import flash.events.TouchEvent;
	
	/**
	 * Controleur Touch
	 * @author Mathieu ANTHOINE
	 */
	public class ControllerTouch extends Controller
	{
		/**
		 * instance unique de la classe ControllerTouch
		 */
		protected static var instance: ControllerTouch;
		
		protected var isBombing:int = -1;
		protected var isSpecial:int = -1;
		protected var isPausing:int = -1;
		protected var isGod:int = -1;
		
		protected var isMoving:int = -1;
		
		protected var oldPosX:Number = 0;
		protected var oldPosY:Number = 0;
		
		protected var horizontal:Number=0;
		protected var vertical:Number = 0;
		
		protected static const MIN_VALUE:Number = 1;
		
		protected static const ACCURACY:Number = 0.5;
		
		public function ControllerTouch() 
		{
			GameStage.getInstance().addEventListener (TouchEvent.TOUCH_BEGIN, onTouchBegin);
			GameStage.getInstance().addEventListener (TouchEvent.TOUCH_END, onTouchEnd);
			GameStage.getInstance().addEventListener (TouchEvent.TOUCH_MOVE, onTouchMove);
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): ControllerTouch {
			if (instance == null) instance = new ControllerTouch();
			return instance;
		}
		
		protected function onTouchBegin (pEvent:TouchEvent): void {
			switch (pEvent.target) {
				case Hud.getInstance().mcBottomRight.getChildByName("btnShoot"):
					if (isSpecial==-1) isSpecial = pEvent.touchPointID;
					break;
				case Hud.getInstance().mcBottomRight.getChildByName("btnBomb"):
					if (isBombing==-1) isBombing = pEvent.touchPointID;
					break;				
				case Hud.getInstance().mcTopRight.getChildByName("btnPause"):
					isPausing = pEvent.touchPointID;
					break;
				case Hud.getInstance().mcTopCenter.getChildByName("txtScore"):
					isGod = pEvent.touchPointID;
					break;
				default:
					if (isMoving == -1) {
						isMoving = pEvent.touchPointID;
						
						oldPosX = pEvent.stageX;
						oldPosY = pEvent.stageY;
					}
			}
		}
		
		protected function onTouchEnd (pEvent:TouchEvent): void {
			if (isSpecial == pEvent.touchPointID) isSpecial = -1;
			else if (isBombing == pEvent.touchPointID) isBombing = -1;
			else if (pEvent.target==Hud.getInstance().mcTopRight.getChildByName("btnPause")) isPausing = -1;
			else if (pEvent.target==Hud.getInstance().mcTopCenter.getChildByName("txtScore")) isGod = -1;
			else if (isMoving == pEvent.touchPointID) {
				horizontal = 0;
				vertical = 0;
				isMoving = -1;
			}
		}
		
		protected function onTouchMove (pEvent:TouchEvent): void {
			if (isMoving == pEvent.touchPointID) {
				horizontal = Math.abs(pEvent.stageX - oldPosX) > MIN_VALUE ? pEvent.stageX - oldPosX : 0; 
				vertical = Math.abs(pEvent.stageY - oldPosY) > MIN_VALUE ? pEvent.stageY - oldPosY : 0;
				oldPosX = pEvent.stageX;
				oldPosY = pEvent.stageY;
			}
		}

		override public function get fire (): Boolean {
			return true;
		}
		
		override public function get bomb (): Boolean {
			return isBombing!=-1;
		}
		
		override public function get special (): Boolean {
			return isSpecial!=-1;
		}
		
		override public function get pause (): Boolean {
			return isPausing!=-1;
		}
		
		override public function get god (): Boolean {
			return isGod!=-1;
		}
		
		override public function get left (): Number {
			return horizontal<0 ? ACCURACY : 0;
		}
		
		override public function get right (): Number {
			return horizontal>0 ? ACCURACY : 0;
		}
		
		override public function get up (): Number {
			return vertical<0 ? ACCURACY : 0;
		}
		
		override public function get down (): Number {
			return vertical>0 ? ACCURACY : 0;
		}	
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			Hud.getInstance().removeEventListener (TouchEvent.TOUCH_BEGIN, onTouchBegin);
			Hud.getInstance().removeEventListener (TouchEvent.TOUCH_END, onTouchEnd);
			
			GameStage.getInstance().removeEventListener (TouchEvent.TOUCH_BEGIN, onTouchBegin);
			GameStage.getInstance().removeEventListener (TouchEvent.TOUCH_END, onTouchEnd);
			GameStage.getInstance().removeEventListener (TouchEvent.TOUCH_MOVE, onTouchMove);
			
			instance = null;
		}
		
	}

}