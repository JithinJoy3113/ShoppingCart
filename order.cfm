<cfoutput>
    <div class="d-flex accordianBody" id="accordianBody">
        <div class="accordion accordion-flush" id="accordionFlushExample">
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
                                Save
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
                        <div class = "accordianAddressDiv">
                            <cfset local.address = application.obj.fetchAddress()>
                            <cfloop array="#local.address#" item="item" index="index">
                                <div class="d-flex align-items-center">
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
                        </div>
                        <div class="d-flex justify-content-end">
                            <button class="accordianBtn" type="button" data-bs-toggle="collapse" value="two" data-bs-target="##flush-collapseThree" aria-expanded="false" onclick="accordianHead(this)" aria-controls="flush-collapseTwo">
                                Save
                            </button>
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
                    <div class="accordion-body">
                        <cfif structKeyExists(URL, "cartId")>
                            <cfset local.cartItems = application.obj.cartItems()>
                        <cfelseif structKeyExists(URL, "productId")>
                            <cfset local.productId = decrypt(URL.productId, application.secretKey, "AES", "Base64")>
                            <cfset local.cartItems = application.obj.viewProducts(productId = local.productId)>
                        </cfif>
                        <cfset local.items = arrayLen(local.cartItems)>
                        <div class = "accordianOrderDiv">
                            <cfset local.totalPrice = 0>
                            <cfset local.totalTax = 0>
                            <cfloop array="#local.cartItems#" item="item">
                                <cfset local.productId = item.productId>
                                <cfif structKeyExists(item, "quantity")>
                                    <cfset local.quantity = item.quantity>
                                    <cfset local.totalPrice += item.totalPrice>
                                    <cfset local.totalTax += item.totalTax>
                                <cfelse>
                                    <cfset local.quantity = 1>
                                    <cfset local.totalPrice += item.price>
                                    <cfset local.totalTax += item.tax>
                                </cfif>
                                <input type="hidden" id="orderPriceInput#item.productId#" value="#item.price#">
                                <input type="hidden" id="orderTaxInput#item.productId#" value="#item.tax#">
                                <div class="cartItemsdiv d-flex flex-column mt-2 bg-white" id="div#item.productId#">
                                    <div class="itemMain d-flex flex-column">
                                        <div class="itemDiv d-flex">
                                            <img src="Assets/uploadImages/#item.file#" class="" alt="" width="93" height="112">
                                            <div class="detailsDiv">
                                                <div class="itemName d-flex flex-column">
                                                    <cfset local.encryptedSubcategoryId = urlEncodedFormat(encrypt(item.subcategoryId, application.secretKey, "AES", "Base64"))>
                                                    <cfset local.encryptedProductId = urlEncodedFormat(encrypt(item.productId, application.secretKey, "AES", "Base64"))>
                                                    <a href="product.cfm?productId=#local.encryptedProductId#&subcategoryId=#local.encryptedSubcategoryId#" class="nameLink text-decoration-none">#item.productName#</a>
                                                </div>
                                                <div class="priceDetailsDiv d-flex flex-column mt-2">
                                                    <span class="amount green">Price :<span class="amount green"  id = "price#item.productId#" data-value=#item.price#> #item.price#</span></span>
                                                    <span class="number">Tax : <span class="number" id="tax#item.productId#" data-value=#item.tax#>#item.tax#</span></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="removeDiv d-flex justify-content-between">
                                            <div class="UpdateQuantityDiv d-flex">
                                                <button type="button" class = "quantityBtn me-2 minusBtn" value = "Minus,#item.productId#" id="minus#item.productId#" onclick="updateQuantityOrder(this)"
                                                    <cfif local.quantity EQ 1>
                                                        disabled
                                                    </cfif>
                                                >-</button>
                                                <span id="quantity#item.productId#" data-value = "#local.quantity#" class = "quantitySpan">#local.quantity#</span>
                                                <button type="button" class = "quantityBtn ms-2" value = "Plus,#item.productId#" onclick="updateQuantityOrder(this)">+</button>
                                            </div>
                                            <button class="later me-5 border-0" type = "button" value = #item.productId#  onClick= "removeOrderItem(this)">REMOVE</button>
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
                                <input type="text" name="cardNumberInput" id="cardNumberInput" class="w-50 form-control cardNumberInput" placeholder="Enter Card Number">
                                <input type="text" name="cardCVVInput" id="cardCVVInput" class="ms-2 w-25 form-control cardCVVInput" placeholder="CVV">
                            </div>
                        </div>
                        <div class="d-flex justify-content-end">
                            <cfset local.payAmount = local.totalPrice+local.totalTax>
                            <span class="text-danger fw-bold removeSpan me-4" id="cardError"></span>
                            <button class="mt-2 accordianBtn" type="button" data-bs-toggle="collapse" value="#local.productId#" onclick="buyProductBtn(this)" aria-expanded="false" aria-controls="flush-collapseOne">
                                PAY &##8377<span class="btnPrice" id="btnPrice">#local.payAmount#</span>
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
                        <span class="amount">Price (#local.items# items)</span>
                        <span class="number" id="orderTotalAmount" data-value="#local.totalPrice#">&##8377 #local.totalPrice#</span>
                    </div>
                    <div class="price d-flex justify-content-between pt-2">
                        <span class="amount">Tax</span>
                        <span class="number" id="orderTotalTax" data-value="#local.totalTax#">&##8377 #local.totalTax#</span>
                    </div>
                   <!---  <div class="price d-flex justify-content-between">
                        <span class="amount">Discount</span>
                        <span class="number green">&##8722 &##8377 11,961</span>
                    </div>
                    <div class="price d-flex justify-content-between">
                        <span class="amount">Coupons for you</span>
                        <span class="number green">&##8722 187</span>
                    </div> --->
                    <div class="price d-flex justify-content-between align-items-center">
                        <span class="amount">Delivery Charges</span>
                        <span class="deliverySpan d-flex align-items-center">
                            <span class="number text-decoration-line-through">&##8377 200</span>
                            <span class="number green">Free</span>
                        </span>
                    </div>
                    <div class="price d-flex justify-content-between py-3">
                        <span class="totalAmount">Total Amount</span>
                        <cfset local.totalAmount = local.totalPrice+local.totalTax>
                        <span class="totalAmount" id="orderAmount" data-value="#local.totalAmount#">&##8377 #local.totalAmount#</span>
                    </div>
                    <!--- <span class="save pb-3">You will save &##8377 12,148 on this order</span>    --->                   
                </div>
            </div>
            <div class="safeDiv d-flex mt-4 ps-3">
                <img src="Assets/Images/safeguard.PNG" class="ms-1" alt="" width="25" height="30"> 
                <span class="safe ms-2">Safe and Secure Payments.Easy returns.100% Authentic products.</span>
            </div>
        </div>
    </div>
    <div class="orderSuccessDiv align-items-center" id="orderSuccessDiv">
        <img src="Assets/Images/ordersuccess.png" alt="" width="100" height="100">
        <span class="successMessage fw-bold text-success mt-3">Order Placed Successfully</span>
        <button type="button" class="successButton mt-3">Close</button>
    </div>
</cfoutput>