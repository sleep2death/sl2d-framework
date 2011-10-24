package sl2d
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class slWilParser
	{
		protected var handler : slRemoteTexture;

		public function slWilParser(handler : slRemoteTexture)
		{
			this.handler = handler;
		}		
		
		// Public Methods
		public function parse( wilPath : String ) : void{
			var loader:URLLoader = new URLLoader;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, fileLoadedHandler);
			loader.load(new URLRequest(wilPath));
		}
		
		// Private Methods
		private function readIndex(uv:ByteArray):uint{	
			var id1 : uint = uv.readByte();
			var id2 : uint = uv.readByte();
			var id3 : uint = uv.readByte();
			var id4 : uint = uv.readByte();
			
			var res : String = (b2s(id1) + b2s(id2) + b2s(id3) + b2s(id4)); 
			return Number(res);
		}

		private function b2s(id : uint) : String {
			var str : String = id.toString();
			if(id < 10) str = "0" + str;
			return str;
		}
		
		// Event Handlers
		private function fileLoadedHandler(evt:Event):void{
			var packet:ByteArray = evt.target.data as ByteArray;
			packet.endian = "littleEndian";

			var width : uint = packet.readUnsignedInt();
			var height : uint = packet.readUnsignedInt();
			var frame : uint = packet.readUnsignedInt();
			var offset_len : uint = frame;

			var fixed_w : int = Math.pow(2, Math.ceil(Math.LOG2E * Math.log(width)));
			var fixed_h : int = Math.pow(2, Math.ceil(Math.LOG2E * Math.log(height)));

			//trace("width: " + width);
			//trace("height: " + height);
			//trace("fixed: " + fixed_w + "x" + fixed_h);
			//trace("frame: " + frame);

			for(var i : uint = 0; i < offset_len; i++){
				//var index:int = readIndex(uv);
				
				var l : Number = packet.readUnsignedInt()/fixed_w;
				var t : Number = packet.readUnsignedInt()/fixed_h;
				var w : Number = packet.readUnsignedInt();
				var h : Number = packet.readUnsignedInt();
				var x : int = packet.readUnsignedInt();
				var y : int = packet.readUnsignedInt();
				
				//trace(l + " " + t + " " + w + " " + h + " " + x + " " + y + " ");

				handler.setTextureCoord(i, Vector.<Number>([l, t, l + (w/fixed_w), t + (h/fixed_h), x, y, w, h])); 
			}


			var image : ByteArray = new ByteArray();
			packet.readBytes(image);

			var bd : BitmapData = new BitmapData(width, height, true, 0);
			bd.setPixels(new Rectangle(0,0,width,height), image);

			handler.setTextureFromBitmap(bd, fixed_w, fixed_h);
			handler.frameCount = frame;
			handler.status = slTexture.INITIALIZED;
		}
	}
}
