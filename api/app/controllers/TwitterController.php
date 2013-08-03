<?php

class TwitterController extends BaseController {
  public function search ()
  {
    $results = Twitter::getSearch(array(
      'q' => Request::get('q'),
      'result_type' => 'recent',
      'count' => Request::get('count')
    ));

    return Response::json(array(
      'success' => 1,
      $results
    ), 200);
  }
}