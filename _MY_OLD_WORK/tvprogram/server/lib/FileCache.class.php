<?php
class FileCache
{
    /**
     * @var FileCache $intance
     */
    protected static $instance = null;

    private function __construct()
    { /* ... */
    }

    private function __clone()
    { /* ... */
    }

    /**
     * @static
     * @return FileCache
     */

    public static function &getInstance()
    {
        if (!self::$instance instanceof FileCache) {
            self::$instance = new self ();
        }
        return self::$instance;
    }

    public function set($name, $data)
    {

        $filePath = CACHE_PATH . '/' . $name . '.cache';
        umask(0113);
        $tmpFileName = tempnam(dirname($filePath), 'tmp');
        $tmpFile = fopen($tmpFileName, "wb");

        if (false === $tmpFile) {
            Log::warn ('cannot create temp file');
        }

        flock($tmpFile, LOCK_EX);
        if (function_exists('igbinary_serialize')) {
            $encodedStr = igbinary_serialize($data);
        }
        elseif (function_exists('bson_encode')) {
            $encodedStr = bson_encode($data);
        }
        else {
            $encodedStr = json_encode($data);
        }

        if (!isset ($encodedStr [0])) {
            Log::warn ('cannot serialize ');
        }

        fwrite($tmpFile, $encodedStr);
        flock($tmpFile, LOCK_UN);
        fclose($tmpFile);
        if (file_exists($filePath)) {
            @unlink($filePath);
        }

        if (file_exists($filePath) && !is_writable($filePath)) {
            @unlink($tmpFileName);
            return true;
        }

        if (rename($tmpFileName, $filePath) === false) {
            @unlink($tmpFileName);
            Log::warn ('error moving datafile');
        }

        chmod($filePath, 0664);
        chown($filePath, 'www-data');
        chgrp($filePath, 'www-data');

        return true;
    }

    public function get($name)
    {

        $filePath = CACHE_PATH . '/' . $name . '.cache';

        if (!is_file($filePath)) {
            return false;
        }

        if (!is_readable($filePath)) {
            return false;
        }

        $handle = fopen($filePath, "rb");
        $data = fread($handle, filesize($filePath));
        if ($data === false) {
            Log::warn ('error reading data');
        }
        if (function_exists('igbinary_unserialize')) {
            $data = igbinary_unserialize($data);
        }
        elseif (function_exists('bson_decode')) {
            $data = bson_decode($data);
        }
        else {
            $data = json_decode($data, true);
        }
        if ($data === false) {
            Log::warn ('error unserialize');
        }

        fclose($handle);

        return $data;
    }

    public function exist($name)
    {

        $filePath = CACHE_PATH . '/' . $name . '.cache';

        if (file_exists($filePath) && is_readable($filePath)) {
            return true;
        }

        return false;
    }

    public function delete($name)
    {

        $filePath = CACHE_PATH . '/' . $name . '.cache';

        if (file_exists($filePath)) {
            @unlink($filePath);
        }
    }

}