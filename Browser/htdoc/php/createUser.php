<?php
	$firstName = $_POST["firstName"];
	$lastName = $_POST["lastName"];
	$address = $_POST["address"];
	$city = $_POST["city"];
	$province = $_POST["province"];
	$country = $_POST["country"];
	$postalCode = $_POST["postalCode"];
	$phone = $_POST["phone"];
	$userType = $_POST["userType"];
	
	$mysqli = new mysqli('localhost','site','p455w0rd','hotelsystem');
	if(mysqli_connect_errno()){
		echo "Connection failed: " . mysqli_connect_error() . "\n";
		exit();
	}
	if($stmt = $mysqli->prepare('INSERT INTO user VALUES (NULL,?,?,?,?,?,?,?,?,?);')){
		$stmt->bind_param('sssssssss',$firstName,$lastName,$address,$city,$province,$country,$postalCode,$phone,$userType);
		$stmt->execute();
		echo $stmt->insert_id;
	}else{
		echo mysqli_error($mysqli);	
	}
	$stmt->close();
	$mysqli->close();
?>
