Effect.Combo = function(element) {
     element = $(element);
     if(element.style.display == 'none') { 
          new Effect.SlideDown(element, arguments[1] || {}); 
     } else { 
          new Effect.SlideUp(element, arguments[1] || {}); 
     }
 }

Effect.Unhide = function(element) {
	element = $(element);
	new Effect.SlideDown(element, arguments[1] || {});
}

Effect.Hide = function(element) {
	element = $(element);
	new Effect.SlideUp(element, arguments[1] || {});
}