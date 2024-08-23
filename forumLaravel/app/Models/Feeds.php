<?php

namespace App\Models;

use App\Models\User;
use App\Models\Comments;
use App\Models\LikeModel;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Feeds extends Model
{
    use HasFactory;

    // Pass through data that can be fetched 

    protected $fillable = [
        'user_id',
        'content',
        'created_at',
    ];

    protected $appends = ['liked']; // Tell Laravel to include append in the Model Return in JSON File

    public function user():BelongsTo
    {
        return $this->BelongsTo(User::class);
    }

    public function likes():HasMany
    {
        return $this->hasMany(LikeModel::class); // The feed can have as many likes as possible
    }
    public function getLikedAttribute():bool
    {
        return (bool) $this->likes()
        ->where('user_id', auth()->id())
        ->exists();
    }
    public function comments():HasMany
    {
        return $this->hasMany(Comments::class); // The Comments can have as many likes as possible
    }
}