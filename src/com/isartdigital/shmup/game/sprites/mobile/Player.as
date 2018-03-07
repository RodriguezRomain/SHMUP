package com.isartdigital.shmup.game.sprites.mobile 
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.controller.ControllerKey;
	import com.isartdigital.shmup.controller.ControllerPad;
	import com.isartdigital.shmup.controller.ControllerTouch;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.layers.GameLayer;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.shmup.game.sprites.Shield;
	import com.isartdigital.shmup.game.sprites.collectable.Collectable;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableBomb;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableFirePower;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableFireUpgrade;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableLife;
	import com.isartdigital.shmup.game.sprites.collectable.CollectableShield;
	import com.isartdigital.shmup.game.sprites.mobile.enemy.Enemy;
	import com.isartdigital.shmup.game.sprites.shoot.Shoot;
	import com.isartdigital.shmup.game.sprites.shoot.shootEnemy.ShootEnemy;
	import com.isartdigital.shmup.game.sprites.shoot.shootplayer.Bomb;
	import com.isartdigital.shmup.game.sprites.shoot.shootplayer.ShootPlayer0;
	import com.isartdigital.shmup.game.sprites.shoot.shootplayer.ShootPlayer1;
	import com.isartdigital.shmup.game.sprites.shoot.shootplayer.ShootPlayer2;
	import com.isartdigital.shmup.game.sprites.shoot.shootplayer.Special;
	import com.isartdigital.shmup.ui.PopInScore;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.CollisionManager;
	import com.isartdigital.utils.sound.SoundManager;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Classe du joueur (Singleton)
	 * En tant que classe héritant de StateObject, Player contient un certain nombre d'états définis par les constantes LEFT_STATE, RIGHT_STATE, etc.
	 * @author Mathieu ANTHOINE
	 */
	public class Player extends Mobile
	{
		
		/**
		 * instance unique de la classe Player
		 */
		protected static var instance: Player;
		
		/**
		 * controleur de jeu
		 */
		protected var controller: Controller;
			
		static protected var countFrame:int = 0;
		protected const SAFELIMIT:Number = 150;
		protected var weapon:MovieClip;
		
		/**
		 * niveau actuel de l'arme
		 */
		protected var weaponLevel:uint = 0;
		
		/**
		 * timer pour l'invincibilité
		 */
		protected var invicibilityTimer:Timer = new Timer(1, 350);
		protected var isInvicible: Boolean = false;
		
		/**
		 * nombre de bombes possédées
		 */
		protected var nbBombs:uint = 1;
		protected var lastBomb:Boolean = false;
		
		/**
		 * indique si le god mode est actif
		 */
		protected var godOn: Boolean = false;
		protected var lastGod:Boolean = false;
		
		public function Player() 
		{	
			super();

			// crée le controleur correspondant à la configuration du jeu
			if (Controller.type == Controller.PAD) controller = ControllerPad.getInstance();
			else if (Controller.type == Controller.TOUCH) controller = ControllerTouch.getInstance();
			else controller = ControllerKey.getInstance();
			
			addChildAt(Special.getInstance(), 1);
			
			weaponCooldown.delay = 250;
			invicibilityTimer.addEventListener(TimerEvent.TIMER, flicker);
			invicibilityTimer.addEventListener(TimerEvent.TIMER_COMPLETE, endInvicibility);
			
			speed = 25;
			hp = 100;
			shootLevel = 0;
			scaleX = scaleY = 0.85;
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Player {
			if (instance == null) instance = new Player();
			return instance;
		}
		
		/**
		 * lance les actions du player et du bouclier
		 */
		override protected function doActionNormal():void 
		{
			super.doActionNormal();
			Shield.getInstance().doAction();
			Shield.getInstance().x = x;
			Shield.getInstance().y = y;
		}
		
		/**
		 * effectue toutes les actions du player
		 */
		override protected function gameActions():void 
		{
			super.gameActions();
			if (!isDead)
				setState("default", true);
			countFrame++;
			if (controller.fire && !isCooling)
				shoot();
			if (controller.bomb && !lastBomb && nbBombs > 0)
			{
				createBomb();
				nbBombs--;
			}
			lastBomb = controller.bomb;
			if (controller.special)
				Special.getInstance().activate();
			Special.getInstance().doAction();
			if (controller.god && !lastGod)
			{
				if (!godOn)
				{
					godOn = true;
					alpha = 0.75;
				}
				else
				{
					godOn = false;
					alpha = 1;
				}
			}
			lastGod = controller.god;
			if (weapon.currentFrame == weapon.totalFrames)
				weapon.gotoAndStop(1);
		}
		
		/**
		 * bouge le player en fonction des inputs du joueur
		 */
		override protected function move():void 
		{	
			super.move();
			if (controller.up > 0 && y - SAFELIMIT -1 > GameLayer.getInstance().getScreenLimits().top)
			{
				setState("up", true);
				y -= speed * controller.up;
			}
			if (controller.down > 0 && y + SAFELIMIT + 1 < GameLayer.getInstance().getScreenLimits().bottom)
			{
				setState("down", true);
				y += speed * controller.down;
			}
			if (controller.left > 0 && x - SAFELIMIT -1 > GameLayer.getInstance().getScreenLimits().left)
			{
				setState("left", true);
				x -= speed * controller.left;
			}
			if (controller.right > 0 && x + SAFELIMIT +1 < GameLayer.getInstance().getScreenLimits().right)
			{
				setState("right", true);
				x += speed * controller.right;
			}
			
			if (x + SAFELIMIT > GameLayer.getInstance().getScreenLimits().right)
				x = GameLayer.getInstance().getScreenLimits().right - SAFELIMIT;
			else if (x - SAFELIMIT < GameLayer.getInstance().getScreenLimits().left)
				x = GameLayer.getInstance().getScreenLimits().left + SAFELIMIT;
			if (y + SAFELIMIT > GameLayer.getInstance().getScreenLimits().bottom)
			y = GameLayer.getInstance().getScreenLimits().bottom - SAFELIMIT;
			else if (y - SAFELIMIT < GameLayer.getInstance().getScreenLimits().top)
			y = GameLayer.getInstance().getScreenLimits().top + SAFELIMIT;
		}
		
		/**
		 * tire une salve de balles
		 */
		override protected function shoot():void 
		{
			ShootPlayer0;
			ShootPlayer1;
			ShootPlayer2;
			var lClass:Class = getDefinitionByName("com.isartdigital.shmup.game.sprites.shoot.shootplayer.ShootPlayer" + shootLevel) as Class;
			
			super.shoot();
			for (var i:int = 0; i <= weaponLevel * 2; i++)
			{
				createShot(lClass, collider.getChildByName("mcWeapon" + i) as MovieClip);
			}
			weapon.play();
			SoundManager.getSound("playerShoot" + Math.floor(Math.random() * 4)).start();
		}
		
		/**
		 * crée un shoot du type courant sur la weapon
		 * @param Class du shoot
		 * @param weapon tirant le shoot
		 */
		override protected function createShot(pClass:Class, pWeapon:MovieClip):Shoot
		{
			var lShoot:Shoot;
			var lGlobalCoord:Point;
			var lLocalCoord:Point;
			var lWeapon:MovieClip;
			
			lShoot = new pClass(shotType);
			lGlobalCoord = localToGlobal(new Point(pWeapon.x, pWeapon.y));
			lLocalCoord = parent.globalToLocal(lGlobalCoord);
			lShoot.x = lLocalCoord.x + pWeapon.width;
			lShoot.y = lLocalCoord.y;
			lShoot.rotation = pWeapon.rotation;
			lShoot.start();
			GameLayer.getInstance().addChildAt(lShoot, 1);
			return (lShoot);
		}
		
		/**
		 * crée une bombe
		 */
		protected function createBomb():void 
		{
			var lBomb:Bomb;
			
			parent.addChild(lBomb = new Bomb());
			lBomb.x = x;
			lBomb.y = y;
			lBomb.start();
		}
		
		/**
		 * renvoie le nombre de bombes du joueur
		 */
		public function get bombs():uint
		{
			return nbBombs;
		}
		
		/**
		 * teste des collisions du joueur
		 */
		override protected function collisionTests():void 
		{
			var lCollectable:Collectable;
			
			for (var i:int  = Collectable.list.length - 1; i >= 0; i--)
			{
				lCollectable = Collectable.list[i];
				if (CollisionManager.hasCollision(hitBox, lCollectable.hitBox, hitBoxes, lCollectable.hitBoxes) && !lCollectable.isTaken)
				{
					getCollectable(lCollectable);
				}
			}
			if (!isInvicible)
			{
				collision(Obstacle, 25);
				collision(Enemy, 25);
				collision(ShootEnemy);
			}
		}
		
		/**
		 * applique l'effet du collectible obtenu
		 */
		protected function getCollectable(pCollectable:Collectable):void 
		{
			pCollectable.pickedUp();
			if (pCollectable is CollectableBomb && nbBombs < 2)
			{
				nbBombs++;
			}
			else if (pCollectable is CollectableFirePower && shootLevel < 2)
			{
				shootLevel++;
				weaponCooldown.delay -= 50;
			}
			else if (pCollectable is CollectableFireUpgrade && weaponLevel < 2)
			{
				weaponLevel++;
			}
			else if (pCollectable is CollectableLife && hp < 100)
			{
				hp += 25;
				if (hp > 100)
					hp = 100;
			}
			else if (pCollectable is CollectableShield && !Shield.getInstance().isActive)
			{
				createShield();
			}
			else
			{
				GameManager.score += 100;
				Hud.getInstance().scoreUpdate();
				PopInScore.createPopIn(100, x, y);
			}
		}
		
		/**
		 * crée un bouclier
		 */
		protected function createShield():void 
		{
			GameLayer.getInstance().addChild(Shield.getInstance());
			Shield.getInstance().start();
			Shield.getInstance().isActive = true;
		}
		
		/**
		 * si le god mode n'est pas activé et qu'il n'y a pas de bouclier le joueur pert de la vie et devient temporairement invincible
		 */
		override public function hit(pDamage:int = 0):void 
		{
			if (!Shield.getInstance().isActive && !godOn)
			{
				super.hit(pDamage);
				isInvicible = true;
				invicibilityTimer.start();
				GameLayer.getInstance().startShake();
			}
		}
		
		/**
		 * change l'état du player et son arme en fonction de son niveau
		 */
		override protected function setState(pState:String, pLoop:Boolean = false, pStart:uint = 1):void 
		{
			var lClass:Class;
			
			super.setState(pState, pLoop, pStart);
			
			lClass = getDefinitionByName("Weapon" + weaponLevel) as Class;
			if (!(weapon is lClass))
			{
				if (weapon)
					MovieClip(MovieClip(renderer.getChildAt(0)).getChildByName("mcWeapon")).removeChildAt(0);
				weapon = new lClass();
				weapon.stop();
			}
			MovieClip(MovieClip(renderer.getChildAt(0)).getChildByName("mcWeapon")).addChild(weapon);
		}
		
		/**
		 * effet de clignotement de l'invincibilité
		 */
		protected function flicker(pEvent:TimerEvent):void 
		{
			if (visible)
				visible = false;
			else
				visible = true;
		}
		
		/**
		 * met fin à la période d'invincibilité
		 */
		protected function endInvicibility(pEvent:TimerEvent):void 
		{
			visible = true;
			invicibilityTimer.reset();
			isInvicible = false;
		}
		
		/**
		 * met les animations et timers en pause
		 */
		override public function pause():void 
		{
			weapon.stop();
			Special.getInstance().pause();
			invicibilityTimer.stop();
			super.pause();
		}
		
		/**
		 * met fin à la pause
		 */
		override public function resume():void 
		{
			super.resume();
			Special.getInstance().resume();
			if (weapon.currentFrame == 1)
				weapon.stop();
			if (isInvicible)
				invicibilityTimer.start();
		}
		
		/**
		 * renvoie le type des tirs courant du joueur
		 */
		public function set shot(pType:int):void 
		{
			shotType = pType;
		}
		
		/**
		 * renvoie les hp du joueur
		 */
		public function get health():int
		{
			return hp;
		}
		
		/**
		 * lance le game over et détruit le joueur
		 */
		override protected function isKilled():void 
		{
			GameManager.gameOver();
			super.isKilled();
		}
		
		/**
		 * lance un hitpause et l'animation d'explosion du joueur
		 */
		override protected function explode():void 
		{
			super.explode();
			GameManager.hitPause();
			SoundManager.getSound("playerExplosion").start();
		}

		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
			Special.getInstance().destroy();
			invicibilityTimer.removeEventListener(TimerEvent.TIMER, flicker);
			invicibilityTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, endInvicibility);
			super.destroy();
		}

	}
}