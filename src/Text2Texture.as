package
{

	import flash.display.*;
	import flash.text.*;
	import flash.events.Event;
	import flash.geom.*;
	import flash.utils.*;
	import flash.text.engine.*;

	import com.bit101.components.*;
	import sl2d.*;

	public class Text2Texture extends Sprite
	{
		public function Text2Texture() : void {
			trace("Just a test to transform text to texture");
			createView3D();
		}

		private var w : slWorld;
		private var ticker : slTicker;

		public function createView3D() : void {
			w = new slWorld(stage, 0, null, contextReady);
			w.backgroundColor = 0x000000;

			ticker = new slTicker(stage);
		}

		private var t : slTextField;

		private var bd : BitmapData;
		private var bm : Bitmap;

		public function contextReady() : void {
			slTextTexture.world = w;
			t  = slTextField.createTextField(12, 100);
			t.text = "AspirinP,史珉,你好 DoDo, Chris?!"

			ticker.addListener(t);
			ticker.addListener(w);

			ticker.start();
			slTextField.textures[0].bm.y = 100;
			addChild(slTextField.textures[0].bm);

			var bg : slButtonGroup = new slButtonGroup();
			//addChild(t.tl);

			//var fontDescriptionNormal : FontDescription = new FontDescription("Arial", FontWeight.NORMAL , FontPosture.NORMAL);
			//var formatNormal:ElementFormat = new ElementFormat(fontDescriptionNormal);
			//formatNormal.fontSize = 24;
			//formatNormal.color = 0xFFFFFFFF;

			//var textBlock : TextBlock = new TextBlock();
			//var textElement : TextElement = new TextElement("您好,Text Engine!", formatNormal);
			//textBlock.content = textElement;

			//var textLine : TextLine = textBlock.createTextLine(null, 150);
			//textLine.y = 40;
			//addChild(textLine);

			//var mtx : Matrix = new Matrix();
			//mtx.ty = 12;

			//var bd : BitmapData = new BitmapData(512, 512, true, 0x00000000);
			//bm = new Bitmap(bd);
			//bm.smoothing = true;
			//bd.draw(textLine, mtx, null, null, null, true);

			//addChild(bm);
		}

		/*private var bd : BitmapData;
		private var bm : Bitmap;

		public function createTexture() : void {
			bd = new BitmapData(512, 512, true, 0x00000000);
			bm = new Bitmap(bd);
			//addChild(bm);
		}

		private var tf : TextField;
		private var tft : TextFormat;

		private var tf_target : TextField;

		public function createTextField() : void {
			tf = new TextField();
			tf.x = this.stage.stageWidth - 205;
			tf.y = 5;
			tf.background = true;
			tf.backgroundColor = 0x333333;
			tf.width = 200;
			tf.height = 60;
			//tf.multiline = true;
			tf.textColor = 0xFFFFFF;
			tf.type = TextFieldType.INPUT;
			addChild(tf);

			tft = new TextFormat();
			tft.size = 12;
			tft.bold = true;
			//tft.italic = true;

			tf.text = "史珉,ABCDEFGHIJKLMNOPQRSTUVWXYZ-1234567890";
			tf.setTextFormat(tft);
			
			tf_target = new TextField();
			//tf_target.background = true;
			//tf_target.backgroundColor = 0x000000;
			tf_target.width =  20;
			tf_target.height = 40;
			tf_target.multiline = true;
			tf_target.textColor = 0xFFFFFFFF;
			tf_target.gridFitType = "subpixel";
			tf_target.defaultTextFormat = tft;


			//addChild(tf_target);

			tf.addEventListener(Event.CHANGE, onChange);
		}

		private var mtx : Matrix = new Matrix();
		private var clip : Rectangle = new Rectangle(0, 0, 14, 16);

		private var dic : Dictionary = new Dictionary();
		private var used : Vector.<uint> = new Vector.<uint>(1116);

		public function onChange(evt : Event = null) : void {
			var str : String = tf.text;
			var len : uint = str.length;
			for(var i : int = 0; i < len; i++){
				var char : String = str.charAt(i);
				if(dic[char] == null){
					var index : int = used.indexOf(0);

					dic[char] = index;
					used[index] = 1;

					var index_y : uint = uint(index/36);
					var index_x : uint = index%36;

					tf_target.text = "\n" + char;

					mtx.tx = index_x * 14;
					mtx.ty = -10 + index_y * 16;

					clip.y = mtx.ty + 10;
					clip.x = mtx.tx;
					bd.draw(tf_target, mtx, null, null, clip);
				}
			}
		}


		public function contextReady() : void {
			var root : slBoundsGroup = new slBoundsGroup();
			onChange();
			var bounds : slBounds = s.textureFactory.createTextureFromBitmap(bm,"bm", false).createBounds();
			//root.addBounds(bounds);
			var fixed_w : uint = 512;
			var fixed_h : uint = 512;

			for(var i : int = 0; i < 1116; i++){
				var w : Number = 14;
				var h : Number = 16;
				var x : int = i%36 * 14;
				var y : int = int(i/36) * 16;
				var l : Number = x/fixed_w;
				var t : Number = y/fixed_h;
				
				//trace(l + " " + t + " " + w + " " + h + " " + x + " " + y + " ");

				bounds.texture.setTextureCoord(i, Vector.<Number>([l, t, l + (w/fixed_w), t + (h/fixed_h), 0, 0, w, h])); 
			}

			bounds.setUV(4);
			root.addBounds(bounds);

			var bounds1 : slBounds = s.textureFactory.createTextureFromBitmap(bm,"bm", false).createBounds();
			bounds1.setUV(0);
			//root.addBounds(bounds1);


			ticker.addListener(root);
			ticker.addListener(s);

			ticker.start();
		}*/
	}
	
}
