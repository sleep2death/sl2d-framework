package sl2d
{
	import flash.geom.Rectangle;

	public class slTextField extends slBoundsGroup
	{
		public static var textures : Vector.<slTextTexture> = Vector.<slTextTexture>([new slTextTexture(), new slTextTexture()]);

		public static function createTextField(fontSize : uint = 12, lineWidth : uint = 100) : slTextField {
			return new slTextField(fontSize, lineWidth);
		}

		public function slTextField(fontSize : uint, lineWidth : uint) : void {
			_fontSize = fontSize;
			_lineWidth = lineWidth;
		}

		protected var _text : String;

		public function set text(value : String) : void {
			_text = value;
			createLines(value);
		}

		public function get text() : String {
			return _text;
		}

		protected var _fontSize : uint = 12;
		protected var charScale : Number = 12/18;

		public function set fontSize(value:uint) : void {
			_fontSize = value;
			charScale = _fontSize/slTextTexture.DEFAULT_FONT_SIZE; 
		}

		public function get fontSize() : uint {
			return _fontSize;
		}


		protected var _lineWidth : uint = 100;
		public function set lineWidth(value:uint) : void {
			_lineWidth = value;
		}

		public function get lineWidth() : uint {
			return _lineWidth;
		}

		
		protected var last_w : uint = 0;
		protected var last_h : uint = 0;

		protected function createLines(str : String) : void {
			var len : uint = str.length;
			var uvIndex : Vector.<int> = new Vector.<int>(len, true);
			var textTexture : slTextTexture = textures[0];

			for(var i : int = 0; i < len; i++){
				var char : String = str.charAt(i);
				uvIndex[i] = textTexture.findCharacater(char);
			}

			var texture : slTexture = textTexture.getTexture();

			for(i = 0; i < len; i++) {
				var bounds : slBounds = texture.createBounds();
				bounds.setUV(uvIndex[i]);

				if((last_w + bounds.width) > _lineWidth){
					last_h += Math.ceil(bounds.height * charScale);
					last_w = 0;
				}

				bounds.x = last_w;
				bounds.y = last_h;
				bounds.color = 0xFF9900;

				bounds.width = Math.ceil(bounds.width * charScale);
				bounds.height = Math.ceil(bounds.height * charScale);
				addBounds(bounds);

				last_w += bounds.width;
			}
		}
	}
}
