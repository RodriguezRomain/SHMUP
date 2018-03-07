package com.isartdigital.shmup.game.sprites.shoot.shootEnemy 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class ShootBoss extends ShootEnemy 
	{
		
		protected var isOriginal:Boolean;
		protected var hasSplit:Boolean = false;
		protected var hasTurned:Boolean = false;
		
		public function ShootBoss(pOriginal:Boolean = true) 
		{
			damageType = 1;
			super();
			_damage = 30;
			speed = 30;
			isOriginal = pOriginal;
			scaleX = scaleY = 3;
		}
		
		/**
		 * effectue les actions habituelles des shoots et si le shoot atteint le borde de l'écran crée un copie qui suivra les bords de l'écran dans un sens tandis que l'original le suivra dans l'autre
		 */
		override protected function doActionNormal():void 
		{
			var lShoot:ShootBoss;
			
			super.doActionNormal();
			
			if (isOriginal && x - width/2 <= GameLayer.getInstance().getScreenLimits().left && !hasSplit)
			{
				lShoot = new ShootBoss(false);
				lShoot.x = x;
				lShoot.y = y;
				lShoot.rotation = rotation - 90;
				lShoot.start();
				parent.addChild(lShoot);
				rotation += 90;
				hasSplit = true;
			}
			if (y - height / 2 <= GameLayer.getInstance().getScreenLimits().top && !hasTurned)
			{
				rotation += 90;
				hasTurned = true;
			}
			else if (y + height / 2 >= GameLayer.getInstance().getScreenLimits().bottom && !hasTurned)
			{
				rotation -= 90;
				hasTurned = true;
			}
			if (x - width > GameLayer.getInstance().getScreenLimits().right)
				destroy();
		}
		
	}

}