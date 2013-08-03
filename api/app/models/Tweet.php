<?php

class Tweet extends Eloquent {
  protected $table = 'tweets';
  
	protected $guarded = array();

	public static $rules = array();
}