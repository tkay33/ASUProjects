<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Bayes Visualizer</title>
    <link rel="stylesheet" href="css/normalize.css">
    <link href='http://fonts.googleapis.com/css?family=Changa+One|Open+Sans:400italic,700italic,400,700,800' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Raleway:500,600,700,800,400' rel='stylesheet' type='text/css'>
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
          <li><a href="index.php" class="selected">Calculate</a></li>
          <li><a href="about.html">About</a></li>
          <li><a href="contact.php">Contact</a></li>
        </ul>
      </nav>
    </header>
    <br>
      <div id="wrapper">
      <section id = "calculate">
        <div id="first">
          <form action="calculate.php" method="post">
            <h3>Enter Details</h3>
            <h4>Please fill all entries.</h4>
            <label>Gender :</label><br><br>
            <input class="male" name="gender" type="radio" value="male">
            <label>Male</label><br>
            <input class="female" name="gender" type="radio" value="female">
            <label>Female</label> <br>
            <label>Age :</label>
            <input id="age" type="text" name="age">
            <label>Race :</label>
            <input id="race" type="text" name="race">
            <label >
            <span>Disease :</span>&nbsp; <br>
            <select id="Disease" name="Disease">
            <option value="Thyroid">Thyroid</option>
            <option value="Colorectal Cancer">Colorectal Cancer</option>
            </select>
            </label><br>
            <label>Prevalence :</label>
            <input id="prevalence" type="text" name= "prevalence">
            <input id="csubmit" type="submit" value="Submit">
            
          </form>
        </div>
      </section>

       <footer>
        <p>&copy; 2015 Taruni Kancharla.</p>
      </footer>
    </div>
  </body>
</html>
