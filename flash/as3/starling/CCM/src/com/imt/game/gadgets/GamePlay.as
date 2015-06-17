﻿package com.imt.game.gadgets{			import com.bedrock.extras.util.MathUtil;	import com.bedrock.extras.util.StringUtil;	import com.bedrock.framework.plugin.storage.SuperArray;	import com.bedrock.framework.plugin.util.ArrayUtil;	import com.bedrock.framework.plugin.util.VariableUtil;	import com.demonsters.debugger.MonsterDebugger;	import com.greensock.TimelineMax;	import com.greensock.TweenAlign;	import com.greensock.TweenMax;	import com.greensock.easing.Power4;	import com.imt.assets.Assets;	import com.imt.framework.core.dispatcher.StarlingDispatcher;	import com.imt.framework.display.AbstractStarlingDisplay;	import com.imt.framework.display.IDisplay;	import com.imt.framework.display.button.GameButton;	import com.imt.framework.display.button.ParticleButton;	import com.imt.framework.engine.data.GameData;	import com.imt.framework.event.StarlingSiteEvent;	import com.imt.game.components.Ball;	import com.imt.game.components.Card;		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.events.MouseEvent;	import flash.geom.Rectangle;	import flash.utils.Dictionary;		import hype.extended.behavior.VariableVibration;	import hype.extended.trigger.ExitRectangleTrigger;	import hype.extended.trigger.ExitShapeTrigger;	import hype.extended.trigger.ExitStarlingShapeTrigger;	import hype.extended.trigger.SeemlessPlacement;	import hype.framework.core.ObjectPool;	import hype.framework.core.TimeType;	import hype.framework.display.BitmapCanvas;	import hype.framework.rhythm.SimpleRhythm;		import starling.display.Image;	import starling.display.Sprite;	import starling.events.Event;	import starling.textures.Texture;	import starling.textures.TextureAtlas;
			public class GamePlay extends AbstractStarlingDisplay implements IDisplay	{						private var _touchedCards:Array;		private var _sequence:SuperArray;		private var _textures:SuperArray;		private var _cards:SuperArray;		private var _cardsDuplicate:Dictionary;		private var COLUMNS:int = 2;		private var PADDING:int = 130;		private var _endWidth:int;		private var _atlas:TextureAtlas;		private var _xml:XML;		private var _alias:String;		//private var _ballsHolder:Sprite;		private var _cardsHolderTouched:Sprite;		private var _stages:Dictionary;		private var _stageSequences:Dictionary;		private var _currentStage:String;		private var _cardsOriginal:Dictionary;		private var _cardPositions:Dictionary;		private var _balls:Array;		private var _pool:ObjectPool		private var _exitShape:Sprite;		private var _numParticles:uint = 5;		private var _numActiveParticles:uint = 0;		public static var STAGE_SEQUENCES:Dictionary;		private var _displayTimeline:TimelineMax;		private var _effectsBitmap:Bitmap;						// Hype.		//var bmc:BitmapCanvas;		private var clipContainer:Sprite;						public function GamePlay()		{			super();		}						public function initialize(data:Object=null):void		{						if( !initialized )			{								trace( this + " : initialize" );				_stages = new Dictionary;				_stageSequences = new Dictionary;				//GamePlay.STAGE_SEQUENCES = new Dictionary;				_displayTimeline = new TimelineMax;				// Cards containers.				//_ballsHolder = new Sprite;				//_cardsHolderTouched = new Sprite;				//_cardsHolderTouched.alpha = 0.5;				//_createCardPositions();				// Set vars.				_alias = data.alias;				_atlas = data.atlas;				_xml = data.xml;				// Create game.				_createGame();				initialized = true;							}					}						public function refresh():void		{						trace(this + " : refresh()");			// Events.			StarlingDispatcher.addEventListener( StarlingSiteEvent.MATCHED, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.MATCHED_SEQUENCE, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.CARDS_MATCHED, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.NO_MATCH, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.PAUSE, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.RESUME, _onEvent );						// To reset particle props here.												_pool.requestAll();					}						public function clear():void		{						trace(this + " : clear()");			StarlingDispatcher.removeEventListener( StarlingSiteEvent.MATCHED, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.MATCHED_SEQUENCE, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.CARDS_MATCHED, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.NO_MATCH, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.PAUSE, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.RESUME, _onEvent );						// Kill animations here.						//_pool.destroy();			//_pool.re			_clearParticles();			_numActiveParticles = 0;								}						public function start():void		{						trace(this + " : start()");			StarlingDispatcher.addEventListener( StarlingSiteEvent.CARDS_MATCHED, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.NO_MATCH, _onEvent );			//pool.requestAll();					}						public function intro():void{};						public function outro():void		{						trace(this + " : outro()");						// Calling an outroComplete based on time.			TweenMax.delayedCall( 1, _onOutroComplete );					}						public function cancel():void{};		public function destroy():void{};						private function _onEvent(event:Event):void		{						trace( this + " _onEvent : " + event.type );						// Reuseable var.			var i:uint;// "for loops".			var clip:ParticleButton;			var length:uint// Used in "for loops".						switch( event.type )			{								case StarlingSiteEvent.PAUSE:					trace( this + " : StarlingSiteEvent.PAUSE" );					_displayTimeline.pause();					break;								case StarlingSiteEvent.RESUME:					trace( this + " : StarlingSiteEvent.RESUME" );					_displayTimeline.resume();					break;								case StarlingSiteEvent.TOUCHED:					_numActiveParticles--;					clip = event.currentTarget as ParticleButton;					clip.disable();					_pool.release( clip );					clipContainer.addChildAt( clip, 0 );										trace("_numActiveParticles : " + _numActiveParticles);					trace("_pool.activeSet.length : " + _pool.activeSet.length);										if( _numActiveParticles <= 0 ) _gameComplete();															break;								case starling.events.Event.ADDED_TO_STAGE:					removeEventListener( starling.events.Event.ADDED_TO_STAGE, _onEvent);					initialize();					break;								default:					trace(this + " : Unhandled event.");								}					}						// Creates and builds out game here.		private function _gameComplete():void		{						trace(this + " : _gameComplete()");																	}												// Creates and builds out game here.		private function _createGame():void		{						trace(this + " : _createGame()");						// Do HYPE stuff here.																		// Add blurring layer here?												clipContainer = new Sprite();			addChild( clipContainer );												//var rhythm:SimpleRhythm = new SimpleRhythm(addNextClip);			//rhythm.start(TimeType.TIME, 1);						_numActiveParticles = _numParticles;						_pool = new ObjectPool( ParticleButton, _numParticles );						_pool.onRequestObject = function(clip:ParticleButton) 			{								//trace(this + " : pool.onRequestObject");				clip.x = Math.random() * Assets.WIDTH;				clip.y = Math.random() * Assets.HEIGHT;				clip.scaleX = clip.scaleY = 0.3 + (Math.floor(Math.random() * 3) * 0.5);								// target Object, property, spring, ease, vibrationRange								var xVib:VariableVibration = new VariableVibration(clip, "x", 0.99, 0.05, 20);				var yVib:VariableVibration = new VariableVibration(clip, "y", 0.99, 0.05, 20);				xVib.start();				yVib.start();				              
								// exit callback function, target Object, shape, shapeFlag								//var onExit:ExitRectangleTrigger = new ExitRectangleTrigger( onExitShape, clip, new Rectangle( _exitShape.x, _exitShape.y, _exitShape.width, _exitShape.height ), false );				// Placed the clip on teh opposite side of the stage when shape exits.				//var onExit:SeemlessPlacement = new SeemlessPlacement( onExitShape, clip, new Rectangle( _exitShape.x, _exitShape.y, _exitShape.width, _exitShape.height ), false );				var onExit:SeemlessPlacement = new SeemlessPlacement( clip, new Rectangle( 0, 0, Assets.WIDTH, Assets.HEIGHT ) );				onExit.start();								clip.enable();				clip.addEventListener( StarlingSiteEvent.TOUCHED, _onEvent );								clipContainer.addChild(clip);							}		}						// Removes particles in play.		private function _clearParticles():void		{						trace(this + " : recreateSequences()");						var clip:ParticleButton;			var l:uint = clipContainer.numChildren;			for( var a:uint = 0; a < l; a++ )			{								trace( a );				clip = clipContainer.getChildAt( 0 ) as ParticleButton;				_pool.release(clip);				clipContainer.removeChild(clip);							}								}						private function onExitShape(clip):void 		{						_pool.release(clip);			clipContainer.removeChild(clip);						// Call obj again?			_pool.request();					}				private function _recreateSequences():void		{						trace(this + " : recreateSequences()");											}						public function getCurrentStage():String		{						return _currentStage;					}						public function setCurrentStage($alias:String):void		{						trace(this + " : setCurrentStage : " + $alias);			_currentStage = $alias;					}				/*		public function createSequences($alias:String, $data:Array):void		{						trace(this + " : createSequences()");			GamePlay.STAGE_SEQUENCES[ $alias ] = _stageSequences[ $alias ] = $data;			//MemoryCardsManager.STAGE_SEQUENCES[ $alias ] = $data;					}						public function destroySequences($alias:String):void		{						trace(this + " : destroySequences() : " + $alias);			GamePlay.STAGE_SEQUENCES[ $alias ] = _stageSequences[ $alias ] = [];			GamePlay.STAGE_SEQUENCES[ $alias ] = _stageSequences[ $alias ] = null;					}				private function _createSequence($total:uint):Array		{						trace(this + " : _createSequence() : " + $total);									// Get var from server and implement here.									return [];								}				private function _playSequence():void		{						trace(this + " : playSequence()");					}						private function _displaySequence($sequence:Array):void		{						trace(this + " : displaySequence() : length : " + $sequence.length);								}						// Call reposition after the _endWidth var has been set/changed.		//private function _repositionLayout($length:uint):void		private function _repositionLayout($clipX:int, $clipY:int):void		{						trace(this + " : _repositionLayout()" );			x = $clipX;			y = $clipY;					}				*/				// Clean up after the outro().		private function _onOutroComplete():void		{						//Assets.getSfx( "VOICE_PLAY_AGAIN_SND" ).play(); 			var l:uint = _sequence.getSelected().length;			for( var i:uint = 0; i < _cards.length; i++ )( _cards.getItemAt( i ) as Card ).clear();			removeChildren();					}			}			}