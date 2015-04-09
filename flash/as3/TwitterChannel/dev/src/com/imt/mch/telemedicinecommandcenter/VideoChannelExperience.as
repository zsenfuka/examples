﻿package com.imt.mch.TeleMedicineCommandCenter{	import com.bedrock.framework.plugin.util.ButtonUtil;	import com.bedrock.extras.util.MathUtil;	//import com.bedrock.framework.plugin.util.StringUtil;	import com.bedrock.framework.plugin.view.IView;	import com.bedrock.framework.plugin.view.MovieClipView;	import com.greensock.TweenMax;	import com.greensock.layout.LiquidArea;	import com.greensock.layout.LiquidStage;	import com.greensock.layout.ScaleMode;	import views.TwitterView;		import flash.display.MovieClip;	import flash.display.StageAlign;	import flash.display.StageDisplayState;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.filesystem.File;	import flash.net.FileReferenceList;	import flash.system.Security;	import flash.text.TextField;	import flash.ui.Mouse;	import flash.ui.MouseCursor;		import hype.extended.behavior.FixedVibration;	import hype.extended.behavior.VariableVibration;	import hype.framework.core.TimeType;		//import mx.utils.StringUtil;		import events.TwitterEvent;	import net.charlesclements.behaviour.Sequencer;		import org.osmf.elements.VideoElement;	import org.osmf.events.DisplayObjectEvent;	import org.osmf.events.MediaError;	import org.osmf.events.MediaErrorEvent;	import org.osmf.events.PlayEvent;	import org.osmf.events.TimeEvent;	import org.osmf.layout.ScaleMode;	import org.osmf.media.DefaultMediaFactory;	import org.osmf.media.MediaElement;	import org.osmf.media.MediaPlayerSprite;	import org.osmf.media.URLResource;	import org.osmf.traits.TraitEventDispatcher;		import settings.Settings;		//public class VideoChannelExperience extends MovieClipView implements IView	public class VideoChannelExperience extends MovieClip// implements IView	{				//public var timing:TextField;		//public var twitter:TwitterView;		public var bg:MovieClip;		public var twitterLogo:MovieClip;				public var area:LiquidArea;				private var frl:FileReferenceList;		private var videos:Array; 				private var factory:DefaultMediaFactory;		private var _start:Boolean = true;		private var _currentIndex:uint = 0;		public var container:MediaPlayerSprite;		public var videoContainer:MovieClip;						public function VideoChannelExperience()		{			super();						//Security.loadPolicyFile("http://www.intermediatouch.com/mch_video_wall/assets/xml/crossdomain.xml");						trace(this);						initialize();					}						public function initialize($data:Object=null):void		{						trace(this + " : initialize");						Mouse.hide();						// Setup player stuff first.			setupPlayer()						// Set up everything that has to do with the stage sizing, scaling and positioning.			setStagePositioning();						// Create File and browse as folder for directory of videos.			var f:File = new File();			f.addEventListener( Event.SELECT, onSelect );			f.browseForDirectory( "Where is the folder that contains the videos?" );					}						// Set up everything that has to do with the stage sizing, scaling and positioning.		private function setupPlayer():void		{						trace("setupPlayer")						container = new MediaPlayerSprite;			container.x = container.y = 0;			container.width = stage.width;			container.height = stage.height;			container.scaleMode = org.osmf.layout.ScaleMode.ZOOM;						addChildAt( container, 1 );						var ls:LiquidStage = new LiquidStage(this.stage, 0, 0, stage.width, stage.height);			var area:LiquidArea = new LiquidArea(this, 0, 0, stage.width, stage.height);			area.preview = true;						container.mediaPlayer.addEventListener( TimeEvent.COMPLETE, onEvent );			container.mediaPlayer.addEventListener( MediaErrorEvent.MEDIA_ERROR, onEvent );			//container.mediaPlayer.addEventListener( DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, onEvent );			//container.mediaPlayer.addEventListener( DisplayObjectEvent.MEDIA_SIZE_CHANGE, onEvent );			container.mediaPlayer.addEventListener( PlayEvent.PLAY_STATE_CHANGE, onEvent );						// Create a Factory for later use. 			factory = new DefaultMediaFactory;					}						// Set up everything that has to do with the stage sizing, scaling and positioning.		private function setStagePositioning():void		{						stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_BORDER;						// Fullscreen.			stage.displayState = StageDisplayState.FULL_SCREEN;					}						private function onSelect(e:Event):void		{						//trace("onSelect")						var f:File = ( e.target as File );			var dir:Array = f.getDirectoryListing()			videos = [];						for(var i:uint=0; i < dir.length; i++)			{								var vid:String = f.url + "/" + ( dir[i] as File ).name;								// Request the factory to create a media element that matches the passed URL:				var media:MediaElement = factory.createMediaElement( new URLResource( vid ) );								// Make sure that the MediaElement exists and that it is of type VideoElement.				if( media != null && media is VideoElement )				{										// Smoothing wasn't working with the FLV's					//( media as VideoElement ).smoothing = true;										// Add to video Array.					videos.push( vid );									}							}						// Play first video.			playNext();					}						private function playNext():void		{						//trace("playNext()");						// Do sequence wrapping condition.			var index:uint;			if( _currentIndex <= videos.length - 1 ) index = _currentIndex;			else index = _currentIndex = 0;						container.resource = new URLResource( videos[ index ] );						//trace("index : " + _currentIndex);						_currentIndex++;		}						private function onEvent(e:Event):void		{									trace(e.type);									switch( e.type )			{								case TimeEvent.COMPLETE:					playNext();					break;								case DisplayObjectEvent.DISPLAY_OBJECT_CHANGE:					break;								case DisplayObjectEvent.MEDIA_SIZE_CHANGE:					break;								case PlayEvent.PLAY_STATE_CHANGE:					break;								case MediaErrorEvent.MEDIA_ERROR:					playNext();					break;							}					}						private function hideMouse($e:MouseEvent):void		{						trace("hideMouse")						Mouse.hide();					}				public function intro($data:Object=null):void		{		}				public function outro($data:Object=null):void		{		}				public function clear():void		{		}			}}