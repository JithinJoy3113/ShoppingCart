<div class="d-flex flex-column justify-content-center align-items-center">
    <form action="" method="post" id="signUpForm">
        <div class="signupDiv d-flex flex-column justify-content-center">
            <span class="signupHead fw-bold mx-auto my-4">User Sign Up</span>
            <div class="d-flex flex-column justify-content-center inputDiv">
                <input type="text" class="textField mt-3" name="firstName" id="firstName" placeholder="Enter First Name">
                <span class="mailError fw-bold text-danger" id="fnameError"></span>
                <input type="text" class="textField mt-3" name="lastName" id="lastName" placeholder="Enter Last Name">
                <span class="mailError fw-bold text-danger" id="lnameError"></span>
                <input type="text" class="textField mt-3" name="userName" id="userName" placeholder="Enter User Email">
                <span class="mailError fw-bold text-danger" id="mailError"></span>
                <input type="text" class="textField mt-3" name="userPhone" id="userPhone" placeholder="Enter User Mobile">
                <span class="mailError fw-bold text-danger" id="phoneError"></span>
                <input type="text" name="password" class="textField passwordInput mt-3" id="password" placeholder="Enter the password">
                <span class="passwordError fw-bold text-danger" id="passwordError"></span>
                <input type="text" class="textField confirmInput mt-3" id="confirmPassword" name="confirmPassword" placeholder="Re-enter the password">
                <span class="confirmpasswordError fw-bold text-danger" id="confirmpasswordError"></span>
            </div>
            <button type="submit" name="submit" class="fw-bold signUpButton mt-4 mx-auto" onClick="return signUpValidate()">SignUp</button>
            <a href="login.cfm" class="text-decoration-none fw-bold mx-auto my-3 text-dark">Already have account? Login</a>
        </div>
    </form>
    <cfif structKeyExists(form, "submit")>
        <cfset local.result = application.obj.userSignUp(
                                        firstName = form.firstName,
                                        lastName = form.lastName,
                                        userName = form.userName,
                                        userPhone = form.userPhone,
                                        password = form.password,
                                        confirmPassword = form.confirmPassword
                                        )>
        
        <cfif local.result>
            <cfif structKeyExists(URL, "productId")>
                <cfset local.login = application.obj.userLogin(
                                                userName = form.userName,
                                                password = form.password )>
                <cfset local.cart = application.obj.addToCart(productId = URL.productId)>
                <cfif local.cart>
                    <cflocation url="cart.cfm">
                </cfif>
            </cfif>
            <span class="text-success fw-bold">SignUp Completed</span>
        <cfelse>
            <span class="text-danger fw-bold">User Name already exists</span>
        </cfif>     
    </cfif>
</div>