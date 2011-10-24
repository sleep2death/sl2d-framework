package sl2d {
	import flash.display.Stage;
	import flash.events.Event;

	public class slTicker {
		private var stage : Stage;

		public function slTicker(stage : Stage) : void {
			this.stage = stage;
		}

		public function start() : void {
			this.stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		}

		public function stop() : void {
			this.stage.removeEventListener(Event.ENTER_FRAME, onUpdate);
		}

		public function onUpdate(evt : Event) : void {
			var len : int = listeners.length;

			for(var i : int = 0; i < len; i++) {
				listeners[i].update();
			}
		}

		protected var listeners : Vector.<slITicker> = new Vector.<slITicker>();
		
		public function addListener(l : slITicker) : void {
			var i : int = listeners.indexOf(l);
			if(i < 0)listeners.push(l);
		}

		public function removeListener(l : slITicker) : void {
			var i : int = listeners.indexOf(l);
			if(i > 0) listeners.splice(i, 1);
		}
	}
}
