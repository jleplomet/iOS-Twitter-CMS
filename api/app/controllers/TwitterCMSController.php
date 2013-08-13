<?php

class TwitterCMSController extends BaseController {
  public function index () {
    $approvedTweets = Tweet::get();

    if (count($approvedTweets) ) {
      return Response::json(array(
        'success' => 1,
        'results' => $approvedTweets->toArray()
      ), 200);
    } else {
      return Response::json(array('success' => 0));
    }
  }

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

      //mark as favorite...
      $favoriteTweet = Twitter::postFavorite(array('id' => $tweet->tweetId));

      $results = array('approvedTweetId' => $approved_tweet_id, $favoriteTweet);

      return Response::json(array('success' => 1, 'results' => $results), 201);
    } else {
      $errors = $tweet->getErrors();

      return Response::json(array('success' => 0, 'errors' => $errors->toArray()), 200);
    }
  }

  public function updateTweet () {
    $tweet = Tweet::find(Request::get('id'));

    //return Response::json(array('success' => 1, 'tweet' => $tweet->toArray()), 200);

    if ($tweet) {
      //check if approved then reject
      if ($tweet->status === 'approved') {
        $tweet->status = 'rejected';

        //destroy favorite
        $favoriteTweet = Twitter::destroyFavorite(array('id' => Request::get('tweetId')));

      } else if ($tweet->status === 'rejected') {
        $tweet->status = 'approved';

        //mark as favorite...
        $favoriteTweet = Twitter::postFavorite(array('id' => $tweet->tweetId));
      }

      $tweet->save();

      return Response::json(array('success' => 1, 'tweet' => $tweet->toArray()), 200);
    }
  }
}