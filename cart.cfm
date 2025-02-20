<cfoutput>
    <cfif structKeyExists(session, "role")>
        <cfset local.cartItems = application.obj.cartItems()>
        <cfif arrayLen(local.cartItems)>
            <div class="bodyContents d-flex" id = "bodyContents">
                <div class="bodyLeftdiv w-100">
                    <div class="scroll d-flex flex-column w-100">
                        <div class="topPincodediv d-flex justify-content-between align-items-center">
                            <span class="pinAddress">From Saved Addresses</span>
                            <div class="pinDiv">
                                <button class="pinButton">Enter Delivery Pincode</button>
                            </div>
                        </div>
                        <cfset local.cartId = 0>
                        <cfset local.totalPrice = 0>
                        <cfset local.totalTax = 0>
                        <cfset local.items = arrayLen(local.cartItems)>
                        <cfloop array="#local.cartItems#" item="item">
                            <cfif structKeyExists(item, "cartId")>
                                <cfset local.cartId = item.cartId>
                                <div class="cartItemsdiv d-flex flex-column mt-2 bg-white" id = "#item.cartId#">
                                    <div class="itemMain d-flex flex-column">
                                        <div class="itemDiv d-flex">
                                            <img src="Assets/uploadImages/#item.file#" class="" alt="" width="93" height="112">
                                            <div class="detailsDiv">
                                                <div class="d-flex flex-column">
                                                    <cfset local.encryptedSubcategoryId = urlEncodedFormat(encrypt(item.subcategoryId, application.secretKey, "AES", "Base64"))>
                                                    <cfset local.encryptedProductId = urlEncodedFormat(encrypt(item.productId, application.secretKey, "AES", "Base64"))>
                                                    <a href="product.cfm?productId=#local.encryptedProductId#&subcategoryId=#local.encryptedSubcategoryId#" class="nameLink text-decoration-none">#item.productName#</a>
                                                </div>
                                                <!--- <div class="sizeDiv">
                                                    <span class="sizeSpan">Size: 10,Black , 10</span>
                                                </div> --->
                                                <div class="priceDetailsDiv d-flex flex-column mt-2">
                                                    <span class="amount green">Price :<span class="amount green" id = "price#item.cartId#"> #item.totalPrice#</span></span>
                                                    <span class="number">Tax : <span class="number" id="tax#item.cartId#">#item.totalTax#</span></span>
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
                                            <button class="later me-5 border-0" type = "button" value = #item.cartId# onClick= "deleteProfileAddressButton(this)">REMOVE</button>
                                        </div>
                                    </div>
                                </div>
                            <cfelse>
                                <cfset local.totalPrice = item.orderAmount>
                                <cfset local.totalTax = item.orderTax>
                            </cfif>
                        </cfloop>
                        <div class="placeOrderdiv d-flex justify-content-end">
                            <button class="orderButton" type="button" value="#local.cartId#" onclick = "buyNow(this)">PLACE ORDER</button>
                        </div>
                    </div>
                </div>
                <div class="bodyRightdiv w-100">
                    <div class="priceDetailsdiv bg-white">
                        <div class="priceDetails">
                            <span class="priceHead">PRICE DETAILS</span>
                        </div>
                        <div class="priceMaindiv d-flex flex-column">
                            <div class="price d-flex justify-content-between pt-2">
                                <span class="amount" >Price (<span id="totalItems">#local.items#</span> items)</span>
                                <span class="number">₹<span class="number" id="cartTotalAmount">#local.totalPrice#</span></span>
                            </div>
                            <div class="price d-flex justify-content-between pt-2">
                                <span class="amount">Tax</span>
                                <span class="number">₹<span class="number" id="cartTotalTax">#local.totalTax#</span></span>
                            </div>
                            <!--- <div class="price d-flex justify-content-between">
                                <span class="amount">Discount</span>
                                <span class="number green">− ₹11,961</span>
                            </div>
                            <div class="price d-flex justify-content-between">
                                <span class="amount">Coupons for you</span>
                                <span class="number green">-187</span>
                            </div> --->
                            <div class="price d-flex justify-content-between align-items-center">
                                <span class="amount">Delivery Charges</span>
                                <span class="deliverySpan d-flex align-items-center">
                                    <span class="number text-decoration-line-through">₹200</span>
                                    <span class="number green">Free</span>
                                </span>
                            </div>
                            <div class="price d-flex justify-content-between py-3">
                                <span class="totalAmount">Total Amount</span>
                                <cfset local.totalAmount = local.totalPrice+local.totalTax>
                                <span class="totalAmount" id="cartOrderAmount">₹#local.totalAmount#</span>
                            </div>
                            <!--- <span class="save pb-3">You will save ₹12,148 on this order</span>--->
                        </div>
                    </div>
                    <div class="safeDiv d-flex mt-4 ps-3">
                        <img src="Assets/Images/safeguard.PNG" class="ms-1" alt="" width="25" height="30"> 
                        <span class="safe ms-2">Safe and Secure Payments.Easy returns.100% Authentic products.</span>
                    </div>
                </div> 
            </div> 
        <cfelse>
            <div class = "cartEmptyDiv">
                <div class = "cartLogin d-flex flex-column justify-content-center">
                    <img src="Assets/Images/cartEmpty.jpg" alt="" class = "mx-auto cartEmptyImg">
                    <span class = "mt-2 missingDiv  d-flex justify-content-center">
                        Cart Empty?
                    </span>
                    <span class = "mt-2 loginMessage d-flex justify-content-center">
                        Explore oru products and find something you like. 
                    </span>
                    <a href="homePage.cfm?" class = "d-flex justify-content-center cartLoginBtn mx-auto mt-2">Home</a>
                </div>
            </div>            
        </cfif>
    <cfelse>
        <div class = "cartLoginDiv px-4 py-4" >
            <div class = "cartLogin d-flex flex-column justify-content-center align-items-center">
                <img src="Assets/Images/cartEmpty.jpg" alt="" class = "cartEmptyImg">
                <span class = "mt-2 missingDiv  d-flex justify-content-center">
                    Missing Cart Items?
                </span>
                <span class = "mt-2 loginMessage d-flex justify-content-center">
                    Login to see the items you added. 
                </span>
                <a href="login.cfm?cartLogin=true" class = "d-flex justify-content-center cartLoginBtn mx-auto mt-2">Login</a>
            </div>
        </div>
    </cfif>
    <div class="deleteConfirm mx-auto mb-4" id="deleteConfirm">
        <span class="logourtAlertHead py-2 d-flex justify-content-center fw-bold text-white">Remove Item</span>
        <div class="logoutMesage  d-flex flex-column justify-content-center">
            <span class="confirmMessage fw-bold">Are you sure want to Remove?</span>
            <button class="alertBtn mt-3" type="button" name="alertDeleteBtn" id="alertCartDeleteBtn" value="" onClick="return removeCartItem(this)">Delete</button>
            <button class="alertCancelBtn mt-2" type="button" name="alertDeleteBtn" id="" value="cancel" onClick="return deleteAlert(this)">Cancel</button>
        </div>
    </div>
</cfoutput>