﻿package com.imt.mch.TeleMedicineCommandCenter.view.map.interactive.marker{		import com.bedrock.framework.core.dispatcher.BedrockDispatcher;	import com.bedrock.framework.core.event.GenericEvent;	import com.bedrock.framework.plugin.util.ButtonUtil;	import com.greensock.TweenMax;	import com.greensock.easing.BackIn;	import com.greensock.easing.Elastic;	import com.imt.mch.TeleMedicineCommandCenter.event.MapEvent;		import flash.display.FrameLabel;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.display.StageScaleMode;	import flash.events.MouseEvent;	import flash.geom.Point;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;		import hype.extended.behavior.FixedVibration;	import hype.extended.behavior.Swarm;	import hype.framework.rhythm.SimpleRhythm;		import net.charlesclements.gadgets.text.RandomizerTextfield;	import net.charlesclements.gadgets.text.TextRandomizer;		import settings.Settings;			// Constructor	public class MarkerView extends MovieClip	{					// Variables		public var target:MovieClip;		private var _markerText:RandomizerTextfield;		private var _satellite:Sprite;		private var _textfield:TextField;		private var _textformat:TextFormat;		private var _line:Sprite;		public var xmlList:XMLList;		private var _rhythm:SimpleRhythm;		private var _swarm:Swarm;		private var _content:String = "";		private var _isAdjustable:Boolean = false;		private var _index:uint;		private var _isCreated:Boolean = false;		private var _isOpen:Boolean = false;		private var _isConnectOpen:Boolean = false;		private var _adjustLayout:Boolean = false;		private var _blink:MovieClip;						// Constructor.		public function MarkerView()		{						xmlList = new XMLList( new XML );					}						// Draws a line to the target.		public function setup($xml:XML, $index:uint, $delay:Number=0):MarkerView		{						xmlList = new XMLList( $xml );			_index = $index;			visible = false;			target.gotoAndStop( "BIG" );			TweenMax.delayedCall( $delay, createMarker );			return this;					}							// Adds all listeners for Marker.		private function addListeners():void		{						// Buttons.			ButtonUtil.addListeners( target, { down:onDown, up:onUp } );			ButtonUtil.addListeners( _markerText, { down:onDown, up:onUp } );			// Marker events.			BedrockDispatcher.addEventListener( MapEvent.CONNECT_DIALOGUE_CLOSED, onMarkerEvent );			BedrockDispatcher.addEventListener( MapEvent.CLOSE_CONNECT_DIALOGUE, onMarkerEvent );			BedrockDispatcher.addEventListener( MapEvent.MARKER_SELECTED, onMarkerEvent );			BedrockDispatcher.addEventListener( MapEvent.MARKER_REFRESH, onMarkerEvent );			BedrockDispatcher.addEventListener( MapEvent.SHOW_LOCATION, onMarkerEvent );					}								// Actions for when any Marker is selected.		private function onMarkerEvent($e:GenericEvent):void		{									switch( $e.type )			{								case MapEvent.CLOSE_CONNECT_DIALOGUE:					_isConnectOpen = true;					break;								case MapEvent.CONNECT_DIALOGUE_CLOSED:					if( !_isOpen ) addText().drawLine().addBehaviour();					break;								case MapEvent.SHOW_LOCATION:					trace(this + " : " + $e.type)					// do window close					if( $e.details.xmlList[ 0 ].label != xmlList[ 0 ].label ) closeText();					break;								case MapEvent.MARKER_REFRESH:					if( $e.details.xmlList[ 0 ].label == xmlList[ 0 ].label )					{												refresh( $e.details.xmlList );											}					break;								case MapEvent.MARKER_SELECTED:					if( $e.details.xmlList[ 0 ].label != xmlList[ 0 ].label )					{												_isOpen = false;											}					else					{												addText().drawLine().addBehaviour();											}					break;							}					}						// Should show content.		private function autoPilot():MarkerView		{						trace(this + " : autoPilot : Show content")			addText().drawLine().addBehaviour();			return this;					}						// Creates everything in the Marker after delay.		private function onDown($e:MouseEvent):void		{						var c:MovieClip = $e.currentTarget as MovieClip;			stage.addEventListener( MouseEvent.MOUSE_UP, onUp );			TweenMax.to( c, 0, { delay:0.4, onComplete:makeAdjustable, onCompleteParams:[ c ] } );					}				// Creates everything in the Marker after delay.		private function onUp($e:MouseEvent):void		{						trace(this+ " : onUp");			// Kill the stage listener.			stage.removeEventListener( MouseEvent.MOUSE_UP, onUp );			// Need to apply code to both target and textfield.			TweenMax.killTweensOf( target );			target.stopDrag();			target.gotoAndPlay( 1 );			TweenMax.killTweensOf( _markerText );			_markerText.stopDrag();			_markerText.gotoAndPlay( 1 );			// Manage if adjustible.			if( _isAdjustable )			{								_isAdjustable = false;				if( _markerText.contains( _blink ) ) _markerText.removeChild( _blink );				xmlList[ 0 ].target.@x = target.x;				xmlList[ 0 ].target.@y = target.y;				xmlList[ 0 ].content.@x = _satellite.x = _markerText.x;				xmlList[ 0 ].content.@y = _satellite.y = _markerText.y;				BedrockDispatcher.dispatchEvent( new MapEvent( MapEvent.MARKER_MODIFIED, this, { index:_index, xmlList:xmlList, target:target, points:{ dialogueX:xmlList[ 0 ].center.@x, dialogueY:xmlList[ 0 ].center.@y } } ) );							}			else			{								if( _isOpen ) BedrockDispatcher.dispatchEvent( new MapEvent( MapEvent.SHOW_LOCATION, this, { label:xmlList[ 0 ].label, xmlList:xmlList, points:{ dialogueX:xmlList[ 0 ].center.@x, dialogueY:xmlList[ 0 ].center.@y } } ) );				else BedrockDispatcher.dispatchEvent( new MapEvent( MapEvent.MARKER_SELECTED, this, { index:_index, xmlList:xmlList } ) );								}		}						// Creates everything in the Marker after delay.		private function makeAdjustable($c:MovieClip):void		{						_isAdjustable = true;			$c.startDrag( false );						var arr:Array = $c.currentLabels			for(var i:uint = 0; i < arr.length; i++) 			{								if( ( arr[ i ] as FrameLabel ).name == "BLINK" )				{										$c.gotoAndPlay( "BLINK" );					return;									}							}						_markerText.addChild( _blink );					}						// Creates everything in the Marker after delay.		private function createMarker():void		{						_blink = new RepositionIndicator as MovieClip;			// Add line.			_line = new Sprite;			_line.mouseChildren = false;			_line.mouseEnabled = false;			addChild( _line );			// Text stuff.			_markerText = new RandomizerTextfield();			_markerText.initialize( { width:110, aheadCount:5 } );			// Get X and Y for the position right here.			_markerText.x = int( xmlList[0].content.@x );			_markerText.y = int( xmlList[0].content.@y );			_markerText.scaleX = _markerText.scaleY = 2;			addChild( _markerText );			// Target property.			target.x = int( xmlList[0].target.@x );			target.y = int( xmlList[0].target.@y );			target.scaleX = target.scaleY = 0.1;			// Create satellite for text to follow.			_satellite = new Sprite;			_satellite.x = _markerText.x;			_satellite.y = _markerText.y;			addChild( _satellite );			// This event should determine what XY coordinates the markerText should be set to.			BedrockDispatcher.dispatchEvent( new MapEvent( MapEvent.MARKER_CREATED, this, { xmlList:xmlList, marker:this, target:target, points:{ dialogueX:xmlList[ 0 ].center.@x, dialogueY:xmlList[ 0 ].center.@y } } ) );			// Behaviour stuff.			_rhythm = new SimpleRhythm( run );			// Tweening.			var s:Number = 2.5;			var t:Number = 0.7;			TweenMax.to( target, t, { scaleX:s, scaleY:s, ease:Elastic.easeOut } );			TweenMax.to( target, t, { delay:t + 0.05, scaleX:0.65, scaleY:0.65, ease:Elastic.easeInOut, onComplete:introTargetComplete } );			// Show!			visible = true;			_isCreated = true;					}						private function introTargetComplete():void		{						// Play pulsing.			target.play();			// Adds listeners after everything in Marker has been setup.			if( Settings.IS_INTERACTIVE ) addListeners();			if( !_isConnectOpen ) autoPilot();					}				// Updates the text and the lines.		public function refresh($xmlList:XMLList):MarkerView		{						xmlList = $xmlList;			if( _isCreated )			{								target.x = int( xmlList[0].target.@x );				target.y = int( xmlList[0].target.@y );				_satellite.x = _markerText.x = int( xmlList[0].content.@x );				_satellite.y = _markerText.y = int( xmlList[0].content.@y );								}			return this;					}						// Updates the text and the lines.		public function addBehaviour():MarkerView		{						_rhythm.start();			return this;					}						private function run(e:Object):void		{						drawLine();					}						// Draws a line to the target.		private function drawLine($clear:Boolean=false):MarkerView		{						_line.graphics.clear();			if( $clear == false )			{								with( _line.graphics )				{										lineStyle(0.5, 0xffffff);					moveTo( target.x, target.y );					lineTo( _markerText.x, _markerText.y );									}							}			return this;					}						// Adds text to the textfield.		private function addText():MarkerView		{						_isOpen = true;			// Set title.			_content = "";			_content += String( xmlList.label[ 0 ] ).toUpperCase() + "\n";			for(var i:uint = 0; i < xmlList[0].content.textline.length(); i++)			{								_content += xmlList.content.textline[ i ] + "\n";							}			// Send the content string to the MarkerText instance.			_markerText.addText( _content );			addChild( _markerText );			return this;					}						public function hide($delay:Number=0):MarkerView		{						var s:Number = 0.01;			var t:Number = 1;			TweenMax.to( _markerText, t, { delay:$delay, x:target.x, y:target.y, scaleX:s, scaleY:s, ease:BackIn.ease } );			TweenMax.to( target, t, { delay:t + 0.3 + $delay, scaleX:s, scaleY:s, ease:BackIn.ease, onComplete:onCloseComplete } );			return this;					}						private function onCloseComplete():void		{						dispatchEvent( new MapEvent( MapEvent.MARKER_CLOSED, this ) );					}						public function close():MarkerView		{						trace(this + " : close")			closeText();			return this;					}						// Removes it form the Stage.		private function closeText():MarkerView		{						//trace(this + " : closeText")						if( _markerText != null && contains( _markerText ) ) 			{								_isOpen = false;				_rhythm.stop();				removeChild( _markerText );				drawLine( true );				TweenMax.killTweensOf( _markerText );				TweenMax.killTweensOf( target );				TweenMax.killTweensOf( _satellite );				//_markerText.clear();							}						return this;					}						// Clears everything from Marker when removing.		public function clear():MarkerView		{						trace(this +" : clear");			BedrockDispatcher.removeEventListener( MapEvent.MARKER_SELECTED, onMarkerEvent );			BedrockDispatcher.removeEventListener( MapEvent.SHOW_LOCATION, onMarkerEvent );			BedrockDispatcher.removeEventListener( MapEvent.MARKER_REFRESH, onMarkerEvent );			ButtonUtil.removeListeners( target, { down:onDown, up:onUp } );			closeText();			//_rhythm.stop();						return this;					}			}	}