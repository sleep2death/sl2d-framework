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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.*;
	import flash.display3D.textures.*;

	public class slTextureFactory {
		private var context : Context3D;

		public function slTextureFactory(context : Context3D){
			this.context = context;	
		}

		private var textureNames : Vector.<String> = new Vector.<String>();
		private var textures : Vector.<slTexture> = new Vector.<slTexture>();

		public function getIndexByName(texture_name : String) : int {
			return textureNames.indexOf(texture_name);
		}

		public function getTextureByName(texture_name : String) : slTexture {
			return textures[getIndexByName(texture_name)];
		}

		public function createTextureFromBitmap(bm : Bitmap, texture_name : String, dispose : Boolean = true, forceNew : Boolean = false) : slTexture {
			var index : int = getIndexByName(texture_name);

			if(index >= 0 && !forceNew){
				return textures[index];
			}else if(index < 0 || forceNew){
				var w : int = Math.pow(2, Math.ceil(Math.LOG2E * Math.log(bm.width)));
				var h : int = Math.pow(2, Math.ceil(Math.LOG2E * Math.log(bm.height)));

				var texture : Texture = createTexture(bm.bitmapData, w, h);				

				var res : slTexture = new slTexture(texture, w, h);
				res.status = slTexture.INITIALIZED;

				textureNames.push(texture_name);
				textures.push(res);

				if(dispose) bm.bitmapData.dispose();

				return res;
			}

			return null;
		}

		public function createTextureFromWil(wil_path : String, texture_name : String) : slRemoteTexture {
			var index : int = getIndexByName(texture_name);

			if(index < 0){
				var res : slRemoteTexture = new slRemoteTexture(this, wil_path);
				textureNames.push(texture_name);
				textures.push(res);

				return res;
			}

			return textures[index] as slRemoteTexture;
		}

		public function createTexture(bd : BitmapData, w : uint , h : uint) : Texture {
				var texture : Texture = context.createTexture(w, h, Context3DTextureFormat.BGRA, true);
				texture.uploadFromBitmapData(bd);				
				return texture;
		}

		public function getTextures() : Vector.<slTexture> {
			return textures;
		}
	}
}
