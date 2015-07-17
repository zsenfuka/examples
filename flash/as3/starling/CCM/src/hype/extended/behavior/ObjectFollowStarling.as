﻿/** * *   Joshua Davis *   http://www.joshuadavis.com *   studio@joshuadavis.com * *   Sep 25, 2009 * * *   Modified by Charles D Clements *   charlesclements@gmail.com *  *   July 16, 2015 * */ package hype.extended.behavior {	import flash.display.Stage;		import hype.framework.behavior.AbstractBehavior;	import hype.framework.behavior.IBehavior;		import starling.display.DisplayObject;
	//import flash.display.DisplayObject;	/**	 * Makes the target track the mouse	 */	public class ObjectFollowStarling extends AbstractBehavior implements IBehavior {				protected var _stage:Stage;		protected var _ease:Number;				/**		 * Constructor		 * 		 * @param target Target object		 * @param ease Ease of the movement		 */		public function ObjectFollowStarling(target:Object, stage:Stage, ease:Number) 		{						super(target);			_stage = stage;			_ease = ease;					}				/**		 * @protected		 */		public function run(target:Object):void 		{						var myTarget:DisplayObject = target as DisplayObject;						//myTarget.hit												//myTarget.x += (_stage.mouseX - myTarget.x) * _ease;			//myTarget.y += (_stage.mouseY - myTarget.y) * _ease;		}				/**		 * Ease of the movement		 */		public function get ease():Number {			return _ease;		}				public function set ease(ease:Number):void {			_ease = ease;		}	}}import flash.display.DisplayObject;