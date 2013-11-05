<?php
	$userID = $_POST["userID"];
	
	$mysqli = new mysqli('localhost','site','p455w0rd','hotelsystem');
	if(mysqli_connect_errno()){
		echo "Connection failed: " . mysqli_connect_error() . "\n";
		exit();
	}
	
	if($stmt = $mysqli->prepare('INSERT INTO customer VALUES (NULL, ?);')){
		$stmt->bind_param('i',$userID);
		$stmt->execute();
		echo $stmt->insert_id;
	}
	$stmt->close();
	$mysqli->close();
?>
