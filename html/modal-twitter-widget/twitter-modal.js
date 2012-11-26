// Load Twitter Widget
document.write('<script charset="utf-8" src="http://widgets.twimg.com/j/2/widget.js"><\/script>');


// Twitter Modal Function
(function($) {

	$.fn.makeModal = function(event) {
	
		$(this).parent().css({
			overflow: "hidden",
			position: "relative"
		});
		
		$(this).css({
			display: "block"
		});
		
		$(this).addClass("twitter-modal").wrapInner(
			$("<div>").addClass("tray-wrap").css("overflow", "hidden")
		).click(function(event) {
		
			if( $(event.target).is( this ) )
			{
				if( $(this).hasClass("retracted") )
				{
					var h = $(".tray-wrap", this).height() + 5;
					
					$(this).animate({
						height: h+"px",
						width: $(this).css("maxWidth")
					}, 500);
					
					$(".tray-wrap", this).animate({
						marginTop: "5px",
						opacity: 1
					});
				}
				else
				{
					if( $(this).css("maxWidth") == "none" )
					{
						$(this).css({
							maxWidth: $(this).width()+"px"
						});
						
						$(".tray-wrap", this).height()+"px";
					}
					
					$(this).animate({
						height: 0,
						width: "15px"
					}, 500);
					
					$(".tray-wrap", this).animate({
						opacity: 0
					});
				}
			
				$(this).toggleClass("retracted");
			}
		
		});
	
	};
	
})(jQuery);