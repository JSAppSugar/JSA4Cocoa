
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
		return (function(){
			return $oc_invoke(this.$this,define,arguments);
		});
	}

	$engine.$import = function(classes){
		$oc_import(classes);
	}

}());


