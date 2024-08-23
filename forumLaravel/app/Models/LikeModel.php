<?php

namespace App\Models;

use App\Models\Feeds;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class LikeModel extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'feeds_id',
        
    ];

    // public function feeds():BelongsTo
    // {
    //     return $this->BelongsTo(Feeds::class);
    // }
    public function feed(): BelongsTo
    {
        return $this->belongsTo(Feeds::class, 'feeds_id'); // Reference 'feed_id'
    }
    
}
