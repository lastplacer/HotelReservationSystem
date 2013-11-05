<? php
	$firstName = $_POST["firstName"];
	$lastName = $_POST["lastName"];
	$address = $_POST["address"];
	$city = $_POST["city"];
	$province = $_POST["province"];
	$country = $_POST["country"];
	$phone = $_POST["phone"];
	$userType = $_POST["userType"];
	
	$mysqli = new mysqli('localhost','site','p455w0rd','hotelSystem');
	if(mysqli_connect_errno()){
		echo "Connection failed: " . mysqli_connect_error() . "\n";
		exit();
	}
	
	if($stmt = $mysqli->prepare('INSERT INTO user VALUES (NULL,?,?,?,?,?,?,?,?);')){
		$stmt->bind_param('ssssssss',$firstName,$lastName,$address,$city,$province,$country,$phone,$userType);
		$stmt->execute();
	}
?>
