package com.isartdigital.utils.game 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	/**
	 * Classe utilitaire permettant de tester diverses collisions entre boites, formes et points
	 * @author Mathieu ANTHOINE
	 */
	public class CollisionManager 
	{
	
		public function CollisionManager() 
		{
			
		}
		
		/**
		 * 
		 * @param	pHitBoxA boite englobante principale
		 * @param	pHitBoxB boite englobante principale
		 * @param	pHitsA liste de boites complémentaires ou de points de collision
		 * @param	pHitsB liste de boites complémentaires ou de points de collision
		 * @return  résultat de la collision
		 */
		public static function hasCollision (pHitBoxA:DisplayObject, pHitBoxB:DisplayObject, pHitsA:* = null, pHitsB:* = null): Boolean {
			if (pHitBoxA == null || pHitBoxB == null) return false;
			
			// test des boites de collision principale
			if (!pHitBoxA.hitTestObject(pHitBoxB)) return false;
			
			// si il n'y a pas de boites de collision plus précises on valide
			if (pHitsA == null && pHitsB == null) return true;
			
			// test points vers la forme de la boite principale 
			if (pHitsA is Vector.<Point>) return testPoints(pHitsA, pHitBoxB);
			if (pHitsB is Vector.<Point>) return testPoints(pHitsB, pHitBoxA);
			
			// test Boxes vers Boxes 
			if (pHitsA is Vector.<DisplayObject> && pHitsB == null) return testBoxes(pHitsA, new <DisplayObject>[pHitBoxB]);
			if (pHitsB is Vector.<DisplayObject> && pHitsA == null) return testBoxes(pHitsB, new <DisplayObject>[pHitBoxA]);
			if (pHitsA is Vector.<DisplayObject> && pHitsB is Vector.<DisplayObject>) return testBoxes(pHitsA, pHitsB);			
			
			// si les Vector sont d'une autre nature
			return false;

		}
		
		/**
		 * 
		 * @param	pHitPoints liste de points de collision (dont le repère est déjà converti en global)
		 * @param	pHitBox boite englobante
		 * @return  résultat de la collision
		 */
		protected static function testPoints (pHitPoints:Vector.<Point>, pHitBox:DisplayObject): Boolean {
			for each (var lHitPoint:Point in pHitPoints) {
				if (pHitBox.hitTestPoint(lHitPoint.x, lHitPoint.y,true)) return true;
			}
				
			return false;
			
		}
		
		/**
		 * 
		 * @param	pHitBoxesA liste de boites de collision
		 * @param	pHitBoxesB liste de boites de collision
		 * @return  résultat de la collision
		 */
		protected static function testBoxes (pHitBoxesA:Vector.<DisplayObject>, pHitBoxesB:Vector.<DisplayObject>): Boolean {
			for each (var lHitBoxA:DisplayObject in pHitBoxesA) {
				for each (var lHitBoxB:DisplayObject in pHitBoxesB) {
					if (lHitBoxA.hitTestObject(lHitBoxB)) return true;
				}
			}
				
			return false;
		}

	}
}