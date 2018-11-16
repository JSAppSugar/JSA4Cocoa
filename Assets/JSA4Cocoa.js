
var $engine = $engine || {};



(function(global){
	"use strict";

	$engine.lang = "oc";
  global.$oc = true;

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
    	if((typeof obj) === "function"){
    		oid = "f"+(++_wrap_id);
    		wrapType = "function";
    	}else if(obj instanceof jsa.Object){
    		if(obj.$this){
    			obj = obj.$this;
    		}else{
    			oid = "o"+(++_wrap_id);
    			wrapType = "object";
    		}
    	}else if(obj instanceof Object && obj.constructor == Object){
        for(var k in obj){
          obj[k] = f_objToJSWrap(obj[k]);
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
  global.$js_function_apply = function($this,$function,$arguments){
  	if(!$this) $this = global;
  	return $function.apply($this,$arguments);
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
	};

	$engine.$staticFunction = function(define){
		var method = define;
		return (function(){
			var className = this.$impl;
			var args = arguments.length==1?[arguments[0]]:Array.apply(null,arguments);
			return $oc_classInvoke(className,method,f_objToJSWrap(args));
		});
	};

	$engine.$import = function(){
		$oc_import(arguments);
	};

  $engine.weakObject = function(){
    var weakObject = new jsa.Object();
    if(this.$this){
      weakObject.$weakThis = $oc_new("NSObject","init",[]);
      weakObject.$class = this.constructor;
      $oc_save_weak(weakObject.$weakThis,this.$this);
    }else{
      weakObject.$this = this;
      weakObject.$weakThis = this;
    }
    return weakObject;
  };
  $engine.isWeak = function(){
    return this.$weakThis?true:false;
  };
  $engine.self = function(){
    if(this.$weakThis){
      var realThis = $oc_get_weak(this.$weakThis);
      if(realThis && this.isWeak()){
        return this.$class.fromNative(realThis);
      }
      return null;
    }else{
      return this;
    }
  };
  $engine.invoke = function(){
    var method = arguments[0];
    var args = arguments.length<2?[]:Array.prototype.slice.call(arguments,1);
    return $oc_invoke(this.$this,method,f_objToJSWrap(args));
  };

  global.$new = function(){
    var className = arguments[0];
    var initMethod = arguments[1];
    var args = arguments.length<3?[]:Array.prototype.slice.call(arguments,2);
    var nativeObj = $oc_new(className,initMethod,f_objToJSWrap(args));
    return new jsa.NativeObject(nativeObj);
  }

}(this));

var console = console || {};
console.log = function(s){
  $log(s);
}

