<html>
<head>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">

<script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
</head>
<body class="container">
<h2>Learn</h2>
<form action="" method="POST" >
	<div><span class="btn btn-secondary" onclick="$(this).closest('div').clone().insertAfter($(this).closest('div'))">+</span>Word<input type="text" name="word[]" /><br/></div>
	<input type="hidden" name="operation" value="learn" />
	<button class="btn btn-primary" type="submit">Send</button>
</form>
<h2>Predict</h2>
	<div><span class="btn btn-secondary" onclick="$(this).closest('div').clone().insertAfter($(this).closest('div'))">+</span>Word<input type="text" name="word[]" /><br/></div>
	<input type="hidden" name="operation" value="predict" />
	<button class="btn btn-primary" type="submit">Send</button>

<h2>Results</h2>
<?php
function execLocalProcess($cmd, $dataIn, &$dataOut) {
	$std_pipes_specs = [["pipe","r"],["pipe","w"],["pipe","w"]];
	$process = proc_open($cmd, $std_pipes_specs, $pipes);
	if (is_resource($process)) {
	    fwrite($pipes[0], $dataIn); fclose($pipes[0]);
	    $dataOut = stream_get_contents($pipes[1]); fclose($pipes[1]);
	    return proc_close($process);
	}	
}
function execExternalAPI($url, $dataIn, &$dataOut) {
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL,$url); curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $dataIn);  // can also use http_build_query(['postvar1' => 'value1']);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // Receive server response ...
	$dataOut = curl_exec($ch);
	curl_close ($ch);
}

if (isset($_POST) && isset($_POST['operation']) && $_POST['operation'] == "learn") {

	execExternalAPI("http://localhost:8080/learn", implode("\n", $_POST["word"]), $dataOut);
	// execLocalProcess("./learn", implode("\n", $_POST["word"]), $dataOut);
	echo $dataOut;
}
if (isset($_POST) && isset($_POST['operation']) && $_POST['operation'] == "predict") {

	execExternalAPI("http://localhost:8080/predict", implode("\n", $_POST["word"]), $dataOut);
	// execLocalProcess("./learn", implode("\n", $_POST["word"]), $dataOut);
	echo $dataOut;
}

?>

</body>
</html>

