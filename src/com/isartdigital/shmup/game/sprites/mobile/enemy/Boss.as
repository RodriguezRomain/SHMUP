package com.isartdigital.shmup.game.sprites.mobile.enemy 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.mobile.Mobile;
	import com.isartdigital.shmup.game.sprites.shoot.Shoot;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootBoss;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy0;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy1;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy2;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Romain Rodriguez
	 */
	public class Boss extends Enemy 
	{
		
		/**
		 * instance unique de la classe Boss
		 */
		protected static var instance: Boss;
		
		/**
		 * compte le nombre de frames entre chaque patterns
		 */
		protected var countFrame : int = 0;
		protected var waitingTime : int = 60;
		
		/**
		 * indique la direction du mouvement
		 */
		protected var isAsc:Boolean = true;
		
		protected var swipeRotation:Number;
		
		/**
		 * tableau des patterns de tir
		 */
		protected var patterns : Vector.<Function> = new Vector.<Function>();
		
		/**
		 * variable contenant la pattern actuelle
		 */
		public var doActionBoss: Function;

		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Boss {
			if (instance == null) instance = new Boss();
			return instance;
		}		
	
		public function Boss() 
		{
			assetName = "Boss0"
			hp = 250;
			type = 0;
			score = 1000;
			super();
			collectableRolled = true;
			SoundManager.getSound("levelLoop").stop();
			for (var i:int = 0; i < 3; i++)
			{
				SoundManager.getSound("bossLoop" + i).loop();
				SoundManager.getSound("bossLoop" + i).volume = 0;
			}
			SoundManager.getSound("bossLoop0").fadeIn();
			initPatterns();
			setModeWait();
		}
		
		/**
		 * effectue les actions du boss
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			if (x + GameLayer.getInstance().getScreenLimits().width / 3 < GameLayer.getInstance().getScreenLimits().right)
			{
				x += GameLayer.getInstance().speed;
				if (!isDead)
					doActionBoss();
				else 
				{
					setModeWait();
				}
			}
			else
			{
				setState("default");
				hp = 250;
				countFrame = 0;
			}
		}
		
		/**
		 * initialise le tableau de patterns
		 */
		protected function initPatterns() : void {
			patterns.push(doActionMissile);
			patterns.push(doActionArc);
			patterns.push(doActionBall);
			patterns.push(doActionSwipe);
		}
		
		/**
		 * lance des missiles téléguidés
		 */
		protected function doActionMissile():void 
		{
			var lNbCannons:int = 2 * type+1;
			
			for (var i:int = 0; i < lNbCannons; i++)
				createShot(ShootEnemy2, collider.getChildByName("mcWeapon" + i) as MovieClip);
			setState("fire");
			SoundManager.getSound("missile").start();
			setModeWait();
		}
		
		/**
		 * crée un arc de bullets
		 */
		protected function doActionArc() : void {
			//TODO : créer le pattern
			var lShoot: Shoot;
			var lAngle: Number;
			var lArc:Number = 120;
			var lIncr:Number = lArc / 8;
			var lRadius:Number = 50;
			var lNbCannons:int = 2 * type+1;
			
			for (var i:int = 0; i < 8; i++)
			{
				for (var j:int = 0; j < lNbCannons; j++)
				{
					lShoot = createShot(ShootEnemy0, collider.getChildByName("mcWeapon" + j) as MovieClip);
					lAngle = ((180 - lArc) / 2 + lIncr / 2 + lIncr * i);
					lShoot.rotation += lAngle - 90;
				}
			}
			setState("fire");
			SoundManager.getSound("bossShoot").start();
			setModeWait();
		}
		
		/**
		 * crée une balle se séparant en deux lorsqu'elle atteint le bord de l'écran
		 */
		protected function doActionBall():void 
		{
			createShot(ShootBoss, collider.getChildByName("mcWeapon0") as MovieClip);
			setState("fire");
			SoundManager.getSound("bossShoot").start();
			setModeWait();
		}
		
		/**
		*crée un vague de bullets
		*/
		private function doActionSwipe():void 
		{
			var lNbCannons:int = 2 * type+1;
			var lSwipeArc:Number = 90;
			var lShoot: Shoot;
			var lNbSalvo:int = 10;
			var lActiveFrame: Number = 120 / lNbSalvo;
			var lIncr:Number = lSwipeArc / 120;
			
			if (countFrame == 0)
				swipeRotation = - lSwipeArc / 2;
			if (countFrame++ < 120)
			{
				swipeRotation += lIncr;
				if (countFrame % lActiveFrame == 0)
				{
					for (var j:int = 0; j < lNbCannons; j++)
					{
						lShoot = createShot(ShootEnemy1, collider.getChildByName("mcWeapon" + j) as MovieClip);
						lShoot.rotation += swipeRotation;
					}
				}
			}
			else 
			{
				countFrame = 0;
				setModeWait();
			}
		}
		
		/**
		 * met le boss en mode attente
		 */
		private function setModeWait() : void {
			doActionBoss = doActionWait;
		}
		
		/**
		 * choisit une pattern aléatoire parmis la liste
		 */
		protected function selectNextPattern() : void {
			var lIndex : int = Math.floor(Math.random() * patterns.length);
			doActionBoss = patterns[lIndex];
		}
		
		/**
		 * le boss attend pendant waitinTime frames puis choisit un pattern aléatoire
		 */
		protected function doActionWait() : void {
			if (countFrame ++ <= waitingTime) return;
			countFrame = 0;
			selectNextPattern();
		}
		
		/**
		 * met le boss en place puis le bouge de façon verticale
		 */
		override protected function move():void 
		{
			super.move();
			if (x + GameLayer.getInstance().getScreenLimits().width / 3 < GameLayer.getInstance().getScreenLimits().right)
			{
				if (isAsc)
					y -= speed;
				else
					y += speed;
				if (y - height/2 <= GameLayer.getInstance().getScreenLimits().top)
					isAsc = false;
				if (y + height / 2 >= GameLayer.getInstance().getScreenLimits().bottom)
					isAsc = true;
			}
		}
		
		override protected function shoot():void 
		{
			
		}
		
		/**
		 * change la phase du boss si il en reste sinon le détruit
		 */
		override protected function isKilled():void 
		{
			var lClass:Class;
			
			if (type == 2)
			{
				GameLayer.getInstance().startShake();
				super.isKilled();
			}
			else
			{
				SoundManager.getSound("bossLoop" + type).fadeOut();
				type++;
				assetName = "Boss" + type;
				
				lClass = getDefinitionByName(assetName+ "_collider") as Class;
				
				removeChild(collider);
				collider = new lClass();
				if (colliderAlpha== 0) collider.visible = false;
				else collider.alpha = colliderAlpha;
				addChild (collider);
				
				hp = 100;
				isDead = false;
				SoundManager.getSound("bossLoop" + type).fadeIn();
			}
		}
		
		/**
		 * lance un hit pause puis l'explosion du boss
		 */
		override protected function explode():void 
		{
			super.explode();
			SoundManager.getSound("bossExplosion").start();
			GameManager.hitPause();
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy():void 
		{
			for (var i:int = 0; i < 3; i++)
			{
				SoundManager.getSound("bossLoop" + i).stop();
			}
			instance = null;
			if (isDead)
				GameManager.win();
			super.destroy();
		}
	}
}