<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFeedsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('feeds', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // Creating the foreign key and setting up cascading deletes
            $table->text('content');
            $table->timestamps();
        });

        /**
         * Few Notes 
         * Foreign Key Declaration: The foreignId method is a more concise way to create a foreign key. 
         * The constrained() method automatically assumes that the referenced table is named users and the referenced column is id.
         * Cascading Deletes: The onDelete('cascade') method ensures that when a user is deleted, the corresponding feeds are also deleted.
         */
        
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('feeds');
    }
}
