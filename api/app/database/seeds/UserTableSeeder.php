<?php

class UsersTableSeeder extends Seeder {

	public function run()
	{
		// Uncomment the below to wipe the table clean before populating
		// DB::table('user')->delete();

		$user = array(
      'username' => 'admin',
      'password' => Hash::make('labs135'),
      'email' => 'jeff@avatarlabs.com',
      'created_at' => new DateTime,
      'updated_at' => new DateTime
		);

		// Uncomment the below to run the seeder
		DB::table('users')->insert($user);
	}

}