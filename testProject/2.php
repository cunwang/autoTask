<?php
ini_set ( 'display_errors', 1); 
error_reporting(7);

if (php_sapi_name() == "cli") {
	$tabName= "comment";
	$s_num	= $argv[1];    
	$limit	= $argv[2];    
	$pipe	= $argv[3];
	$sql	= "SELECT id,content FROM {$tabName} WHERE output_status=1 AND content!='' AND (`id` > {$s_num} AND `id` < {$limit}) ORDER BY id ASC";
	echo $sql."\n";

	sleep (2); 
	shell_exec('echo  > '.$pipe);
}
