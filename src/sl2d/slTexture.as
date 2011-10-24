package sl2d {
	import flash.display3D.textures.Texture;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class slTexture {
		public static const FAILED : int = -1;
		public static const NOT_READY : int = 0;
		public static const PREPARING : int = 1;
		public static const READY : int = 2;
		public static const INITIALIZED : int = 3;

		public var status : uint = NOT_READY;
		public var root : Sprite;

		public var compareMode : String = Context3DCompareMode.GREATER_EQUAL;
		public var blendFactor_src : String = Context3DBlendFactor.ONE;
		public var blendFactor_dst : String = Context3DBlendFactor.ZERO;

		public var texture : Texture;

		public var width : uint = 0;
		public var height : uint = 0;

		public var frameCount : uint = 0;

		public function slTexture(texture : Texture = null, w : uint = 0, h : uint = 0, isReady : Boolean = true) : void {
			this.texture = texture;
			this.width = w;
			this.height = h;
		}

		public var vertexVector : Vector.<Number> = new Vector.<Number>();
		public var uvVector : Vector.<Number> = new Vector.<Number>();
		public var colorVector : Vector.<Number> = new Vector.<Number>();

		protected var recycled : Vector.<slBounds> = new Vector.<slBounds>();
		
		public function createBounds() : slBounds {
			if(recycled.length > 0) return recycled.shift();

			var len : uint = vertexVector.push(
					0, 0, 0,
					1, 0, 0,
					0, 1, 0,
					1, 1, 0
					);

			colorVector.push(
					1, 1, 1, 
					1, 1, 1, 
					1, 1, 1, 
					1, 1, 1 
					);

			uvVector.push(
					0, 0, 1,
					1, 0, 1,
					0, 1, 1,
					1, 1, 1
					);
			bc ++;
			vc = bc * 4;
			ic = bc * 2;

			return new slBounds(this, len - 12);
		}

		protected var bc : uint = 0;
		protected var vc : uint = 0;
		protected var ic : uint = 0;

		public function get bufferCount() : uint {
			return bc;
		}

		public function get vertexCount() : uint {
			return vc;
		}

		public function get indexCount() : uint {
			return ic;
		}

		public function recycle(bounds : slBounds) : void {
			resetVector(bounds.offset);
			recycled.push(bounds);
		}

		public function setV(offset : uint, position : uint, value : Number) : void {
			vertexVector[offset + position] = value;
		}

		public function getV(offset : uint, position : uint) : Number {
			return vertexVector[offset + position];
		}

		public function setU(offset : uint, position : uint, value : Number) : void {
			uvVector[offset + position] = value;
		}
		
		public function getU(offset : uint, position : uint) : Number {
			return vertexVector[offset + position];
		}


		public function resetVector(offset : uint) : void {
			vertexVector[offset + 0] = 0;
			vertexVector[offset + 1] = 0;
			vertexVector[offset + 2] = 0;

			vertexVector[offset + 3] = 1;
			vertexVector[offset + 4] = 0;
			vertexVector[offset + 5] = 0;

			vertexVector[offset + 6] = 0;
			vertexVector[offset + 7] = 1;
			vertexVector[offset + 8] = 0;

			vertexVector[offset + 9] = 1;
			vertexVector[offset + 10] = 1;
			vertexVector[offset + 11] = 0;

			uvVector[offset + 0] = 0;
			uvVector[offset + 1] = 0;
			uvVector[offset + 2] = 1;

			uvVector[offset + 3] = 1;
			uvVector[offset + 4] = 0;
			uvVector[offset + 5] = 1;

			uvVector[offset + 6] = 0;
			uvVector[offset + 7] = 1;
			uvVector[offset + 8] = 1;

			uvVector[offset + 9] = 1;
			uvVector[offset + 10] = 1;
			uvVector[offset + 11] = 1;
		}
		

		//UV Info
		public var uvIndex : Vector.<uint> = Vector.<uint>([0]);
		public var uvInfo : Vector.<Number> = Vector.<Number>([0, 0, 1, 1, 0, 0, 1, 1]);//left, top, right, bottom, offsetX, offsetY, width, height

		public function getTextureCoord(index_id : uint, vector : Vector.<Number>) : void {
			var index : int = uvIndex.indexOf(index_id);

			if(index >= 0){
				index = index * 8;
				vector[0] = uvInfo[index];
				vector[1] = uvInfo[index + 1];
				vector[2] = uvInfo[index + 2];
				vector[3] = uvInfo[index + 3];
				vector[4] = uvInfo[index + 4];
				vector[5] = uvInfo[index + 5];
				vector[6] = uvInfo[index + 6];
				vector[7] = uvInfo[index + 7];
			}else{
				throw new Error("Can't find the uv info:" + index_id);
			}
		}

		public function setTextureCoord(index_id : uint, vector : Vector.<Number>) : void {
			var index : int = uvIndex.indexOf(index_id);

			if(index >= 0){
				uvInfo[index]     = vector[0]; 
				uvInfo[index + 1] = vector[1]; 
				uvInfo[index + 2] = vector[2]; 
				uvInfo[index + 3] = vector[3]; 
				uvInfo[index + 4] = vector[4]; 
				uvInfo[index + 5] = vector[5]; 
				uvInfo[index + 6] = vector[6]; 
				uvInfo[index + 7] = vector[7]; 
			}else{
				uvInfo = uvInfo.concat(vector);
				uvIndex.push(index_id);
			}
		}
	}
}
