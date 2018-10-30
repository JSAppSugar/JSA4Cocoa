
var $engine = $engine || {};



(function(){
	"use strict";

	$engine.lang = "oc";

	$engine.$init = function(){
		this.$this = $oc_new(this.constructor.$impl,"init",[]);
	};

	$engine.$function = function(define){
		return (function(){
		});
	}

	$engine.$import = function(classes){
		$oc_import(classes);
	}

}());


