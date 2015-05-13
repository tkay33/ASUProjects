
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
          <li><a href="contact.php" class="selected">Contact</a></li>
        </ul>
      </nav>
    </header>
    <div id="wrapper">
      <section id="primary">
        <h3>General Information</h3>
        <p> Please fill out this form including as much detail as possible for us to provide you with the fastest and efficient customer support.</p>
      </section>
      <section id="secondary">
        <h3>Contact Form</h3>
        <!-- <ul class="contact-info">

        </ul> -->
        <?php if (isset($_GET["status"]) AND $_GET["status"] == "thanks") { ?>
                <p>Thanks for the email! I&rsquo;ll be in touch shortly!</p>
            <?php } else { ?>
              <form action="" method="post" class="smart-green">
                  <h1>Contact Form 
                      <span>Complete the form to send me an email.</span>
                  </h1>
                  <label>
                      <span>Your Name :</span>
                      <input id="name" type="text" name="name" placeholder="Your Full Name" />
                  </label>
                  
                  <label>
                      <span>Your Email :</span>
                      <input id="email" type="email" name="email" placeholder="Valid Email Address" />
                  </label>
                  
                  <label>
                      <span>Message :</span>
                      <textarea id="message" name="message" placeholder="Your Message to Us"></textarea>
                  </label> 
                   <label>
                      <span>Subject :</span><select name="selection">
                        <option value="Product Inquiry">General Inquiry</option>
                        <option value="Feedback">Feedback</option>
                        <option value="Complaint">Complaint</option>
                      </select>
                  </label>    
                   <label>
                      <span>&nbsp;</span> 
                      <input type="button" class="button" value="Send" /> 
                  </label>    
              </form>

            <?php } ?>
      </section>
      <footer>
        <p>&copy; 2015 Taruni Kancharla.</p>
      </footer>
    </div>
  </body>
</html>
