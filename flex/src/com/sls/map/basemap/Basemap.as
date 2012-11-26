package com.sls.map.basemap 
{			
	import com.sls.Debug;
	import com.sls.utils.XMLLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class Basemap extends EventDispatcher
	{	
		public var selected:BasemapVO;
		public var list:ArrayCollection = new ArrayCollection();
		
		// loading 
		public function load(url:String):void {			
			var oXMLLoader:XMLLoader = new XMLLoader(url, handleConfigLoader);			
		}
		private function handleConfigLoader(event:Event):void {
			this.parseXML((event.currentTarget as XMLLoader).xml);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		// parsing
		public function parseXML(oXML:XML):void {			
			var acList:ArrayCollection = new ArrayCollection();
			for(var i:int = 0; i < oXML.children().length(); ++i){
				var oBasemapXML:XML = oXML.children()[i];
				
				if ((String(oBasemapXML.type) != BasemapVO.TILE) && 
					(String(oBasemapXML.type) != BasemapVO.DYNAMIC) &&
					(String(oBasemapXML.type) != BasemapVO.OPEN_STREET)) {
					Debug.handleError("Layer with Id " + String(oBasemapXML.id) + " was dropped 'cuase type '" + String(oBasemapXML.type) + "'not defined", "Basemap Parse Error");
					continue;					
				}
				
				var oBaseMap:BasemapVO = new BasemapVO();
				oBaseMap.id = String(oBasemapXML.id);
				oBaseMap.group = String(oBasemapXML.group);
				oBaseMap.label = String(oBasemapXML.label);  				
				oBaseMap.url = String(oBasemapXML.url);				
				oBaseMap.background_url = String(oBasemapXML.background_url);
				oBaseMap.legend = String(oBasemapXML.legend);
				oBaseMap.tooltip = String(oBasemapXML.tooltip);
				oBaseMap.thumb = String(oBasemapXML.thumb);
				
				oBaseMap.type = String(oBasemapXML.type);
				
				acList.addItem(oBaseMap);				
				
				if (String(oBasemapXML.@default) == "true")
					this.selected = oBaseMap;
				
			}
			
			this.list = acList;
			if (!this.selected && this.list.length > 0)
				this.selected = this.list.getItemAt(0) as BasemapVO;			
		}
		
		public function filter(group:String):ArrayCollection {
			var acList:ArrayCollection = new ArrayCollection();
			for (var i:Number = 0; i < this.list.length; ++i) {
				var oBasemapVO:BasemapVO = this.list[i] as BasemapVO;
				if (group == "")
					acList.addItem(oBasemapVO);
				else {
					if (group == oBasemapVO.group)
						acList.addItem(oBasemapVO);
				}
			}
			return acList;
		}
		//SINGLETON ==========================================================================================
		private static var oInstance:Basemap;		
		public static function get instance():Basemap {
			if (oInstance == null)
				oInstance = new Basemap(new Enforcer());			
			return oInstance;
		}
		
		public function Basemap(enforcer:Enforcer) {			
		}
	}
}
class Enforcer { }
// ActionScript file