package sl2d {
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;

    public class slCamera {

        protected var renderMatrix:Matrix3D = new Matrix3D();
        protected var projectionMatrix:Matrix3D = new Matrix3D();
        protected var viewMatrix:Matrix3D = new Matrix3D();

        protected var _sceneWidth:Number;
        protected var _sceneHeight:Number;

        public var invalidated:Boolean = true;

        public function slCamera(w:Number, h:Number) {
            resizeCameraStage(w, h);
        }

        public function resizeCameraStage(w:Number, h:Number):void {
            _sceneWidth = w;
            _sceneHeight = h;
            invalidated = true;
            projectionMatrix = makeOrtographicMatrix(0, w, 0, h);
        }

        public function makeOrtographicMatrix(left:Number, right:Number, top:Number, bottom:Number, zNear:Number = -1, zFar:Number = 1):Matrix3D {

            return new Matrix3D(Vector.<Number>([
                                                    2 / (right - left), 0, 0,  0,
                                                    0,  2 / (top - bottom), 0, 0,
                                                    0,  0, 1 / (zFar - zNear), 0,
                                                    0, 0, 0, 1
                                                ]));
        }

        public function getViewProjectionMatrix():Matrix3D {
            if(invalidated) {
                invalidated = false;

				viewMatrix.identity();
				viewMatrix.appendScale(2/_sceneWidth * zoom,-2/_sceneHeight * zoom,1/3000);
				viewMatrix.appendTranslation(-1 - (x/_sceneWidth) * 2, 1 +  (y/_sceneHeight) * 2,0);

                viewMatrix.appendRotation(_rotation, Vector3D.Z_AXIS);

            }

            return viewMatrix;
        }

        public function reset():void {
            x = y = rotation = 0;
            zoom = 1;
        }

        private var _x:Number = 0.0;

        public function get x():Number {
            return _x;
        }

        public function set x(value:Number):void {
            invalidated = true;
            _x = value;
        }

        private var _y:Number = 0.0;

        public function get y():Number {
            return _y;
        }

        public function set y(value:Number):void {
            invalidated = true;
            _y = value;
        }

        private var _zoom:Number = 1.0;

        public function get zoom():Number {
            return _zoom;
        }

        public function set zoom(value:Number):void {
            invalidated = true;
            _zoom = value;
        }

        private var _rotation:Number = 0.0;

        public function get rotation():Number {
            return _rotation;
        }

        public function set rotation(value:Number):void {
            invalidated = true;
            _rotation = value;
        }

        public function get sceneWidth():Number {
            return _sceneWidth;
        }

        public function get sceneHeight():Number {
            return _sceneHeight;
        }
    }
}
