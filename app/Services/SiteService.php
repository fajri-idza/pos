<?php 

namespace App\Services;

use App\Repositories\SiteRepository;

class SiteService {

	public function update(array $data): Object
	{
		$site = new SiteRepository;
		
		return $site->update($data);
	}

}

 ?>