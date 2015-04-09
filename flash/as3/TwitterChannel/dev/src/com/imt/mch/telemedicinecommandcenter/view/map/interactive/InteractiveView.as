﻿package com.imt.mch.TeleMedicineCommandCenter.view.map.interactive{	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;	import com.bedrock.framework.core.event.GenericEvent;	import com.bedrock.framework.plugin.view.IView;	import com.imt.mch.TeleMedicineCommandCenter.controller.DialogueController;	import com.imt.mch.TeleMedicineCommandCenter.event.MapEvent;	import com.imt.mch.TeleMedicineCommandCenter.model.MapStore;	import com.imt.mch.TeleMedicineCommandCenter.view.map.interactive.marker.MarkerManager;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.geom.Point;	import flash.system.Capabilities;		public class InteractiveView extends Sprite// implements IView	{				public var markers:MarkerManager;		public var hotspots:MapHotspotsView		//private var _dialogues:DialogueController;		//private var _image:Sprite;						public function InteractiveView()		{						super();					}				// Initialize class.		public function initialize($data:Object=null):InteractiveView		{						trace(this + " : initialize");						// Add hotspots to the bottom.			hotspots = ( new MapHotspots as MapHotspotsView );			addChild( hotspots );			hotspots.initialize();						// Create the Map Markers.			markers = new MarkerManager;			addChild( markers );						// Events			BedrockDispatcher.addEventListener( MapEvent.MARKER_CREATED, onMarkerEvent );			//BedrockDispatcher.addEventListener( MapEvent.CHECK_MONITORS_GRID, onMarkerEvent );			BedrockDispatcher.addEventListener( MapEvent.MARKER_MODIFIED, onMarkerEvent );			//BedrockDispatcher.addEventListener( MapEvent.CLOSE_CONNECT, onMarkerEvent );						return this;					}						private function onMarkerEvent($e:GenericEvent):void		{						trace(this + " : onMarkerCreated");						switch($e.type)			{								case MapEvent.MARKER_CREATED:					trace(this + " " + MapEvent.MARKER_CREATED + " : " + $e.details.xmlList[ 0 ].label );					// This checks for the collision to see where the content box needs to be placed on stage.					checkCollision( $e.details );					break								case MapEvent.MARKER_MODIFIED:					trace(this + " " + MapEvent.MARKER_MODIFIED);					// This checks for the collision to see where the content box needs to be placed on stage.					checkCollision( $e.details );					break							}					}						// Checks to see what hotspot gets hit.		private function checkCollision($o:Object):void		{						trace( this + " : checkCollision" );						// Simplify Array of hotspots.			var h:Array = hotspots.hotspots;						// Loop thru.			for(var i:uint = 0; i < h.length; i++)			{								// Simplify MovieClip reference.				var c:MovieClip = ( h[ i ] as MovieClip );								if( c.hitTestPoint( $o.target.x, $o.target.y ) )				{										$o.xmlList[ 0 ].center.@x = c.x;					$o.xmlList[ 0 ].center.@y = c.y;					BedrockDispatcher.dispatchEvent( new MapEvent( MapEvent.MARKER_POSITIONS_UPDATED, this, { xmlList:$o.xmlList } ) );					break;									}							}					}						// Clears class.		public function clear():void		{		}			}	}