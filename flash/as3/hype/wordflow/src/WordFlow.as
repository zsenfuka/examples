﻿package{	import flash.display.Sprite;		import hype.extended.behavior.FixedVibration;	import hype.extended.behavior.VariableVibration;	import hype.extended.color.ColorPool;	import hype.extended.trigger.ExitShapeTrigger;	import hype.framework.core.ObjectPool;	import hype.framework.core.TimeType;	import hype.framework.display.BitmapCanvas;	import hype.framework.rhythm.SimpleRhythm;		public class WordFlow extends Sprite	{								private var myWidth:uint;		private var myHeight:uint;		private var bmc:BitmapCanvas;		private var clipContainer:Sprite;		private var color:ColorPool;		private var pool:ObjectPool;		private var rhythm:SimpleRhythm		private var bgShape:Sprite;						private var exit:ExitShapeTrigger;						public function WordFlow()		{									myWidth = stage.stageWidth;			myHeight = stage.stageHeight;						// Create the exit shape;			bgShape = new Sprite;			bgShape.graphics.beginFill( 0xcccc00 );			bgShape.graphics.drawRect( 0, 0, myWidth, myHeight );			bgShape.graphics.endFill();			addChild( bgShape );															bmc = new BitmapCanvas(myWidth, myHeight);			addChild(bmc);						clipContainer = new Sprite();						color = new ColorPool( 0x587b7C, 0x719b9E, 0x9FC1BE, 0xE0D9BB, 0xDACB94, 0xCABA88, 0xDABD55, 0xC49F32, 0xA97409 );			pool = new ObjectPool( MyCircle, 13 );												pool.onRequestObject = function(clip) 			{								trace("onRequestObject : " + clip);												exit = new ExitShapeTrigger( exitHandler, clip, bgShape );				exit.start( "enter_frame", 10 );																	clip.x = myWidth / 2;				clip.y = myHeight / 2;				clip.scaleX = clip.scaleY = 0;								color.colorChildren(clip);								// target Object, property, spring, ease, vibrationRange								var xVib:VariableVibration = new VariableVibration(clip, "x", 0.9, 0.3, 10);				var yVib:VariableVibration = new VariableVibration(clip, "y", 0.9, 0.3, 10);								xVib.start();				yVib.start();																// target Object, property, spring, ease, min, max, isRelative								var sVib:FixedVibration = new FixedVibration(clip, "scale", 0.99, 0.0005, 0.95, 1.0, false);				//var sVib:FixedVibration = new FixedVibration(clip, "scale", 0.99, 0.05, 0.5, 1.0, false);				sVib.start();								clipContainer.addChild(clip);							}						rhythm = new SimpleRhythm(addNextClip);			rhythm.start(TimeType.TIME, 250);						bmc.startCapture(clipContainer, false);					}								private function exitHandler(clip)		{									trace("exitHandler : " + clip);											}												// addNextClip		private function addNextClip(r:SimpleRhythm):void		{						if (pool.isFull) {				rhythm.stop();			} else {				pool.request();			}					}											}	}