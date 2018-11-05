
var $engine = $engine || {};



(function(){
	"use strict";

	$engine.lang = "oc";

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
			this.$this = $oc_new(this.constructor.$impl,initMethod,arguments);
		});
	};

	$engine.$function = function(define){
		var method = define;
		return (function(){
			return $oc_invoke(this.$this,method,arguments);
		});
	}

	$engine.$staticFunction = function(define){
		var method = define;
		return (function(){
			var className = this.$impl;
			return $oc_classInvoke(className,method,arguments);
		});
	}

	$engine.$import = function(classes){
		$oc_import(classes);
	}

}());


