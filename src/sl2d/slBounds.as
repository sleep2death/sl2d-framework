package sl2d {
	public class slBounds {
		public var parent : slBoundsGroup;

		public var texture : slTexture;
		public var offset : uint;
		
		//public var parent : slBoundsGroup = null;

		public function slBounds(texture : slTexture, offset : uint) : void {
			this.texture = texture;
			this.offset = offset;
		}

		public function recycle() : void {
			texture.recycle(this);
		}

		//vX, vY, vWidth, vHeight,
		//uX, uY, uWidth, uHeight,
		//depth, alpha, offsetX, offsetY
		protected var bounds : Vector.<Number> = Vector.<Number>([0,0,0,0,
																  0,0,0,0,
																  0,0,0,0]);

		protected var vDirty : Boolean = false; //vertex dirty
		protected var uDirty : Boolean = false; //uv dirty
		protected var dDirty : Boolean = false; //depth dirty
		protected var cDirty : Boolean = false; //color dirty

		public function set x(value : Number) : void {
			bounds[0] = value;
			vDirty = true;
		}

		public function set y(value : Number) : void {
			bounds[1] = value;
			vDirty = true;
		}

		public function get x() : Number {
			return bounds[0];
		}

		public function get y() : Number {
			return bounds[1];
		}

		public function setPosition(x : Number, y : Number) : void {
			bounds[0] = x;
			bounds[1] = y;

			vDirty = true;
		}

		public function setOffset(x : Number, y : Number) : void {
			bounds[10] = x;
			bounds[11] = y;

			vDirty = true;
		}

		public function set width(value : Number) : void {
			bounds[2] = value;
			vDirty = true;
		}

		public function set height(value : Number) : void {
			bounds[3] = value;
			vDirty = true;
		}

		public function get width() : Number {
			return bounds[2];
		}

		public function get height() : Number {
			return bounds[3];
		}

		public function setSize(w : uint, h : uint) : void {
			bounds[2] = w;
			bounds[3] = h;

			vDirty = true;
		}

		public function set depth(value : Number) : void {
			if(bounds[8] == value) return;
			bounds[8] = value;
			dDirty = true;
		}

		public function get depth() : Number {
			return bounds[8];
		}

		public function set color(value : Number) : void {
			bounds[9] = value;
			cDirty = true;
		}

		public function get color() : Number {
			return bounds[9];
		}

		protected var uvCoord : Vector.<Number> = Vector.<Number>([0, 0, 1, 1]);//left, top, right, bottom

		private var coord_index : int = -1;

		public function setUV(coord_index : uint) : void {
			if(texture.status < slTexture.INITIALIZED || this.coord_index == coord_index) return;

			this.coord_index = coord_index;
			texture.getTextureCoord(coord_index, uvCoord);	
			
			var uVector : Vector.<Number> = texture.uvVector;

			uVector[offset + 0]  = uvCoord[0];
			uVector[offset + 1]  = uvCoord[1];

			uVector[offset + 3]  = uvCoord[2];
			uVector[offset + 4]  = uvCoord[1];

			uVector[offset + 6]  = uvCoord[0];
			uVector[offset + 7]  = uvCoord[3];

			uVector[offset + 9]  = uvCoord[2];
			uVector[offset + 10] = uvCoord[3];

			setPosition(uvCoord[4], uvCoord[5]);
			setSize(uvCoord[6], uvCoord[7]);
		}

		protected var oX : Number = 0;
		protected var oY : Number = 0;

		protected var invalidate : Boolean = true;

		public function update() : void {
			var vVector : Vector.<Number> = texture.vertexVector;
			var uVector : Vector.<Number> = texture.uvVector;
			var cVector : Vector.<Number> = texture.colorVector;

			var left : Number;
			var top : Number;
			var right : Number;
			var bottom : Number;

			if(vDirty){
				left   = bounds[0] + bounds[10];
				top    = bounds[1] + bounds[11];

				right  =  left + bounds[2];
				bottom =  top  + bounds[3];

				vVector[offset + 0]  = left;
				vVector[offset + 1]  = top;

				vVector[offset + 3]  = right;
				vVector[offset + 4]  = top;

				vVector[offset + 6]  = left;
				vVector[offset + 7]  = bottom;

				vVector[offset + 9]  = right;
				vVector[offset + 10] = bottom;

				vDirty = false;
			}

			if(dDirty){
				vVector[offset + 2]  = bounds[8];
				vVector[offset + 5]  = bounds[8];
				vVector[offset + 8]  = bounds[8];
				vVector[offset + 11] = bounds[8];

				dDirty = false;
			}

			if(cDirty){
				var red : uint = color >> 16;
				var green : uint = (color & 0x00FF00) >> 8;
				var blue : uint = (color & 0x0000FF) ;

				//trace(red.toString(16) + " : " + green.toString(16) + " : " + blue.toString(16));

				cVector[offset + 0] =  red/0xFF;
				cVector[offset + 3] =  red/0xFF;
				cVector[offset + 6] =  red/0xFF;
				cVector[offset + 9] = red/0xFF;

				cVector[offset + 1] =  green/0xFF;
				cVector[offset + 4] =  green/0xFF;
				cVector[offset + 7] =  green/0xFF;
				cVector[offset + 10] = green/0xFF;

				cVector[offset + 2] =  blue/0xFF;
				cVector[offset + 5] =  blue/0xFF;
				cVector[offset + 8] =  blue/0xFF;
				cVector[offset + 11] = blue/0xFF;
				
				cDirty = false;
			}
		}
	}
}
