package sl2d {
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;

    public class slDisplayNode {
		internal static var renderIndex : uint = 0;

        protected var children : Vector.<slDisplayNode> = new Vector.<slDisplayNode>();

        protected var children_not_validated : Vector.<slDisplayNode> = new Vector.<slDisplayNode>();

		protected var parent : slDisplayNode;

		protected var _numChildren : int = 0;

		public function get numChildren() : int {
			return _numChildren;
		}

        public function slDisplayNode() : void {
        }

		//NODE FUNCTIONS
        public  function addChild(child : slDisplayNode) : slDisplayNode {
            return addChildAt(child, _numChildren);
        }

        public  function addChildAt(child : slDisplayNode, index : int) : slDisplayNode {
            if(child && index <= _numChildren){
                children.splice(index, 0, child);
				child.parent = this;
			}else{
                throw new Error("Error: slDisplayNode Object can't be added.");
			}

			_numChildren = children.length;

            return child;
        }

        public  function removeChild(child : slDisplayNode) : slDisplayNode {
            return removeChildAt(getChildIndex(child));
        }
		
        public  function removeChildAt(index : int) : slDisplayNode {
			var child : slDisplayNode;
            if(index >= 0 && index < _numChildren){
                child = children.splice(index, 1)[0] as slDisplayNode;
				child.parent = this;
			}else{
                throw new Error("Error: slDisplayNode Object can't be removed.");
			}

			_numChildren = children.length;

            return child;
        }

		public function getChildIndex(child : slDisplayNode) : int {
			return children.indexOf(child);
		}

        public  function setChildIndex(child : slDisplayNode, index : int) : void {
            var i : int = getChildIndex(child);
            if(i == index) return;

            if( i > -1){
                children.splice(i, 1);
                children.splice(index, 0, child);
            }
        }
	}
}

