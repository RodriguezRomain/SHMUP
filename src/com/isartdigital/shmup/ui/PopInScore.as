package com.isartdigital.shmup.ui 
{
	import com.greensock.TweenLite;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.ui.hud.Hud;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class PopInScore extends MovieClip
	{
		public var textField:TextField
		
		public function PopInScore(pScore:uint) 
		{
			super();
			textField.text = "" + pScore;
		}
		
		public function destroy():void 
		{
			parent.removeChild(this);
		}
		
		static public function createPopIn(pScore:uint, pX:Number, pY:Number):void 
		{
			var lPopin:PopInScore = new PopInScore(pScore);
			
			GameLayer.getInstance().addChild(lPopin);
			lPopin.x = pX;
			lPopin.y = pY;
			TweenLite.to(lPopin, 2, {scaleX:2, scaleY:2, alpha:0, onComplete:lPopin.destroy});
		}
		
	}

}