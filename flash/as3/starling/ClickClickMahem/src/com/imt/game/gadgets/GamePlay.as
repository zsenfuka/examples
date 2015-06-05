﻿package com.imt.game.gadgets{			import com.bedrock.extras.util.MathUtil;	import com.bedrock.extras.util.StringUtil;	import com.bedrock.framework.plugin.storage.SuperArray;	import com.bedrock.framework.plugin.util.ArrayUtil;	import com.bedrock.framework.plugin.util.VariableUtil;	import com.demonsters.debugger.MonsterDebugger;	import com.greensock.TimelineMax;	import com.greensock.TweenAlign;	import com.greensock.TweenMax;	import com.greensock.easing.Power4;	import com.imt.framework.core.dispatcher.StarlingDispatcher;	import com.imt.framework.display.AbstractStarlingDisplay;	import com.imt.framework.display.IDisplay;	import com.imt.framework.event.StarlingSiteEvent;	import com.imt.game.components.Card;		import flash.utils.Dictionary;		import starling.display.Sprite;	import starling.events.Event;	import starling.textures.TextureAtlas;
			public class GamePlay extends AbstractStarlingDisplay implements IDisplay	{						private var _touchedCards:Array;		private var _sequence:SuperArray;		private var _textures:SuperArray;		private var _cards:SuperArray;		private var _cardsDuplicate:Dictionary;		private var COLUMNS:int = 2;		private var PADDING:int = 130;		private var _endWidth:int;		private var _atlas:TextureAtlas;		private var _xml:XML;		private var _alias:String;		private var _cardsHolder:Sprite;		private var _cardsHolderTouched:Sprite;		private var _stages:Dictionary;		private var _stageSequences:Dictionary;		private var _currentStage:String;		private var _cardsOriginal:Dictionary;		private var _cardPositions:Dictionary;		public static var STAGE_SEQUENCES:Dictionary;		private var _displayTimeline:TimelineMax;						public function GamePlay()		{			super();		}						public function initialize(data:Object=null):void		{						if( !initialized )			{								trace( this + " : initialize" );				_stages = new Dictionary;				_stageSequences = new Dictionary;				GamePlay.STAGE_SEQUENCES = new Dictionary;				_displayTimeline = new TimelineMax;				// Cards containers.				_cardsHolder = new Sprite;				_cardsHolderTouched = new Sprite;				_cardsHolderTouched.alpha = 0.5;				//_createCardPositions();				// Set vars.				_alias = data.alias;				_atlas = data.atlas;				_xml = data.xml;				// Create game.				_createMemoryGame();				initialized = true;							}					}						public function refresh():void		{						trace(this + " : refresh()");			// Events.			StarlingDispatcher.addEventListener( StarlingSiteEvent.MATCHED, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.MATCHED_SEQUENCE, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.CARDS_MATCHED, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.NO_MATCH, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.PAUSE, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.RESUME, _onEvent );			// Add to stage.			addChild( _cardsHolder );			addChild( _cardsHolderTouched );			// Clear the array of the touched Card references.			_touchedCards = [];			//_repositionLayout();			// Refresh all cards.			//for( var i:uint = 0; i < _cards.length; i++ ) ( _cards.source[ i ] as Card ).refresh();					}						public function clear():void		{						trace(this + " : clear()");			StarlingDispatcher.removeEventListener( StarlingSiteEvent.MATCHED, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.MATCHED_SEQUENCE, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.CARDS_MATCHED, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.NO_MATCH, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.PAUSE, _onEvent );			StarlingDispatcher.removeEventListener( StarlingSiteEvent.RESUME, _onEvent );						/*			// Clear all cards.			for( var i:uint = 0; i < _cards.length; i++ )( _cards.getItemAt( i ) as Card ).clear();			_cardsHolder.removeChildren();			_cardsHolderTouched.removeChildren();			*/		}						public function start():void		{						trace(this + " : start()");			StarlingDispatcher.addEventListener( StarlingSiteEvent.CARDS_MATCHED, _onEvent );			StarlingDispatcher.addEventListener( StarlingSiteEvent.NO_MATCH, _onEvent );			_recreateSequences();			//_sequence.setSelected( -1 );			_playSequence();					}						public function intro():void{};						public function outro():void		{						trace(this + " : outro()");			/*						// Do outro on existing cards.			var l:uint = _sequence.getSelected().length;			for( var i:uint = 0; i < l; i++ ) _sequence.getSelected()[ i ].outro();*/			// Calling an outroComplete based on time.			TweenMax.delayedCall( 1, _onOutroComplete );					}						public function cancel():void{};		public function destroy():void{};						private function _onEvent(event:Event):void		{						trace( this + " _onEvent : " + event.type );			// Reuseable var.			var i:uint;// "for loops".			var c:Card;// Incremental card references.			var c2:Card;// Incremental card references.			var length:uint// Used in "for loops".						switch( event.type )			{								case StarlingSiteEvent.PAUSE:					trace( this + " : StarlingSiteEvent.PAUSE" );					_displayTimeline.pause();					break;								case StarlingSiteEvent.RESUME:					trace( this + " : StarlingSiteEvent.RESUME" );					_displayTimeline.resume();					break;								case StarlingSiteEvent.MATCHED:					trace( this + " : StarlingSiteEvent.MATCHED" );					//_repositionLayout( _sequence.getSelected().length );					break;								case StarlingSiteEvent.MATCHED_SEQUENCE:					trace( this + " : StarlingSiteEvent.MATCHED_SEQUENCE" );										break;								case StarlingSiteEvent.CARDS_MATCHED:										/*					// Number of the children on the stage.					length = _cardsHolderTouched.numChildren;					// You win!					if( _sequence.selectedIndex >= _sequence.lastIndex && length >= _sequence.selectedItem.length )					{												// Announce globally that the user won.						StarlingDispatcher.dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.WIN, {} ) );						// Clear the touchedCards Array.						_touchedCards = [];											}					// Play next sequence.					else if( length < ( _sequence.selectedItem as Array ).length )					{												trace( "CARDS_MATCHED : Keep choosing" );						// Clear the touchedCards Array.						_touchedCards = [];						StarlingDispatcher.dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.MATCHED, {} ) );											}					else 					{												trace( "CARDS_MATCHED : Show new sequence." );						_touchedCards = [];																		//_displayTimeline.timeScale( 0.15 );						//_displayTimeline.reverse();						//_displayTimeline.progress(0);						_displayTimeline.pause(0);												for( i = 0; i < length; i++ )						{														c = _cardsHolderTouched.getChildAt( i ) as Card;							c.touchable = false;							// Outro Cards.							//TweenMax.to( c, 0, { delay:0.3, onComplete:c.outro } );													}						// Announce globally that there is a MATCH!						StarlingDispatcher.dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.MATCHED_SEQUENCE, {} ) );						// Delayed temporarily so the cards have a chance to outro().						TweenMax.delayedCall( 0.35, _playSequence );											}										*/																				break;								case StarlingSiteEvent.NO_MATCH:															/*					length = _cardsHolder.numChildren;					for( i = 0; i < length; i++ )					{												c = _cardsHolder.getChildAt( i ) as Card;						c.touchable = false;						TweenMax.to( c, 0, { delay:0.3, onComplete:c.showFront } );											}					*/					// Clear the touchedCards Array.					_touchedCards = [];										break;								case StarlingSiteEvent.TOUCHED:																									/*															//dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.CARD_TOUCHED, {} ) );										c = event.currentTarget as Card;					//trace(this + " : StarlingSiteEvent.TOUCHED : " + c.data.name + " : " + c.data.index + " : " + c.data.front + " : " + c.data.back );					c.touchable = false;										var l:uint = _touchedCards.length;					var matched:Boolean = false;					if( l > 0 )					{												// Check if card was already picked.						for( i = 0; i < l; i++ )						{														if( c.data.id == ( _touchedCards[ i ] as Card ).data.id )							{																matched = true;								event.stopImmediatePropagation();								// Add cards into the new container.								_cardsHolderTouched.addChild( c );								c2 = ( _touchedCards[ i ] as Card );								_cardsHolderTouched.addChild( c2 );								StarlingDispatcher.dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.CARDS_MATCHED, {} ) );								// Show a yeah screen here.								// Clear the touchedCards Array.								_touchedCards = [];								break;															}																				}						// Was there a match?						if( !matched )						{														_touchedCards = [];							StarlingDispatcher.dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.NO_MATCH, {} ) );													}						//else dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.CARD_TOUCHED, {} ) );						// Break before Card gets pushed into Array.						break;											}					else dispatchEvent( new StarlingSiteEvent( StarlingSiteEvent.CARD_TOUCHED, {} ) );					// Push card into Array for comparison.					//_touchedCards.push( event.data.id );					_touchedCards.push( c );										*/																														break;								case starling.events.Event.ADDED_TO_STAGE:					removeEventListener( starling.events.Event.ADDED_TO_STAGE, _onEvent);					initialize();					break;								default:					trace(this + " : Unhandled event.");								}					}						private function _createCards():void		{						trace(this + " : createCards()");															/*						var list:XMLList = _xml..SubTexture.( StringUtil.beginsWith( @name, "cards/" ) );			var l:uint = list.length();			var back:String;			_textures = new SuperArray;			// Push objects into Array.			for( var i:uint = 0; i < l; i++ )			{								back = list[ i ].@name.toXMLString();				if( back != "cards/card-front" ) _textures.push( { id:String( "cards/card" + i ), front:"cards/card-front", back:back } );							}			_cards = new SuperArray;			_cardsOriginal = new Dictionary;			_cardsDuplicate = new Dictionary;			var texturesCopy:Array = _textures.duplicate();			var total:uint = texturesCopy.length;//4;			var c1:Card;			var c2:Card;			// Create each Card.			for( var a:uint = 0; a < total; a++ ) 			{								back = _textures.getItemAt( a ).back;				if( back != "cards/card-front" )				{										var o:Object = texturesCopy.shift();					o.index = a;					o.atlas = _atlas;					o.name = back;					o.duplicate = false;					c1 = _cardsOriginal[ a ] = new Card( o );					c1.initialize();					c1.addEventListener( StarlingSiteEvent.TOUCHED, _onEvent );					_cards.push( c1 );					// Create a second set of cards.					// Store a duplicate in a Dictionary class.					var o2:Object = VariableUtil.clone( o );					o2.name = back + "_dub"					o2.atlas = _atlas;					o2.index = a;					o2.duplicate = true					c2 = _cardsDuplicate[ c1.data.id ] = new Card( o2 );					c2.addEventListener( StarlingSiteEvent.TOUCHED, _onEvent );					c2.initialize();					//trace("Creating card index a : " + a + " , c1 back: " + c1.data.back + " , c2 back: " + c2.data.back );					//trace("CREATED CARD" );									}				else				{										//trace("DON'T CREATE" );					//trace("Not creating card");									}											}						//MonsterDebugger.trace( this, _cards );			//trace("Total created " + _cards.length );						// This createCards() function only gets called once, but the createSequence() gets called multiple times.			// Only create the sequence variable once.			_sequence = new SuperArray;			*/		}						// Creates and builds sequences of cards.		private function _createMemoryGame():void		{						trace(this + " : createMemoryGame()");			// Creates cards for class use.			_createCards();					}						private function _recreateSequences():void		{						trace(this + " : recreateSequences()");									/*						var arr:Array = _stageSequences[ getCurrentStage() ];			// Create one full sequence.			_sequence.clear();			var l:uint = arr.length;			for( var i:uint = 0; i < l; i++ )			{								_sequence.push( _createSequence( arr[ i ] ) );							}			_sequence.wrapIndex = true;// Left this as true so the initial runtime selected item can be 0.						*/											}						public function getCurrentStage():String		{						return _currentStage;					}						public function setCurrentStage($alias:String):void		{						trace(this + " : setCurrentStage : " + $alias);			_currentStage = $alias;					}						public function createSequences($alias:String, $data:Array):void		{						trace(this + " : createSequences()");			GamePlay.STAGE_SEQUENCES[ $alias ] = _stageSequences[ $alias ] = $data;			//MemoryCardsManager.STAGE_SEQUENCES[ $alias ] = $data;					}						public function destroySequences($alias:String):void		{						trace(this + " : destroySequences() : " + $alias);			GamePlay.STAGE_SEQUENCES[ $alias ] = _stageSequences[ $alias ] = [];			GamePlay.STAGE_SEQUENCES[ $alias ] = _stageSequences[ $alias ] = null;					}						private function _createSequence($total:uint):Array		{						trace(this + " : _createSequence() : " + $total);															/*			if( MathUtil.isEven( $total ) )			{								_endWidth = PADDING * $total;				//_repositionLayout();				var card:Card;				var arr:Array = [];				var copy:Array = _cards.duplicate();				// Shuffle Array.				ArrayUtil.shuffle( copy );				for( var a:uint = 0; a < $total / 2; a++ ) 				{										// Get Card.					card = copy.shift();					arr.push( card );					// Create duplicate card.					card = _cardsDuplicate[ card.data.id ] as Card;					arr.push( card );									}				copy = [];				// Return new Array.				return arr;							}			else throw( "The total of the sequence must be an event number, divisible by 2." );			*/						return [];								}				private function _playSequence():void		{						trace(this + " : playSequence()");												/*						// Clear the array of the touched Card references.			_touchedCards = [];			// Remove the cards from the display.			_cardsHolder.removeChildren();			_cardsHolderTouched.removeChildren();			var c1:Card			var c2:Card						for( var i:uint = 0; i < _cards.length; i++ )			{								// This is where the confusion is happening.				c1 = ( _cards.getItemAt( i ) as Card );				c1.refresh();					c2 = ( _cardsDuplicate[ c1.data.id ] as Card );				c2.refresh();							}			_displaySequence( _sequence.selectNext() );			trace(this + " : playSequence()");			*/		}						private function _displaySequence($sequence:Array):void		{						trace(this + " : displaySequence() : length : " + $sequence.length);												/*			ArrayUtil.shuffle( $sequence );			var length:uint = $sequence.length;			var i:uint;						_displayTimeline.kill();			_displayTimeline = new TimelineMax({});						_displayTimeline.pause( 0 );			var tweens:Array = [];						for( i = 0; i < length; i++ )			{								//var c:Card = $sequence[ i ] as Card;				var c:Card = $sequence[ i ] as Card;				trace(i + " : " + c.data.name);				var obj:Object = {};				obj.index = i;				//obj.origX = _endWidth / 2;				obj.origX = stage.stageWidth / 2;				obj.targX = _cardPositions[ length ].positions[ i ].x;				obj.origScaleX = 0.05;				obj.origScaleY = 0.05;				obj.targScaleX = 1.0;				obj.targScaleY = 1.0;				obj.origY = 100;				obj.targY = _cardPositions[ length ].positions[ i ].y;				c.update( obj );				_cardsHolder.addChild( c );				c.refresh();
				c.intro();    																//tweens.push( new TweenMax( c, 0, { delay:data.index * 0.6, autoAlpha:0, immediateRender:true, x:obj.targX, y:obj.targY, scaleX:obj.origScaleX, scaleY:obj.origScaleY } ) );				tweens.push( new TweenMax( c, 0.8, { autoAlpha:1, x:obj.targX, y:obj.targY, scaleX:obj.targScaleX, scaleY:obj.targScaleY, onComplete:c.showFront, ease:Power4.easeOut } ) );				//delay:obj.index * 0.6, 																							}			_repositionLayout( _cardPositions[ length ].clipX, _cardPositions[ length ].clipY );			_displayTimeline.appendMultiple( tweens, 0, TweenAlign.SEQUENCE, -0.15 );			_displayTimeline.timeScale( 1 );			_displayTimeline.play( 0 );			*/								}						// Call reposition after the _endWidth var has been set/changed.		//private function _repositionLayout($length:uint):void		private function _repositionLayout($clipX:int, $clipY:int):void		{						trace(this + " : _repositionLayout()" );			x = $clipX;			y = $clipY;					}						// Clean up after the outro().		private function _onOutroComplete():void		{						//Assets.getSfx( "VOICE_PLAY_AGAIN_SND" ).play(); 			var l:uint = _sequence.getSelected().length;			for( var i:uint = 0; i < _cards.length; i++ )( _cards.getItemAt( i ) as Card ).clear();			removeChildren();					}				/*		// This creates a set of positions into a Dictionary that can be accessed by passing in the length of the amount of Cards requested.		private function _createCardPositions():void		{						trace(this + " : _createPositions()" );			_cardPositions = new Dictionary;			_cardPositions[ 4 ] = { clipX:250, clipY:200, positions:[ { x:PADDING * 0, y:PADDING * 0 }, { x:PADDING * 1, y:PADDING * 0 }, { x:PADDING * 2, y:PADDING * 0 }, { x:PADDING * 3, y:PADDING * 0 } ] };			_cardPositions[ 6 ] = { clipX:350, clipY:175, positions:[ { x:PADDING * 0, y:PADDING * 0 }, { x:PADDING * 1, y:PADDING * 0 }, { x:PADDING * 2, y:PADDING * 0 }, 									{ x:PADDING * 0, y:PADDING * 1 }, { x:PADDING * 1, y:PADDING * 1 }, { x:PADDING * 2, y:PADDING * 1 } ] };			_cardPositions[ 8 ] = { clipX:250, clipY:175, positions:[ { x:PADDING * 0, y:PADDING * 0 }, { x:PADDING * 1, y:PADDING * 0 }, { x:PADDING * 2, y:PADDING * 0 }, { x:PADDING * 3, y:PADDING * 0 }, 									{ x:PADDING * 0, y:PADDING * 1 }, { x:PADDING * 1, y:PADDING * 1 }, { x:PADDING * 2, y:PADDING * 1 }, { x:PADDING * 3, y:PADDING * 1 } ] };			_cardPositions[ 10 ] = { clipX:200, clipY:175, positions:[ { x:PADDING * 0, y:PADDING * 0 }, { x:PADDING * 1, y:PADDING * 0 }, { x:PADDING * 2, y:PADDING * 0 }, { x:PADDING * 3, y:PADDING * 0 }, { x:PADDING * 4, y:PADDING * 0 }, 									{ x:PADDING * 0, y:PADDING * 1 }, { x:PADDING * 1, y:PADDING * 1 }, { x:PADDING * 2, y:PADDING * 1 }, { x:PADDING * 3, y:PADDING * 1 }, { x:PADDING * 4, y:PADDING * 1 } ] };			_cardPositions[ 12 ] = { clipX:150, clipY:175, positions:[ { x:PADDING * 0, y:PADDING * 0 }, { x:PADDING * 1, y:PADDING * 0 }, { x:PADDING * 2, y:PADDING * 0 }, { x:PADDING * 3, y:PADDING * 0 }, { x:PADDING * 4, y:PADDING * 0 }, { x:PADDING * 5, y:PADDING * 0 }, 									{ x:PADDING * 0, y:PADDING * 1 }, { x:PADDING * 1, y:PADDING * 1 }, { x:PADDING * 2, y:PADDING * 1 }, { x:PADDING * 3, y:PADDING * 1 }, { x:PADDING * 4, y:PADDING * 1 }, { x:PADDING * 5, y:PADDING * 1 } ] };					}		*/			}			}