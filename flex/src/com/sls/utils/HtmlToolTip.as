package com.sls.utils
{
    import mx.controls.ToolTip;
    import mx.styles.StyleManager;

    public class HtmlToolTip extends ToolTip
    {
    	private function ToolTip():void {
    		this.alpha = 0.7;    		    		   		    		
    	}
        override protected function commitProperties():void
        {
            super.commitProperties();   			
   			this.setStyle("backgroundColor", "0xd0d0a0");
   			this.setStyle("borderColor", "0x000000");
            textField.htmlText = text;                        
        }        
    }
}