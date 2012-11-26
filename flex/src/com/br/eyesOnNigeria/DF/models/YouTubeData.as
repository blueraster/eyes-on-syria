package com.br.eyesOnNigeria.DF.models
{
	import com.br.eyesOnNigeria.DF.Data.YouTubeVideoVO;
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.utils.WebMercatorUtil;
	
	import mx.collections.ArrayCollection;
	 
	[Bindable]
	public class YouTubeData {
		// config
		public var youtube_api_key:String = '';
		public var youtube_user_id:String = '';
		public var search_for:String = '';
		public var cross_domain:String = '';
		public var user_search_prefix:String = '';
		public var user_search_suffix:String = '';
				
		public var videos:ArrayCollection = new ArrayCollection();		
		
		public var oTagsDestinationStore:Object = {};
		
		public function parseXML(_xml:XML):void {			
			var aNodes:XMLList = _xml.children();
			var sNodeName:String;
			for (var i:int=0; i<aNodes.length(); i++) {
				sNodeName = aNodes[i].name();
				switch (sNodeName) {
					
					default:
						this[sNodeName] = aNodes[i].toString();
						break;
				}
			}		
		}
		
		public function getGraphicById(id:String):Graphic {
			for each (var oTagDesctination:Object in oTagsDestinationStore) {				
				for each(var graphic:Graphic in oTagDesctination.layer.graphicProvider) {
					if (graphic.attributes.id == id)					
						return graphic;					
				}
			}
			
			return null;
		}
		
		// ===================================================================================================
		public function clearGraphics():void {
			for each (var oTagDesctination:Object in oTagsDestinationStore) {
				oTagDesctination.layer.graphicProvider = new ArrayCollection();
			}
		}
		
		public function addTagDestination(tags:Array, layer:GraphicsLayer):void {
			this.oTagsDestinationStore[tags[0]] = {};
			this.oTagsDestinationStore[tags[0]].tags = tags;
			this.oTagsDestinationStore[tags[0]].layer = layer;
		}
		public function removeTagDestination(tags:Array):void {
			delete this.oTagsDestinationStore[tags[0]];
		}
		public function removeAllTagDestinations():void {
			this.oTagsDestinationStore = {};
		}
		public function updateDestinations():void {
			for each (var oTagDesctination:Object in oTagsDestinationStore) {
				oTagDesctination.layer.graphicProvider = this.getGraphicsByTags(oTagDesctination.tags);
			}
		}

		public function getGraphicsByTags(tags:Array):ArrayCollection  {			
			//convert video vos to graphics	
			if (this.videos.length > 0) {
				var graphics:Array = [];
				var gr:Graphic;
				var i:int;
				var bFound:Boolean;
				for each (var vo:YouTubeVideoVO in this.videos) {									
					if (tags.length == 0) {
						bFound = true;
					} else {
						for (i=0; i<tags.length; ++i) {
							bFound = false;
							for each (var tag:String in vo.keywords) {								
								if (tags[i] == tag) {								
									bFound = true;
									break;
								}
							}							
							if (!bFound)							
								break;						
						}
					}
					if (bFound && (vo.latitude != 0 || vo.longitude != 0)) {						
						gr = new Graphic();
						gr.attributes = vo;
						gr.geometry = WebMercatorUtil.geographicToWebMercator(new MapPoint(vo.longitude, vo.latitude)) as MapPoint;						
						graphics.push(gr);
					}
				}				
				return new ArrayCollection(graphics);
			}
			return new ArrayCollection();
		}
		
		// ===================================================================================================
		//SINGLETON========================================================
		public static const instance:YouTubeData = new YouTubeData();
		
		public function YouTubeData() {
		}
	}
}

