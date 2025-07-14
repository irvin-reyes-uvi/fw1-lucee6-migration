var sandalsMenuLinkArrow = '<img src="/sandals-menu-header/images/menuLink-arrow.gif" width="5" height="7" />';
;(function($){
	$.fn.superfish = function(op){

		var sf = $.fn.superfish,
			c = sf.c,
			$arrow = $(['<span class="',c.arrowClass,'"> &#187;</span>'].join('')),
			over = function(){
				var $$ = $(this), menu = getMenu($$);
				clearTimeout(menu.sfTimer);
				$$.showSuperfishUl().siblings().hideSuperfishUl();
			},
			out = function(){
				var $$ = $(this), menu = getMenu($$), o = sf.op;
				clearTimeout(menu.sfTimer);
				menu.sfTimer=setTimeout(function(){
					o.retainPath=($.inArray($$[0],o.$path)>-1);
					$$.hideSuperfishUl();
					if (o.$path.length && $$.parents(['li.',o.hoverClass].join('')).length<1){over.call(o.$path);}
				},o.delay);	
			},
			getMenu = function($menu){
				var menu = $menu.parents(['ul.',c.menuClass,':first'].join(''))[0];
				sf.op = sf.o[menu.serial];
				return menu;
			},
			addArrow = function($a){ $a.addClass(c.anchorClass).append($arrow.clone()); };
			
		return this.each(function() {
			var s = this.serial = sf.o.length;
			var o = $.extend({},sf.defaults,op);
			o.$path = $('li.'+o.pathClass,this).slice(0,o.pathLevels).each(function(){
				$(this).addClass([o.hoverClass,c.bcClass].join(' '))
					.filter('li:has(ul)').removeClass(o.pathClass);
			});
			sf.o[s] = sf.op = o;
			
			$('li:has(ul)',this)[($.fn.hoverIntent && !o.disableHI) ? 'hoverIntent' : 'hover'](over,out).each(function() {
				if (o.autoArrows) addArrow( $('>a:first-child',this) );
			})
			.not('.'+c.bcClass)
				.hideSuperfishUl();
			
			var $a = $('a',this);
			$a.each(function(i){
				var $li = $a.eq(i).parents('li');
				$a.eq(i).focus(function(){over.call($li);}).blur(function(){out.call($li);});
			});
			o.onInit.call(this);
			
		}).each(function() {
			var menuClasses = [c.menuClass];
			if (sf.op.dropShadows  && !($.browser.msie && $.browser.version < 7)) menuClasses.push(c.shadowClass);
			$(this).addClass(menuClasses.join(' '));
		});
	};

	var sf = $.fn.superfish;
	sf.o = [];
	sf.op = {};
	sf.IE7fix = function(){
		var o = sf.op;
		if ($.browser.msie && $.browser.version > 6 && o.dropShadows && o.animation.opacity!=undefined)
			this.toggleClass(sf.c.shadowClass+'-off');
		};
	sf.c = {
		bcClass     : 'sf-breadcrumb',
		menuClass   : 'sf-js-enabled',
		anchorClass : 'sf-with-ul',
		arrowClass  : 'sf-sub-indicator',
		shadowClass : 'sf-shadow'
	};
	sf.defaults = {
		hoverClass	: 'sfHover',
		pathClass	: 'overideThisToUse',
		pathLevels	: 1,
		delay		: 800,
		animation	: {opacity:'show'},
		speed		: 'normal',
		autoArrows	: true,
		dropShadows : true,
		disableHI	: false,		// true disables hoverIntent detection
		onInit		: function(){}, // callback functions
		onBeforeShow: function(){},
		onShow		: function(){},
		onHide		: function(){}
	};
	$.fn.extend({
		hideSuperfishUl : function(){
			var o = sf.op,
				not = (o.retainPath===true) ? o.$path : '';
			o.retainPath = false;
			var $ul = $(['li.',o.hoverClass].join(''),this).add(this).not(not).removeClass(o.hoverClass)
					.find('>ul:not(.ignore)').hide().css('visibility','hidden');
			o.onHide.call($ul);
			return this;
		},
		showSuperfishUl : function(){
			var o = sf.op,
				sh = sf.c.shadowClass+'-off',
				$ul = this.addClass(o.hoverClass)
					.find('>ul:hidden').css('visibility','visible');
			
			sf.IE7fix.call($ul);
			o.onBeforeShow.call($ul);
			$ul.animate(o.animation,o.speed,function(){ sf.IE7fix.call($ul); o.onShow.call($ul); });
			return this;
		}
	});
	
	runMainMenu();

})(jQuery);


function runMainMenu(){
	IE7 = (navigator.appVersion.indexOf("MSIE 7.")==-1) ? false : true;
	$("a.mmLink").hover(
		function(){
			var mmID = $(this).attr('id').substr(0,3);
			mmTimer = setTimeout(function(){mmOver(mmID); mmID = null},300);
		},
		function(){
			clearTimeout(mmTimer);
		}
	);
	if(mmOverID != null){
		mmOver(mmOverID);	
	}
}


function mmOver(mm_id){
	//$('#mmHolder').scrollTo($('#mmResortHolder'),800,{ easing:'easeOutExpo' });
	//$('#mmDefault').fadeOut(1500, function(){$('#mmResortHolder').fadeIn(1500);});
	//$('#mmResortHolder').scrollTop()
	
	if(IE7){
		$('#mmDefault').animate({'margin-top':'-187px'});
	} else {
		$('#mmDefault').animate({'margin-top':'-167px'});
	}
	
	var mmPosition = $('.mmResort').index($('#mm_'+mm_id));
	var mmMoveTo = mmPosition * 177;
	mmMoveTo = IE7 ? mmMoveTo + 20 : mmMoveTo;
	mmMoveTo = mmMoveTo > 0 ? '-'+mmMoveTo+'px' : mmMoveTo+'px';
	
	$('#mmResortHolder .mmResort:first').animate({'margin-top':mmMoveTo},800,'easeOutExpo');
	//$('#mmResortHolder').css({'marginTop':mmMoveTo });
	//$('#mmResortHolder').);  (mmMoveTo);
	
	var mmResortPath = $('#mm_'+mm_id).attr('rel');
	$('#mmSubNav a').eq(0).attr('href',mmResortPath+'-home.cfm');
	$('#mmSubNav a').eq(1).attr('href',mmResortPath+'-accommodations.cfm');
	$('#mmSubNav a').eq(2).attr('href',mmResortPath+'-dining.cfm');
	$('#mmSubNav a').eq(3).attr('href',mmResortPath+'-activities.cfm');
	$('#mmSubNav a').eq(4).attr('href',mmResortPath+'-tours.cfm');
	$('#mmSubNav a').eq(5).attr('href',mmResortPath+'-specials.cfm');
	$('#mmSubNav a').eq(6).attr('href',mmResortPath+'-media.cfm');
	//$('#mmResortHolder').stop().scrollTo($('#mm_'+mm_id),800,{easing:'easeOutExpo'});
}

$(document).ready(function(){
	// Main Menu
	$("ul.sf-menu").supersubs({ 
		minWidth:    12,
		maxWidth:    40,
		extraWidth:  1
	}).superfish({
		autoArrows:  false	
	});
});