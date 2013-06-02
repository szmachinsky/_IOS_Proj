<?php

class MCache
{

    /**
     * @var Memcached $connect
     */
    protected $connect = null;

    /**
     * @var MCache $instance
     */
    protected static $instance = null;

    /**
     * @var string $prefix
     */
    protected $prefix = false;

    /**
     * @var string $host
     */
    protected $host = '127.0.0.1';

    /**
     * @var string $port
     */
    protected $port = 11211;


    private function __construct()
    { /* ... */
    }

    private function __clone()
    { /* ... */
    }

    /**
     * @static
     * @return MCache
     */

    public static function &getInstance()
    {
        if (!self::$instance instanceof MCache) {
            self::$instance = new self ();
            self::$instance->connect();
        }
        return self::$instance;
    }

    /**
     * @private
     * @return bool
     */

    private function connect()
    {
        $this->connect = new Memcached ();

        if (defined('MEMCACHE_PREFIX')) {
            $this->prefix = MEMCACHE_PREFIX;
        }

        if (defined('MEMCACHE_HOST')) {
            $this->host = MEMCACHE_HOST;
        }

        if (defined('MEMCACHE_PORT')) {
            $this->port = MEMCACHE_PORT;
        }

        //		$result = $this->connect->setOption(Memcached::OPT_COMPRESSION, false);
        //		$result = $this->connect->setOption(Memcached::OPT_BINARY_PROTOCOL, true);
        //		$result = $this->connect->setOption(Memcached::OPT_NO_BLOCK, true);
        //		$result = $this->connect->setOption(Memcached::OPT_TCP_NODELAY, true);
        //		if (Memcached::HAVE_IGBINARY) {
        //			$result = $this->connect->setOption(Memcached::OPT_SERIALIZER,Memcached::SERIALIZER_IGBINARY);
        //		}
        $result = $this->connect->addServer($this->host, $this->port);
        if (false === $result) {
            Log::warn('unable to connect to memcached server ' . $this->host . ':' . $this->port);
            return false;
        }
        return true;
    }

    /**
     * @param string $name
     * @param mixed $value
     * @param int $expired [optional]
     * @return bool
     */
    public function set($name, $value, $expired = 86400)
    {
        $result = $this->connect->set('hofarm' . $name, $value, $expired);
        $status = $this->connect->getResultCode();
        if ($status != Memcached::RES_SUCCESS) {
            Log::warn('SET, memory error ' . $status);
        }
        return $result;
    }

    /**
     * @param string $keyName
     * @return mixed
     */

    public function get($keyName)
    {
        $keyName = $this->getPrefix($keyName);
        $result = $this->connect->get($keyName);
        $status = $this->connect->getResultCode();
        if ($status != Memcached::RES_SUCCESS && $status != Memcached::RES_NOTFOUND) {
            Log::Error('GET ' . $keyName . ', memory error ' . $status);
        }
        return $result;
    }

    /**
     * @param string $keyName
     * @return boolean
     */

    public function exist($keyName)
    {
        $keyName = $this->getPrefix($keyName);
        $result = $this->connect->get($keyName);
        if (false !== $result) {
            return true;
        }
        return false;
    }

    /**
     * Удаляет ключ и ассоциированное с ним значение из кеша в памяти
     * @param string $keyName
     * @return bool
     */

    public function delete($keyName)
    {
        $keyName = $this->getPrefix($keyName);
        $result = $this->connect->delete($keyName, 0);
        if (false === $result) {
            Log::warn('error delete key ' . $keyName . ' from memoryCache');
            return false;
        }
        $status = $this->connect->getResultCode();
        if ($status != Memcached::RES_SUCCESS && $status != Memcached::RES_NOTFOUND) {
            Log::Error('DELETE, memory error ' . $status);
            return false;
        }
        return true;
    }

    /**
     * @param string $keyName
     * @return string
     */

    private function getPrefix($keyName)
    {
        if (false !== $this->prefix) {
            return $this->prefix . $keyName;
        }
        return $keyName;
    }

}