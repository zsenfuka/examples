﻿package net.fastindemand.event{	import flash.events.Event;		public class AppEvent extends Event	{				public static var LOGIN_SUCCESS:String = "AppEvent.onLoginSuccess";		public static var LOGIN_FAIL:String = "AppEvent.onLoginFail";		public static var UPDATE_PROJECTS:String = "AppEvent.onUpdateProjects";		public static var NEW_PROJECT:String = "AppEvent.onNewProject";		public static var OPEN_PROJECT:String = "AppEvent.onOpenProject";		public static var CLOSE_PROJECT:String = "AppEvent.onCloseProject";		public static var CANCEL_CLOSE_PROJECT:String = "AppEvent.onCancelCloseProject";		public static var REMOVE_PROJECT:String = "AppEvent.onRemoveProject";				public static var SHOW_PROJECTS:String = "AppEvent.onShowProjects";						public function AppEvent(type:String, bubbles:Boolean=false, cancellable:Boolean=false, data:Object=null)		{			super(type, bubbles, cancellable);		}	}}