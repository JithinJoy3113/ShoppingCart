<cfoutput>
    <div class="bodyContents d-flex">
        <div class="bodyLeftdiv w-100">
            <div class="scroll" d-flex flex-column>
                <div class="topPincodediv d-flex justify-content-between align-items-center">
                    <span class="pinAddress">From Saved Addresses</span>
                    <div class="pinDiv">
                        <button class="pinButton">Enter Delivery Pincode</button>
                    </div>
                </div>
                <cfset local.cartItems = application.obj.cartItems()>
                <cfset local.totalPrice = 0>
                <cfset local.tax = 0>
                <cfset local.items = arrayLen(local.cartItems)>
                <cfloop array="#local.cartItems#" item="item">
                    <cfset local.totalPrice += item.totalPrice>
                    <cfset local.tax += item.totalTax>
                    <div class="cartItemsdiv d-flex flex-column mt-2 bg-white" id = "#item.cartId#">
                        <div class="itemMain d-flex flex-column">
                            <div class="itemDiv d-flex">
                                <img src="Assets/uploadImages/#item.file#" class="" alt="" width="93" height="112">
                                <div class="detailsDiv">
                                    <div class="itemName d-flex flex-column">
                                        <a href="product.cfm?productId=#item.productId#&subcategoryId=#item.subcategoryId#" class="nameLink text-decoration-none">#item.productName#</a>
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
                                    <button type="button" class = "quantityBtn me-2 minusBtn" value = "Minus,#item.cartId#" id="minus#item.cartId#" onclick="updateQuantity(this)">-</button>
                                    <span id="quantity#item.cartId#" data-value = "#item.quantity#">#item.quantity#</span>
                                    <button type="button" class = "quantityBtn ms-2" value = "Plus,#item.cartId#" onclick="updateQuantity(this)">+</button>
                                </div>
                                <button class="later me-5 border-0" type = "button" value = #item.cartId# onClick= "removeCartItem(this)">REMOVE</button>
                            </div>
                        </div>
                    </div>
                </cfloop>
                <div class="placeOrderdiv d-flex justify-content-end">
                    <button class="orderButton">PLACE ORDER</button>
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
                        <span class="amount">Price (#local.items# items)</span>
                        <span class="number" id="cartTotalAmount">₹#local.totalPrice#</span>
                    </div>
                    <div class="price d-flex justify-content-between pt-2">
                        <span class="amount">Tax</span>
                        <span class="number" id="cartTotalTax">₹#local.tax#</span>
                    </div>
                    <div class="price d-flex justify-content-between">
                        <span class="amount">Discount</span>
                        <span class="number green">− ₹11,961</span>
                    </div>
                    <div class="price d-flex justify-content-between">
                        <span class="amount">Coupons for you</span>
                        <span class="number green">-187</span>
                    </div>
                    <div class="price d-flex justify-content-between align-items-center">
                        <span class="amount">Delivery Charges</span>
                        <span class="deliverySpan d-flex align-items-center">
                            <span class="number text-decoration-line-through">₹200</span>
                            <span class="number green">Free</span>
                        </span>
                    </div>
                    <div class="price d-flex justify-content-between py-3">
                        <span class="totalAmount">Total Amount</span>
                        <cfset local.totalAmount = local.totalPrice+local.tax>
                        <span class="totalAmount" id="cartOrderAmount">₹#local.totalAmount#</span>
                    </div>
                    <span class="save pb-3">You will save ₹12,148 on this order</span>                      
                </div>
            </div>
            <div class="safeDiv d-flex mt-4 ps-3">
                <img src="Assets/Images/safeguard.PNG" class="ms-1" alt="" width="25" height="30"> 
                <span class="safe ms-2">Safe and Secure Payments.Easy returns.100% Authentic products.</span>
            </div>
        </div>             
    </div>  
</cfoutput>