<cfoutput>
    <div class="d-flex accordianBody" id="accordianBody">
        <div class="accordion accordion-flush orderAccordianUser" id="accordionFlushExample">
            <div class="accordion-item">
                <h2 class="accordion-header" id="flush-headingOne">
                    <button class="titleDiv topBtn" type="button" data-bs-toggle="collapse" data-bs-target="##flush-collapseOne" id="top" value="top" aria-expanded="true" aria-controls="flush-collapseOne" onclick="accordianHead(this)">
                        User Details
                    </button>
                </h2>
                <div id="flush-collapseOne" class="accordion-collapse collapse show" aria-labelledby="flush-headingOne" data-bs-parent="##accordionFlushExample">
                    <div class="accordion-body">
                        <div class = "accordianUserDetailsDiv d-flex flex-column">
                            <span class = "userInfo fw-bold">#session.firstName# #session.lastName#</span>
                            <span class = "userInfo">#session.userMail#</span>
                            <span class = "userInfo">#session.phone#</span>
                        </div>
                        <div class="d-flex justify-content-end">
                            <button class="accordianBtn" type="button" data-bs-toggle="collapse" value="one" data-bs-target="##flush-collapseTwo" aria-expanded="false" onclick="accordianHead(this)" aria-controls="flush-collapseOne">
                                Continue
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header" id="flush-headingTwo">
                    <button class="titleDiv" type="button" id="one" data-bs-toggle="collapse" value="one" data-bs-target="##flush-collapseTwo" aria-expanded="false" aria-controls="flush-collapseTwo" onclick="accordianHead(this)">
                        Delivery Address
                    </button>
                </h2>
                <div id="flush-collapseTwo" class="accordion-collapse collapse" aria-labelledby="flush-headingTwo" data-bs-parent="##accordionFlushExample">
                    <div class="accordion-body">
                        <span class = "addressAddSpan pb-3">
                            <button type="button" value="" class = "addAddressBtn border-0 d-flex align-items-center" onclick = "openAddressModal()">
                                <img src="Assets/Images/plus.png" alt="" width="18" height="18" class = "me-2"> ADD NEW ADDRESS
                            </button>
                        </span>
                        <div class = "accordianAddressDiv d-flex flex-column" id="accordianAddressDiv">
                            <cfset variables.address = application.obj.fetchAddress()>
                            <cfset variables.arrayLength = arrayLen(variables.address)>
                            <cfif variables.arrayLength GT 0>
                                <cfloop array="#variables.address#" item="item" index="index">
                                    <div class="d-flex align-items-center" id="accordianAddressSelect">
                                        <input type="radio" name="addressRadio" value="#item.addressID#" 
                                            <cfif index == 1>
                                                checked
                                            </cfif>
                                        >
                                        <div class = "addressDiv d-flex flex-column">
                                            <span class="addressNameSpan fw-bold">#item.firstName# #item.lastName#
                                                <span class="ms-2 addressPhoneSpan">#item.phone#</span>
                                            </span>
                                            <span class="addressSpan">
                                                #item.addressOne#, #item.addressTwo#, #item.city#, #item.state#, #item.pincode#
                                            </span>
                                        </div>
                                    </div>
                                </cfloop>
                            <cfelse>
                                <span class = "fw-bold" id="addAddressErrorSpan">Add Address</span>
                            </cfif>
                        </div>
                        <div class="d-flex justify-content-end">
                            <button class="accordianBtn
                                <cfif variables.arrayLength EQ 0>
                                    disabled
                                </cfif>" type="button" data-bs-toggle="collapse" value="two" id="orderAddressBtn" data-bs-target="##flush-collapseThree" aria-expanded="false" onclick="accordianHead(this)" aria-controls="flush-collapseTwo"
                            >Save</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header" id="flush-headingThree">
                    <button type = "button" class="titleDiv" data-bs-toggle="collapse" id="two" value="two" aria-expanded="false" data-bs-target="##flush-collapseThree" onclick="accordianHead(this)" aria-controls="flush-collapseThree">
                        Order Summary
                    </button>
                </h2>
                <div id="flush-collapseThree" class="accordion-collapse collapse" aria-labelledby="flush-headingThree" data-bs-parent="##accordionFlushExample">
                    <div class="accordion-body accordianScroll">
                        <cfset variables.totalAmount = 0>
                        <cfset variables.productId = "">
                        <cfif structKeyExists(URL, "productId")>
                                <cfset variables.productId = decrypt(URL.productId, application.secretKey, "AES", "Base64")>
                                <cfset variables.cartItems = application.obj.cartItems(productId = variables.productId)>
                        <cfelse>
                            <cfset variables.cartItems = application.obj.cartItems()>
                        </cfif>
                        <cfset variables.cartItems = application.obj.cartItems()>
                        <cfset variables.productDetails =  variables.cartItems['productDetails']>
                        <cfset variables.orderTotal = variables.cartItems['orderTotal']>
                        <cfset variables.items = arrayLen(variables.productDetails)>
                        <div class = "accordianOrderDiv">
                            <cfloop array="#variables.productDetails#" item="item">
                                <input type="hidden" id="orderPriceInput#item.productId#" value="#item.price#">
                                <input type="hidden" id="orderTaxInput#item.productId#" value="#item.tax#">
                                <div class="cartItemsdiv d-flex flex-column mt-2 bg-white" id="div#item.cartId#">
                                    <div class="itemMain d-flex flex-column">
                                        <div class="itemDiv d-flex">
                                            <img src="Assets/uploadImages/#item.file#" class="" alt="" width="93" height="112">
                                            <div class="detailsDiv">
                                                <div class="itemName d-flex flex-column">
                                                    <cfset variables.encryptedSubcategoryId = urlEncodedFormat(encrypt(item.subcategoryId, application.secretKey, "AES", "Base64"))>
                                                    <cfset variables.encryptedProductId = urlEncodedFormat(encrypt(item.productId, application.secretKey, "AES", "Base64"))>
                                                    <a href="product.cfm?productId=#variables.encryptedProductId#&subcategoryId=#variables.encryptedSubcategoryId#" class="nameLink text-decoration-none">#item.productName#</a>
                                                    <span class = "orderBrand">Brand : #item.brandName#</span>
                                                </div>
                                                <div class="priceDetailsDiv d-flex flex-column mt-2">
                                                    <span class="amount green">Price :<span class="amount green"  id = "price#item.productId#"> #item.price * item.quantity#</span></span>
                                                    <span class="number">Tax : <span class="number" id="tax#item.productId#">#decimalFormat(item.totalTax)#</span><span> (#numberFormat(item.Tax)# %)</span></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="removeDiv d-flex justify-content-between">
                                            <div class="UpdateQuantityDiv d-flex">
                                                <button type="button" class = "quantityBtn me-2 minusBtn" value = "Minus,#item.cartId#" id="minus#item.cartId#" onclick="updateQuantity(this)"
                                                    <cfif item.quantity EQ 1>
                                                        disabled
                                                    </cfif>
                                                >-</button>
                                                <span id="quantity#item.cartId#" data-value = "#item.quantity#">#item.quantity#</span>
                                                <button type="button" class = "quantityBtn ms-2" value = "Plus,#item.cartId#" onclick="updateQuantity(this)">+</button>
                                            </div>
                                            <button class="later me-5 border-0" type = "button" value = #item.cartId# onClick= "deleteAddress(this)">REMOVE</button>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        </div>
                        <div class="d-flex justify-content-end">
                            <button class="accordianBtn" type="button" data-bs-toggle="collapse" value="three" data-bs-target="##flush-collapseFour" onclick="accordianHead(this)" aria-expanded="false" aria-controls="flush-collapseThree">
                                Payment
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header" id="flush-headingOne">
                    <button type = "button" class="titleDiv" data-bs-toggle="collapse" id="three" aria-expanded="false" data-bs-target="##flush-collapseFour" onclick="accordianHead(this)" value="three" aria-controls="flush-collapseFour">
                        Payment
                    </button>
                </h2>
                <div id="flush-collapseFour" class="accordion-collapse collapse" aria-labelledby="flush-headingOne" data-bs-parent="##accordionFlushExample">
                    <div class="accordion-body">
                        <div class = "accordianCardDiv d-flex flex-column">
                            <span class="fw-bold my-2">Card Details</span>
                            <div class="cardNumberDiv d-flex">
                                <input type="text" id="cardNumberInput" name="cardNumberInput" class="w-50 cardNumberInput productInput" placeholder="Enter your card number" maxlength="14" required pattern="\d{4}(\s?\d{4}){3}" oninput="checkCard()">
                                <input type="text" name="cardCVVInput" id="cardCVVInput" class="ms-2 w-25 cardCVVInput productInput" maxlength="3" placeholder="CVV" oninput="checkCard()">
                            </div>
                        </div>
                        <div class="d-flex justify-content-end">
                            <span class="text-danger fw-bold removeSpan me-4" id="cardError"></span>
                            <button class="mt-2 accordianBtn disabled" type="button" data-bs-toggle="collapse" onclick="buyProduct('#variables.productId#')" aria-expanded="false" aria-controls="flush-collapseOne" id="paymentButon">
                                PAY &##8377<span class="btnPrice" value="" id="btnPrice">#variables.orderTotal.orderAmount+variables.orderTotal.orderTax#</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="orderRightdiv w-100">
            <div class="priceDetailsdiv bg-white">
                <div class="priceDetails">
                    <span class="priceHead">PRICE DETAILS</span>
                </div>
                <div class="priceMaindiv d-flex flex-column">
                    <div class="price d-flex justify-content-between pt-2">
                        <span class="amount">Price (#variables.items# items)</span>
                        <span class="number" id="orderTotalAmount" data-value="#variables.orderTotal.orderAmount#">&##8377 #variables.orderTotal.orderAmount#</span>
                    </div>
                    <div class="price d-flex justify-content-between pt-2">
                        <span class="amount">Tax</span>
                        <span class="number" id="orderTotalTax" data-value="#variables.orderTotal.orderTax#">&##8377 #decimalFormat(variables.orderTotal.orderTax)#</span>
                    </div>
                    <div class="price d-flex justify-content-between align-items-center">
                        <span class="amount">Delivery Charges</span>
                        <span class="deliverySpan d-flex align-items-center">
                            <span class="number text-decoration-line-through">&##8377 200</span>
                            <span class="number green">Free</span>
                        </span>
                    </div>
                    <div class="price d-flex justify-content-between py-3">
                        <span class="totalAmount">Total Amount</span>
                        <span class="totalAmount" id="orderAmount">&##8377 #variables.orderTotal.orderAmount+variables.orderTotal.orderTax#</span>
                    </div>
                </div>
            </div>
            <div class="safeDiv d-flex mt-4 ps-3">
                <img src="Assets/Images/safeguard.PNG" class="ms-1" alt="" width="25" height="30"> 
                <span class="safe ms-2">Safe and Secure Payments.Easy returns.100% Authentic products.</span>
            </div>
        </div>
    </div>
    <div class = "addressModal accordianAddressModal pb-3 fw-bold mt-2" id="addressModal">
        <form action="" method="post" id="addressForm">
            <span class="addressHead px-2 py-3">Add New Address</span>
            <div class="addressNameDiv d-flex py-3">
                <input type="text" placeholder="FirstName" class="productInput" name="firstName">
                <input type="text" placeholder="LastName" class="productInput ms-2" name="lastName">
            </div>
            <span class="text-danger removeSpan" id="profileFirstNameError"></span>
            <div class="addressLineDiv d-flex py-3">
                <textarea name="addressOne" id="lineOne" placeholder="Address Line 1" class="productInput"></textarea>
                <textarea name="addressTwo" id="lineTwo" placeholder="Address Line 2 " class="productInput ms-2"></textarea>
            </div>
            <span class="text-danger removeSpan" id="profileAddressOneError"></span>
            <div class="stateDiv d-flex py-3">
                <input type="text" class="productInput" placeholder="City" name="city">
                <input type="text" class="productInput  ms-2" placeholder="State" name="state">
            </div>
            <div class="d-flex justify-content-between">
                <span class="text-danger removeSpan" id="profileCityError"></span>
                <span class="text-danger removeSpan" id="profileStateError"></span>
            </div>
            <div class="pinDiv d-flex py-3">
                <input type="text" class="productInput" placeholder="Pincode" name="pincode">
                <input type="text" class="productInput ms-2" placeholder="Phone" name="phone">
            </div>
            <div class="d-flex justify-content-between">
                <span class="text-danger removeSpan" id="profilePincodeError"></span>
                <span class="text-danger removeSpan" id="profilePhoneError"></span>
            </div>
            <div class="d-flex justify-content-center py-3">
                <button type="button" value="" class="addAddressClose" onclick="addAddressCloseBtn()">Cancel</button>
                <button type="button" value="" class="addCategory" onclick="addAddressBtn()">Submit</button>
            </div>
        </form>
    </div>
    <div class="deleteConfirm mx-auto mb-4" id="deleteConfirm">
        <span class="logourtAlertHead py-2 d-flex justify-content-center fw-bold text-white">Delete Item</span>
        <div class="logoutMesage  d-flex flex-column justify-content-center">
            <span class="confirmMessage fw-bold">Are you sure want to Delete?</span>
            <button class="alertBtn mt-3" type="button" name="alertDeleteBtn" value="" id="alertCartDeleteBtn" value="" onClick="return removeCartItem(this)">Delete</button>
            <button class="alertCancelBtn mt-2" type="button" name="alertDeleteBtn" id="" value="cancel" onClick="return deleteAlert(this)">Cancel</button>
        </div>
    </div>
    <div class="orderSuccessDiv align-items-center" id="orderSuccessDiv">
        <img src="Assets/Images/ordersuccess.png" alt="" width="100" height="100">
        <span class="successMessage fw-bold text-success mt-3">Order Placed Successfully</span>
        <div class="d-flex justify-content-center align-items-center">
            <a href="orderHistory.cfm" class="text-decoration-none historyBtn">Orders</a>
        </div>
    </div>
</cfoutput>