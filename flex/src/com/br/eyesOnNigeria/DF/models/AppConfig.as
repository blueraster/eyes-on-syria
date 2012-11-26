package com.br.eyesOnNigeria.DF.models
{
	import com.esri.ags.geometry.Extent;
	
	import flash.external.ExternalInterface;
	
	import spark.filters.GlowFilter;
	
	[Bindable]
	public class AppConfig
	{		
		public var highlight_new_date:Number = 0;
		public var highlight_new_filter:GlowFilter;
		public var new_date_founded:Boolean = false;
		
		public var default_theme:String = "";
		
		public const SYMBOL_GLOW:Array = [new GlowFilter(0xffffff, 1, 4, 4, 1, 3)];
		//NOTE: These values are directly tied to the show/hide markers properties below, with THEME not supporting show/hide
		public const MARKER_TYPE_THEME:String = "theme";
		public const MARKER_TYPE_FIRST:String = "first";
		public const MARKER_TYPE_SECOND:String = "second";
		public const MARKER_TYPE_PHOTO:String = "photo";
		public const MARKER_TYPE_VIDEO:String = "video";
		
		public var application_url:String;
		public var facebook_app_id:String;
		public var initial_extent:Extent;
		public var initial_scale:Number = 0;
		public var twitter_hash_tag:String;

		public var base_mapserver_url:String = "";
		public var topo_url:String = "";
		public var ve_access_key:String = "";
		public var ve_map_style:String = "";
		public var introHeading:String = "";
		public var introText:String = "";
		
		// show/hide markers
		public var show_markers_first:Boolean = true;
		public var show_markers_second:Boolean = true;
		public var show_markers_photo:Boolean = true;
		public var show_markers_video:Boolean = true;
		
		public function parseXML(_xml:XML):void 
		{
			debug(".parseXML() -- _xml = " + _xml.toString());
			var aNodes:XMLList = _xml.children();
			var sNodeName:String;
			for (var i:int=0; i<aNodes.length(); i++) 
			{
				sNodeName = aNodes[i].name();
				switch (sNodeName) 
				{
					case "initial_extent":
						this.initial_extent = new Extent(_xml.initial_extent.@xmin, _xml.initial_extent.@ymin, _xml.initial_extent.@xmax, _xml.initial_extent.@ymax);
						this.initial_scale = Number(_xml.initial_extent.@scale);
						break;
					case "highlight_new":	
						this.highlight_new_date = (new Date()).time/1000 - Number(_xml.highlight_new.@days) * 24 * 3600 - Number(_xml.highlight_new.@hours) * 3600 - Number(_xml.highlight_new.@minutes) * 60 - Number(_xml.highlight_new.@seconds);
						if (String(_xml.highlight_new.@enable) == "false")
							this.highlight_new_date = -1;
						this.highlight_new_filter = new GlowFilter(Number(_xml.highlight_new.@color), 1, Number(_xml.highlight_new.@blur), Number(_xml.highlight_new.@blur), Number(_xml.highlight_new.@strength));
						break;
					default:
						this[sNodeName] = aNodes[i].toString();
						break;					
				}
			}
		}
		
		public function AppConfig()
		{
			
		}
		
		public static const instance:AppConfig = new AppConfig();
		
		private function debug(message:String):void 
		{
			//trace("AppConfig" + message);
		}
	}
}