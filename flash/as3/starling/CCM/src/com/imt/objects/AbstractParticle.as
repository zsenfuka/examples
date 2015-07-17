﻿package com.imt.objects{				import com.greensock.TimelineMax;	import com.greensock.TweenAlign;	import com.greensock.TweenMax;	import com.imt.framework.core.dispatcher.Dispatcher;	import com.imt.framework.core.event.SiteEvent;	import com.imt.framework.event.StarlingSiteEvent;		import flash.utils.Dictionary;		import hype.framework.behavior.AbstractBehavior;	import hype.framework.trigger.AbstractTrigger;		import starling.display.DisplayObject;	import starling.display.Image;	import starling.display.Sprite;	import starling.events.Event;	import starling.events.TouchEvent;	import starling.events.TouchPhase;	import starling.textures.Texture;
			public class AbstractParticle extends Sprite	{				//private var bg:Image;		public var t:TweenMax;		private var blinkTween:TimelineMax;		public var eventComplete:String = "";		public var initialized:Boolean = false;		public var time:Number = 1;		private var bg:Image;		private var _upState:Texture;		private var _downState:Texture;		public var id:String = "";		public var index:uint = 0;		public var data:Object;		public var locked:Boolean = false;		protected var _behaviour:Array = [];		protected var _behaviourDictionary:Dictionary;		protected var _stageIndex:uint = 0;		protected var _key:String = "0";		protected var _swarmPoint:DisplayObject = null;						public function AbstractParticle($data:Object, upState:Texture, text:String, downState:Texture = null)		{						data = $data;			locked = ( $data.locked == true ) ? true : false;			index = ( $data.index ) ? $data.index : 0;			id = ( $data.id ) ? $data.id : String( "AbstractButton_" + index );				_upState = upState;			_downState = downState;			bg = new Image( _upState );			addChild( bg );			//bg.x = ( bg.width / 2 ) * -1;			//bg.y = ( bg.height / 2 ) * -1;			touchable = true;				addEventListener( TouchEvent.TOUCH, onEvent);			t = new TweenMax({},0,{});						_behaviourDictionary = new Dictionary;									// Blinking.						//arr.push( new TweenMax( this, 0.3, { scaleX:1.5, scaleY:1.5 } ) );			//arr.push( new TweenMax( this, 0.3, { delay:0.7, scaleX:1, scaleY:1 } ) );						blinkTween = new TimelineMax( { repeat:-1} );			/*arr.push( new TweenMax( this, 0.3, { x:"5" } ) );			arr.push( new TweenMax( this, 0.3, { delay:0.5, x:0 } ) );			blinkTween.appendMultiple( arr, 0, TweenAlign.SEQUENCE );*/					}				public function set key(key:String):void		{						_key = key;					}						public function get key():String		{						return _key;					}												// Runs behaviour		public function startBehaviour():void		{						trace( this + " : startBehaviour" );						// Kill running behaviours.			stopBehaviour();						trace( "+" );			var b:Dictionary = _behaviourDictionary;			trace( "+" );									trace( b );			trace( _key );			trace( b[ _key ].length );									var l:uint = b[ _key ].length;						trace( "+" );			for( var a:uint = 0; a < l; a++ )			{								b[ _key ][ a ].start();							}			trace( "+" );					}						// Stops behaviour		public function stopBehaviour():void		{						trace( this + " : stopBehaviour" );									// Address manager directly?									AbstractBehavior.removeBehaviorsFromObject( this );			AbstractTrigger.removeTriggersFromObject( this );									/*			var b:Dictionary = _behaviourDictionary;			var l:uint = b[ _key ].length;						for( var a:uint = 0; a < l; a++ )			{								for( var b:uint = 0; b < stagesLength; b++ )				{										trace( b[ _key ][ b ] );					if( b[ _key ][ b ] != undefined ) b[ _key ][ b ].stop();																			}							}			*/														}																		public function enable():void		{			//trace( this + " enable" );			addEventListener( TouchEvent.TOUCH, onEvent);			touchable = true;					}				public function disable():void		{						removeEventListener( TouchEvent.TOUCH, onEvent);			touchable = false;						if( _downState )			{								bg.dispose();				bg = new Image( _downState );				addChild( bg );							}								}				public function blink($doBlinking:Boolean=true):void		{						trace(this + " : blink : "  + $doBlinking );						if( $doBlinking )			{								blinkTween.clear();				blinkTween = new TimelineMax( { repeat:-1} );				var arr:Array = [];								var X:int = x;								arr.push( new TweenMax( this, 0.2, { delay:0.5, x:X + 15 } ) );				arr.push( new TweenMax( this, 0.2, { delay:0.05, x:X } ) );				blinkTween.appendMultiple( arr, 0, TweenAlign.SEQUENCE );								blinkTween.play( 0 );							}			else			{								blinkTween.gotoAndStop( 0 );				blinkTween.clear();							}											}						private function onEvent(event:Event):void		{						switch( event.type )			{								case TouchEvent.TOUCH:					if( (event as TouchEvent ).getTouch( this, TouchPhase.BEGAN ) )					{												dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.TOUCHED, data ) );						//timed( time );											}					break;								}					}												public function destroy():void		{						trace( "AbstractButton - destroy" );						stopTimer();						removeChild( bg );			removeEventListener( TouchEvent.TOUCH, onEvent);			bg.dispose();									_upState.dispose();			_downState.dispose();						dispose();						//_upState.					}								public function stopTimer():AbstractParticle		{						t.kill();			return this;					}						public function timed($seconds:Number):AbstractParticle		{						t.kill();			t = TweenMax.delayedCall( $seconds, timedComplete );			return this;					}						private function timedComplete():void		{						dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.TIMER_COMPLETE, data ) );			dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.TOUCHED, data ) );					}						public function close():AbstractParticle		{						Dispatcher.dispatchEvent( new SiteEvent( SiteEvent.CLOSE_WINDOW ) );			return this;					}			}}