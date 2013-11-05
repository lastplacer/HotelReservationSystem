<?php
	$dateFor = $_POST["dateFor"];
	$customerID = $_POST["customerID"];
	$reservationType = $_POST["reservationType"];
	
	$mysqli = new mysqli('localhost','site','p455w0rd','hotelsystem');
	if(mysqli_connect_errno()){
		echo "Connection failed: " . mysqli_connect_error() . "\n";
		exit();
	}
	
	if($stmt = $mysqli->prepare('INSERT INTO reservation VALUES (NULL, CURDATE()+0,?,?,?);')){
		$stmt->bind_param('sis',$dateFor,$customerID,$reservationType);
		$stmt->execute();
		echo mysqli_error($mysqli);
		echo $stmt->insert_id;
	}else{
		echo mysqli_error($mysqli);	
	}
	$stmt->close();
	$mysqli->close();
?>
