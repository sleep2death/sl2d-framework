package sl2d
{
	public class slButtonGroup extends slDisplayNode implements slITicker {
		public function slButtonGroup() : void {
		}

		protected var buttonList : Vector.<slButton> = new Vector.<slButton>();
		protected var _numButtons : uint = 0;

		public function addButton(b : slButton) : slButton {
			if(buttonList.indexOf(b) >= 0) return b;
			return addButtonAt(b, _numButtons);
		}

        public  function addButtonAt(b : slButton, index : int) : slButton {
            if(b && index <= _numButtons){
                buttonList.splice(index, 0, b);
				//b.parent = this;
			}else{
                throw new Error("Error: slButton Object can't be added.");
			}

			_numButtons = buttonList.length;

            return b;
        }

        public  function removeButton(b : slButton, recycle : Boolean = true) : slButton {
            return removeButtonAt(getButtonIndex(b));
        }
		
        public  function removeButtonAt(index : int) : slButton {
			var b : slButton;
            if(index >= 0 && index < _numButtons){
                b = buttonList.splice(index, 1)[0] as slButton;
				//b.parent = null;
			}else{
                throw new Error("Error: slButton Object can't be removed.");
			}

			_numButtons = buttonList.length;

            return b;
        }

		public function getButtonIndex(b : slButton) : int {
			return buttonList.indexOf(b);
		}

        public  function setButtonIndex(b : slButton, index : int) : void {
            var i : int = getButtonIndex(b);
            if(i == index) return;

            if( i > -1){
                buttonList.splice(i, 1);
                buttonList.splice(index, 0, b);
            }
        }

		public function update() : void {
		}
	}
}
