<?php

namespace App\Http\Controllers\Feeds;
use App\Models\User;
use App\Models\Feeds;
use App\Models\Comments;
use App\Models\LikeModel;
use Illuminate\Http\Request;
use App\Http\Requests\PostRequest;
use App\Http\Controllers\Controller;

class FeedsController extends Controller
{
    //Return or fetch feeds Data
    public function index(){

        $feeds =  Feeds::with('user')->latest()->get();
        return response([
            'feeds' => $feeds,
        ], 200);
    }

    public function feeds(PostRequest $request)
    {
        $request->validated();
        auth()->user()->feeds()->create([
            'content' => $request->content,
        ]);

        return response([
            'message' => 'Post Created',
        ], 200);
    }
    public function LikePost($feeds_id)
{
    $feed = Feeds::whereId($feeds_id)->first();

    if(!$feed) {
        return response([
            'message' => '404 Not Found',
        ], 404);
    }

    $like = LikeModel::where('user_id', auth()->id())->where('feeds_id', $feeds_id)->first();

    if($like) {
        $like->delete();
        return response([
            'message' => 'Unliked',
        ], 200);
    }

    $likedPost = LikeModel::create([
        'user_id' => auth()->id(),
        'feeds_id' => $feeds_id,
    ]);
    
    if($likedPost) {
        return response([
            'message' => 'Liked',
        ], 200);
    }
   
    return response([
        'message' => 'An error occurred while liking the post.',
    ], 500);
}
// public function comments(Request $request, $feeds_id)
// {

//     $request->validate([
//         'comment' => 'required|string',
//     ]);
//     // Check for authenticated user 
//     $comment = Comments::create([
//         'user_id' => auth()->id(),
//         'feeds_id' => $feeds_id,
//         'comment' => $request->comment,

//     ]);
    // Return a response
    public function comments(Request $request, $feeds_id)
    {
        // Validate the request input
        $request->validate([
            'comment' => 'required|string',
        ]);
    
        // Check if the user is authenticated
        if (auth()->check()) {
            // Create the comment
            $comment = Comments::create([
                'user_id' => auth()->id(),
                'feeds_id' => $feeds_id,
                'comment' => $request->comment,
            ]);
    
            // Return a successful response with the created comment
            return response()->json([
                'message' => 'Comment posted successfully.',
                'comment' => $comment,
            ], 201);
        } else {
            // Return an error response if the user is not authenticated
            return response()->json([
                'message' => 'Login To Comment',
            ], 401);
        }
    }     

public function getComments($feeds_id)
{
    $comments = Comments::with('feeds')->with('user')->where('feeds_id', $feeds_id)->latest()->get();

    return response([
        'comments' => $comments,
    ], 200);
}
}
