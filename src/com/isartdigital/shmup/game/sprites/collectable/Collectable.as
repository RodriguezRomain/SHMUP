package com.isartdigital.shmup.game.sprites.collectable 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.utils.game.StateObject;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Collectable extends StateObject 
	{
		public static var list:Vector.<Collectable>;
		
		/**
		 * liste des drops
		 */
		static protected var collectableSet:Vector.<Class>;
		static protected var setCopy:Vector.<Class>;
		
		/**
		 * indique si le collectible à été ramassé
		 */
		protected var isPickedUp:Boolean = false;
		
		public function Collectable() 
		{
			super();
			list.push(this);
		}
		
		/**
		 * initialise la liste des drops
		 */
		static public function init():void
		{
			list = new Vector.<Collectable>();
			collectableSet = new <Class>[CollectableBomb, CollectableFirePower, CollectableFireUpgrade, CollectableLife, CollectableShield, null, null, null, null, null];
			setCopy = collectableSet.concat();
		}
		
		/**
		 * effectue les actions du collectible
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (isPickedUp && isAnimEnd())
				destroy();
		}
		
		/**
		 * change l'etat du collectible
		 */
		public function pickedUp():void
		{
			setState("get");
			isPickedUp = true;
		}
		
		/**
		 * retourne la variable indiquant si l'objet à été ramassé
		 */
		public function get isTaken():Boolean 
		{
			return isPickedUp;
		}
		
		/**
		 * crée un collectible
		 */
		static public function spawn(pX:Number,pY:Number):void 
		{
			var lIndex:Number;
			var lCollectable:Collectable;
			
			if (setCopy.length == 0)
				setCopy = collectableSet.concat();
			lIndex = Math.floor(Math.random() * (setCopy.length));
			if (setCopy[lIndex] != null)
			{
				lCollectable = new setCopy[lIndex]();
				lCollectable.x = pX;
				lCollectable.y = pY;
				GameLayer.getInstance().addChild(lCollectable);
				lCollectable.start();
			}
			setCopy.splice(lIndex, 1);
		}
		
		/**
		 * detruit l'objet
		 */
		override public function destroy():void 
		{
			list.splice(list.indexOf(this), 1);
			super.destroy();
		}
		
	}

}