package com {
	
	import com.cp.CP_RollingScroller;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Main extends MovieClip {
		
		public function Main() {
			// constructor code
			//var values:Array = ["0", "1", "2", "3"];
			var values:Array = ["I", "H", "X", "C"];
			var rs:CP_RollingScroller = new CP_RollingScroller(values);
			this.addChild(rs);
			rs.x = 135;
			rs.y = 240;
		}
		
		
	}
	
}
