﻿package com.fatbird.framework.core.dispatcher{		import starling.events.Event;	import starling.events.EventDispatcher;

	/**	 * The BedrockDispatcher class serves as a centralized dispatcher for the Bedrock framework.	 */	public class StarlingDispatcher extends EventDispatcher	{		/*		* Variable Declarations		*/		private static var __eventDispatcher:EventDispatcher = new EventDispatcher();		/*		Dispatch Event		*/		public static function dispatchEvent($event:Event):void		{						return StarlingDispatcher.__eventDispatcher.dispatchEvent($event);		}		/*		Write something descriptive.		*/		public static function addEventListener($type:String, $listener:Function, $capture:Boolean = false, $priority:int = 0, $weak:Boolean = true):void		{			//GlobalDispatcher.__eventDispatcher.addEventListener($type, $listener, $capture, $priority, $weak);			StarlingDispatcher.__eventDispatcher.addEventListener($type, $listener);		}		public static function removeEventListener($type:String, $listener:Function, $capture:Boolean = false):void		{			//GlobalDispatcher.__eventDispatcher.removeEventListener($type, $listener, $capture);			StarlingDispatcher.__eventDispatcher.removeEventListener($type, $listener);		}		public static function hasEventListener($type:String):void		{			StarlingDispatcher.__eventDispatcher.hasEventListener($type);		}		/*		public static function willTrigger($type:String):void		{			GlobalDispatcher.__eventDispatcher.willTrigger($type);		}		*/	}}