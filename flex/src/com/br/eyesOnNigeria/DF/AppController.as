package com.br.eyesOnNigeria.DF
{

	import com.br.eyesOnNigeria.DF.Data.FlickrPhotoVO;
	import com.br.eyesOnNigeria.DF.Data.FlickrSearchVO;
	import com.br.eyesOnNigeria.DF.Data.HeadingVO;
	import com.br.eyesOnNigeria.DF.Data.PointLayerVO;
	import com.br.eyesOnNigeria.DF.Data.YouTubeVideoVO;
	import com.br.eyesOnNigeria.DF.events.AppEvent;
	import com.br.eyesOnNigeria.DF.events.FlickrEvent;
	import com.br.eyesOnNigeria.DF.events.YouTubeEvent;
	import com.br.eyesOnNigeria.DF.loaders.ApplicationStateReloader;
	import com.br.eyesOnNigeria.DF.loaders.FacebookService;
	import com.br.eyesOnNigeria.DF.loaders.FlickrLoader;
	import com.br.eyesOnNigeria.DF.loaders.YouTubeLoader;
	import com.br.eyesOnNigeria.DF.models.AppConfig;
	import com.br.eyesOnNigeria.DF.models.FlickrData;
	import com.br.eyesOnNigeria.DF.models.Themes;
	import com.br.eyesOnNigeria.DF.models.YouTubeData;
	import com.br.eyesOnNigeria.UI.windows.FacebookPostWindow;
	import com.br.eyesOnNigeria.UI.windows.PhotoPopup;
	import com.br.eyesOnNigeria.UI.windows.TwitterPostWindow;
	import com.br.eyesOnNigeria.UI.windows.VideoPopup;
	import com.media.facebook.FacebookPostInfo;
	import com.media.facebook.events.FacebookEvent;
	import com.media.twitter.Tweet;
	import com.media.twitter.TwitterService;
	import com.media.twitter.events.TwitterEvent;
	import com.sls.map.basemap.Basemap;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="photoPopUp", type="com.br.eyesOnNigeria.DF.events.AppEvent")]
	[Event(name="videoPopUp", type="com.br.eyesOnNigeria.DF.events.AppEvent")]
	[Event(name="closeInfoWindow", type="com.br.eyesOnNigeria.DF.events.AppEvent")]
	[Event(name="closePopUp", type="com.br.eyesOnNigeria.DF.events.AppEvent")]
	[Event(name="updateSelectedTheme", type="com.br.eyesOnNigeria.DF.events.AppEvent")]
	[Event(name="photoInitializeComplete", type="com.br.eyesOnNigeria.DF.events.AppEvent")]
	[Event(name="videoInitializeComplete", type="com.br.eyesOnNigeria.DF.events.AppEvent")]
	[Event(name="initialViewLoaded", type="com.br.eyesOnNigeria.DF.events.AppEvent")]
	[Event(name="requestToShareContent", type="com.br.eyesOnNigeria.DF.events.AppEvent")]
	
	[Event(name="facebookPostComplete", type="com.media.facebook.events.FacebookEvent")]
	
	[Event(name="tweetComplete", type="com.media.twitter.events.TwitterEvent")]
	public class AppController extends EventDispatcher
	{			
		private const oFlickrStore:Object = {};
		private var sCurrentTags:String = "";
		
		// PUBLIC METHODS ====================================================================================
		public static function init():void {
			instance.init();
		}
		
		public static function closePopUp():void {
			instance.dispatchEvent(new AppEvent(AppEvent.CLOSE_POP_UP, false, false));
		}
		
		public static function photoPopUp(flickrPhotoVO:FlickrPhotoVO):void {			
			instance.oPhotoPopup.updateImageWindow(flickrPhotoVO); 
		}
		
		public static function videoPopUp(youtubeVideoVO:YouTubeVideoVO):void {
			instance.dispatchEvent(new AppEvent(AppEvent.VIDEO_POPUP ,false, false, youtubeVideoVO));
			instance.oVideoPopup.updateVideo(youtubeVideoVO);
		}
		
		public static function updateSelectedTheme(headingVO:HeadingVO):void {
			for each(var o:Object in headingVO.theme) {
				switch (o.type)  {
					case 'flickr':
						instance.updateFlickrModel(o as PointLayerVO);
						break;
					case 'youtube':
						instance.updateYouTubeModel(o as PointLayerVO);
						break;
					default:
						break;	
				}
			}
			
			instance.dispatchEvent(new AppEvent(AppEvent.UPDATE_SELECTED_THEME, false, false, headingVO));
		}
		
		public static function initialViewLoaded():void {
			instance.dispatchEvent(new AppEvent(AppEvent.INITIAL_VIEW_LOADED, false, false, null));
		}
		
		private function updateFlickrModel(pointInfo:PointLayerVO):void {			
			FlickrData.instance.updateDestinations();
		}
		
		private function updateYouTubeModel(pointInfo:PointLayerVO):void {
			YouTubeData.instance.updateDestinations();
		}
		
		//SHARING with FACEBOOK AND TWITTER =================================================================
		
		public static function requestToShareContent(serviceName:String='facebook'):void {
			instance.dispatchEvent(new AppEvent(AppEvent.REQUEST_TO_SHARE_CONTENT, false, false, serviceName));
		}
		
		public static function openFacebookPostWindow(facebookPostInfo:FacebookPostInfo):void  {			
			var oFacebookPostWindow:FacebookPostWindow = new FacebookPostWindow();
			oFacebookPostWindow.facebookPostInfo = facebookPostInfo;
			oFacebookPostWindow.addEventListener(CloseEvent.CLOSE, 
				function ():void {					
					PopUpManager.removePopUp(oFacebookPostWindow);
				}
			);
			
			PopUpManager.addPopUp(oFacebookPostWindow, FlexGlobals.topLevelApplication.parentDocument, true);
			PopUpManager.centerPopUp(oFacebookPostWindow);			
		}
		
		public static function postToFacebook(facebookPostInfo:FacebookPostInfo):void {
			instance.oFacebookService.postToFacebook(facebookPostInfo);
		}
		
		public static function openTwitterPostWindow(tweet:Tweet):void  {			
			var oTwitterPostWindow:TwitterPostWindow = new TwitterPostWindow();
			oTwitterPostWindow.tweet = tweet;
			oTwitterPostWindow.addEventListener(CloseEvent.CLOSE, 
				function ():void {					
					PopUpManager.removePopUp(oTwitterPostWindow);
				}
			);
			
			PopUpManager.addPopUp(oTwitterPostWindow, FlexGlobals.topLevelApplication.parentDocument, true);
			PopUpManager.centerPopUp(oTwitterPostWindow);			
		}
		
		public static function postToTwitter(tweet:Tweet):void {
			tweet.text += ' #eyesonsyria';
			instance.oTwitterService.postToTwitter(tweet);
		}
				
		public static function loadFlickrByTags(tags:Array):void {
			instance.sCurrentTags = tags.join(",");
			if (instance.oFlickrStore[tags.join(",")]) {
				if (instance.oFlickrStore[tags.join(",")] == "true")
					return;
				var oFlickrEvent:FlickrEvent = new FlickrEvent(FlickrEvent.PHOTO_SEARCH_COMPLETE,false,false, instance.oFlickrStore[tags.join(",")]);
				instance.handleInitialFlickrRequest(oFlickrEvent);
			}
			else {
				instance.oFlickrStore[tags.join(",")] = "true";
				
				var initialFlickrRequest:FlickrSearchVO = new FlickrSearchVO();
				initialFlickrRequest.perpage = 500;
				initialFlickrRequest.machine_tags = tags;			
				instance.oFlickrLoader.photoSearchByTag(initialFlickrRequest);
			}
		}
		
		// LOADERS ==========================================================================================
		private var oFlickrLoader:FlickrLoader;
		private var oYouTubeLoader:YouTubeLoader;
		private var oApplicationStateReloader:ApplicationStateReloader;
		private var oFacebookService:FacebookService;
		private var oTwitterService:TwitterService;

		// INITIALIZATION ====================================================================================
		private function init():void  {						
			this.oApplicationStateReloader = new ApplicationStateReloader();
			this.oApplicationStateReloader.load();
			
			this.oFlickrLoader = new FlickrLoader(FlickrData.instance.flickr_api_key, null, FlickrData.instance.flickr_user_id);
			this.oFlickrLoader.addEventListener(Event.COMPLETE,handleFlickrInitComplete);
			this.oFlickrLoader.addEventListener(FlickrEvent.PHOTO_SEARCH_COMPLETE,handleInitialFlickrRequest);
			this.oFlickrLoader.loadSecurityFiles();

			this.oYouTubeLoader = new YouTubeLoader(YouTubeData.instance.youtube_api_key, YouTubeData.instance.youtube_user_id);
			this.oYouTubeLoader.addEventListener(YouTubeEvent.YOUTUBE_LOAD_COMPLETE, handleInitialYouTubeRequest);
			this.oYouTubeLoader.searchUserVideos(YouTubeData.instance.search_for);
			
			this.oFacebookService = new FacebookService(AppConfig.instance.facebook_app_id);
			this.oFacebookService.addEventListener(FacebookEvent.FACEBOOK_POST_COMPLETE, onFacebookPostComplete);
			
			this.oTwitterService = new TwitterService();
			this.oTwitterService.addEventListener(TwitterEvent.TWEET_COMPLETE, onTwitterPostComplete);						
			
			this.createWindowInstances();
			
			//TODO: Why is this timer being used???
			var oTimer:Timer = new Timer(100, 1);
			oTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleInitWaitComplete);
			oTimer.start();
		}
		
		//TODO: Why is this timer being used???
		private function handleInitWaitComplete(event:TimerEvent):void 
		{
			var oTimer:Timer = event.currentTarget as Timer;
			oTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleInitWaitComplete);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//Photo Search =======================================================================================
		private function handleFlickrInitComplete(event:Event):void 
		{
			//this.oFlickrLoader.removeEventListener(Event.COMPLETE,handleFlickrInitComplete);			
			
			if (this.oApplicationStateReloader.photo_id)
				instance.oFlickrLoader.photoSearchByID(this.oApplicationStateReloader.photo_id);
			
			/*var initialFlickrRequest:FlickrSearchVO = new FlickrSearchVO();
			initialFlickrRequest.perpage = 500;
			initialFlickrRequest.machine_tags.push('eyesonsyria:');			
			instance.oFlickrLoader.photoSearchByTag(initialFlickrRequest);
			*/
		}
		
		private function handleInitialFlickrRequest(event:FlickrEvent):void {
			this.oFlickrStore[(event.data as FlickrSearchVO).machine_tags.join(",")] = event.data;
			
			if (this.sCurrentTags == "" || (event.data as FlickrSearchVO).machine_tags.length == 0 || this.sCurrentTags == (event.data as FlickrSearchVO).machine_tags.join(",")) {
				FlickrData.instance.photos = event.data.photos;
				FlickrData.instance.updateDestinations();			
			
				this.dispatchEvent(new AppEvent(AppEvent.PHOTO_INITIALIZE_COMPLETE, false, false, null));
			}
		}
		
		private function onFacebookPostComplete(event:FacebookEvent):void {
			this.dispatchEvent(event);
		}
		
		private function onTwitterPostComplete(event:TwitterEvent):void {
			this.dispatchEvent(event);
		}
		
		//Video Search =======================================================================================
		private function handleInitialYouTubeRequest(event:YouTubeEvent):void  {	
			YouTubeData.instance.videos = new ArrayCollection(event.data as Array);
			YouTubeData.instance.updateDestinations();

			this.dispatchEvent(new AppEvent(AppEvent.VIDEO_INITIALIZE_COMPLETE, false, false, null));
		}
		
		//POP UP WINDOWS
		private var oPhotoPopup:PhotoPopup;
		private var oVideoPopup:VideoPopup;
		private function createWindowInstances():void  {
			this.oPhotoPopup = new PhotoPopup();
			this.oVideoPopup = new VideoPopup();
		}
		
		// CONSTRUCTOR =======================================================================================
		public function AppController() {
		}
		
		private function debug(message:*):void {			
		}
		
		// EVENT BUS==========================================================================================
		private static const instance:AppController = new AppController();		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void  {
			instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void  {
			instance.removeEventListener(type, listener, useCapture);
		}
	}
}