<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login In</title>
        <link rel = "stylesheet" href = "Assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="Assets/css/style.css">
    </head>
    <body class="signupBody">
        <div class="signUpHeader d-flex justify-content-center">
           <div class="cartLogoDiv d-flex justify-content-center align-items-center">
                <img src="Assets/Images/shoppingBag.png" alt="" width="20" height="20">
                <span class="cartNameLogo ms-2">
                    clickCart
                </span>
            </div>
        </div>
        <div class="d-flex flex-column justify-content-center align-items-center">
            <form action="" method="post" id="loginForm">
                <div class="signupDiv d-flex flex-column justify-content-center">
                    <span class="signupHead fw-bold mx-auto my-4">User Login</span>
                    <div class="d-flex flex-column justify-content-center inputDiv">
                        <input type="text" class="userNameInput textField" id="userName" name="userName" placeholder="Enter User Name">
                        <span class="mailError fw-bold text-danger" id="mailError"></span>
                        <input type="text" class="passwordInput mt-3 textField" id="password" name="password" placeholder="Enter your password">
                        <span class="passwordError fw-bold text-danger" id="passwordError"></span>
                    </div>
                    <button type="submit" name="submit" class="signUpButton mt-4 mx-auto" onClick="return loginValidation()">Login</button>
                    <a href="signup.cfm" class="text-decoration-none fw-bold mx-auto mt-3 text-dark">Create account</a>
                    <span id="existError" class="fw-bold text-danger" ></span>
                </div>
            </form>
            <cfif structKeyExists(form, "submit")>
                <cfset local.obj = new components.component()>
                <cfset local.result = local.obj.validUser(form.userName,form.password)>
                <cfif session.role EQ 1>
                    <cflocation  url="admin.cfm">
                <cfelseif session.role EQ 2>
                    <cflocation  url="user.cfm">
                <cfelse>
                    <span class="text-danger fw-bold">Invalid username/password</span>
                
                </cfif>
            </cfif>
        </div>
        <script src="js/script.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
    </body>
</html>