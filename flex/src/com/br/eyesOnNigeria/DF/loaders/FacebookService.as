package com.br.eyesOnNigeria.DF.loaders
{
	
	import com.facebook.graph.Facebook;
	import com.media.facebook.FacebookPostInfo;
	import com.media.facebook.events.FacebookEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.controls.Alert;
	
	[Event(name="facebookPostComplete", type="com.media.facebook.events.FacebookEvent")]
	public class FacebookService extends EventDispatcher
	{
		/*
		*/
		
		
		private var logged_in:Boolean = false;
		private var _applicationId:String;
		private var lastPost:FacebookPostInfo;
		
		public function FacebookService(applicationId:String, target:IEventDispatcher=null)
		{
			super(target);
			this._applicationId = applicationId;
		}
		
		public function postToFacebook(facebookPostInfo:FacebookPostInfo):void 
		{
			this.lastPost = facebookPostInfo;
			
			if (!this.logged_in) 
			{				
				Facebook.init(this._applicationId, initHandler);
				Facebook.login(loginHandler, {scope:"publish_stream"});
			}
			
			else 
			{
				this.submitPost(facebookPostInfo);
			}				
		} 
		
		/**
		 * It looks like there is a bug in the Facebook swc.
		 *  
		 * @param success
		 * @param fail
		 * 
		 */		
		private function initHandler(success:Object,fail:Object):void {
			if(success){    
			} 
		}
		
		private function loginHandler(success:Object,fail:Object):void 
		{			
			if(success)
			{    
				this.logged_in = true;
				this.submitPost(this.lastPost);
			} 
		}
		
		private function submitPost(facebookPostInfo:FacebookPostInfo):void 
		{
			var obj:Object = new Object();			
			obj.message = facebookPostInfo.message;			
			obj.name = facebookPostInfo.title;
			obj.link = facebookPostInfo.link;
			obj.type ='link';
			obj.source = facebookPostInfo.source;
			
			Facebook.api("/me/feed",submitPostHandler, obj, "POST");		
		}
		
		private function submitPostHandler(result:Object,fail:Object):void 
		{
			this.dispatchEvent(new FacebookEvent(FacebookEvent.FACEBOOK_POST_COMPLETE));			
		}
	}
}