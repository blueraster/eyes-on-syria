package com.sls.map.basemap
{
	[Bindable]
	public class BasemapVO
	{
		public static const TILE:String = "tile";
		public static const DYNAMIC:String = "dynamic";
		public static const OPEN_STREET:String = "openstreet";
				
		public var id:String = "";
		public var group:String = "";
		public var label:String = "";		
		public var url:String = "";
		public var background_url:String = "";
		public var thumb:String = "";
		public var legend:String = "";
		public var tooltip:String = "";		
		
		public var type:String = "tile";		
		
		public function BasemapVO()
		{
		}
	}
}