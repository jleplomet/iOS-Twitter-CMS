<?php

class TwitterController extends BaseController {
  public function search ()
  {
    $results = Twitter::getSearch(array(
      'q' => Request::get('q'),
      'result_type' => 'recent',
      'since_id' => Request::get('since_id'),
      'count' => Request::get('count')
    ));

    return Response::json(array(
      'success' => 1,
      'results' => $results
    ), 200);
  }

  public function searchNextResults ()
  {
    $results = Twitter::getSearch(array(
      'max_id' => Request::get('max_id'),
      'q' => Request::get('q'),
      'count' => Request::get('count'),
      'include_entities' => Request::get('include_entities'),
      'result_type' => Request::get('result_type')
    ));

    return Response::json(array(
      'success' => 1, 
      'results' => $results
    ), 200);
  }

  public function searchRefreshResults ()
  {
    $results = Twitter::getSearch(array(
      'since_id' => Request::get('since_id'),
      'q' => Request::get('q'),
      'result_type' => 'recent',
      'include_entities' => Request::get('include_entities')
    ));

    return Response::json(array(
      'success' => 1,
      'results' => $results
    ), 200);
  }
}