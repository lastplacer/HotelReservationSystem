<?php
	$checkInDate = $_POST["checkInDate"];
	$checkOutDate = $_POST["checkOutDate"];
	$numGuests = $_POST["numGuests"];
	$numBeds = $_POST["numBeds"];
	$isLakeview = $_POST["isLakeview"];
	$isSuite = $_POST["isSuite"];
	$roomNum = -1;
	
	echo $checkInDate . "\n";
	echo $checkOutDate . "\n";
	echo $numGuests . "\n";
	echo $numBeds . "\n";
	echo $isLakeview . "\n";
	echo $isSuite . "\n";
	
	if($checkInDate >= $checkOutDate){
		echo "failed";
	}else{
		$mysqli = new mysqli('localhost','site','p455w0rd','hotelSystem');
		if(mysqli_connect_errno()){
			echo "Connection failed: " . mysqli_connect_error() . "\n";
			exit();
		}
		//if($stmt = $mysqli->prepare('SELECT roomID FROM room WHERE isLakeview = ? AND isSuite = ? AND numBeds = ? and locked = 0;')){
		if($stmt = $mysqli->prepare('SELECT roomID 
										FROM room 
										WHERE roomID NOT EXISTS (
											SELECT roomreservation.roomID 
											FROM roomresetvation
											INNER JOIN reservation
											ON reservation.reservationID = roomreservation.reservationID
											WHERE DATEDIFF(?,dateFor) >= 0
											AND DATEDIFF(?,checkOutDate) <= 0
										)
										AND isLakeview = ?
										AND isSuite = ?
										AND numBeds = ?
										AND locked = 0;')){

			$stmt->bind_param('ssiii',$checkOutDate,$checkInDate,$isLakeview, $isSuite, $numBeds);
			
			$stmt->execute();
			
			$stmt->bind_result($roomNum);
			
			while($stmt->fetch()){
				echo $roomNum . "\n";
			}
			$stmt->close();
		}
		$mysqli->close();
	}
?>