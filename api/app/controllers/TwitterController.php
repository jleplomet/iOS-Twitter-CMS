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
      'results' => $results
    ), 200);
  }

  public function refresh ()
  {

    $results = Twitter::getSearch(array(
      'q' => Request::get('q'),
      'result_type' => Request::get('result_type'),
      'since_id' => Request::get('since_id'),
      'include_entities' => Request::get('include_entities'),
      'count' => 10
    ));

    return Response::json(array(
      'success' => 1, 
      'results' => $results
    ), 200);
  }
}