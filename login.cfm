<cfoutput>
    <div class="d-flex flex-column justify-content-center align-items-center">
        <form action="" method="post" id="loginForm">
            <div class="signupDiv d-flex flex-column justify-content-center">
                <span class="signupHead fw-bold mx-auto my-4">Login</span>
                <div class="d-flex flex-column justify-content-center inputDiv">
                    <input type="text" class="userNameInput textField" id="userName" name="userName"  oninput="removeSpan('userName')" placeholder="Enter User Name">
                    <span class="mailError fw-bold text-danger" id="loginMailError"></span>
                    <input type="password" class="passwordInput mt-3 textField" id="userPassword" name="password"  oninput="removeSpan('userPassword')" placeholder="Enter your password">
                    <span class="passwordError fw-bold text-danger" id="loginPasswordError"></span>
                </div>
                <span class="text-danger fw-bold" id="loginResult"></span>
                <button type="button" name="loginSubmit" class="signUpButton mt-4 mx-auto" id="loginBtn" onclick="return loginValidation()">Login</button>
                <span id="existError" class="fw-bold text-danger" ></span>
            </div> 
        </form>
        <cfif structKeyExists(session, "role")>
            <cfif structKeyExists(URL, "cartLogin")>
                <cflocation  url="cart.cfm" addtoken="no">
            <cfelseif structKeyExists(URL, "page")>
                <cfset variables.productDetails = application.obj.updateProductquantity(productId = URL.productId)>
                <cfset variables.encryptedProductId = urlEncodedFormat(encrypt(URL.productId, application.secretKey, "AES", "Base64"))>
                <cflocation  url="order.cfm?productId=#variables.encryptedProductId#" addtoken="no">
            <cfelseif structKeyExists(session, "role") AND structKeyExists(URL, "productId")>
                <cfset variables.cart = application.obj.addToCart(productId = URL.productId)>
                <cflocation  url="cart.cfm" addtoken="no">
            <cfelseif session.roleId EQ 1>
                <cflocation  url="admin.cfm" addtoken="no">
            <cfelseif session.roleId EQ 2>
                <cflocation  url="homePage.cfm" addtoken="no">
            </cfif>
        </cfif>
    </div>
</cfoutput>