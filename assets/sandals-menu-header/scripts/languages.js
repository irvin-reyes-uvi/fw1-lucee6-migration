/*$(document).ready(function(){
	$("a.clickLan").toggle(function() { 
		$("#lanBox").fadeIn(300);
		$(this).addClass("activeLan"); 
	},
	function() { 
		$("#lanBox").fadeOut(300);
		$(this).removeClass("activeLan"); 
	});
});*/



$(document).ready(function(){
	$("a.clickLan").click(function(){
		if ($("#lanBox").is(':hidden'))
			$("#lanBox").fadeIn(300),
			$(this).addClass("activeLan"); 
		else{
			$("#lanBox").fadeOut(300),
			$(this).removeClass("activeLan");
		}
		return false;
	});

	$('#lanBox').click(function(e) {
		e.stopPropagation();
	});
	$(document).click(function() {
		$('#lanBox').fadeOut(300);
		$("a.clickLan").removeClass("activeLan");
	});
});