package sl2d {
	import flash.display.Loader;
	import flash.display.LoaderInfo;

	public class slSimpleTextureLoader {
		protected var world : slWorld;

		public function slSimpleTextureLoader(world : slWorld) : void {
			this.world = world;
		}

		protected var textureName : String;

		public function loadTexture(textureName : String,  textureURL : String, coordURL : String) : void {
			var loader0 : Loader = new Loader();
			var loader1 : URLLoader = new URLLoader();

			this.textureName = textureName;

			loader0.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureLoaded);
			loader1.addEventListener(Event.COMPLETE, onCoordLoaded);

			loader0.load(new URLRequest(textureURL));
			loader1.load(new URLRequest(textureURL));
		}

		public function onTextureLoaded(evt : Event) : void {
			var bm : Bitmap = Bitmap(evt.target.content);
			var t : slTexture = world.textureFactory.createTextureFromBitmap(bm, textureName, true);
		}
	}
}
