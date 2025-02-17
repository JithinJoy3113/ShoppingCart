<cfoutput>
    <div class="d-flex flex-column justify-content-center align-items-center">
        <form action="" method="post" id="loginForm">
            <div class="signupDiv d-flex flex-column justify-content-center">
                <span class="signupHead fw-bold mx-auto my-4">Login</span>
                <div class="d-flex flex-column justify-content-center inputDiv">
                    <input type="text" class="userNameInput textField" id="userName" name="userName"  oninput="removeSpan('userName')" placeholder="Enter User Name">
                    <span class="mailError fw-bold text-danger" id="loginMailError"></span>
                    <input type="text" class="passwordInput mt-3 textField" id="userPassword" name="password"  oninput="removeSpan('userPassword')" placeholder="Enter your password">
                    <span class="passwordError fw-bold text-danger" id="loginPasswordError"></span>
                </div>
                <span class="text-danger fw-bold" id="loginResult"></span>
                <button type="button" name="loginSubmit" class="signUpButton mt-4 mx-auto" id="loginBtn" onclick="return loginValidation()">Login</button>
                <!--- <a href="signup.cfm" class="text-decoration-none fw-bold mx-auto mt-3 text-dark">Create account</a> --->
                <span id="existError" class="fw-bold text-danger" ></span>
            </div>
        </form>

        <cfif structKeyExists(form, "userName") AND structKeyExists(form, "password")>
            <cfif structKeyExists(URL, "cartLogin")>
                <cflocation  url="cart.cfm" addtoken="no">
            <cfelseif session.roleId EQ 1>
                <cflocation  url="admin.cfm" addtoken="no">
            <cfelseif session.roleId EQ 2>
                <cfif structKeyExists(url, "productId")>
                    <cfset local.cart = application.obj.addToCart(productId = URL.productId)>
                    <cfif structKeyExists(URL, "page")>
                        <cfset local.encryptedProductId = urlEncodedFormat(encrypt(URL.productId, application.secretKey, "AES", "Base64"))>
                        <cflocation url="order.cfm?productId=#local.encryptedProductId#&page=buy" addtoken="no">
                    <cfelseif local.cart EQ 'cart exist'>
                        <cflocation url="cart.cfm">
                    <cfelse> 
                        <cflocation url="cart.cfm">
                    </cfif>
                <cfelse>
                    <cflocation  url="homePage.cfm" addtoken="no">
                </cfif>
            <cfelse>
                <cflocation  url="homePage.cfm" addtoken="no">
            </cfif>
        </cfif>
    </div>
</cfoutput>