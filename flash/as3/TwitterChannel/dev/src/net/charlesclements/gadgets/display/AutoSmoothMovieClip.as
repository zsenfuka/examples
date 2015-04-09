﻿/*-------------------------------------------------------Charles D Clements www.charlesclements.net created: 20090422last update: 20110513- Made the takeSnapshot() method public and manditiory.-------------------------------------------------------*/import flash.display.BitmapData;class net.charlesclements.gadget.AutoSmoothMovieClip extends MovieClip{		/*	Varialbles	*/	private var _mcClip:MovieClip;	private var _objCurrentBitmapData:BitmapData;			/* 	Constructor.	*/	public function AutoSmoothMovieClip()	{				//trace("AutoSmoothMovieClip")		this.takeSnapshot()			}			/* 	Takes a picture of the phone to use bitmap smoothing.	*/	private function takeSnapshot():Void	{				//trace("takeSnapshot")				 if(this["gr"] == undefined)		 {			 		 	throw("ERROR: Internal MovieClip 'gr' is undefined within "+this+". Image smoothing will not occur.")					 }		 else		 {			 		 	this._objCurrentBitmapData.dispose();			this._objCurrentBitmapData = new BitmapData(this["gr"]._width, this["gr"]._height, true, 0x00000000);			this._objCurrentBitmapData.draw(this["gr"]);			this._mcClip = this["createEmptyMovieClip"]("mc", 0);			this._mcClip._x = this["gr"]._x;			this._mcClip._y = this["gr"]._y;			this._mcClip.attachBitmap(this._objCurrentBitmapData, 0, "auto", true);			this.doRemove(this["gr"]);					 }		 	}			/* 	Removes the MovieClip from the stage and clears the BitmapData.	*/	public function remove():Void	{				this._objCurrentBitmapData.dispose();		this.doRemove(this);			}			/*	Removes a desired Movieclip.	*/	private function doRemove($clip:MovieClip):Void	{				$clip.swapDepths($clip._parent.getNextHighestDepth());		$clip.removeMovieClip();			}		}