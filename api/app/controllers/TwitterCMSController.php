<?php

class TwitterCMSController extends BaseController {
  public function approve () {
    $tweet = new Tweet;
    $tweet->tweetId = Request::get('tweetId');
    $tweet->user = Request::get('user');
    $tweet->text = Request::get('text');
    $tweet->avatar = Request::get('avatar');
    $tweet->status = 'approved';
    $tweet->tweetCreatedAt = Request::get('created_at');

    $tweet->save();

    if($tweet->id) {
      $approved_tweet_id = $tweet->id;

      return Response::json(array('success' => 1, 'approvedTweetId' => $approved_tweet_id), 201);
    } else {
      $errors = $tweet->getErrors();

      return Response::json(array('success' => 0, 'errors' => $errors->toArray()), 200);
    }
  }
}