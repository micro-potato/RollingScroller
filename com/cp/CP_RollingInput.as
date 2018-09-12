package com.cp {
	
	import flash.display.MovieClip;
	
	
	public class CP_RollingInput extends MovieClip {
		
		
		public function CP_RollingInput() {
			// constructor code
		}
		
		public function get InputValue():String
		{
			return this["t_value"].text;
		}
		
		public function set InputValue(value:String):void
		{
			this["t_value"].text = value;
			//trace("set input value:" + value);
		}
	}
	
}
