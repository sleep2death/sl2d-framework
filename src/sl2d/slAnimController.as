package sl2d {
	public class slAnimController {
		public var frameStart : uint = 0;
		public var frameEnd   : uint = 0;
		public var frameRate  : uint = 4;

		public var currentFrame : uint = 0;
		public var loop : Boolean;

		public function slAnimController(frameStart : int, frameEnd : int, frameRate : int = 4, loop : Boolean = true) : void {
			this.frameStart = frameStart;
			this.frameEnd   = frameEnd;
			this.frameRate = frameRate;
			this.loop = loop;

			this.currentFrame = frameStart;
			this.currentRes = currentFrame;
		}

		public function nextFrame() : int {
			currentFrame ++;

			if(currentFrame > frameEnd) {
				currentFrame = loop ? frameStart : frameEnd;
			}

			currentRes = currentFrame;
			return currentRes;
		}

		public function prevFrame() : int {
			currentFrame --;
			if(currentFrame < frameStart) {
				currentFrame = loop ? frameEnd : frameStart;
			}

			currentRes = currentFrame;
			return currentRes;
		}

		private var currentCount : uint = 0;
		private var currentRes : int;

		public function update() : int {
			currentCount++;

			if(currentCount % frameRate == 0){
				return nextFrame();
			}
			
			return currentRes;
		}
	}
}
