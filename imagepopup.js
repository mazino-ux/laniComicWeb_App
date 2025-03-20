function em_to_px(input, obj) {
    if (!obj || obj.length === 0) {
        obj = jQuery("body");
    }
    var emSize = parseFloat(obj.css("font-size"));
    return (emSize * input);
}

function px_to_em(input, obj) {
    if (!obj || obj.length === 0) {
        obj = jQuery("body");
    }
    var emSize = parseFloat(obj.css("font-size"));
    return (input / emSize);
}

function getOffset( el ) {
    var _x = 0;
    var _y = 0;
    while( el && !isNaN( el.offsetLeft ) && !isNaN( el.offsetTop ) ) {
        _x += el.offsetLeft - el.scrollLeft;
        _y += el.offsetTop - el.scrollTop;
        el = el.offsetParent;
    }
    return {top: _y, left: _x};
}

function hideimg() {
    var img = document.getElementById('preview_img');
    img.src = '';
    img.parentNode.style.display = 'none';
}
function showimg(width,height,file) {
    var img = document.getElementById('preview_img');
    img.src = file;
    if (width > 0) {
        img.width = width;
    }
    if (height > 0) {
        img.height = height;
    }
    img.parentNode.style.display = 'inline-block';
}
function hover(pre,elemid) {
    if (pre == 'set') {
        var title = document.getElementById('setname'+elemid);
        title.classList.add('glow');
    }
    var elem = document.getElementById(pre+elemid);
    elem.style.visibility = 'visible';
}
function hoveroff(pre,elemid) {
    if (pre == 'set') {
        var title = document.getElementById('setname'+elemid);
        title.classList.remove('glow');
    }
    var elem = document.getElementById(pre+elemid);
    elem.style.visibility = 'hidden';
}
function toggleIndex(e) {
    var elem = document.getElementById('idxlist');
    var clr = false;
    if (!elem) {
        elem = document.getElementById('idxlistfixed');
        clr = true;
    }
    var title = document.getElementById('idx');
    if (elem.style.display == 'none') {
        elem.style.display = 'block';
        if (clr) { title.style.color = 'yellow'; }
        else { title.innerHTML = "&#x25BC; Index:"; }
    }
    else {
        elem.style.display = 'none';
        if (clr) { title.style.color = 'white'; }
        else { title.innerHTML = "&#x25B6; Index:"; }
    }
    e = e || window.event;
    e.stopPropagation();
}
function toggleVisibility(elemid) {
    var e = document.getElementById('allsets'+elemid);
    var etitle = document.getElementById('setname'+elemid);
    if (e.style.display == 'none' || e.style.display == '') {
        e.style.display = 'block';
        etitle.style.border = '1px solid black';
        etitle.style.padding = '0.1em 0.4em 0.1em';
        etitle.style.backgroundColor = 'lightgrey';
        //etitle.style.marginTop = "0.5em";
        //etitle.style.borderTopWidth = "1px";
        //etitle.style.borderTopStyle = "solid";
    }
    else {
        e.style.display = 'none';
        //etitle.style.marginTop = "0.5em";
        etitle.style.borderStyle = "none";
        etitle.style.padding = '0em';
        etitle.style.backgroundColor = 'inherit';
    }
}
function toggleListVisibility(elemid) {
    var e = document.getElementById(elemid);
    var arrow = document.getElementById('arrow'+elemid);
    if (e.style.display == 'none' || e.style.display == '') {
        e.style.display = 'block';
        arrow.innerHTML = "&#9660; ";
    }
    else {
        e.style.display = 'none';
        arrow.innerHTML = "&#9654; ";
    }
}
function slideToggleVisibility(elemid) {
    if ('ontouchstart' in document.documentElement) {
        var elem = document.getElementById(elemid);
        if (elem.style.display != 'block') {
            elem.style.display = 'block';
        }
        else {
            elem.style.display = 'none';
        }
    }
    else {
        $('#'+elemid).slideToggle();
    }
}

function adjustWidth( elem, startWidth, stopWidth, delay, after ) {
    if (startWidth == stopWidth) return;
    var steps = Math.round(Math.abs(stopWidth - startWidth) / 2);
    var grow  = startWidth < stopWidth;

    function adjust(step){
        var w = Math.PI/2 * step / steps;
        if (grow) w = Math.PI/2 - w;
        var wid = Math.cos(w) * ((grow) ? stopWidth : startWidth);
        elem.width = wid;
        if (step < steps) {
            setTimeout( function(){adjust(step+1);}, delay * Math.sin(w) );
        }
        else after();
    }
    adjust(1);
}

//Additional arguments must be passed to this function which are the
//image files under the rootpath to cycle through.
//The first image argument should be the second image in the cycle.
function cycleImg(elemid,flip,rootpath) {
    if (arguments.length <= 4) return;
    var img = document.getElementById(elemid);
    var which = Number(img.getAttribute('imgshown'));
    if (which == 0 || which >= arguments.length - 1) {
        which = 3;
    }
    else {
        which++;
    }
    var nextimg = rootpath + arguments[which];
    if (flip) {
        adjustWidth( img, 130, 0, 20, function(){
            img.src = nextimg;
            adjustWidth( img, 0, 130, 20, function(){
                img.setAttribute('imgshown',which);
            });
        });
    }
    else {
        img.src = nextimg;
        img.setAttribute('imgshown',which);
    }
}

function toggleCheck(elemid) {
    var elem = document.getElementById(elemid);
    var txt = elem.textContent.trim();
    if (txt.charCodeAt(0) == 9744) {
        txt = String.fromCharCode(10148); //(9787);
        elem.style.color = "orange";
        toggleCheck.smiles++;
    }
    else {
        txt = String.fromCharCode(9744);
        elem.style.color = "black";
        toggleCheck.smiles--;
    }
    elem.textContent = txt + ' ';
}
toggleCheck.smiles = 0;

function expandComicInfo(obj, toffset, rows, top, height, inc){
    obj.css({"top": (top+toffset)+"em", "height": height+"em"});
    if (height < rows) {
        setTimeout(function() {expandComicInfo(obj, toffset, rows, top-inc, height+inc, inc);}, 0);
    }
}
function shrinkComicInfo(obj, toffset, top, height, inc){
    obj.css({"top": (top+toffset)+"em", "height": height+"em"});
    if (height > 1) {
        setTimeout(function() {shrinkComicInfo(obj, toffset, top+inc, height-inc, inc);}, 0);
    }
    else {
        obj.hide();
    }
}
function toggleComicInfo(e) {
    e.stopPropagation();
    var full = jQuery(this).parent();
    if (e.altKey) {
        full = full.parent();
    }
    full.find(".fullinfo").each( function(){
        f  = jQuery(this);
        var topOffset = px_to_em( f.parent().offset().top - 7, f );
        var rows = f.children("div").length;
        rows += (rows - 2) * 0.1; // add a bit extra
        if (f.is(":hidden")) {
            toggleComicInfo.numVisible += 1;
            f.show();
            expandComicInfo( f, topOffset, rows+1, 18, 1, (rows > 2) ? 0.2 : 0.05);
        }
        else {
            shrinkComicInfo( f, topOffset, 18-rows, rows+1, (rows > 2) ? 0.2 : 0.05 );
            toggleComicInfo.numVisible -= 1;
        }
    } );
}
toggleComicInfo.numVisible = 0;

function indexOfMax(arr) {
    if (arr.length === 0) {
        return -1;
    }

    var max = arr[0];
    var maxIndex = 0;

    for (var i = 1; i < arr.length; i++) {
        if (arr[i] > max) {
            maxIndex = i;
            max = arr[i];
        }
    }
    return maxIndex;
}

function handleIndexResize() {
	var view_height = jQuery(window).height() - jQuery("#static-header").height() - 40; //40 for offset and padding
	view_height = 100 * view_height / jQuery(window).height();
	jQuery("#idxlist").height( view_height + "vh" );
	jQuery("#theindex").css( "height", "calc(" + view_height + "vh - 80px)" ); //80 for home button

	var elems = jQuery(".indextitle");
	view_height = jQuery("#theindex").height() - elems.length * elems.height() - jQuery("#buttons").height();

	elems = jQuery(".indexgroup");
	var h = [];
	var mx = 0;
	for (var i=0; i<elems.length; i++) {
		if (jQuery(elems[i]).css("display") != "none") {
			jQuery(elems[i]).css("max-height", parseInt(jQuery(elems[i]).attr("origHeight")) + "px");
			h.push( true );
			mx += 1;
			view_height -= 4; //for bold border
		} else {
			h.push( false );
		}
	}
	if (mx > 1) {
		var found = true;
		while (found) {
			found = false;
			for (var i=0; i<elems.length; i++) {
				if (h[i] && jQuery(elems[i]).height() < view_height / mx) {
					mx -= 1;
					h[i] = false;
					view_height -= jQuery(elems[i]).height();
					found = true;
				}
			}
		}
	}
	if (mx > 0) elems.each( function () {jQuery(this).css("max-height", (view_height / mx) + "px")} );
}

function handleComicResize() {
    if (toggleComicInfo.numVisible > 0) {
        jQuery(".fullinfo").hide();
        toggleComicInfo.numVisible = 0;
    }
	handleIndexResize();
}

function revealCovers(evt) {
    var elem = jQuery(evt.target);
    if (elem.length === 0) return;
    while (elem[0].nodeName != "DIV") {
        elem = elem.parent();
    }
    elem.css("cursor", "default");
    elem = elem.next();
    if (!elem.is(".issue-wrapper")) {
        elem = elem.css("display", "block").next(".issue-wrapper");
    }
    elem.children(".img")
        .each(function() {
            jQuery(this)
                .children("img")
                .each(function() {
                    jQuery(this).attr("src", jQuery(this).attr("data-src"));
                });
            })
        .css("display", "block");
}

function toggleComicIndex(elem) {
	elem.toggleClass("indextitlesel").next().slideToggle('fast', function() {handleIndexResize();});
}

function comicsInit(xmlFile, stylesheet) {
    jQuery.lazyLoadXT.autoInit = false;

//    var var_massif = location.search.substring(1); // gets the string and removes the `?`
    var d     = new Date();
    var day   = d.getDate();
    var month = d.getMonth() + 1;
    if (day <= 9) day = "0" + day;
    if (month <= 9) month = "0" + month;

    var body  = jQuery("body")[0]; // gets the body element where the result will be inserted

//    if (var_massif) {
        var processor = new XSLTProcessor();  // starts the XSL processor
        processor.setParameter(null, "today", "" + d.getFullYear() + month + day);

        var source;

        var xslReq = jQuery.get(stylesheet, function (data) { // loads the stylesheet
            processor.importStylesheet(data);
        });
        var xmlReq = jQuery.get(xmlFile, function (data) { // loads the xml
            source = data;
        });

        jQuery.when(xslReq, xmlReq).done(function () { // waits both to load
            var result = processor.transformToDocument(source);  // transforms document
            body.appendChild(result.documentElement); // adds result as child of body element


            jQuery("div.comicinfo").on( "click", toggleComicInfo );
            jQuery(window).resize( handleComicResize );

            // hover effects
            jQuery("div.group").mouseenter(function() {
                jQuery(this).stop(true,true).animate({backgroundColor:'#222'}, 'fast');
            }).mouseleave(function() {
                jQuery(this).animate({backgroundColor:'#555'}, 'slow');
            });

            jQuery(".comicinfo").mouseenter(function() {
                jQuery(this).stop(true,true).animate({"border-color": "gold"}, 'fast');
            }).mouseleave(function() {
                jQuery(this).animate({"border-color": "black"}, 'slow');
            });

            jQuery("div.cancel img").mouseenter(function() {
                jQuery(this).stop(true,true).animate({"opacity": 1}, 'fast');
            }).mouseleave(function() {
                jQuery(this).animate({"opacity": 0.3}, 'fast');
            });

            jQuery("div.img").mouseenter(function() {
                jQuery(this).children("anni40badge").hide();
                jQuery(this).children("giconbadge").hide();
                jQuery(this).children("grmtbadge").hide();
            }).mouseleave(function() {
                jQuery(this).children("anni40badge").show();
                jQuery(this).children("giconbadge").show();
                jQuery(this).children("grmtbadge").show();
            });

            jQuery("#hidehave").on( "mouseup", function() {
                jQuery(".comic.ownit").add(".comic.noneed").add(".comic.cancel").css("display", "none");
                jQuery(".comic.ownit").parent().parent().find(".title90").parent().css("display", "none");
                jQuery(".comic:not(.ownit)").not(".comic.noneed").not(".comic.cancel").css("display", "block");
                //scroll the window to load newly visible images
                jQuery(window).scrollTop(jQuery(window).scrollTop() + 1);
                jQuery(".issueheader").css("cursor", "pointer");
                jQuery("#showall").removeAttr("disabled");
            });

            jQuery("#showall").on( "mouseup", function() {
                jQuery(".comic:not(.need)").css("display", "block");
                jQuery(".comic:not(.need)").parent().parent().find(".title90").parent().css("display", "block");
                //scroll the window to load newly visible images
                jQuery(window).scrollTop(jQuery(window).scrollTop() + 1);
                jQuery("#showall").attr("disabled", "disabled");
                jQuery(".issueheader").css("cursor", "default");
            });

            jQuery("#byrelease").on( "mouseup", function() {
				function sort_by_date(a, b) {
					return (jQuery(b).attr('datestamp')) > (jQuery(a).attr('datestamp')) ? 1 : -1;
				}
				jQuery("div[datestamp]").sort(sort_by_date).prependTo("#comic-content");
				jQuery("#comic-content").css("padding-top", "60px");
				jQuery("#comic-table tr").remove();
            });

            jQuery("#actionfig").on( "mouseup", function() {
                jQuery(".comic[af='Y']").css("display", "block");
                jQuery(".group").not(":has('.comic[af=\"Y\"]')").css("display", "none");
                jQuery(".comic[af!='Y']").css("display", "none");
                jQuery("tr").not(":has('.comic[af=\"Y\"]')").css("display", "none");
                //scroll the window to load newly visible images
                jQuery(window).scrollTop(jQuery(window).scrollTop() + 1);
                jQuery(".issueheader").css("cursor", "pointer");
            });

            jQuery("#twentyfifth").on( "mouseup", function() {
                jQuery(".comic[TPM25='Y']").css("display", "block");
                jQuery(".group").not(":has('.comic[TPM25=\"Y\"]')").css("display", "none");
                jQuery(".comic[TPM25!='Y']").css("display", "none");
                jQuery("tr").not(":has('.comic[TPM25=\"Y\"]')").css("display", "none");
                //scroll the window to load newly visible images
                jQuery(window).scrollTop(jQuery(window).scrollTop() + 1);
                jQuery(".issueheader").css("cursor", "pointer");
            });

            jQuery("#fortieth").on( "mouseup", function() {
                jQuery(".comic").has("anni40badge").css("display", "block");
                jQuery(".group").not(":has('anni40badge')").css("display", "none");
                jQuery(".comic").not(":has('anni40badge')").css("display", "none");
                jQuery("tr").not(":has('anni40badge')").css("display", "none");
                //scroll the window to load newly visible images
                jQuery(window).scrollTop(jQuery(window).scrollTop() + 1);
                jQuery(".issueheader").css("cursor", "pointer");
            });

            jQuery("#fiftieth").on( "mouseup", function() {
                jQuery(".comic[LFL50='Y']").css("display", "block");
                jQuery(".group").not(":has('.comic[LFL50=\"Y\"]')").css("display", "none");
                jQuery(".comic[LFL50!='Y']").css("display", "none");
                jQuery("tr").not(":has('.comic[LFL50=\"Y\"]')").css("display", "none");
                //scroll the window to load newly visible images
                jQuery(window).scrollTop(jQuery(window).scrollTop() + 1);
                jQuery(".issueheader").css("cursor", "pointer");
            });

            jQuery("#choosedestiny").on( "mouseup", function() {
                jQuery(".comic[CYD='Y']").css("display", "block");
                jQuery(".group").not(":has('.comic[CYD=\"Y\"]')").css("display", "none");
                jQuery(".comic[CYD!='Y']").css("display", "none");
                jQuery("tr").not(":has('.comic[CYD=\"Y\"]')").css("display", "none");
                //scroll the window to load newly visible images
                jQuery(window).scrollTop(jQuery(window).scrollTop() + 1);
                jQuery(".issueheader").css("cursor", "pointer");
            });

            jQuery("#galacticicon").on( "mouseup", function() {
                jQuery(".comic").has("giconbadge").css("display", "block");
                jQuery(".group").not(":has('giconbadge')").css("display", "none");
                jQuery(".comic").not(":has('giconbadge')").css("display", "none");
                jQuery("tr").not(":has('giconbadge')").css("display", "none");
                //scroll the window to load newly visible images
                jQuery(window).scrollTop(jQuery(window).scrollTop() + 1);
                jQuery(".issueheader").css("cursor", "pointer");
            });

            jQuery("#greatestmoments").on( "mouseup", function() {
                jQuery(".comic").has("grmtbadge").css("display", "block");
                jQuery(".group").not(":has('grmtbadge')").css("display", "none");
                jQuery(".comic").not(":has('grmtbadge')").css("display", "none");
                jQuery("tr").not(":has('grmtbadge')").css("display", "none");
                //scroll the window to load newly visible images
                jQuery(window).scrollTop(jQuery(window).scrollTop() + 1);
                jQuery(".issueheader").css("cursor", "pointer");
            });

            jQuery(".artistname").on( "mouseup", function() {
                //reset
                jQuery(".comic").css("display", "block");
                jQuery(".group").css("display", "inline-block");
                jQuery("tr").css("display", "table-row");
                jQuery(".group").attr("counter",0);
                jQuery("tr").attr("counter",0);

                var aname = jQuery(this).text();
                var pos = aname.indexOf("(");
                if (pos >= 0) {
                    aname = aname.substr(0, pos - 1);
                }
                jQuery(".comic").not('[artist="' + aname + '"]').css("display", "none");
                jQuery('.comic[artist="' + aname + '"]').each(function() {
                    var $me = $(this).parent().parent();
                    var count = $me.attr("counter");
                    $me.attr("counter", parseInt(count) + 1);
                  });
                jQuery(".group[counter='0']").css("display", "none");
                jQuery(".group[counter!='0']").each(function() {
                    var $me = $(this).parent().parent().parent(); //want tr
                    var count = $me.attr("counter");
                    $me.attr("counter", parseInt(count) + 1);
                  });
                jQuery("tr[counter='0']").css("display", "none");
            });

            jQuery(".exclname").on( "mouseup", function() {
                //reset
                jQuery(".comic").css("display", "block");
                jQuery(".group").css("display", "inline-block");
                jQuery("tr").css("display", "table-row");
                jQuery(".group").attr("counter",0);
                jQuery("tr").attr("counter",0);

                var ename = jQuery(this).text();
                jQuery(".comic").not('[excl="' + ename + '"]').css("display", "none");
                jQuery('.comic[excl="' + ename + '"]').each(function() {
                    var $me = $(this).parent().parent();
                    var count = $me.attr("counter");
                    $me.attr("counter", parseInt(count) + 1);
                  });
                jQuery(".group[counter='0']").css("display", "none");
                jQuery(".group[counter!='0']").each(function() {
                    var $me = $(this).parent().parent().parent(); //want tr
                    var count = $me.attr("counter");
                    $me.attr("counter", parseInt(count) + 1);
                  });
                jQuery("tr[counter='0']").css("display", "none");
            });

			//temporarily draw all divs so we can find the maximum width
			var elems = jQuery("div.indexgroup");
			var h = [];
			for (var i=0; i<elems.length; i++) {
				if (jQuery(elems[i]).css("display") == "none") {
					h.push( i );
					jQuery(elems[i]).css("display", "block");
				}
			}
			var wid = jQuery("div.indexgroup span.comictitle").map(function() {return jQuery(this).width();}).get();
			for (var i=0; i<h.length; i++)
				jQuery(elems[h[i]]).css("display", "none");

			var max = 0;
			for (var i = 0; i < wid.length; i++) if (wid[i] > max) max = wid[i];
			jQuery("#idxlist").width((max + 45) + "px");  //padding and room for scrollbar
			jQuery("#comic-content").css("margin-left", (max + 70) + "px");  //padding and room for scrollbar

            jQuery("#hidehave").removeAttr("disabled");
            jQuery("#showall").removeAttr("disabled");
            jQuery("#fortieth").removeAttr("disabled");
            jQuery("#galacticicon").removeAttr("disabled");

            //click on the issue header to reveal hidden covers
            jQuery(".issueheader").on( "click", revealCovers );

            //click the index header to show/hide the comic list
            jQuery(".indextitle").on( "click", function(evt) {
				toggleComicIndex( jQuery(evt.target) );
            });
            jQuery(".indextitle > img").on( "click", function(evt) {
				toggleComicIndex( jQuery(evt.target).parent() );
				evt.stopPropagation();
            });

            //store the default menu heights
            jQuery(".indexgroup").each(function() {jQuery(this).attr("origHeight", jQuery(this).height())});

			//set the bottom jump scripts
			jQuery(".bottomJump").on("mouseup", function() {
				document.getElementById(this.getAttribute("destination")).scrollIntoView({behavior: "smooth", block: "end", inline: "nearest"});
			});

			handleComicResize();
            jQuery(window).lazyLoadXT();
        });

//    } else {
//        body.html("<h1>Missing query string</h1>"); // in case there is no query string
//    }
}
