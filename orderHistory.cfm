<cfoutput>
    <div class="orderHistoryBody">
        <div class="orderHistoryDiv">
            <div class="orderDiv">
                <cfif structKeyExists(form, "orderSearch")>
                    <cfset local.orders = application.obj.getOrders(search = orderSearch)>
                    <cfif NOT arrayLen((local.orders))>
                        <div class="noOrdersDiv">
                            <div class="d-flex flex-column justify-content-center align-items-center">
                                <img src="Assets/Images/cartEmpty.jpg" alt="" class = "mx-auto cartEmptyImg">
                                <span class="noOrderMessage">Oops! No matching orders for the search</span>
                                <a href="orderHistory.cfm?" class = "d-flex justify-content-center cartLoginBtn mx-auto mt-2">Back</a>
                            </div>
                        </div>
                        <cfabort>
                    </cfif>
                <cfelse>
                    <cfset local.orders = application.obj.getOrders()>
                </cfif>
                <cfif arrayLen((local.orders))>
                    <form action="" method="post">
                        <div class = "d-flex justify-content-center">
                            <input type="search" class="historySearch" placeholder="Search for order history..." name="orderSearch">
                        </div>
                    </form>
                    <cfloop array="#local.orders#" item="item">
                        <div class="orderItemDiv d-flex flex-column mt-5">
                            <div class="orderHead d-flex align-items-center justify-content-between">
                                <div class="d-flex flex-column">
                                    <span class="orderIdSpan">OrderId : #item.orderId#</span>
                                    <span class="orderIdSpan">Order Date : #item.orderDate#</span>
                                </div>
                                <a href="##" class="text-decoration-none" name="pdfButton" onClick = "pdfDownload('#item.orderId#')">
                                    <img src="Assets/Images/pdf (1).png" class="fileImage mx-1" width="32px" height="32px">
                                </a>
                            </div>
                            <cfset local.orderItems = application.obj.getOrderItems(orderId = item.orderId)>
                            <cfloop array="#local.orderItems#" item="product">
                                <div class="itemDetailsDiv d-flex flex-column">
                                    <div class="orderProductDiv d-flex align-items-center justify-content-between">
                                        <div class="d-flex flex-column">
                                            <span class="itemNameSpan">#product.productName#</span>
                                            <span class="orderItemBrand py-2">Brand : #product.brandName#</span>
                                        </div>
                                        <img src="Assets/uploadImages/#product.fileName#" alt="" width="80" height="80"> 
                                    </div>
                                    <div class="orderPriceDetailsDiv d-flex flex-column">
                                        <span class="orderItemPrice">Quantity : #product.quantity#</span>
                                        <span class="orderItemPrice">Price : #product.quantity * product.unitPrice#</span>
                                        <span class="orderItemPrice">Tax : #product.quantity * product.unitTax#</span>
                                        <span class="orderItemTotal fw-bold text-success">Total Amount : #product.quantity*(product.unitPrice+product.unitTax)#</span>
                                    </div>
                                </div>
                            </cfloop>
                            <div class="orderDeliveryDiv d-flex justify-content-between">
                                <div class="orderTotalAmountDiv d-flex flex-column">
                                    <span class="orderItemPrice">Total Price : #item.totalPrice#</span>
                                    <span class="orderItemPrice">Total Tax : #item.totalTax#</span>
                                    <span class="orderItemTotal fw-bold text-success">Total Amount : #item.totalPrice + item.totalTax#</span>
                                </div>
                                <div class="shippingAddressDiv d-flex flex-column">
                                    <span class="fw-bold">Address:</span>
                                    <span class="orderAddressSapn deliveryAddress">#item.firstName# #item.lastName#, #item.address1# #item.address2#,
                                     #item.city# #item.state# #item.pincode#</span>
                                </div>
                                <div class="orderContactDiv d-flex flex-column">
                                    <span class="fw-bold">Contact:</span>
                                    <span class="orderAddressSapn">#item.phone#</span>
                                </div>
                            </div>
                        </div>
                    </cfloop>
                <cfelse>
                    <div class="noOrdersDiv">
                        <div class="d-flex flex-column justify-content-center align-items-center">
                            <img src="Assets/Images/cartEmpty.jpg" alt="" class = "mx-auto cartEmptyImg">
                            <span class="noOrderMessage">Oops! No orders placed. Let's change that.</span>
                            <span class = "mt-2 loginMessage d-flex justify-content-center">
                                Explore oru products and find somenthing you like. 
                            </span>
                            <a href="homePage.cfm?" class = "d-flex justify-content-center cartLoginBtn mx-auto mt-2">Home</a>
                        </div>
                    </div>
                </cfif>
            </div>
        </div>
    </div>
</cfoutput>