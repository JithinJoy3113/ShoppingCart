<cfoutput>
    <div class="d-flex flex-column justify-content-center align-items-center">
        <cfif structKeyExists(URL, "productId")>
            <cfset local.encryptedProductId = urlEncodedFormat(encrypt(URL.productId, application.secretKey, "AES", "Base64"))>
            <input type="hidden" value=#local.encryptedProductId# id="buyProductId">
            <cfdump  var="#local.encryptedProductId#">
        </cfif>
        <form action="" method="post" id="signUpForm">
            <div class="signupDiv d-flex flex-column justify-content-center">
                <span class="signupHead fw-bold mx-auto my-4">User Sign Up</span>
                <div class="d-flex flex-column justify-content-center inputDiv">
                    <input type="text" class="textField mt-3 " name="firstName" id="firstName" oninput="removeSpan('firstName')" placeholder="Enter First Name">
                    <span class="mailError fw-bold text-danger" id="fnameError"></span>
                    <input type="text" class="textField mt-3" name="lastName" id="lastName" oninput="removeSpan('lastName')" placeholder="Enter Last Name">
                    <span class="mailError fw-bold text-danger" id="lnameError"></span>
                    <input type="text" class="textField mt-3" name="userName" id="userName" oninput="removeSpan('userName')" placeholder="Enter User Email">
                    <span class="mailError fw-bold text-danger" id="mailError"></span>
                    <input type="text" class="textField mt-3" name="userPhone" id="userPhone" oninput="removeSpan('userPhone')" placeholder="Enter User Mobile">
                    <span class="mailError fw-bold text-danger" id="phoneError"></span>
                    <input type="text" name="password" class="textField passwordInput mt-3" id="password" oninput="removeSpan('password')" placeholder="Enter the password">
                    <span class="passwordError fw-bold text-danger" id="passwordError"></span>
                    <input type="text" class="textField confirmInput mt-3" id="confirmPassword" oninput="removeSpan('confirmPassword')" name="confirmPassword" placeholder="Re-enter the password">
                    <span class="confirmpasswordError fw-bold text-danger" id="confirmpasswordError"></span>
                </div>
                <span class="fw-bold" id="signUpResult"></span>
                <button type="button" name="submit" class="fw-bold signUpButton mt-4 mx-auto" onClick="return signUpValidate(this)" 
                    <cfif structKeyExists(URL, "productId")>
                        value = #URL.productId#
                        <cfelse>
                            value=""
                    </cfif>>SignUp
                </button>
                <a href="login.cfm" class="text-decoration-none fw-bold mx-auto my-3 text-dark">Already have account? Login</a>
            </div>
        </form>
                <!--- <cfif structKeyExists(form, "userName") AND structKeyExists(form, "password")>
                    <cfif structKeyExists(URL, "productId")>
                        <cfset local.login = application.obj.userLogin(
                            userName = form.userName,
                            password = form.password 
                            )>
                            <cfset local.cart = application.obj.addToCart(productId = URL.productId)>
                                <cfif local.cart>
                                    <cflocation url="cart.cfm">
                                    </cfif>
                                    <cfelse>
                                        <span class = "fw-bold text-success">SignUp Completed</span>
                                    </cfif>
                                </cfif> --->
    </div>
</cfoutput>