﻿package com.imt.mch.TeleMedicineCommandCenter.view.map.interactive.dialogue{	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;	import com.bedrock.framework.plugin.util.ButtonUtil;	import com.imt.mch.TeleMedicineCommandCenter.event.MapEvent;		import fl.controls.Button;		import flash.events.MouseEvent;	import flash.text.TextField;		//import mx.controls.Button;	public class EditMarkerDialogue extends AbstractDialogue	{						public var cancel:Button;		public var saveLocationBtn:Button;		public var labelTxt:TextField;		public var text1:TextField;		public var text2:TextField;		public var text3:TextField;						// 		public function EditMarkerDialogue()		{						super();			ButtonUtil.addListeners( saveLocationBtn, { down:onCreateLocation } );			ButtonUtil.addListeners( cancel, { down:onCancel } );								}						public function autofill($xmlList:XMLList = null):EditMarkerDialogue		{						trace(this + " : autofill");			//trace($xmlList);						//t.kill();			return this;					}						//		private function onCreateLocation($e:MouseEvent):void		{						//trace(this + " : onCreateLocation")			BedrockDispatcher.dispatchEvent( new MapEvent( MapEvent.LOCATION_ADDED, this, { label:labelTxt.text, textline1:text1.text, textline2:text2.text, textline3:text3.text } ) );			onCancel();					}						private function onCancel($e:MouseEvent=null):void		{						labelTxt.text = "";			text1.text = "";			text2.text = "";			text3.text = "";						BedrockDispatcher.dispatchEvent( new MapEvent( MapEvent.CLOSE_WINDOW, this, {} ) );					}					}	}