﻿package com.imt.mch.TeleMedicineCommandCenter.event{	import com.bedrock.framework.core.event.GenericEvent;		public class MapEvent extends GenericEvent	{				// Schedule		public static var SHOW_SCHEDULE:String = "MapEvent.onShowSchedule";		//public static var SHOW_EDIT_SCHEDULE:String = "MapEvent.onShowEditSchedule";		//public static var CANCEL_SCHEDULE:String = "MapEvent.onCancelSchedule";		//public static var SAVE_SCHEDULE:String = "MapEvent.onSaveSchedule";				// Generic		public static var EDIT:String = "MapEvent.onEdit";		public static var CANCEL:String = "MapEvent.onCancel";		public static var SAVE:String = "MapEvent.onSave";				// Location		public static var SHOW_LOCATION:String = "MapEvent.onShowLocation";		public static var SHOW_LOCATION_IMAGE:String = "MapEvent.onShowLocationImage";				public static var HOTSPOT_LOCATION_UPDATE:String = "MapEvent.onHotspotLocationUpdate";		public static var XML_READY:String = "MapEvent.onXmlReady";		public static var SHOW_DIALOGUE:String = "MapEvent.onShowDialogue";		public static var SHOW_OPTIONS:String = "MapEvent.onShowOptions";		public static var HIDE_CONTENT:String = "MapEvent.onHideContent";		public static var CLOSE_CONNECT_DIALOGUE:String = "MapEvent.onCloseConnectionDialogue";		public static var CONNECT_DIALOGUE_CLOSED:String = "MapEvent.onConnectionDialogueClosed";		public static var LOCATION_ADDED:String = "MapEvent.onLocationAdded";		public static var LOCATION_EDITED:String = "MapEvent.onLocationEdited";		public static var ADD_LOCATION:String = "MapEvent.onAddLocation";		public static var REMOVE_LOCATION:String = "MapEvent.onRemoveLocation";		public static var EDIT_LOCATION:String = "MapEvent.onEditLocation";		public static var CLOSE_WINDOW:String = "MapEvent.onCloseWindow";		public static var CLEAR_SHARED_OBJECT:String = "MapEvent.onClearSharedObject";		public static var MARKER_CREATED:String = "MapEvent.onMarkerCreated";		public static var MARKER_CLOSED:String = "MapEvent.onMarkerClosed";		public static var MARKER_MODIFIED:String = "MapEvent.onMarkerModified";		public static var MARKER_POSITIONS_UPDATED:String = "MapEvent.onMarkerPositionsUpdated";		public static var MARKER_SELECTED:String = "MapEvent.onMarkerSelected";		public static var MARKER_REFRESH:String = "MapEvent.onMarkerRefresh";		public static var START_ADJUST_LAYOUT:String = "MapEvent.onStartAdjustLayout";		public static var STOP_ADJUST_LAYOUT:String = "MapEvent.onStopAdjustLayout";		public static var CHECK_MONITORS_GRID:String = "MapEvent.onCheckMonitorsGrid";		public static var MONITORS_CHECKED:String = "MapEvent.onMonitorsChecked";		public static var TIMEZONE_UPDATED:String = "MapEvent.onTimezoneUpdated";				public function MapEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)		{			super($type, $origin, $details, $bubbles, $cancelable);		}	}}