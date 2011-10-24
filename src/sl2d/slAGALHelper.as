package sl2d {
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	import flash.geom.*;

	import com.adobe.utils.AGALMiniAssembler;

	public class slAGALHelper {
		private var context : Context3D;
		
		public function slAGALHelper(context : Context3D) : void {
			this.context = context;
			initialize();
		}

		private function initialize() : void {
			initVectors();
			initBuffers();
			initShader();
		}

		private static const MAX_SIZE : uint = 1500;

		private static const VERTEX_SIZE : uint = MAX_SIZE * 4;
		private static const INDEX_SIZE  : uint = MAX_SIZE * 6;

		private var vertexVector : Vector.<Number> = new Vector.<Number>();
		private var uvVector : Vector.<Number> = new Vector.<Number>();
		private var indexVector : Vector.<uint> = new Vector.<uint>();

		private function initVectors() : void {
			for(var i:int = 0;i<MAX_SIZE;i++) {
				var vertexOffset:Number = i*4;
				vertexVector.push(
					0,0,0,
					1,0,0,
					0,1,0,
					1,1,0
				);
				uvVector.push(
					0,0,1,
					1,0,1,
					0,1,1,
					1,1,1
				);
				indexVector.push(
					vertexOffset, vertexOffset+1, vertexOffset+2,vertexOffset+1,vertexOffset+2,vertexOffset+3
				);
			}
		}

		private var vertexBuffer : VertexBuffer3D; 
		private var uvBuffer : VertexBuffer3D; 
		private var colorBuffer : VertexBuffer3D; 
		private var indexBuffer : IndexBuffer3D; 

		private function initBuffers() : void {
			//vertexBuffer = context.createVertexBuffer( VERTEX_SIZE, 3);
			//uvBuffer = context.createVertexBuffer( VERTEX_SIZE, 3);

			//indexBuffer = context.createIndexBuffer( indexVector.length);
			//indexBuffer.uploadFromVector(indexVector, 0, indexVector.length);
		}

		//Static Code From M2D;
		public var vertex_shader : String =
			"mov vt1, va0 \n"+
			"m44 op, vt1, vc0 \n"+	// 4x4 matrix transform from world space to output clipspace
			"mov v0, va1 \n"+	// copy xformed tex coords to fragment program
			"mov v1, va2 \n";	// copy xformed tex coords to fragment program

		public var fragment_shader : String =
			"mov ft0, v0 \n" +
			"mov ft1, v1 \n" +
			"tex ft2, ft0.xy, fs0 <2d,clamp,linear> \n" + // sample texture 0
			"mul ft2, ft2, ft1 \n" + 
			"mov oc, ft2";

		private var shaderProgram : Program3D;

		private function initShader() : void {
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, vertex_shader );
			
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler(); 
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT, fragment_shader);
			
			shaderProgram = context.createProgram();
			shaderProgram.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode );			

			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, FRAGMENT_CONSTANT_0);
			context.setProgram( shaderProgram );
		}

		private var camera : slCamera;

		public function setCamera(camera : slCamera) : void {
			this.camera = camera;	
		}


		private static const FRAGMENT_CONSTANT_0 : Vector.<Number> = Vector.<Number> ( [0, 0, 0, -0.015] );

		private var compareMode : String = Context3DCompareMode.GREATER_EQUAL;
		private var blendFactor_src : String = Context3DBlendFactor.ONE;
		private var blendFactor_dst : String = Context3DBlendFactor.ZERO;

		public function draw(textures : Vector.<slTexture>) : void {
			if(camera.invalidated) context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, camera.getViewProjectionMatrix(), true);

			var len : uint = textures.length;

			for(var i : uint = 0; i < len; i++){
				var t : slTexture = textures[i];

				if(t.status < slTexture.INITIALIZED){
					continue;	
				}

				if(compareMode != t.compareMode){
					compareMode = t.compareMode;
					context.setDepthTest(true, compareMode);
				}

				if(blendFactor_src != t.blendFactor_src || blendFactor_dst != t.blendFactor_dst){
					blendFactor_src = t.blendFactor_src;
					blendFactor_dst = t.blendFactor_dst;

					context.setBlendFactors(blendFactor_src, blendFactor_dst);
				}

				context.setTextureAt(0, t.texture);

				var count : uint = t.bufferCount * 4;
				vertexBuffer = context.createVertexBuffer(count, 3);
				uvBuffer = context.createVertexBuffer(count, 3);
				colorBuffer = context.createVertexBuffer(count, 3);

				//trace(t.bufferCount + "::" + t.indexCount);
				indexBuffer = context.createIndexBuffer( t.indexCount*3);
				indexBuffer.uploadFromVector(indexVector, 0, t.indexCount*3);

				vertexBuffer.uploadFromVector(t.vertexVector, 0, t.vertexCount);
				uvBuffer.uploadFromVector(t.uvVector, 0, t.vertexCount);
				colorBuffer.uploadFromVector(t.colorVector, 0, t.vertexCount);

				context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				context.setVertexBufferAt(1, uvBuffer,     0, Context3DVertexBufferFormat.FLOAT_3);
				context.setVertexBufferAt(2, colorBuffer,  0, Context3DVertexBufferFormat.FLOAT_2);

				context.drawTriangles(indexBuffer, 0, t.indexCount);
			}
		}
	}
}
