<?php
define ('DEBUG', 1);
error_reporting(E_ALL);

if (DEBUG > 0) {
    $mtime = microtime(true);
    $tstart = $mtime;
}
else {
    error_reporting(0);
}

define('MEMCACHE_PREFIX', 'tvguide');
define('MEMCACHE_HOST', '127.0.0.1');
define('MEMCACHE_PORT', 11211);

define('BASE_URI', 'http://tvprogram.selfip.info/data/');

define('BASE_PATH', '/home/hosting/tvprogram');
define('CACHE_PATH', BASE_PATH . '/cache');
define('PICS_PATH', BASE_PATH . '/pics');
define('OUT_PATH', BASE_PATH . '/data/new');
define('XML_PATH', BASE_PATH . '/data/xmls');
define('CHANNELS_LOGO_PATH', BASE_PATH . '/data/channels_logo');
define('JSON_PATH', BASE_PATH . '/data/jsons');
define('LOCKS_PATH', BASE_PATH . '/locks');

define('DB_HOST', 'localhost');
define('DB_LOGIN', 'tvuser');
define('DB_PASS', 'NEaaGqp8dSNQBXdH');
define('DB_NAME', 'tvprogram');

//define('XML_URL', 'http://www.vsetv.com/export/redplanetsoft/export.xml');
define('XML_URL', 'http://www.teleguide.info/download/new3/xmltv.xml.gz');
//define('XML_USERNAME', 'mitrofanov');
define('XML_USERNAME', '');
//define('XML_PASSWORD', 'vthrehbq');
define('XML_PASSWORD', '');

if (!date_default_timezone_set('Europe/Minsk')) {
    Log::warn('timezone is not set');
}

register_shutdown_function("shutdown");
set_include_path(implode(PATH_SEPARATOR, array(realpath(dirname(__FILE__) . '/../lib'), get_include_path())));

function shutdown()
{
    if (DEBUG > 0) {
        global $tstart;
        error_log($_SERVER ['PHP_SELF'] . ' worked ' . (microtime(true) - $tstart) . ' sec', 0);
    }
}

function __autoload($className)
{
    //    $className = strtolower($className);
    if (false === strpos($className, '_')) {
        $classExtension = ".class.php";
        $fileName = $className;
    }
    else {
        $fileName = str_replace('_', '/', $className);
        $classExtension = ".php";
    }
    $filePath = $fileName . $classExtension;
    if (!include_once ($filePath)) {
        error_log('error loading file ' . $filePath);
    }
    return false;
}
