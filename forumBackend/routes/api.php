<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TestAuth\AuthenticationController;

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

// Api End Point 

Route::group(['prefix'=> 'v2'], function(){
    Route::post('/login', [AuthenticationController::class, 'login']);
    Route::post('/register', [AuthenticationController::class, 'register']);
    
    // Create a Middleware to secure Authentication
    Route::group(['middleware' => 'auth:sanctum'], function()
    {
        Route::get('/profile', [AuthenticationController::class, 'profile']);
        Route::post('/logout', [AuthenticationController::class, 'logout']);
    });

});

