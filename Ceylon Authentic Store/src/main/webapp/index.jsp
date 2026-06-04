<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ceylon Authentic Store</title>

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">

<style>

body{
    margin:0;
    font-family:Arial, sans-serif;
    overflow:hidden;
}

/* Full Background Section */

.welcome-section{

    height:100vh;

    background:
    linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.55)),
    url("images/image1.png");

    background-size:cover;
    background-position:center;
    background-repeat:no-repeat;

    display:flex;
    justify-content:center;
    align-items:center;

    text-align:center;

    color:white;
}

/* Content Area */

.content{
    padding:40px;
    animation:fadeIn 2s ease;
}

/* Main Heading */

.content h1{

    font-family:'Playfair Display', serif;

    font-size:78px;

    line-height:1.1;

    letter-spacing:2px;

    margin-bottom:25px;

    text-shadow:2px 2px 10px rgba(0,0,0,0.5);
}

/* Paragraph */

.content p{

    font-size:28px;

    line-height:1.6;

    margin-bottom:40px;

    max-width:900px;
}

/* Button */

.btn{

    display:inline-block;

    padding:16px 40px;

    background:#ffc107;

    color:#0f5132;

    text-decoration:none;

    border-radius:40px;

    font-size:18px;

    font-weight:bold;

    transition:0.3s;
}

/* Button Hover */

.btn:hover{

    background:white;

    color:#0f5132;

    transform:translateY(-5px);

    box-shadow:0 0 20px #ffc107;
}

/* Animation */

@keyframes fadeIn{

    from{
        opacity:0;
        transform:translateY(30px);
    }

    to{
        opacity:1;
        transform:translateY(0);
    }
}

</style>

</head>

<body>

<div class="welcome-section">

    <div class="content">

        <h1>
            Authentic Sri Lankan <br>
            Heritage
        </h1>

        <p>
            Discover premium Ceylon tea, spices,
            handcrafted items, and natural treasures.
        </p>

        <a href="home" class="btn">
            Explore Products
        </a>

    </div>

</div>

</body>
</html>