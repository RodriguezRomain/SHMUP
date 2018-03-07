package com.isartdigital.shmup.game.layers 
{
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.GameStage;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Classe "Plan de scroll", chaque plan de scroll (y compris le GameLayer) est une instance de ScrollingLayer ou d'une classe fille de ScrollingLayer
	 * TODO: A part GameLayer, toutes les instances de ScrollingLayer contiennent 3 MovieClips dont il faut gérer le "clipping" afin de les faire s'enchainer correctement
	 * alors que l'instance de ScrollingLayer se déplace
	 * @author Mathieu ANTHOINE
	 */
	public class ScrollingLayer extends GameObject
	{
		protected var screenLimits:Rectangle;
		public var mcPart1:MovieClip;
		public var mcPart2:MovieClip;
		public var mcPart3:MovieClip;
		protected var partLength:Number = 1220;
		protected var coef:Number;
		protected var ref:ScrollingLayer;
		
		public function ScrollingLayer() 
		{
			super();
		}
		
		public function init(pCoef:Number, pRef:ScrollingLayer = null):void 
		{
			coef = pCoef;
			ref = pRef;
		}

		protected function setScreenLimits ():void {
			var lTopLeft:Point = new Point (0, 0);
			var lTopRight:Point = new Point (Config.stage.stageWidth, 0);
			
			lTopLeft = globalToLocal(lTopLeft);
			lTopRight = globalToLocal(lTopRight);
						
			screenLimits=new Rectangle(lTopLeft.x, 0, lTopRight.x-lTopLeft.x, GameStage.SAFE_ZONE_HEIGHT);
		}
		
		/**
		 * Retourne les coordonnées des 4 coins de l'écran dans le repère du plan de scroll concerné 
		 * Petite nuance: en Y, retourne la hauteur de la SAFE_ZONE, pas de l'écran, car on a choisi de condamner le reste de l'écran (voir cours Ergonomie Multi écran)
		 * @return Rectangle dont la position et les dimensions correspondant à la taille de l'écran dans le repère local
		 */
		public function getScreenLimits ():Rectangle {
			return screenLimits;
		}
		
		override protected function doActionNormal():void 
		{
			x = coef * ref.x;
			setScreenLimits();
			if (!screenLimits.contains(mcPart1.x + partLength, 0))
			{
				mcPart1.x = mcPart3.x + partLength;
			}
			else if (!screenLimits.contains(mcPart2.x + partLength, 0))
			{
				mcPart2.x = mcPart1.x + partLength;
			}
			else if (!screenLimits.contains(mcPart3.x + partLength, 0))
			{
				mcPart3.x = mcPart2.x + partLength;
			}
		}
	}

}