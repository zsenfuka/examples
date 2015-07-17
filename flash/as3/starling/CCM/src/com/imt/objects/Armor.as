﻿package com.imt.objects{			import com.bedrock.extras.util.MathUtil;	import com.imt.model.Storage;		import flash.display.BitmapData;	import flash.geom.Rectangle;	import flash.utils.Dictionary;		import hype.extended.behavior.SwarmToDisplayObject;	import hype.extended.behavior.VariableVibration;	import hype.extended.trigger.SeamlessPlacement;		import starling.display.Sprite;	import starling.textures.Texture;			public class Armor extends AbstractParticle implements IParticle	{								//private var _behaviour:Array;		public function Armor()		{						//trace( "Armor" );									var size:uint = 20;			super( { id:"Armor" }, Texture.fromBitmapData( new BitmapData( size, size, false, 0xff0000 ) ), "", Texture.fromBitmapData( new BitmapData( size, size, false, 0x00ff00 ) ) );						var b:Dictionary = _behaviourDictionary;						// Stage 1.			var key:String = "0";			b[ key ] = [];			b[ key ].push( new VariableVibration( this, "x", 0.99, 0.05, 1.5 ) );			b[ key ].push( new VariableVibration( this, "y", 0.99, 0.05, 1.5 ) );			b[ key ].push( new VariableVibration( this, "rotation", 0.99, 0.05, 0.1 ) );			b[ key ].push( new SeamlessPlacement( this, new Rectangle( 0, 0, Storage.WIDTH, Storage.HEIGHT ) ) );						// Stage 2.			key = "1";			b[ key ] = [];			b[ key ].push( new VariableVibration( this, "rotation", 0.99, 0.05, 0.1 ) );						// Swarm stage.			key = "swarm";			b[ key ] = [];			b[ key ].push( new SwarmToDisplayObject( this, _swarmPoint, 0.99, 0.05, 0.1 ) );			b[ key ].push( new VariableVibration( this, "rotation", 0.99, 0.05, 0.1 ) );																																										// Random rotation.			rotation = MathUtil.degreesToRadians( Math.random() * 360 );			//scaleX = scaleY = 0.6 + ( Math.floor( Math.random() * 100 ) * 0.01);			/*						_behaviour[ tempIndex ].push( new VariableVibration( this, "x", 0.99, 0.05, 1.5 ) );			_behaviour[ tempIndex ].push( new VariableVibration( this, "y", 0.99, 0.05, 1.5 ) );			_behaviour[ tempIndex ].push( new VariableVibration( this, "rotation", 0.99, 0.05, 0.1 ) );			_behaviour[ tempIndex ].push( new SeamlessPlacement( this, new Rectangle( 0, 0, Storage.WIDTH, Storage.HEIGHT ) ) );						_behaviourDictionary[ tempIndex ] = 						// Stage 2.			_behaviour.push( [] );						tempIndex = 1;			_behaviour[ tempIndex ].push( new VariableVibration( this, "rotation", 0.99, 0.05, 0.1 ) );						// Random rotation.			rotation = MathUtil.degreesToRadians( Math.random() * 360 );			//scaleX = scaleY = 0.6 + ( Math.floor( Math.random() * 100 ) * 0.01);			*/		}		/*		// Runs behaviour		public function startBehaviour():void		{						trace( "Armor - startBehaviour" );						// Kill running behaviours.			stopBehaviour();						for( var a:uint = 0; a < _behaviour[ _stageIndex ].length; a++ )			{								_behaviour[ _stageIndex ][ a ].start();							}					}						// Stops behaviour		public function stopBehaviour():void		{						trace( "Armor - stopBehaviour" );						var stagesLength:uint = _behaviour.length;						trace( stagesLength );									for( var a:uint = 0; a < stagesLength; a++ )			{								for( var b:uint = 0; b < stagesLength; b++ )				{										trace( _behaviour[ a ][ b ] );					if( _behaviour[ a ][ b ] != undefined ) _behaviour[ a ][ b ].stop();																			}							}					}		*/				public function reset():void		{						trace( "Armor - reset" );			rotation = MathUtil.degreesToRadians( 0 );					}						public function removeMe():void		{						//trace( "Armor - removeMe" );			parent.removeChild( this );					}						public function setup():void		{						trace( "Armor - setup" );											}					}		}