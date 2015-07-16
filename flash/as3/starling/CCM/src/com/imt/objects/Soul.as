﻿package com.imt.objects{			import com.bedrock.extras.util.MathUtil;	import com.imt.framework.display.button.AbstractButton;	import com.imt.model.Storage;		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.geom.Rectangle;		import hype.extended.behavior.MouseFollowEase;	import hype.extended.behavior.VariableVibration;	import hype.extended.trigger.SeamlessPlacement;		import starling.display.Image;	import starling.textures.Texture;
		public class Soul extends AbstractButton implements IParticle	{					public function Soul()		{						//trace( "Soul" );						// Create soul circle here.			var circle:flash.display.Shape = new flash.display.Shape();			circle.graphics.beginFill(0xffff00, 1);			circle.graphics.drawCircle( 10, 10, 10 );			circle.graphics.endFill();						var bmpData:BitmapData = new BitmapData( 20, 20, false, 0x000000 );			bmpData.draw( circle );			//bmpData.drawWithQuality( circle );						var bm:Bitmap = new Bitmap( bmpData, "auto", true );			super( { id:"soul" }, Texture.fromBitmap( bm ), "" );												// Stage 1.			_behaviour.push( [] );						var tempIndex:uint = 0;			_behaviour[ tempIndex ].push( new VariableVibration( this, "x", 0.99, 0.05, 1.5 ) );			_behaviour[ tempIndex ].push( new VariableVibration( this, "y", 0.99, 0.05, 1.5 ) );			_behaviour[ tempIndex ].push( new MouseFollowEase( this, 0.1 ) );			//_behaviour[ stage ].push( new VariableVibration( this, "rotation", 0.99, 0.05, 0.1 ) );			_behaviour[ tempIndex ].push( new SeamlessPlacement( this, new Rectangle( 0, 0, Storage.WIDTH, Storage.HEIGHT ) ) );						// Random rotation.			//rotation = MathUtil.degreesToRadians( Math.random() * 360 );								}						// Runs behaviour		public function startBehaviour():void		{						trace( "Soul - startBehaviour" );						// Kill running behaviours.			stopBehaviour();						for( var a:uint = 0; a < _behaviour[ _stageIndex ].length; a++ )			{								_behaviour[ _stageIndex ][ a ].start();							}					}						// Stops behaviour		public function stopBehaviour():void		{						trace( "Soul - stopBehaviour" );						var stagesLength:uint = _behaviour.length;						for( var a:uint = 0; a < stagesLength; a++ )			{								for( var b:uint = 0; b < stagesLength; b++ )				{										_behaviour[ a ][ b ].stop();									}							}					}								public function reset():void		{						trace( "Soul - reset" );			rotation = MathUtil.degreesToRadians( 0 );					}						public function removeMe():void		{						//trace( "ParticleButton - removeMe" );			parent.removeChild( this );					}						public function setup():void		{						trace( "ParticleButton - setup" );											}					}		}