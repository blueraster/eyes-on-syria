package com.br.eyesOnNigeria.UI.mappping
{
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	
	public class BasicExtentControlLayer extends GraphicsLayer
	{
		public var zoom_to_extent_fully_visible:Boolean = true;
		
		public function BasicExtentControlLayer()
		{
		}
		
		// ===================================================================================================
		public var min_level:int = 0;
		
		public function set level(value:int):void {
			if (!this.map)
				return;
			
			this.map.level = value;
		}
		
		public function set scale(value:Number):void {
			if (!this.map)
				return;
			
			this.map.scale = value;
		}

		// ===================================================================================================
		public function setMapExtent(xmin:Number, ymin:Number, xmax:Number, ymax:Number):void {
			if (!this.map)
				return;
			
			var oZoomToExtent:Extent = new Extent(xmin, ymin, xmax, ymax);
			if (zoom_to_extent_fully_visible) {
				var goToLevel:int = 0;
				var myCenterPoint:MapPoint = new MapPoint(oZoomToExtent.center.x, oZoomToExtent.center.y);
				var dX:Number=Math.abs(oZoomToExtent.xmax-oZoomToExtent.xmin);
				var dY:Number=Math.abs(oZoomToExtent.ymax-oZoomToExtent.ymin);
				var nMapW:Number = this.map.width;
				var nMapH:Number = this.map.height;
				var requestResolution:Number=Math.max(dX/nMapW,dY/nMapH);
				for(var level:int=0; level < this.map.lods.length; level++){
					if(requestResolution > this.map.lods[level].resolution){
						goToLevel = level-1;
						break;
					}
				}
				if (goToLevel < min_level) goToLevel = min_level;
				if (goToLevel >= this.map.lods.length) goToLevel = this.map.lods.length - 1;
				
				this.map.centerAt(myCenterPoint);
				this.map.level = goToLevel;
			} else {
				this.map.extent = oZoomToExtent;
			}
		}
		
		public function centerAndZoom(x:Number, y:Number, level:int):void {
			this.map.centerAt(new MapPoint(x, y));
			this.map.level = level;
		}
		public function centerAt(point:MapPoint):void {
			this.map.centerAt(point);
		}
		
		// ===================================================================================================
		override protected function addMapListeners():void {
			super.addMapListeners();
			if (this.map) {
				callLater(fixZoomBar);
			}
		}
		
		private function fixZoomBar():void {
			this.map.level = this.map.level;
		}
	}
}