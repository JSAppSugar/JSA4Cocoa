
var $engine = $engine || {};



(function(global){
	"use strict";

	$engine.lang = "oc";

	var _wrap_id = 0;
  var _wrap_pool = {};
  var f_objToJSWrap = function(obj){
    if (obj === undefined || obj === null) return obj;
    if(Array.isArray(obj)){
    	for(var i in obj){
    		obj[i] = f_objToJSWrap(obj[i]);
    	}
    }else{
    	var oid = null;
    	var wrapType = null;
    	var wrapObj = null;
    	if(obj instanceof Function){
    		oid = "f"+(++_wrap_id);
    		wrapType = "function";
    	}else if(obj instanceof jsa.Object){
    		if(obj.$this){
    			obj = obj.$this;
    		}else{
    			oid = "o"+(++_wrap_id);
    			wrapType = "object";
    		}
    	}
    	if(oid){
    		wrapObj = {};
    		wrapObj.$id = oid;
    		wrapObj.$type = wrapType;
    		_wrap_pool[oid] = obj;
    		obj = wrapObj;
    	}
    }
    return obj;
  };
  global.$js_retrieve = function(id){
    var o = _wrap_pool[id];
    delete _wrap_pool[id];
    return o;
  };

	$engine.$init = function(define){
		return (function(){
			var initMethod = "init";
			if(arguments.length > 0){
				for(var i in define){
					var method = define[i];
					if(method.match(/:/g).length == arguments.length){
						initMethod = method;
						break;
					}
				}
			}
			var args = arguments.length==1?[arguments[0]]:Array.apply(null,arguments);
			this.$this = $oc_new(this.constructor.$impl,initMethod,f_objToJSWrap(args));
		});
	};

	$engine.$function = function(define){
		var method = define;
		return (function(){
			var args = arguments.length==1?[arguments[0]]:Array.apply(null,arguments);
			return $oc_invoke(this.$this,method,f_objToJSWrap(args));
		});
	}

	$engine.$staticFunction = function(define){
		var method = define;
		return (function(){
			var className = this.$impl;
			var args = arguments.length==1?[arguments[0]]:Array.apply(null,arguments);
			return $oc_classInvoke(className,method,f_objToJSWrap(args));
		});
	}

	$engine.$import = function(classes){
		$oc_import(classes);
	}

}(this));


