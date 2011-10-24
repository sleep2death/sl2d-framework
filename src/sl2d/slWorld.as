/*
* SL2D - The next generation flash 2d game engine. 
* .....................
* 
* Author: Aspirin - Sleep2Death
* Copyright (c) SNDA 2011
* 
*
*/
package sl2d {
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	import flash.geom.*;
	import flash.events.Event;

	public class slWorld implements slITicker{
		protected var stage : Stage;
		protected var viewPort : Rectangle;

		protected var stage3D : Stage3D;
		protected var context : Context3D;

		public var readyCallBack : Function;

		public function slWorld(stage : Stage, index : uint = 0, viewPort : Rectangle = null, readyCallBack : Function = null) : void {
			if(!viewPort) {
				this.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}else{
				this.viewPort = viewPort;
			}


			this.readyCallBack = readyCallBack;
			this.stage = stage;

			stage3D = stage.stage3Ds[ index ];
			trace(this.viewPort);

			if(stage3D.context3D == null){
				stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
				stage3D.requestContext3D("auto");
			}else{
				initialize();
			}
		}


		protected function onContext3DCreate(evt : Event) : void {
			var stage3D : Stage3D = evt.target as Stage3D;
			context = stage3D.context3D;

			stage3D.x = this.viewPort.x;
			stage3D.y = this.viewPort.y;

			initialize();

			if(readyCallBack != null) readyCallBack.call(this);
		}

		public static var antiAlias : uint = 4;

		public var helper : slAGALHelper;
		public var textureFactory : slTextureFactory;
		public var camera : slCamera;

		protected function initialize() : void {
			context.enableErrorChecking = true;
			context.configureBackBuffer( viewPort.width, viewPort.height, antiAlias, true);

			context.setCulling(Context3DTriangleFace.NONE);
			context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context.setDepthTest(true, Context3DCompareMode.GREATER_EQUAL);

			helper = new slAGALHelper(context);

			textureFactory = new slTextureFactory(context);

			camera = new slCamera(viewPort.width, viewPort.height);
			helper.setCamera(camera);
		}

		protected var bRed : Number = 0;
		protected var bGreen : Number = 0;
		protected var bBlue : Number = 0;

		public function set backgroundColor(value : uint) : void {
			bRed = ((value & 0xFF0000) >> 16)/256;
			bGreen = ((value & 0x00FF00) >> 8)/256;
			bBlue = ((value & 0x0000FF))/256;
		}

		public function update() : void {
			context.clear(bRed, bGreen, bBlue,0,0);
			helper.draw(textureFactory.getTextures());
			context.present();
		}
	}
}

