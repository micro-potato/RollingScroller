package com.cp {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class CP_RollingScroller extends MovieClip {
		
		private var _values:Array = new Array();
		private var _activeValue:String = "";
		private var _inputValues:Array = new Array();
		private var _inputHeight:int = 0;
		private var _centerIndex:int = 0;
		
		var _inputSprite:Sprite = new Sprite();
		var _maskSprite:Sprite = new Sprite();
		var _dragSprite:Sprite = new Sprite();
		
		//var _scrollTimer:Timer = new Timer(333);
		public function CP_RollingScroller(values:Array) {
			// constructor code
			Values = values;
			this.addChild(_inputSprite);
			this.addChild(_maskSprite);
			InitRollingScroller();
			//_scrollTimer.addEventListener(TimerEvent.TIMER, OnScrollTImer);
		}
		
		function set Values(value:Array):void 
		{
			_values = value;
			_inputValues = InputValues();
			trace(_inputValues);
		}
		
		function InputValues():Array 
		{
			var values:Array = new Array();
			var valueCount:int = _values.length;
			for (var i:int = 1; i < valueCount; i++) 
			{
				values.push(_values[i]);
			}
			values.push(_values[0]);
			for (var j:int = 1; j < valueCount; j++) 
			{
				values.push(_values[j]);
			}
			return values;
		}
		
		function InitRollingScroller():void //set inputs count,location,value,dragRec
		{
			_centerIndex = _values.length - 1;
			var centerInput:CP_RollingInput = new CP_RollingInput();
			_inputSprite.addChild(centerInput);
			centerInput.InputValue = _inputValues[_centerIndex];
			_inputHeight = centerInput.height;
			
			var inputCount:int = _inputValues.length;
			for (var i:int = 0; i <inputCount ; i++) 
			{
				if (i == _centerIndex)//centerInput already added
				{
					continue;
				}
				else
				{
					var dIndex:int = i - _centerIndex;
					var ly:int = dIndex * _inputHeight;
					var input:CP_RollingInput = new CP_RollingInput();
					_inputSprite.addChild(input);
					//this.addChild(input);
					input.y = ly;
					input.InputValue = _inputValues[i];
				}
			}
			
			var maskmc = new Rolling_Mask();
			_maskSprite.addChild(maskmc);
			_inputSprite.mask = _maskSprite;
			
			_dragSprite = new Rolling_Mask();
			this.addChild(_dragSprite);
			_dragSprite.alpha = 0;
			_dragSprite.x = _inputSprite.x;
			_dragSprite.y = _inputSprite.y;
			_dragSprite.width = _inputSprite.width;
			_dragSprite.height = _inputSprite.height;
			
			_dragSprite.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			//trace("_dragSprite size:" + _dragSprite.width + "," + _dragSprite.height);
		}
		
		/*-------------------------movement-------------------------*/
		var _prevY:int = 0; 
		var _curY:int = 0; 
		var _speed:Number = 6;
		
		
		function OnMouseDown(e:MouseEvent):void 
		{
			_prevY = e.localY;
			_dragSprite.removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			_dragSprite.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			_dragSprite.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut);
			_dragSprite.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			//_scrollTimer.start();
		}
		
		function OnMouseOut(e:Event):void 
		{
			_dragSprite.removeEventListener(MouseEvent.MOUSE_OUT, OnMouseOut);
			_dragSprite.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			_dragSprite.removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			_dragSprite.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			CorrectionScrollResult();
			//_scrollTimer.stop();
		}
		
		function OnMouseUp(e:Event):void 
		{
			_dragSprite.removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			_dragSprite.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			_dragSprite.removeEventListener(MouseEvent.MOUSE_OUT, OnMouseOut);
			_dragSprite.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			CorrectionScrollResult();
			//_scrollTimer.stop();
		}
		
		function OnMouseMove(e:MouseEvent):void 
		{
			//_curY = e.localY;
			
			var curY:int = e.localY;
			var dy:int = curY - _prevY;
			var ty:int = _inputSprite.y + _speed * dy;
			//_inputSprite.y += _speed * dy;
			//trace(dy + "-" + _inputSprite.y);
			UpdateScroll(ty);
			_prevY = curY;
		}
		
		//update rollingscroller location by drag result
		function UpdateScroll(targetY:int):void 
		{
			var dIndex:int = Math.round(targetY / _inputHeight);
			//var offsetY:int = targetY - dIndex * _inputHeight;
			if (Math.abs(dIndex) != (_values.length - 1))
			{
				_inputSprite.y = targetY;
			}
			else
			{
				if (dIndex > 0)
				{
					_inputSprite.y -= _values.length * _inputHeight;
					//trace("dIndex:"+dIndex+",Y="+_inputSprite.y);
				}
				else
				{
					_inputSprite.y += _values.length * _inputHeight;
					//trace(_inputSprite.y);
				}
			}
		}
		
		function CorrectionScrollResult():void 
		{
			var dIndex:int = Math.round(_inputSprite.y / _inputHeight);
			_inputSprite.y = dIndex * _inputHeight;
			var valueIndex:int = _centerIndex - dIndex;
			_activeValue = _inputValues[valueIndex];
			trace("valueIndex:"+valueIndex+",get value:" + _activeValue);
		}
	}
}
