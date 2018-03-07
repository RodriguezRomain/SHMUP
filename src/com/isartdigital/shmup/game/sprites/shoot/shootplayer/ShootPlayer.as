package com.isartdigital.shmup.game.sprites.shoot.shootplayer 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.shmup.game.sprites.shoot.Shoot;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class ShootPlayer extends Shoot
	{
		public static var list:Vector.<ShootPlayer> = new Vector.<ShootPlayer>();
		
		public function ShootPlayer(pType:int = -1) 
		{
			damageType = pType;
			list.push(this);
			super();
			speed = 60;
		}
		
		/**
		 * effectue les action hbituelles des shoots et verifie si ils sortent de l'écran par la droite
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (x - width > GameLayer.getInstance().getScreenLimits().right)
				destroy();
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