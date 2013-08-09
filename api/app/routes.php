<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the Closure to execute when that URI is requested.
|
*/

Route::get('/', array('before' => 'auth.basic', function()
{
	$authToken = AuthToken::create(Auth::user());
  $publicToken = AuthToken::publicToken($authToken);

  return Response::json( array('user_auth_token' => $publicToken, 'user' => Auth::user()->toArray()) );
}));

Route::group( array('prefix' => 'api/v1'/*, 'before' => 'auth.token'*/), function() {
  Route::get('search', 'TwitterController@search');
  Route::get('search/next', 'TwitterController@searchNextResults');
  Route::get('search/refresh', 'TwitterController@searchRefreshResults');

  Route::post('cms/approve', 'TwitterCMSController@approve');
});

App::error(function( AuthTokenNotAuthorizedException $exception ) {
  return Response::json(array('error'=> $exception->getMessage()), $exception->getCode());
});