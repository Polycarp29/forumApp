<?php

namespace App\Models;

use App\Models\User;
use App\Models\Feeds;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Comments extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'feeds_id',
        'comment',
        'created_at',
    ];
    // Comment should belong to a feed.
    public function feeds():BelongsTo
    {
        return $this->belongsTo(Feeds::class); // Create a relationship between the feed and comments Models 
    }
    public function user():BelongsTo
    {
        return $this->belongsTo(User::class); // Create a relationship between the User and Comments Models
    }
}
