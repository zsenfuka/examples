﻿package net.fastindemand.event{	import flash.events.Event;		public class AppEvent extends Event	{				public static var UPDATE_PROJECTS:String = "AppEvent.onUpdateProjects";		public static var NEW_PROJECT:String = "AppEvent.onNewProject";		public static var OPEN_PROJECT:String = "AppEvent.onOpenProject";		public static var CLOSE_PROJECT:String = "AppEvent.onCloseProject";		public static var CANCEL_CLOSE_PROJECT:String = "AppEvent.onCancelCloseProject";		public static var REMOVE_PROJECT:String = "AppEvent.onRemoveProject";						public function AppEvent(type:String, data:Object=null, bubbles:Boolean=false)		{			super(type, bubbles, data);		}	}}