package sl2d {
	public class slBoundsGroup extends slDisplayNode implements slITicker {
		public function slBoundsGroup() : void {
		}

		protected var boundsList : Vector.<slBounds> = new Vector.<slBounds>();
		protected var _numBounds : uint = 0;

		public function containsBound(b : slBounds) : Boolean {
			return boundsList.indexOf(b) >= 0;
		}

		public function addBounds(b : slBounds) : slBounds {
			if(boundsList.indexOf(b) >= 0) return b;
			return addBoundsAt(b, _numBounds);
		}

        public  function addBoundsAt(b : slBounds, index : int) : slBounds {
            if(b && index <= _numBounds){
                boundsList.splice(index, 0, b);
				b.parent = this;
			}else{
                throw new Error("Error: slBounds Object can't be added.");
			}

			_numBounds = boundsList.length;

            return b;
        }

        public  function removeBounds(b : slBounds, recycle : Boolean = true) : slBounds {
            return removeBoundsAt(getBoundsIndex(b));
        }
		
        public  function removeBoundsAt(index : int, recycle : Boolean = true) : slBounds {
			var b : slBounds;
            if(index >= 0 && index < _numBounds){
                b = boundsList.splice(index, 1)[0] as slBounds;
				b.parent = null;
				if(recycle) b.texture.recycle(b);
			}else{
                throw new Error("Error: slBounds Object can't be removed.");
			}

			_numBounds = boundsList.length;

            return b;
        }

		public function getBoundsIndex(b : slBounds) : int {
			return boundsList.indexOf(b);
		}

        public  function setBoundsIndex(b : slBounds, index : int) : void {
            var i : int = getBoundsIndex(b);
            if(i == index) return;

            if( i > -1){
                boundsList.splice(i, 1);
                boundsList.splice(index, 0, b);
            }
        }

		private var _x : Number = 0;

		public function set x(value : Number) : void {
			_x = value;
		}

		public function get x() : Number {
			return _x;
		}

		private var _y : Number = 0;

		public function set y(value : Number) : void {
			_y = value;
		}

		public function get y() : Number {
			return _y;
		}

		public function setPosition(x : Number, y : Number) : void {
			_x = x;
			_y = y;
		}

		protected var global_x : Number = 0;
		protected var global_y : Number = 0;

		public function setGlobalOffset(x : Number, y : Number) : void {
			global_x = x + _x;
			global_y = y + _y;
		}


		protected var oX : Number = 0;
		protected var oY : Number = 0;

		protected var invalidate : Boolean = true;

		public function update() : void {
			var len  : int = _numChildren;

			for(var i : int = 0; i < len; i++) {
				var child : slBoundsGroup = children[i] as slBoundsGroup;
				child.setGlobalOffset(global_x, global_y);
				child.update();
			}

			len = _numBounds; 
			for(i = 0; i < len; i++) {
				var bounds : slBounds= boundsList[i] as slBounds;
				bounds.setOffset(global_x, global_y);	
				bounds.update();
			}
		}
	}
}
