
var $engine = $engine || {};



(function(){
	"use strict";

	$engine.lang = "oc";

	$engine.$init = function(define){
		return (function(){
			this.$this = $oc_new(this.constructor.$impl,define?define:"init",[]);
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


