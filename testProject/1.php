<?php
ini_set ( 'display_errors', 1); 
error_reporting(7);

if (php_sapi_name() == "cli") {
	$tabName= "comment";
	$dates	= $argv[1];    
	$pipe	= $argv[2];
	$sql	= "SELECT id,content FROM {$tabName} WHERE date ='{$dates}' ORDER BY id ASC";
	echo $sql."\n";

	sleep (1); 
	shell_exec('echo  > '.$pipe);
}
