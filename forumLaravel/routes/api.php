<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Feeds\FeedsController;
use App\Http\Controllers\Apis\AuthenticationController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Include the routes fo Apis  here 
Route::post('/register', [AuthenticationController::class, 'register']);
Route::post('/login', [AuthenticationController::class, 'login']);

// Create a middleware after authentication using laravel sanctum.

Route::group(['middleware' => 'auth:sanctum'], function()
{    
    Route::get('/feeds', [FeedsController::class, 'index']); // Fetches all the feeds
    Route::post('feed/save', [FeedsController::class, 'feeds']);
    Route::post('feed/like/{feeds_id}', [FeedsController::class, 'LikePost']); // Controller that handles the like button
    Route::post('/feed/comment/{feeds_id}', [FeedsController::class, 'comments']);
    Route::get('/feed/getcomments/{feeds_id}', [FeedsController::class, 'getComments']);
   
});


