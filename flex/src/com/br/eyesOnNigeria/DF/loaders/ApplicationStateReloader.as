package com.br.eyesOnNigeria.DF.loaders
{
	import com.br.eyesOnNigeria.DF.AppController;
	import com.br.eyesOnNigeria.DF.Data.FlickrPhotoVO;
	import com.br.eyesOnNigeria.DF.Data.HeadingVO;
	import com.br.eyesOnNigeria.DF.Data.YouTubeVideoVO;
	import com.br.eyesOnNigeria.DF.events.AppEvent;
	import com.br.eyesOnNigeria.DF.models.AppConfig;
	import com.br.eyesOnNigeria.DF.models.FlickrData;
	import com.br.eyesOnNigeria.DF.models.Themes;
	import com.br.eyesOnNigeria.DF.models.YouTubeData;
	import com.esri.ags.Graphic;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	
	public class ApplicationStateReloader extends EventDispatcher {
		public var theme:String;
		public var themeVO:HeadingVO;
		public var photo_id:String;
		public var video_id:String;
		
		public function ApplicationStateReloader(target:IEventDispatcher=null){
			super(target);
			
			AppController.addEventListener(AppEvent.INITIAL_VIEW_LOADED, onInitialViewLoaded);
			AppController.addEventListener(AppEvent.PHOTO_INITIALIZE_COMPLETE, onPhotoInitializeComplete);
			AppController.addEventListener(AppEvent.VIDEO_INITIALIZE_COMPLETE, onVideoInitializeComplete);
		}
		
		public function load():void {
			this.loadURLParameters();
			this.preloadThemeVO();
		}
		
		private function preloadThemeVO():void {
			if(this.theme)
				this.themeVO = Themes.instance.getHeadingVOById(this.theme);			
		}
		
		private function onInitialViewLoaded(event:AppEvent):void {
			AppController.removeEventListener(AppEvent.INITIAL_VIEW_LOADED, onInitialViewLoaded);
			
			if(this.themeVO)
				AppController.updateSelectedTheme(this.themeVO);
		}
		
		private function onPhotoInitializeComplete(event:AppEvent):void {
			AppController.removeEventListener(AppEvent.PHOTO_INITIALIZE_COMPLETE, onPhotoInitializeComplete);
			
			if(this.photo_id) {
				var graphic:Graphic = FlickrData.instance.getGraphicById(this.photo_id);
				if (graphic)
					AppController.photoPopUp(graphic.attributes as FlickrPhotoVO);
			}
		}
		
		private function onVideoInitializeComplete(event:AppEvent):void {
			AppController.removeEventListener(AppEvent.VIDEO_INITIALIZE_COMPLETE, onVideoInitializeComplete);
			
			if(this.video_id && this.photo_id == null) {
				var graphic:Graphic = YouTubeData.instance.getGraphicById(this.video_id);
				if (graphic)
					AppController.videoPopUp(graphic.attributes as YouTubeVideoVO);
			}
		}
		
		private function loadURLParameters():void
		{
			var url:String = ExternalInterface.call("window.location.href.toString");
			var url_split:Array = url.split('?');			
			this.theme = AppConfig.instance.default_theme;
			
			//this.photo_id = "6198376692";
			//this.theme = "harassment";
			//?theme=deadlydetention&photo=6033386142
			//this.photo_id = "6033386142";
			//this.theme = "deadlydetention";
			
			if(url_split.length > 1) {
				var uriComponent:String = decodeURIComponent(url_split[1]);
				var params:Array = uriComponent.split('&');
				
				for(var i:int = 0; i < params.length; i++)  {
					var split:Array = params[i].split('=');
					var key:String = split[0];
					var value:String = split[1];
					
					switch(key) {
						case 'theme':
							this.theme = value;
							break;					
						case 'photo':
							this.photo_id = value;
							break;						
						case 'video':
							this.video_id = value;
							break;
						default:							
							break;
					}
				}
			}
		}
		
	}
}