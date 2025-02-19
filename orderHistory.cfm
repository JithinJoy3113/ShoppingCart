<cfoutput>
    <div class="orderHistoryBody">
        <div class="orderHistoryDiv">
            <div class="orderDiv" id="orderDiv">
                <cfif structKeyExists(form, "orderSearch")>
                    <cfset local.orders = application.obj.getOrders(search = orderSearch)>
                    <cfif NOT structCount((local.orders))>
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
                <cfif structCount(local.orders)>
                    <form action="" method="post">
                        <div class = "d-flex justify-content-center">
                            <input type="search" class="historySearch" placeholder="Search for order history..." name="orderSearch">
                        </div>
                    </form>
                    <div id="orderHistoryDisplay">

                        
                    </div>
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
        <div class="pagination">
            <button id="prev" onclick="changePage('prev')" class="disabled" disabled>Previous</button>
            <span id="page-number">Page 1</span>
            <button id="next" onclick="changePage('next')">Next</button>
        </div>
    </div>
</cfoutput>




<!--- <cfoutput>
    <div class="orderHistoryBody">
        <div class="orderHistoryDiv">
            <div class="orderDiv">
                <cfif structKeyExists(form, "orderSearch")>
                    <cfset local.orders = application.obj.getOrders(search = orderSearch)>
                    <cfif NOT structCount((local.orders))>
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
                <cfif structCount(local.orders)>
                    <form action="" method="post">
                        <div class = "d-flex justify-content-center">
                            <input type="search" class="historySearch" placeholder="Search for order history..." name="orderSearch">
                        </div>
                    </form>
                    <cfloop collection="#local.orders#" item="orderId">
                        <cfset local.order = local.orders[orderId][1]>
                        <div class="orderItemDiv d-flex flex-column mt-5">
                            <div class="orderHead d-flex align-items-center justify-content-between">
                                <div class="d-flex flex-column">
                                    <span class="orderIdSpan">OrderId : #orderId#</span>
                                    <span class="orderIdSpan">Order Date : #local.order.orderDate#</span>
                                </div>
                                <a href="##" class="text-decoration-none" name="pdfButton" onClick = "pdfDownload('#orderId#')">
                                    <img src="Assets/Images/pdf (1).png" class="fileImage mx-1" width="32px" height="32px">
                                </a>
                            </div>
                            <cfloop array="#local.orders[orderId]#" item="items">
                                <div class="itemDetailsDiv d-flex flex-column">
                                    <div class="orderProductDiv d-flex align-items-center justify-content-between">
                                        <div class="d-flex flex-column">
                                            <span class="itemNameSpan">#items.productName#</span>
                                            <span class="orderItemBrand py-2">Brand : #items.brandName#</span>
                                        </div>
                                        <img src="Assets/uploadImages/#items.fileName#" alt="" width="80" height="80"> 
                                    </div>
                                    <div class="orderPriceDetailsDiv d-flex flex-column">
                                        <span class="orderItemPrice">Quantity : #items.quantity#</span>
                                        <span class="orderItemPrice">Price : #items.quantity * items.unitPrice#</span>
                                        <span class="orderItemPrice">Tax : #items.quantity * items.unitTax#</span>
                                        <span class="orderItemTotal fw-bold text-success">Total Amount : #items.quantity*(items.unitPrice+items.unitTax)#</span>
                                    </div>
                                </div>
                            </cfloop>
                            <div class="orderDeliveryDiv d-flex justify-content-between">
                                <div class="orderTotalAmountDiv d-flex flex-column">
                                    <span class="orderItemPrice">Total Price : #local.order.totalPrice#</span>
                                    <span class="orderItemPrice">Total Tax : #local.order.totalTax#</span>
                                    <span class="orderItemTotal fw-bold text-success">Total Amount : #local.order.totalPrice + local.order.totalTax#</span>
                                </div>
                                <div class="shippingAddressDiv d-flex flex-column">
                                    <span class="fw-bold">Address:</span>
                                    <span class="orderAddressSapn deliveryAddress">#local.order.firstName# #local.order.lastName#, #local.order.address1# #local.order.address2#,
                                     #local.order.city# #local.order.state# #local.order.pincode#</span>
                                </div>
                                <div class="orderContactDiv d-flex flex-column">
                                    <span class="fw-bold">Contact:</span>
                                    <span class="orderAddressSapn">#local.order.phone#</span>
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
</cfoutput> --->