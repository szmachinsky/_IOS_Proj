<?php
/**
 * Created by JetBrains PhpStorm.
 * User: mamont
 * Date: 18.08.11
 * Time: 16:13
 * To change this template use File | Settings | File Templates.
 */

require_once '/home/hosting/tvprogram/etc/config.php';

$channels = new Model_Channels();

$list = $channels->buidlChannelsList();


$ch = curl_init();
curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
curl_setopt($ch, CURLOPT_USERPWD, "testindia01@test.com:india123");
curl_setopt($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_URL, $submit_url);