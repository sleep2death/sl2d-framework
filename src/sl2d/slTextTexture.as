package sl2d
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.*;

	public class slTextTexture
	{
		public static var world : slWorld;
		public static const DEFAULT_TEXTURE_WIDTH : uint = 512;
		public static const DEFAULT_TEXTURE_HEIGHT : uint = 512;

		public static const DEFAULT_TEXT_WIDTH : uint = 20;
		public static const DEFAULT_TEXT_HEIGHT : uint = 25;
		public static const DEFAULT_FONT_COLOR : uint = 0xFFFFFFFF;
		public static const DEFAULT_FONT_SIZE : uint = 20;

		public static const DEFAULT_LINE_HEIGHT : uint = 22;
		public static const DEFAULT_OFFSET_Y : uint = 20;

		public var dict : Dictionary = new Dictionary();
		public var bd : BitmapData;
		public var bm : Bitmap;

		private var bdInvalidated : Boolean = false;
		private var texture : slTexture;

		public var char_w : uint = DEFAULT_TEXT_WIDTH;
		public var char_h : uint = DEFAULT_TEXT_HEIGHT;

		public var font_size : uint = DEFAULT_FONT_SIZE;

		public var w : uint = DEFAULT_TEXTURE_WIDTH;
		public var h : uint = DEFAULT_TEXTURE_HEIGHT;

		public var col : uint = 0;
		public var row : uint = 0;

		public var offset_y : int = -14;

		public var textClip : Rectangle;
		public var textMatrix : Matrix = new Matrix();

		public var used : Vector.<Rectangle> = new Vector.<Rectangle>();

		public function slTextTexture(w : uint = DEFAULT_TEXTURE_WIDTH, h : uint = DEFAULT_TEXTURE_HEIGHT) : void {
			this.w = w;
			this.h = h;

			init();
		}

		protected var tb : TextBlock = new TextBlock();
		protected var tl : TextLine;
		protected var te : TextElement;
		protected var ef : ElementFormat;

		protected var last_w : uint = 0;
		protected var last_h : uint = 0;
		protected var max_W : uint = DEFAULT_TEXTURE_WIDTH * DEFAULT_TEXTURE_HEIGHT;

		protected var mtx : Matrix = new Matrix();

		public var isFull : Boolean = false;

		public function init() : void {
			bd = new BitmapData(w, h, true, 0x00000000);
			bm = new Bitmap(bd);

			var fontDescriptionNormal : FontDescription = new FontDescription("Arial", FontWeight.NORMAL , FontPosture.NORMAL);
			var ef:ElementFormat = new ElementFormat(fontDescriptionNormal);
			ef.fontSize = DEFAULT_FONT_SIZE;
			ef.color = DEFAULT_FONT_COLOR;

			te = new TextElement(null, ef);
		}

		public function hasCharacter(char : String) : int {
			if(dict[char]){
				return dict[char]
			}
			return -1;
		}


		public function findCharacater(char : String, canBeAdded : Boolean = true) : int {
			if(char.length > 1) throw new Error("Can not find find more than ONE Character.");

			var index : int = hasCharacter(char);

			if(index > -1){
				return index;
			}else if(canBeAdded){
				bdInvalidated = true;
				te.text = char;
				tb.content = te;
				tl = tb.createTextLine(null, 100);
				var rect : Rectangle = tl.getAtomBounds(0);

				if(DEFAULT_TEXTURE_WIDTH < (last_w + rect.width)){
					last_w = 0;
					last_h += DEFAULT_LINE_HEIGHT;
					if(last_h + DEFAULT_LINE_HEIGHT > DEFAULT_TEXTURE_HEIGHT){
						isFull = true;
						return -1;
					}
				}

				mtx.tx = last_w;
				mtx.ty = DEFAULT_OFFSET_Y + last_h;

				var clip : Rectangle = new Rectangle(mtx.tx, last_h, rect.width, DEFAULT_LINE_HEIGHT);
				bd.draw(tl, mtx, null, null, clip, true);

				last_w += rect.width;
				bdInvalidated = true;

				clip.height = DEFAULT_LINE_HEIGHT;
				used.push(clip);
				dict[char] = used.length - 1;

				return dict[char];
			}

			return -1;
		}

		public function getCharacterBounds(index : int) : Rectangle {
			return used[index];
		}

		public function getTexture() : slTexture {
			if(!texture || bdInvalidated){
				texture = world.textureFactory.createTextureFromBitmap(bm, "text_bm", false, true);

				for(var i : int = 0; i < used.length; i++){
					var rect : Rectangle = used[i];
					var l : Number = rect.x/w;
					var t : Number = rect.y/h;
					texture.setTextureCoord(i, Vector.<Number>([l, t, l + (rect.width/w), t + (rect.height/h), 0, 0, rect.width, rect.height]));
				}

				bdInvalidated = false;

			}

			return texture;
		}
	}
	
}
