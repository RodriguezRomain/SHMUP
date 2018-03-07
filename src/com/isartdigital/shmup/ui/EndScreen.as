package com.isartdigital.shmup.ui 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.sound.SoundManager;
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * Classe mère des écrans de fin
	 * @author Mathieu ANTHOINE
	 */
	public class EndScreen extends Screen 
	{
		
		public var mcBackground:Sprite;
		public var mcScore:Sprite;
		
		public var btnNext:SimpleButton;
	
		public function EndScreen() 
		{
			super();
			
			while (GameStage.getInstance().getHudContainer().numChildren > 0) {
				GameStage.getInstance().getHudContainer().removeChildAt(0);
			}
			SoundManager.getSound("levelLoop").stop();
			SoundManager.getSound("ambienceLoop").stop();
			TextField(mcScore.getChildAt(0)).text = "SCORE: " + GameManager.score;
		}
		
		override protected function init(pEvent:Event):void 
		{
			super.init(pEvent);
			btnNext.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		/**
		 * renvoie à l'écran titre lorsque le bouton est activé
		 */
		protected function onClick(pEvent:MouseEvent):void
		{
			UIManager.addScreen(TitleCard.getInstance());
			GameManager.destroy();
			SoundManager.getSound("click").start();
		}
		
		override protected function onResize (pEvent:Event=null): void {	
			UIManager.setPosition(mcBackground, UIPosition.FIT_SCREEN);
		}
	}
}