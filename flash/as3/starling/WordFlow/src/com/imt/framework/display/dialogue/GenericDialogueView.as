﻿package com.imt.mobile.display.dialogue{	import com.greensock.TweenMax;	import com.greensock.easing.Power3;	import com.greensock.easing.Power4;	import com.imt.framework.core.event.SiteEvent;	import com.imt.framework.display.AbstractFlashDisplay;	import com.imt.framework.display.IDisplay;	import com.imt.framework.engine.data.GameData;	import com.imt.framework.engine.data.SiteData;	import com.imt.framework.display.AbstractStarlingDisplay;		//import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;		import com.imt.games.neo.memory_plane.Settings;		import starling.events.Touch;	import starling.events.TouchEvent;	import starling.events.TouchPhase;
		public class GenericDialogueView extends AbstractStarlingDisplay implements IDisplay	{				public var buttonPressed:Sprite;		public var button1:Sprite;		public var button2:Sprite;		public var buttonID:String;		public var sprite:Sprite;		//private var tween				public function GenericDialogueView()		{						super();		}				public function initialize():IDisplay		{						if( !initialized )			{								trace(this + " : initialize");				initialized = true;							}						return null;		}				public function refresh():IDisplay		{						trace(this + " : refresh");			if( !initialized ) initialize();			button1.addEventListener( MouseEvent.MOUSE_DOWN, onEvent );			button2.addEventListener( MouseEvent.MOUSE_DOWN, onEvent );			x = Settings.X_RIGHT;//stage.stageWidth/2;			y = Settings.HEIGHT/2;			intro();						return null;		}						// Handle all the events.		private function onEvent(event:Event):void		{						switch( event.type )			{				//case TouchEvent.TOUCH: 				case MouseEvent.MOUSE_DOWN: 					buttonPressed = ( event as MouseEvent ).currentTarget as Sprite;					switch( buttonPressed )					{						case button1:							buttonID = SiteData.BUTTON_1;							break						case button2:							buttonID = SiteData.BUTTON_2;							break					}					outro();					break;								default:					trace(this + " : Unhandled event.");								}					}						public function intro():IDisplay		{						trace(this + " : intro");			TweenMax.to( this as Sprite, GameData.ANIMATION_TIME, { x:Settings.X_CENTER, onComplete:introComplete, ease:Power4.easeOut } );			return null;					}						public function introComplete():void		{					trace(this + " : introComplete");			dispatchEvent( new SiteEvent( SiteEvent.INTRO_COMLETE ) );					}						public function outroComplete():void		{					trace(this + " : outroComplete");			dispatchEvent( new SiteEvent( SiteEvent.OUTRO_COMLETE, { button:buttonPressed, id:buttonID } ) );					}						public function start():IDisplay		{			return this;		}						public function outro():IDisplay		{						TweenMax.to( this, GameData.ANIMATION_TIME, { x:Settings.X_LEFT, onComplete:outroComplete, ease:Power4.easeIn } );			return null;		}				public function clear():IDisplay		{						x = stage.stageWidth + width + 100;			y = stage.stageHeight + height + 100;			return null;					}				public function destroy():IDisplay		{						trace(this + " : destroy");			initialized = false;			return null;					}			}}