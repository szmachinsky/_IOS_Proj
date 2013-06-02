<?php
class Db extends mysqli {

    private static $connection = null;

    private function __construct($host, $userName, $passwd, $dbName) {
        parent::__construct ( $host, $userName, $passwd, $dbName );
    }

    /**
     * @static
     * @return db
     */

    static function &getInstance() {

        if (self::$connection == null) {
            self::$connection = new db ( DB_HOST, DB_LOGIN, DB_PASS, DB_NAME );
            if (mysqli_connect_error ()) {
                new Error ( mysqli_connect_error (), mysqli_connect_errno () );
            }
            if (! self::$connection->set_charset ( "utf8" )) {
                new Error ( mysqli_connect_error (), mysqli_connect_errno () );
            }
        }

        return self::$connection;
    }

    /**
     * @param string|boolean $sql
     * @return resource
     */

    public function doQuery($sql = false) {
        if ($sql === false) {
            return false;
        }
        $res = self::$connection->query ( $sql );
        if ($res === false) {
            new Error ( self::$connection->error, self::$connection->errno );
        }
        return $res;
    }

    /**
     * @param resource $result
     * @return array
     */

    public function fetchRows($result) {
        $rows = $result->fetch_all ();
        $result->free ();
        return $rows;
    }

    /**
     * @param resource $result
     * @return array
     */

    public function rowsAssoc($result) {
        $rows = array ();
        while ( $row = $result->fetch_assoc () ) {
            $rows [] = $row;
        }
        $result->free ();
        return $rows;
    }

    /**
     * @param resource $result
     * @return array
     */

    public function rowAssoc($result) {
        $row = $result->fetch_assoc ();
        $result->free ();
        return $row;
    }

    public function row($result) {
        $row = array ();
        $row = $result->fetch_row ();
        $result->free ();
        return $row;
    }

    public function rows($result) {
        $rows = array ();
        while ( $row = $result->fetch_row () ) {
            $rows [] = $row;
        }
        $result->free ();
        return $rows;
    }

    public function esc($data) {
        return self::real_escape_string ( $data );
    }

}
