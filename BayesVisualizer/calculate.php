<html>
  <head>
    <meta charset="utf-8">
    <title>Bayes Visualizer</title>
    <link rel="stylesheet" href="css/normalize.css">
    <link href='http://fonts.googleapis.com/css?family=Changa+One|Open+Sans:400italic,700italic,400,700,800' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/responsive.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  </head>
  <body>
    <header>
      <a href="index.php" id="logo">
        <h1>Bayes Visualizer</h1>
        <h2>Diagnostic Test Recommender</h2>
      </a>
      <nav>
        <ul>
          <li><a href="index.php">Calculate</a></li>
          <li><a href="about.html">About</a></li>
          <li><a href="contact.php">Contact</a></li>
        </ul>
      </nav>
    </header>
    <div id="wrapper">
      <section>
        <h3>Results</h3>
        <p><?php
		//echo "I have information from a form. Now what?";
		//var_dump($_POST);
		$prevalence = $_POST["prevalence"];
		$pretestodds = $prevalence / (100-$prevalence);
		$disease = $_POST["Disease"];
		$thyroid_tests = array();
		$thyroid_tests[0] = array(
			"code" => "TSH",
			"name" => "TSH",
			"sensitivity" => "94",
			"specificity" => "94",
			"LR+" => "15.6667",
			"LR-" => "0.0638",
			"Risk" => "N/A",
			"cost" => "79$"
			);
		$thyroid_tests[1] = array(
			"code" => "T3",
			"name" => "T3",
			"sensitivity" => "82",
			"specificity" => "94",
			"LR+" => "13.6667",
			"LR-" => "0.1914",
			"Risk" => "N/A",
			"cost" => "99$"
			);
		$thyroid_tests[2] = array(
			"code" => "T4",
			"name" => "T4",
			"sensitivity" => "86",
			"specificity" => "88",
			"LR+" => "7.1667",
			"LR-" => "0.1590",
			"Risk" => "N/A",
			"cost" => "129$"
			);
		$colorectal_tests = array();
		$colorectal_tests[0] = array(
			"code" => "FOBT",
			"name" => "FOBT",
			"sensitivity" => "55",
			"specificity" => "95.25",
			"LR+" => "11.5789",
			"LR-" => "0.4724",
			"Risk" => "N/A",
			"cost" => "10$"
			);
		$colorectal_tests[1] = array(
			"code" => "FS",
			"name" => "Flexible sigmoidoscopy",
			"sensitivity" => "95",
			"specificity" => "92",
			"LR+" => "11.875",
			"LR-" => "0.0543",
			"Risk" => "GIT bleeding, GIT perforation, cardiovascular risk, abdominal pain",
			"cost" => "300$"
			);
		$colorectal_tests[2] = array(
			"code" => "CS",
			"name" => "Colonoscopy",
			"sensitivity" => "95",
			"specificity" => "90",
			"LR+" => "9.5",
			"LR-" => "0.0555",
			"Risk" => "GIT bleeding, GIT perforation, cardiovascular risk, abdominal pain",
			"cost" => "1000$"
			);
		$colorectal_tests[3] = array(
			"code" => "FI",
			"name" => "Fecal immunochemistry",
			"sensitivity" => "70",
			"specificity" => "95",
			"LR+" => "14",
			"LR-" => "0.3157",
			"Risk" => "N/A",
			"cost" => "10$"
			);
		$colorectal_tests[3] = array(
			"code" => "FDNA",
			"name" => "Fecal DNA",
			"sensitivity" => "85",
			"specificity" => "90",
			"LR+" => "8.5",
			"LR-" => "0.1667",
			"Risk" => "N/A",
			"cost" => "10$"
			);
		//echo $disease;
		?> </p>
		<ul>
		<?php if ($disease == "Thyroid") { 
			foreach ($thyroid_tests as $test) {
				$positiveposttestodds = $pretestodds * $test["LR+"];
				$positiveposttestprobability = $positiveposttestodds / (1+$positiveposttestodds); 
				$negativeposttestodds = $pretestodds * $test["LR-"];
				$negativeposttestprobability = $negativeposttestodds / (1+$negativeposttestodds); 
				echo "<li> <h4><b>".$test["name"]."</b></h4><p> <b>Post-test Probability given test is positive:</b> ".$positiveposttestprobability."</p>";
				echo "<p> <b>Post-test Probability given test is negative:</b> ".$negativeposttestprobability."</p>";
				echo "<p> <b>Risk:</b> ".$test["Risk"]."</p>";
				echo "<p> <b>Cost:</b> ".$test["cost"]."</p>"."</li>";
			} ?>
			
			<?php } elseif ($disease == "Colorectal Cancer") { 
				foreach ($colorectal_tests as $test) {
				$positiveposttestodds = $pretestodds * $test["LR+"];
				$positiveposttestprobability = $positiveposttestodds / (1+$positiveposttestodds); 
				$negativeposttestodds = $pretestodds * $test["LR-"];
				$negativeposttestprobability = $negativeposttestodds / (1+$negativeposttestodds); 
				echo "<li> <h4><b>".$test["name"]."</b></h4><p> <b>Post-test Probability given test is positive:</b> ".$positiveposttestprobability."</p>";
				echo "<p> <b>Post-test Probability given test is negative:</b> ".$negativeposttestprobability."</p>";
				echo "<p> <b>Risk:</b> ".$test["Risk"]."</p>";
				echo "<p> <b>Cost:</b> ".$test["cost"]."</p>"."</li>";
			} 
			}?>
		</ul>
      </section>
      <footer>
        <p>&copy; 2015 Taruni Kancharla.</p>
      </footer>
    </div>
  </body>
</html>
