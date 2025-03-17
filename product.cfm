<cfoutput>
    <cfset variables.productId = decrypt(URL.productId, application.secretKey, "AES", "Base64")>
    <cfset variables.subCategoryId = decrypt(URL.subCategoryId, application.secretKey, "AES", "Base64")>
    <cfset variables.file = "">
    <div class="productBodydiv" id="randomProductsMainDiv">
            <div class="productImgMaindiv d-flex">
                <div class="productLeft d-flex flex-column">
                    <div class="productImgdiv d-flex">
                        <div class="productImagesdivLeft d-flex flex-column">
                            <cfset variables.productDetails = application.obj.randomProducts(productId = variables.productId)>
                            <cfset variables.imageDetails = variables.productDetails[variables.productId].imageDetails>
                            <cfset variables.productDetails = variables.productDetails[variables.productId].productDetails>
                            <cfloop array="#variables.imageDetails#" item="item">
                                <div class="productImg d-flex align-items-center justify-content-center">
                                    <img src="Assets/uploadImages/#item.fileName#" class="sideImage" alt="" width="60" height="62">
                                </div>
                                <cfif item.default EQ 1>
                                    <cfset variables.file = item.fileName>
                                </cfif>
                            </cfloop>
                        </div>
                        <div class="productImagesdivRight ps-2 pt-3 d-flex justify-content-center">
                            <div class="productMainimg d-flex justify-content-center">
                                <img src="Assets/uploadImages/#variables.file#" data-value = "Assets/uploadImages/#variables.file#" class="mainImg" alt="" id="mainImg">
                            </div>
                        </div>
                    </div>
                    <form method = "post" action = "">
                        <div class="productButtondiv d-flex ">
                            <div class="cartButtondiv w-50 me-1">
                                <cfif structKeyExists(session, "role")>
                                    <cfset variables.cart = application.obj.cartItems(productId = variables.productDetails.productId)>
                                    <cfif arrayLen(variables.cart['productDetails'])>
                                        <a href="cart.cfm" class="cartBtn text-decoration-none text-white d-flex justify-content-center">GO TO CART</a>
                                    <cfelse>
                                        <button type = "button" class="cartBtn border-0 text-white W-50" value = "#variables.productDetails.productId#" name="cartBtn" onclick = "addCart(this)">
                                            <img src="" class="cartButtonImg mb-1 me-1" alt="">ADD TO CART
                                        </button>
                                    </cfif>
                                <cfelse>
                                    <button type = "button" class="cartBtn border-0 text-white W-50" value = "#variables.productDetails.productId#" name="cartBtn" onclick = "addCart(this)">
                                        <img src="" class="cartButtonImg mb-1 me-1" alt="">ADD TO CART
                                    </button>
                                </cfif>
                            </div>
                            <cfset variables.encryptedProductId = urlEncodedFormat(encrypt(variables.productDetails.productId, application.secretKey, "AES", "Base64"))>
                            <a href="order.cfm?productId=#variables.encryptedProductId#&page=buy" class="W-50 buy buyButtondiv text-decoration-none text-white" onClick="return buyNow(#variables.productDetails.productId#)">
                                BUY NOW
                            </a>
                        </div>
                    </form>
                </div>
                <div class="productDetailsdiv mt-4">
                    <div class="pathMaindiv d-flex">
                        <div class="pathDiv d-none d-md-flex">
                            <div class="pathMobile">
                                <a href="homePage.cfm" class="pathLink text-decoration-none">Home</a>
                                <img src="Assets/Images/rightarrowgrey.PNG" class="me-1" alt="">
                            </div>
                            <cfset variables.encryptedCategoryId = urlEncodedFormat(encrypt(variables.productDetails.categoryId, application.secretKey, "AES", "Base64"))>
                            <cfset variables.encryptedSubCategoryName = urlEncodedFormat(encrypt(variables.productDetails.subcategoryName, application.secretKey, "AES", "Base64"))>
                            <cfset variables.encryptedCategoryName = urlEncodedFormat(encrypt(variables.productDetails.categoryName, application.secretKey, "AES", "Base64"))>
                            <cfset variables.encryptedSubCategoryId = urlEncodedFormat(encrypt(variables.productDetails.subcategoryId, application.secretKey, "AES", "Base64"))>
                            <div class="pathMobile">
                                <a href="productListing.cfm?categoryId=#variables.encryptedCategoryId#&categoryName=#variables.encryptedCategoryName#" class="pathLink mobile text-decoration-none">#variables.productDetails.categoryName#</a>
                                <img src="Assets/Images/rightarrowgrey.PNG" class="me-1" alt="">
                            </div>
                            <div class="pathMobile">
                                <a href="subcategory.cfm?subCategoryId=#variables.encryptedSubCategoryId#&subCategoryName=#variables.encryptedSubCategoryName#" class="pathLink text-decoration-none">#variables.productDetails.subcategoryName#</a>
                                <img src="Assets/Images/rightarrowgrey.PNG" class="me-1" alt="">
                            </div>
                            <div class="pathMobile productName d-flex align-items-center">
                                <a href="" class="text-decoration-none pathLink text-truncate">#variables.productDetails.productName#</a>
                            </div>
                        </div>
                    </div>
                    <div class="mobileDetailsdiv">
                        <div class="headingDiv">#variables.productDetails.productName#</div>
                        <div class="mobileRatingdiv">
                            <div class="priceDiv d-none d-md-flex align-items-center">
                                <span class="price">RS. #variables.productDetails.price#</span>
                            </div>
                            <div class="discriptionDiv d-none d-sm-flex">
                                <span class="colorSpan">Discription</span>
                                <span class="discription"># variables.productDetails.description#</span>
                            </div>
                        </div>
                    </div>
                    <div class="deliveryPindiv">
                        <div class="deliveryPin d-flex">
                            <div class="pinDin d-flex">
                                <span class="colorSpan">Delivery</span>
                            </div>
                            <cfset variables.currentDate = now()>
                            <cfset variables.futureDate = dateAdd("d", 10, variables.currentDate)>
                            <cfset variables.dayOfMonth = day(variables.futureDate)>
                            <cfset variables.monthName = left(monthAsString(month(variables.futureDate)),3)>
                            <cfset variables.Weekday = DayOfWeekAsString(DayOfWeek(variables.futureDate))>
                            <cfset variables.formattedDate = variables.dayOfMonth & " " & variables.monthName & ", " & variables.Weekday> 
                            <span class="deliveryDate ms-5 ps-1">#variables.formattedDate#
                                <span class="deliveryFree ms-1"> | Free</span>
                                <span class="text-decoration-line-through ms-1">Rs.40</span>
                            </span>
                        </div>
                    </div>
                    <div class="productSeller d-flex mt-3">
                        <span class="colorSpan">Seller</span>
                        <div class="sellerDetailsdiv d-flex flex-column">
                            <div class="sellerName d-flex">
                                <a href="" class="checkSpan text-decoration-none ms-4 me-2 mt-1">#variables.productDetails.brandName#</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="similarProductsdiv d-flex flex-column">
                <span class="similarProductshead mt-4">Similar Products</span>
                <div class="similarProductsrow d-flex">
                    <cfset variables.similarProducts = application.obj.randomProducts(subCategoryId = variables.subcategoryId)>
                    <cfloop collection="#variables.similarProducts#" item="item">
                        <cfif item EQ 'orderTotal'>
                            <cfcontinue>
                        </cfif>
                        <cfset variables.productDetails = variables.similarProducts[item].productDetails>
                        <cfset variables.imageDetails = variables.similarProducts[item].imageDetails[1]>
                        <cfset variables.encryptedSubcategoryId = urlEncodedFormat(encrypt(variables.productDetails.subcategoryId, application.secretKey, "AES", "Base64"))>
                        <cfset variables.encryptedProductId = urlEncodedFormat(encrypt(variables.productDetails.productId, application.secretKey, "AES", "Base64"))>
                        <a href="product.cfm?productId=#variables.encryptedProductId#&subcategoryId=#variables.encryptedSubcategoryId#" class ="productbtn text-decoration-none">
                            <div class="randomProducts d-flex flex-column ms-4">
                                <img src="Assets/uploadImages/#variables.imageDetails.fileName#" class="similarImage mx-auto zoomHover" height="186" alt="">
                                <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                                    <span class="productsNamespan d-flex justify-content-center">#variables.productDetails.productName#</span>
                                    <div class="similarPriceDiv d-flex align-items-center mt-2">
                                        <span class="similarPrice text-success">RS.#variables.productDetails.price#</span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </cfloop>
                </div>
            </div>
        </div>
    </div>
</cfoutput>