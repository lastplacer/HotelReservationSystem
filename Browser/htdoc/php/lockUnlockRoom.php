<?php
	$roomNum = $_POST["roomNum"];
	$locked = $_POST["locked"];
	
	$mysqli = new mysqli('localhost','site','p455w0rd','hotelSystem');
	if(mysqli_connect_errno()){
		echo "Connection failed: " . mysqli_connect_error() . "\n";
		exit();
	}
	
	if($stmt = $mysqli->prepare('UPDATE hotelsystem.room SET locked = ? WHERE roomID = ?;')){
		$stmt->bind_param('ii',$locked,$roomNum);
		$stmt->execute();
	}
?>