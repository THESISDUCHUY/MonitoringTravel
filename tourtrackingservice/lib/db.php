<?php

class db {

    public $_mysqli;

    //public $db;
    public function __construct() {

        $this->_mysqli = new mysqli(DB_HOST, DB_USER_NAME, DB_PASSWORD, DB_NAME);
        $this->_mysqli->query("SET NAMES 'utf8'");
    }

    public function escape_string($text) {
        return $this->_mysqli->real_escape_string($text);
    }

    public function query($query) {
        //return mysql_query($query, $this->db);
        return $this->_mysqli->query($query);
    }

    public function getLastId() {
        return $this->_mysqli->insert_id;
    }

    public function fetchRow($query) {
        $result = $this->query($query);
        if ($result === false) {
            return NULL;
        }
        return $result->fetch_assoc();
        //return mysqli_fetch_object($result);
    }

     public function multi_query($query) {
        return $this->_mysqli->multi_query($query);
    }


    public function fetchAll_LastQuery_From_MultiQuery($query) {
        $result = $this->_mysqli->multi_query($query);
        $results = array();
        do {
            $records = array();
            $result = $this->_mysqli->store_result();
            if ($result != False) {
                while ($row = $result->fetch_assoc()) {
                    $records[] = $row;
                }
            }
            if (is_object($result)) {
                $result->free_result();
            }
            $results[] = $records;
        } while ($this->_mysqli->next_result());

        if (count($results) > 1)
            return $results[count($results) - 1];
        return False;
    }

    public function fetchAll($query) {
        $return = array();
        $result = $this->query($query);
        if ($result === false) {
            return NULL;
        } else {
            while ($row = $result->fetch_assoc()) {
                $return[] = $row;
            }
        }
        return $return;
    }

    public function getAffected() {
        return $this->_mysqli->affected_rows;
    }

    public function begin() {
        $query = "START TRANSACTION;";
        $this->query($query);
    }

    public function commit() {
        $query = "COMMIT;";
        $this->query($query);
    }

    public function rollback() {
        $query = "ROLLBACK;";
        $this->query($query);
    }

}
