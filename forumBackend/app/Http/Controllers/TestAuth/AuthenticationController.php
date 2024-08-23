<?php

namespace App\Http\Controllers\TestAuth;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthenticationController extends Controller
{
    //
    public function login(Request $request)
{
    // Validate using the Validator class
    $validator = Validator::make($request->all(), [
        'email' => 'required|email',
        'password' => 'required|string|min:6',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'message' => $validator->errors()->first()
        ], 401);
    }

    // Extract email and password from the request
    $credentials = $request->only('email', 'password');

    // Attempt to log in with the provided credentials
    if (!auth()->attempt($credentials)) {
        return response()->json([
            'message' => 'Unauthorized. Check Credentials',
        ], 401);
    }

    // Get the authenticated user
    $user = $request->user();

    // Create an access token for the authenticated user
    $tokenResult = $user->createToken('Access');
    $token = $tokenResult->plainTextToken;

    return response()->json([
        'token' => $token,
        'user' => $user,
    ]);
}
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|between:2,15',
            'email' => 'required|string|email|max:100|unique:users',
            'password' => 'required|string|confirmed|min:6',
        ]);
        if($validator->fails()){
            return response()->json([
                'message' => $validator->errors()->first()
            ], 401);
        }
        // Store User 

        $user = User::create(
            array_merge(
                $validator->validated(),
                ['password'=> Hash::make($request->password)],
            )
            );
            // Enable the user to genarate the token after registration
            $tokenResult = $user->createToken('Access');
            $token = $tokenResult->plainTextToken;
    
            return response()->json([
                'message' => 'User Create Successfully',
                'token' => $token,
                'user' => $user,
            ]);
    }
    // Returns the Profile Information
    public function profile()
    {
        return response()->json(auth()->user());
    }
    // Logout User
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json([
            'message' => 'User Successfully Logged Out',
        ]);
    }

}
