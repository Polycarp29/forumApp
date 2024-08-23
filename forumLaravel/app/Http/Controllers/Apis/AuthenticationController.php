<?php

namespace App\Http\Controllers\Apis;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Requests\LoginRequest;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use App\Http\Requests\RegisterRequest;

class AuthenticationController extends Controller
{
    //
    public function register(RegisterRequest $request)
    {
        $request->validated();
        $userData = [
            'username' => $request->username,
            'name' => $request->name,
            'email' => $request->email,
            //Encrypt password 
            'password' => Hash::make($request->password),
        ];

        // Create or Store User 

        $userStored = User::create($userData);
        // Create a Token 
        $userToken = $userStored->createToken('Acces Granted')->plainTextToken;

        return response([
            'message' => 'User Created Successfully',
            'user' => $userStored,
            'token' => $userToken,
        ],200);

    }
    // Include Login Request 
    public function login(LoginRequest $request)
    {
        $request->validated();
        $user = User::whereUsername($request->username)->first();
        if(!$user || !Hash::check($request->password, $user->password)){
            return response([
                    'message' => 'Invalid Credentials Wrong Email or Password',
                ], 422);
        }
        // Generate User Token When the User is Correct
        $userToken = $user->createToken('Acces Granted')->plainTextToken;

        return response([
            'user' => $user,
            'token' => $userToken,
        ],200);


    }
}
