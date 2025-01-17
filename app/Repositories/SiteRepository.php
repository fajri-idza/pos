<?php 

namespace App\Repositories;

use App\Models\Site;

class SiteRepository {

	public function update(array $data): Object
	{
		$site = Site::first();
		$site->update($data);

		return $site;
	}

}


 ?>