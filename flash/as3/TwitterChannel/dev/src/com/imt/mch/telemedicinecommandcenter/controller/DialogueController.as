﻿package com.imt.mch.TeleMedicineCommandCenter.controller{	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;	import com.bedrock.framework.core.event.GenericEvent;	import com.bedrock.framework.plugin.view.SpriteView;	import com.demonsters.debugger.MonsterDebugger;	import com.greensock.layout.AlignMode;	import com.greensock.layout.LiquidArea;	import com.greensock.layout.ScaleMode;	import com.imt.framework.display.Container;	import com.imt.framework.display.FlashDisplayer;	import com.imt.framework.display.IDisplay;	import com.imt.framework.engine.data.SiteData;	import com.imt.framework.plugin.remoting.SaveEditedLocationXML;	import com.imt.mch.TeleMedicineCommandCenter.data.AppData;	import com.imt.mch.TeleMedicineCommandCenter.event.MapEvent;	import com.imt.mch.TeleMedicineCommandCenter.view.map.interactive.dialogue.MapDialogueView;	import com.imt.mch.TeleMedicineCommandCenter.view.map.interactive.dialogue.SlideImageDialogue;	import com.imt.mch.TeleMedicineCommandCenter.view.map.interactive.dialogue.location.LocationDialogueView;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Point;		import settings.Settings;
		public class DialogueController extends SpriteView	{				private var _xml:XML;		private var _mapDialogue:IDisplay;		private var _slideImageDialogue:IDisplay;		private var _locationDialogue:IDisplay;		private var _scheduleDialogue:IDisplay;		private var _container:FlashDisplayer		private var _area:LiquidArea;		private var _saveEditedLocationXML:SaveEditedLocationXML;		//private var				// Constructor.		public function DialogueController()		{						trace(this);			super();					}				// Initializes class.		public function initialize():DialogueController		{						trace(this + " : initialize");						/*			area.attach( _interactive, { scaleMode:ScaleMode.PROPORTIONAL_INSIDE, hAlign:AlignMode.CENTER, vAlign:AlignMode.CENTER });			area.attach( branding, { scaleMode:ScaleMode.PROPORTIONAL_INSIDE, hAlign:AlignMode.CENTER, vAlign:AlignMode.CENTER });			area.attach( _box, { scaleMode:ScaleMode.STRETCH, hAlign:AlignMode.CENTER, vAlign:AlignMode.CENTER });			*/						_container = new FlashDisplayer;			addChild( _container );			_mapDialogue = new MapDialogue;			_mapDialogue.initialize();			_locationDialogue = new LocationDialogue;			_locationDialogue.initialize();			_slideImageDialogue = new SlideImageDialogue;			_slideImageDialogue.initialize();						// Sean will mess with t his later.				    _scheduleDialogue = new ScheduleDialogue;			_scheduleDialogue.initialize();						_saveEditedLocationXML = new SaveEditedLocationXML;									// Needs LiquidArea here. CDC			//_area = new LiquidArea(this, 0, 0, AppData.STAGE_WIDTH, AppData.STAGE_HEIGHT, 0x313f19);			_area = new LiquidArea( _container, 0, 0, AppData.STAGE_WIDTH, AppData.STAGE_HEIGHT, 0x313f19);			//_area.attach( _slideImageDialogue as Sprite, { scaleMode:ScaleMode.PROPORTIONAL_INSIDE, hAlign:AlignMode.CENTER, vAlign:AlignMode.CENTER });						// Event handlers.			//BedrockDispatcher.addEventListener( MapEvent.SHOW_DIALOGUE, onShowDialogue );			BedrockDispatcher.addEventListener( MapEvent.XML_READY, onEvent );			BedrockDispatcher.addEventListener( MapEvent.CLOSE_WINDOW, onEvent );			BedrockDispatcher.addEventListener( MapEvent.SHOW_OPTIONS, onEvent );			//BedrockDispatcher.addEventListener( MapEvent.HIDE_CONTENT, onHideContent );			BedrockDispatcher.addEventListener( MapEvent.SHOW_SCHEDULE, onEvent );			BedrockDispatcher.addEventListener( MapEvent.SHOW_LOCATION, onEvent );			BedrockDispatcher.addEventListener( MapEvent.SHOW_LOCATION_IMAGE, onEvent );			BedrockDispatcher.addEventListener( MapEvent.CLOSE_CONNECT_DIALOGUE, onEvent );			BedrockDispatcher.addEventListener( MapEvent.ADD_LOCATION, onEvent );			BedrockDispatcher.addEventListener( MapEvent.EDIT_LOCATION, onEvent );			BedrockDispatcher.addEventListener( MapEvent.HOTSPOT_LOCATION_UPDATE, onEvent );			BedrockDispatcher.addEventListener( MapEvent.LOCATION_EDITED, onEvent );			BedrockDispatcher.addEventListener( MapEvent.EDIT, onEvent );						return this;					}								private function handleSizingAndPositioning( $point:Point ):void		{						if( stage.stageWidth > AppData.STAGE_WIDTH && stage.height > AppData.STAGE_HEIGHT )			{								AppData.DIALOGUE_X = $point.x;				AppData.DIALOGUE_Y = $point.y;				AppData.DIALOGUE_SCALE = 0.3;							}			else			{								AppData.DIALOGUE_X = stage.stageWidth / 2;				AppData.DIALOGUE_Y = stage.height / 2;				AppData.DIALOGUE_SCALE = 1;							}					}						// Gets called when there is a request to connect to a location.		private function onEvent($e:GenericEvent):void		{									switch( $e.type )			{				/*				case MapEvent.EDIT:										trace(this + " : onEvent : " + $e.type);																									break;				*/				case MapEvent.HOTSPOT_LOCATION_UPDATE:					handleSizingAndPositioning( $e.details.point as Point );					break;								case MapEvent.XML_READY:					_xml =  new XML($e.details.xml);					// Send data to dialogue.					( _mapDialogue as MapDialogueView ).setup( _xml );					break;				case MapEvent.SHOW_OPTIONS:										trace("MapEvent.SHOW_OPTIONS");					//( _mapDialogue as MapDialogueView ).showOptions();					//_container.change( _mapDialogue );										BedrockDispatcher.dispatchEvent( new MapEvent( MapEvent.SHOW_SCHEDULE, this, {} ) );										break;				case MapEvent.CLOSE_WINDOW:					_container.change();					break;				case MapEvent.SHOW_LOCATION_IMAGE:					_container.change( _slideImageDialogue );					_area.attach( _slideImageDialogue as Sprite, { scaleMode:ScaleMode.PROPORTIONAL_INSIDE, hAlign:AlignMode.CENTER, vAlign:AlignMode.CENTER });					break;				case MapEvent.SHOW_SCHEDULE:															_container.change( _scheduleDialogue );					_area.attach( _scheduleDialogue as Sprite, { scaleMode:ScaleMode.PROPORTIONAL_INSIDE, hAlign:AlignMode.CENTER, vAlign:AlignMode.CENTER });					_area.release( _scheduleDialogue as Sprite );					_scheduleDialogue.start();															break;				case MapEvent.SHOW_LOCATION:					AppData.SELECTED_XMLLIST = $e.details.xmlList;					_container.change( _locationDialogue );					_area.attach( _locationDialogue as Sprite, { scaleMode:ScaleMode.PROPORTIONAL_INSIDE, hAlign:AlignMode.CENTER, vAlign:AlignMode.CENTER });					_area.release( _locationDialogue as Sprite );					_locationDialogue.start();					break;								case MapEvent.ADD_LOCATION:					( _mapDialogue as MapDialogueView ).ShowAddMarker();					break								case MapEvent.EDIT_LOCATION:					( _mapDialogue as MapDialogueView ).ShowEditMarker( $e.details );					break				case MapEvent.LOCATION_EDITED:										_saveEditedLocationXML.addEventListener( "ready", onReady )					_saveEditedLocationXML.save( $e.details.xmlList );										//SaveEditedLocationXML										//( _mapDialogue as MapDialogueView ).ShowEditMarker( $e.details );																																								break								case MapEvent.CLOSE_CONNECT_DIALOGUE:					//_mapDialogue.closeConnectDialogue();					break							}					}						private function onReady($e:Event):void		{														}									}	}