package com.isartdigital.shmup.game.sprites.shoot 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.game.StateObject;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Shoot extends StateObject 
	{
		/**
		 * vitesse du shoot
		 */
		protected var speed:Number = 30;
		
		/**
		 * degats éffectués au contact
		 */
		protected var _damage:int;
		
		/**
		 * type du shoot
		 */
		protected var damageType:int;
		
		/**
		 * tableau des couleurs correspondant au types de shoots
		 */
		static protected var colors: Vector.<uint> = new <uint>[0x009933, 0x003399, 0xcc0000];
		static public var list: Vector.<Shoot> = new Vector.<Shoot>;
		protected var destroyed:Boolean = false;
		
		public function Shoot() 
		{
			var lColorTransform: ColorTransform = new ColorTransform();
			
			super();
			if (damageType >= 0)
			{
				lColorTransform.color = colors[damageType];
				renderer.transform.colorTransform = lColorTransform;
			}
			renderer.stop();
			list.push(this);
		}
		
		/**
		 * effectue les actions du shoot à chaque frame
		 */
		override protected function doActionNormal():void 
		{
			if (!destroyed)
			{
				move();
				collisionTests();
			}
			else if (isAnimEnd())
				destroy();
		}
		
		/**
		 * fait avancer le shoot en fonction de sa vitesse et rotation
		 */
		protected function move():void 
		{
			var degToRad:Number = Math.PI / 180;	
			
			x += GameLayer.getInstance().speed;
			x += speed * Math.cos(rotation * degToRad);
			y += speed * Math.sin(rotation * degToRad);
		}
		
		/**
		 * met le shoot en état d'explosion et met ses dégats à 0
		 */
		override public function hit(pDamage:int = 0):void 
		{
			destroyed = true;
			_damage = 0;
			setState("explosion");
		}
		
		/**
		 * renvoie si le shoot est en état explosion ou non
		 */
		public function get dead():Boolean
		{
			return destroyed;
		}
		
		/**
		 * renvoie le type du shoot
		 */
		public function get type():int
		{
			return damageType;
		}
		
		/**
		 * renvoie la couleur liée au type
		 * @param type dont on veut la couleur
		 */
		static public function getColor(lType:int): uint
		{
			if (lType < 0)
				return colors[colors.length -1];
			else
				return colors[lType];
		}
		
		/**
		 * renvoie les dégats du shoot
		 */
		public function get damage():int
		{
			return _damage;
		}
		
		/**
		 * détruit l'objet
		 */
		override public function destroy():void 
		{
			list.splice(list.indexOf(this), 1);
			super.destroy();
		}
	}

}