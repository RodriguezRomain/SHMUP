package com.isartdigital.shmup.game.sprites.shoot.shootEnemy 
{
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.shoot.Shoot;
	
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class ShootEnemy extends Shoot 
	{
		public static var list:Vector.<ShootEnemy> = new Vector.<ShootEnemy>();
		
		public function ShootEnemy() 
		{
			super();
			list.push(this);
		}
		
		/**
		 * effectue les actions des shoots et le detruit si il dépasse le bord de l'écran par la gauche
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (x + width < GameLayer.getInstance().getScreenLimits().left)
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