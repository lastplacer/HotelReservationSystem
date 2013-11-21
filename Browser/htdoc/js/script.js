var currPage = "#selectionInfo";
var roomNum = -1;
var timeout;
var checking = false;

window.onbeforeunload = function(e) {
	unlockRoom(roomNum);
    return null;
}

function lockRoom(roomNumber){
	if(roomNumber > 0){
		$.post("php/lockUnlockRoom.php",{roomNum: roomNumber,locked: 1});
	}
}

function unlockRoom(roomNumber){
	console.log("derp");
	console.log(roomNumber);
	if(roomNumber > 0){
		$.ajax({
			type: "POST",
			url: "php/lockUnlockRoom.php",
			data: {
				roomNum: roomNumber,
				locked: 0
			},
			async: false
		});
	}
}

function changePage(newPage){
	$(currPage).hide();
	currPage = newPage;
	$(currPage).show();
}

function nextPage(){
	if(currPage == "#selectionInfo"){
 		changePage("#personalInfo");
	}else if(currPage == "#personalInfo"){
		changePage("#paymentInfo");
	}else if(currPage == "#paymentInfo"){
 		changePage("#confirmationInfo");
	}
}

function backPage(){
	if(currPage == "#confirmationInfo"){
		changePage("#paymentInfo");
	}else if(currPage == "#paymentInfo"){
		changePage("#personalInfo");
	}else if(currPage == "#personalInfo"){
		changePage("#selectionInfo");
	}
}

function updateBillingAddress(disabled){
	$("#paymentAddress input").each(function(index, element) {
		$(this).prop("disabled",disabled);
		if(disabled){
			$(this).val($("#" + $(this).attr("id").replace("payment","personal")).val());
		}else{
			$(this).val("");	
		}
	});
}

function setDefaultValues(){
	$(".datepicker").datepicker();
	$("#selectionCheckInDate").datepicker().bind("change", function(){
		var minValue = $(this).val();
		minValue = $.datepicker.parseDate("mm/dd/yy", minValue);
		minValue.setDate(minValue.getDate()+1);
		$("#selectionCheckOutDate").datepicker("option", "minDate", minValue);
	});
	var myDate = new Date();
	$("#selectionCheckInDate").datepicker("setDate", myDate);
	$("#selectionCheckInDate").datepicker("option", "minDate", 0);
	$("#selectionCheckOutDate").datepicker("option","minDate",1);
	$("#selectionCheckOutDate").datepicker("setDate", 1);
	
	$("#selectionGuestCount").val(1);
	$("#selectionRoomType").val(0);
	$("#selectionBeds").val(2);
	$("#selectionLakeview").prop("checked",false);
	
	$("#samePaymentAddress").prop("checked",false);
	$("#paymentType").val("mc");
}

function init(){
	$("#selectionInfo").hide();
	$("#personalInfo").hide();
	$("#paymentInfo").hide();
	$("#confirmationInfo").hide();
	changePage("#selectionInfo");
	
	setDefaultValues();
	
	updateBillingAddress(false);
	
	updateSummaryAndConfirmation($("#selectionCheckInDate"));
	updateSummaryAndConfirmation($("#selectionCheckOutDate"));
	updateSummaryAndConfirmation($("#selectionGuestCount"));
	updateSummaryAndConfirmation($("#selectionRoomType"));
	updateSummaryAndConfirmation($("#selectionBeds"));
	updateSummaryAndConfirmation($("#selectionLakeview"));
}

function checkAvailability(){
	unlockRoom(roomNum);
	var inDate = $("#selectionCheckInDate").val();
	inDate = $.datepicker.parseDate("mm/dd/yy",inDate);
	inDate = $.datepicker.formatDate("yy-mm-dd",inDate);
	var outDate = $("#selectionCheckOutDate").val();
	outDate = $.datepicker.parseDate("mm/dd/yy",outDate);
	outDate = $.datepicker.formatDate("yy-mm-dd",outDate);
	
	$.ajax({
		type:"POST",
		url:"php/checkRoomAvailability.php",
		data: {
			checkInDate: inDate,
			checkOutDate: outDate,
			numGuests: $("#selectionGuestCount").val(),
			numBeds: $("#selectionBeds").val(),
			isLakeview: $("#selectionLakeview").prop("checked") ? 1:0,
			isSuite: $("#selectionRoomType").val()
		},
		success: function(data, status){
			roomNum = data;
			console.log(roomNum);
			lockRoom(roomNum);
			if(data == -1){
				alert("No rooms available matching given criteria!");
			}else if(checking == true){
				alert("Room available matching given criteria!");
			}
			$("#availBtn").attr("disabled",false);
		},
		async: false
	});
}

function createReservation(){
	var inDate = $("#selectionCheckInDate").val();
	inDate = $.datepicker.parseDate("mm/dd/yy",inDate);
	inDate = $.datepicker.formatDate("yy-mm-dd",inDate);
	var outDate = $("#selectionCheckOutDate").val();
	outDate = $.datepicker.parseDate("mm/dd/yy",outDate);
	outDate = $.datepicker.formatDate("yy-mm-dd",outDate);
	
	function createUser(){
		return $.ajax({
			type: "POST",
			url: "php/createUser.php",
			data: {
				firstName: $("#personalFirstName").val(),
				lastName: $("#personalLastName").val(),
				address: $("#personalStreet").val(),
				city: $("#personalCity").val(),
				province: $("#personalProvince").val(),
				country: $("#personalCountry").val(),
				postalCode: $("#personalPostalCode").val(),
				phone: $("#personalPhone").val(),
				userType: "c"
			}
		});
	}
	
	
	function createCustomer(userID){
		return $.post("php/createCustomer.php",{
			userID: userID
		});
	}
	
	function createReservation(customerID){
		return $.post("php/createReservation.php",{
			dateFor: inDate,
			customerID: customerID,
			reservationType: "r"
		});
	}
	
	function createRoomReservation(reservationID){
		return $.ajax({
			type: "POST",
			url: "php/createRoomReservation.php",
			data: {
				reservationID: reservationID,
				checkOutDate: outDate,
				roomNum: roomNum
			},
			success: function(){
				$("#reserveBtn").attr("disabled", false);
			}
		});
	}
	
	$.when(createUser()).done(function(user){
		$.when(createCustomer(user)).done(function(customer){
			$.when(createReservation(customer)).done(function(reservation){
				$.when(createRoomReservation(reservation)).done(function(data){
					unlockRoom(roomNum);
					roomNum = -1;
					alert("Reservation successfully create from " + inDate + " until " + outDate);
				});
			});
		});
	});
}

$(function(){
	init();
	
	$("#progress li").on("click", function(event){
		changePage("#" + $(this).attr("id").replace("Progress","Info"));
	});
	
	$("#availBtn").on("click", function(event){
		$("#availBtn").attr("disabled",true);
		checking = true;
		checkAvailability();
	});
	
	$(".nextBtn").on("click", function(event){
		nextPage();
	});
	
	$(".backBtn").on("click", function(event){
		backPage();
	});
	
	$("#reserveBtn").on("click", function(event){
		$("#reserveBtn").attr("disabled",true);
		checking = false;
		if(roomNum == -1){
			checkAvailability();
		}
		if(roomNum != -1){
			createReservation();
		}
	});
	
	$("#samePaymentAddress").on("change", function(event){
		updateBillingAddress($(this).prop("checked"));
	});
	
	$("#paymentType").on("change", function(event){
		if($(this).val() == "c"){
			$("#cardInfo").hide("slow");
		}else{
			$("#cardInfo").show("slow");
		}
	});
	
	$("#selectionInfo").children().on("change", function(event){
		updateSummaryAndConfirmation($(event.target));
	});
});

function updateSummaryAndConfirmation(target){
	var inDate, outDate;
	if(target.attr("id").match("selectionCheck(In|Out)Date")){
		if((inDate = $("#selectionCheckInDate").val()) != ""){
			if((outDate = $("#selectionCheckOutDate").val()) != ""){
				var time = Math.floor((new Date(outDate) - new Date(inDate))/(1000*60*60*24));
				if(time > 0){
					$("#summaryNightsStaying").val(time);
					$("#confirmationNightsStaying").val(time);
				}else{
					$("#summaryNightsStaying").val("Invalid");
					$("#confirmationNightsStaying").val("Invalid");
				}
			}
		}
	}else if(target.attr("id") == "selectionLakeview"){
		if(target.prop("checked")){
			$("#summaryLakeview").val("Yes");
			$("#confirmationLakeview").val("Yes");
		}else{
			$("#summaryLakeview").val("No");
			$("#confirmationLakeview").val("No");
		}
	}else if(target.attr("id") == "selectionRoomType"){
		console.log("1");
		if(target.val() == 1){
			console.log("yes");
			$("#summaryRoomType").val("Suite");
			$("#confirmationRoomType").val("Suite");
		}else{
			console.log("no");
			$("#summaryRoomType").val("Standard");
			$("#confirmationRoomType").val("Standard");	
		}
	}else{
		$("#" + target.attr("id").replace("selection","summary")).val(target.val());
		$("#" + target.attr("id").replace("selection","confirmation")).val(target.val());
	}
}
