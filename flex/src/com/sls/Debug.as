package com.sls
{
	import mx.controls.Alert;
	import mx.rpc.Fault;
	
	public class Debug
	{
		//this function is global so that error handling is consistant whether it is using alerts or whatever.
		public static function handleLoadError(oFault:Fault, sErrorContext:String):void {
			var sMessage:String = oFault.faultString;
			if (oFault.faultDetail) {
				if (sMessage.length > 0) {
					sMessage += " (" + oFault.faultDetail + ")";
				} else {
					sMessage = oFault.faultDetail;
				}
			}
			trace(">>>>>>>>>> ERROR >>>>>>>>>> " + sMessage);
			Alert.show(sMessage, sErrorContext);
		}
		
		public static function handleError(sMessage:String, sErrorContext:String):void {
			trace(">>>>>>>>>> ERROR >>>>>>>>>> " + sMessage);
			Alert.show(sMessage, sErrorContext);
		}				
	}
}