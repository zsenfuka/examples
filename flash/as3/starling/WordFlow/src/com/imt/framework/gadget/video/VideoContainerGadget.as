﻿package com.imt.framework.gadget.video{		import com.bedrock.extras.util.MathUtil;	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;	import com.bedrock.framework.plugin.view.SpriteView;	import com.greensock.TweenMax;	import com.imt.framework.engine.data.GameData;	import com.imt.framework.engine.data.SiteData;	import com.imt.framework.engine.data.VideoData2;	import com.imt.framework.display.IDisplay;	import com.imt.framework.core.event.SiteEvent;		import flash.events.Event;	import flash.utils.Timer;		import org.osmf.elements.AudioElement;	import org.osmf.elements.VideoElement;	import org.osmf.events.MediaPlayerStateChangeEvent;	import org.osmf.events.TimeEvent;	import org.osmf.layout.ScaleMode;	import org.osmf.media.MediaElement;	import org.osmf.media.MediaPlayer;	import org.osmf.media.MediaPlayerSprite;	import org.osmf.media.URLResource;	import org.osmf.utils.OSMFSettings;		import com.imt.games.neo.memory_plane.Settings;
		public class VideoContainerGadget extends SpriteView implements IDisplay	{				private var _video:VideoElement;		private var _player:MediaPlayer;		public var container:MediaPlayerSprite;		public var bg:Background;				public function VideoContainerGadget()		{			super();		}						// Initialize class.		public function initialize():IDisplay		{						trace(this + " : initialize()" );			// Container.			container = new MediaPlayerSprite;			container.width = Settings.WIDTH;			container.height = Settings.HEIGHT;			//container.x = 327;			//container.y = 91;			//container.scaleMode = ScaleMode.ZOOM;			container.scaleMode = ScaleMode.LETTERBOX;			container.mediaPlayer.autoPlay = false;			// Background Graphic.			bg = new Background;			bg.width = Settings.WIDTH;			bg.height = Settings.HEIGHT;			addChild( bg );			return this;					}						// Refresh class properties.		public function refresh():IDisplay		{						trace(this + " : refresh()" );						if( GameData.CURRENT_SECTION != SiteData.PLAYERS_CLUB )			{								TweenMax.to( bg, 0, { autoAlpha:1 } );				TweenMax.to( bg, 0.4, { delay:0.4, autoAlpha:0 } );				container.mediaPlayer.addEventListener( TimeEvent.COMPLETE, onEvent );								var a:Array;				var num:uint;				var v:VideoData2;				switch( GameData.CURRENT_SECTION )				{										case SiteData.FRESH_HARVEST:						a = GameData.AVAILABLE_FOOD_VIDEOS;						num = MathUtil.randomRange( 0, a.length );						break;										case SiteData.PAVILION:						a = GameData.ACTS_VIDEOS;						num = GameData.SELECTED_BUTTON_INDEX;						break;									}								v = a[ num ];								trace(v.id);				trace(v.volume);				trace(v.endTime);								if( v.endTime != 0 ) TweenMax.delayedCall( v.endTime, doEndTime );								//container.mediaPlayer.				container.mediaPlayer.volume = v.volume;				container.media = v.media;				//container.mediaPlayer.media								if( !OSMFSettings.enableStageVideo ) addChild( bg );				//addChild( bg );				addChildAt( container, 0 );				container.mediaPlayer.play();				addChild( bg );											}						return this;					}						// The timer for if v.endTime exists.		private function doEndTime():void		{						trace(this + " : doEndTime()" );			container.mediaPlayer.removeEventListener( TimeEvent.COMPLETE, onEvent );			container.mediaPlayer.stop();			BedrockDispatcher.dispatchEvent( new SiteEvent( SiteEvent.SHOW_PRIZE, this, {} ) );			removeChildren();					}						// Refresh class properties.		public function clear():IDisplay		{			trace(this + " : clear()" );			//container.mediaPlayer.removeEventListener( TimeEvent.COMPLETE, onEvent );			TweenMax.to( bg, 0, { autoAlpha:1 } );			return this;					}						private function onEvent(e:Event):void		{			//trace(this + " : " + e.type )						switch( e.type )			{								case TimeEvent.COMPLETE:										trace(this + " : " + e.type );					container.mediaPlayer.removeEventListener( TimeEvent.COMPLETE, onEvent );					BedrockDispatcher.dispatchEvent( new SiteEvent( SiteEvent.SHOW_PRIZE, this, {} ) );					removeChildren();					break;							}					}			}	}