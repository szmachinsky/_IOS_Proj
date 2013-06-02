<?php

class Error {

	function __construct($error, $errcode = 0) {
		Log::error($error);
		exit ( 2 );
	}

}