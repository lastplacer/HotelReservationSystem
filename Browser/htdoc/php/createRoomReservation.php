<?php
	$reservationID = $_POST["reservationID"];
	$checkOutDate = $_POST["checkOutDate"];
	$roomNum = $_POST["roomNum"];
	
	$mysqli = new mysqli('localhost','site','p455w0rd','hotelsystem');
	if(mysqli_connect_errno()){
		echo "Connection failed: " . mysqli_connect_error() . "\n";
		exit();
	}
	
	if($stmt = $mysqli->prepare('INSERT INTO roomreservation VALUES (NULL,?,?,?);')){
		$stmt->bind_param('isi',$reservationID,$checkOutDate,$roomNum);
		$stmt->execute();
		echo $stmt->insert_id;
	}
	$stmt->close();
	$mysqli->close();
?>
