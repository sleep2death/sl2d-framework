package sl2d {
	import flash.display.BitmapData;

	public class slRemoteTexture extends slTexture {

		protected var url : String;
		protected var parse : uint = 0;

		protected var parser : slWilParser;
		protected var factory : slTextureFactory;

		public function slRemoteTexture(factory : slTextureFactory, url : String) : void {
			this.url = url;
			this.factory = factory;

			parser = new slWilParser(this);
			parser.parse(url);	

			status = PREPARING;
		}

		public function setTextureFromBitmap(bd : BitmapData, w : uint, h : uint) : void {
			texture = factory.createTexture(bd, w, h);
		}
	}
}
