function eWorld_AddEvent(target, eventName, method) { 
   if (target.addEventListener) { 
      target.addEventListener(eventName, method, false);
   } else if (target.attachEvent) { 
      target.attachEvent("on" + eventName, method);
   }
}

function eWorld_RemoveEvent(target, eventName, method) {
   if (target.removeEventListener) {
      target.removeEventListener(eventName, method, false);
   } else if (target.detachEvent) {
      target.detachEvent('on' + eventName, method);
   }
}

function eWorld_FindItem(array, id) {
   if (typeof array == "undefined" || array == null) {
      return null;
   }
   for (var i=0; i<array.length; i++) {
      if (array[i].Id == id) {
         return array[i];
      }
   }
}

function eWorld_FindPosition(element) {
   var result = new Object();
    result.x = 0;
    result.y = 0;
    result.width = 0;
    result.height = 0;
    if (element.offsetParent) {
        result.x = element.offsetLeft;
        result.y = element.offsetTop;
        var parent = element.offsetParent;
        while (parent) {
            var parentTagName = parent.tagName.toLowerCase();
            if ((parent.style.position == null || parent.style.position == '') && 
                ((parent.style.top != null || parent.style.top != '') ||
                (parent.style.left != null || parent.style.left != ''))) {
               result.x += parent.offsetLeft;
               result.y += parent.offsetTop;
               if (navigator.appName == 'Microsoft Internet Explorer' && parentTagName == 'div' && parent.scrollLeft != null && parent.scrollTop != null) {
                  result.x -= parent.scrollLeft;
                  result.y -= parent.scrollTop;
               }
            }
            if (parentTagName != "table" &&
                parentTagName != "body" && 
                parentTagName != "html" && 
                parentTagName != "div" && 
                parent.clientTop && 
                parent.clientLeft) {
                result.x += parent.clientLeft;
                result.y += parent.clientTop;
            }
            parent = parent.offsetParent;
        }
    }
    else if (element.left && element.top) {
        result.x = element.left;
        result.y = element.top;
    }
    else {
        if (element.x) {
            result.x = element.x;
        }
        if (element.y) {
            result.y = element.y;
        }
    }
    if (element.offsetWidth && element.offsetHeight) {
        result.width = element.offsetWidth;
        result.height = element.offsetHeight;
    }
    else if (element.style && element.style.pixelWidth && element.style.pixelHeight) {
        result.width = element.style.pixelWidth;
        result.height = element.style.pixelHeight;
    }
    return result;
}

function eWorld_ReplaceFormat(input, params) {
   var output = input;
   for (var i=0; i<params.length; i++) {
      eval('var rx=/\\{' + i + '\\}/');
      while (output.match(rx)) {
         output = output.replace(rx, params[i]);
      }
   }
   return output;
}

function eWorld_ValidateControl(control) {
   if (typeof ValidatorValidate == 'undefined' || typeof ValidatorUpdateIsValid == 'undefined') return;
   
   Page_InvalidControlToBeFocused = null;
   var vals;
   if (typeof control.Validators != "undefined") {
      vals = control.Validators;
   }
   else {
      if (control.tagName.toLowerCase() == "label") {
         control = document.getElementById(control.htmlFor);
         vals = control.Validators;
      }
   }
   if (typeof vals != 'undefined' && vals != null) {
      var i;
      for (i = 0; i < vals.length; i++) {
         ValidatorValidate(vals[i], null, null);
      }
      ValidatorUpdateIsValid();
   }
}

function eWorld_Trim(input) {
   input = input.replace(/^\s+(\d*)\s*$/, '$1');
   input = input.replace(/^(\d*)\s+$/, '$1');
   return input;
}
