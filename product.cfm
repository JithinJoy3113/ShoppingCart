<cfoutput>
    <cfset local.productId = decrypt(URL.productId, application.secretKey, "AES", "Base64")>
    <cfset local.subCategoryId = decrypt(URL.subcategoryId, application.secretKey, "AES", "Base64")>
    <cfset local.file = "">
    <div class="productBodydiv" id="randomProductsMainDiv">
            <div class="productImgMaindiv d-flex">
                <div class="productLeft d-flex flex-column">
                    <div class="productImgdiv d-flex">
                        <div class="productImagesdivLeft d-flex flex-column">
                            <cfset local.productDetails = application.obj.displayProduct(productId = local.productId)>
                            <cfset local.imageResult = application.obj.viewImages(productId = local.productId)>
                            <cfloop array="#local.imageResult#" item="item">
                                <div class="productImg d-flex align-items-center justify-content-center">
                                    <img src="Assets/uploadImages/#item.imageFileName#" class="sideImage" alt="" width="60" height="62">
                                </div>
                                <cfif item.defaultImage EQ 1>
                                    <cfset local.file = item.imageFileName>
                                </cfif>
                            </cfloop>
                        </div>
                        <div class="productImagesdivRight ps-2 pt-3 d-flex justify-content-center">
                            <div class="productMainimg d-flex justify-content-center">
                                <img src="Assets/uploadImages/#local.file#" data-value = "Assets/uploadImages/#local.file#" class="mainImg" alt="" id="mainImg">
                            </div>
                        </div>
                    </div>
                    <form method = "post" action = "">
                        <div class="productButtondiv d-flex ">
                            <div class="cartButtondiv w-50 me-1">
                                <cfif structKeyExists(session, "role")>
                                    <cfset local.cart = application.obj.cartItems(productId = local.productDetails.productId)>
                                    <cfif arrayLen(local.cart)>
                                        <a href="cart.cfm" class="cartBtn text-decoration-none text-white d-flex justify-content-center">GO TO CART</a>
                                    <cfelse>
                                        <button type = "button" class="cartBtn border-0 text-white W-50" value = "#local.productDetails.productId#" name="cartBtn" onclick = "addCart(this)">
                                            <img src="" class="cartButtonImg mb-1 me-1" alt="">ADD TO CART
                                        </button>
                                    </cfif>
                                <cfelse>
                                    <button type = "button" class="cartBtn border-0 text-white W-50" value = "#local.productDetails.productId#" name="cartBtn" onclick = "addCart(this)">
                                        <img src="" class="cartButtonImg mb-1 me-1" alt="">ADD TO CART
                                    </button>
                                </cfif>
                            </div>
                            <cfset local.encryptedProductId = urlEncodedFormat(encrypt(local.productDetails.productId, application.secretKey, "AES", "Base64"))>
                            <a  href="order.cfm?productId=#local.encryptedProductId#&page=buy" class="W-50 buy buyButtondiv text-decoration-none text-white" onClick="return buyNow(#local.productDetails.productId#)">
                         
                                        <!--- <img src="assets/images/buy.png" class="cartButtonImg mb-1 me-1" alt=""> --->BUY NOW
                                
                            </a>
                        </div>
                    </form>
                    <div class="productButtondiv d-flex d-sm-none w-100 px-2">
                        <!--- <img src="assets/images/mobilecart.webp" class="" alt=""> --->
                        <div class="payButtondiv d-flex flex-column mx-1 align-items-center j ustify-content-center">
                            <span class="payEmi">Pay with EMI</span>
                            <span class="emiAmount">From ₹2,675/m</span>
                        </div>
                        <div class="buyButtondiv d-flex mx-1 align-items-center justify-content-center">
                            Buy now
                        </div>
                    </div>
                </div>
                <div class="productDetailsdiv">
                    <div class="pathMaindiv d-flex">
                        <div class="pathDiv d-none d-md-flex">
                            <div class="pathMobile">
                                <a href="homePage.cfm" class="pathLink text-decoration-none">Home</a>
                                <img src="Assets/Images/rightarrowgrey.PNG" class="me-1" alt="">
                            </div>
                            <cfset local.encryptedCategoryId = urlEncodedFormat(encrypt(local.productDetails.categoryId, application.secretKey, "AES", "Base64"))>
                            <cfset local.encryptedSubCategoryName = urlEncodedFormat(encrypt(local.productDetails.subCategoryName, application.secretKey, "AES", "Base64"))>
                            <cfset local.encryptedCategoryName = urlEncodedFormat(encrypt(local.productDetails.categoryName, application.secretKey, "AES", "Base64"))>
                            <div class="pathMobile">
                                <a href="productListing.cfm?categoryId=#local.encryptedCategoryId#&categoryName=#local.encryptedCategoryName#" class="pathLink mobile text-decoration-none">#local.productDetails.categoryName#</a>
                                <img src="Assets/Images/rightarrowgrey.PNG" class="me-1" alt="">
                            </div>
                            <div class="pathMobile">
                                <a href="subcategory.cfm?subCategoryId=#URL.subcategoryId#&subCategoryName=#local.encryptedSubCategoryName#" class="pathLink text-decoration-none">#local.productDetails.subCategoryName#</a>
                                <img src="Assets/Images/rightarrowgrey.PNG" class="me-1" alt="">
                            </div>
                            <div class="pathMobile productName d-flex align-items-center">
                                <a href="" class="text-decoration-none pathLink text-truncate">#local.productDetails.productName#</a>
                            </div>
                        </div>
                        <div class="compareDiv d-none d-md-flex ms-auto">
                            <div class="checkDiv">
                                <input type="checkbox" class="check me-1">
                                <span class="compare me-4">Compare</span>
                            </div>
                        </div>
                        <div class="shareDiv d-none d-md-flex ">
                            <div class="checkDiv">
                               <img src="Assets/Images/share.png" alt="" width="18" height="18">
                                <span class="share">Share</span>
                            </div>
                        </div>
                    </div>
                    <div class="mobileDetailsdiv">
                        <div class="headingDiv">#local.productDetails.productName#</div>
                        <div class="mobileRatingdiv">
                            <div class="rating d-none d-md-flex align-items-center py-1">
                                <span class="ratingSpan ms-2">37,817 Ratings & 1,431 Reviews</span>
                            </div>
                            <div class="rating d-flex d-md-none align-items-center justify-content-between py-1">
                                <div class="d-flex">
                                    <a class="ratingSpan ms-2 text-decoration-none">8,715 ratings</a>
                                </div>
                                <div class="">
                                </div>
                            </div>
                            <div class="priceDiv d-none d-md-flex align-items-center">
                                <span class="price">RS. #local.productDetails.price#</span>
                            </div>
                            <div class="discriptionDiv d-none d-sm-flex">
                                <span class="colorSpan">Discription</span>
                                <span class="discription"># local.productDetails.description#</span>
                            </div>
                            <div class="fee d-flex mt-3">No cost EMI RS.2,345/month<a href="" class="d-flex deliverPlans text-decoration-none ms-1">View Plans</a></div>
                            <div class="sellerFinddiv d-flex d-sm-none justify-content-between align-items-center">
                                <span class="findSeller">Find a seller that delivers to you</span>
                                <div class="findPin d-flex">
                                    <a href="" class="pinLink text-decoration-none">Enter pincode</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="withoutExchangediv d-flex">
                        <div class="exchangeTable d-flex flex-column">
                            <div class="tableRowone forColor d-flex">
                                <input type="radio" class="radioInput">
                                <div class="buyExchange d-flex">
                                    <span class="spanOne">Buy without Exchange</span>
                                    <span class="spanTwo ms-auto">Rs.12,999</span>
                                </div>
                            </div>
                            <div class="tableRowone">
                                <div class="exchangeDiv d-flex flex-column">
                                    <div class="withExchange d-flex">
                                        <input type="radio" class="radioInput" disabled>
                                        <div class="withExchangediv d-flex">
                                            <span class="spanOne buyGrey">Buy with Exchange</span>
                                            <span class="spanTwo buyGrey ms-auto">up to Rs.7,950 off</span>
                                        </div>
                                    </div>
                                    <span class="checkPin text-danger">Enter pincode to check if exchange is available</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="deliveryPindiv d-none d-sm-flex">
                        <div class="deliveryPin d-flex flex-column">
                            <div class="pinDin d-flex">
                                <span class="colorSpan">Delivery</span>
                                <div class="pinInputdiv d-flex">
                                    <!--- <img src="assets/images/loc.png" class="locImg" alt=""> --->
                                    <input type="text" class="pinInput border-0" placeholder="Enter Delivey Pincode">
                                    <a href="" class="checkSpan text-decoration-none me-3">Check</a>
                                </div>
                                <div class="enterPindiv ms-3">
                                    Enter Pincode
                                </div>
                            </div>
                            <cfset local.currentDate = now()>
                            <cfset local.futureDate = dateAdd("d", 10, local.currentDate)>
                           <cfset local.dayOfMonth = day(local.futureDate)>
                             <cfset local.monthName = left(monthAsString(month(local.futureDate)),3)>
                            <cfset local.Weekday = DayOfWeekAsString(DayOfWeek(local.futureDate))>
                            <cfset local.formattedDate = local.dayOfMonth & " " & local.monthName & ", " & local.Weekday> 
                            <div class="expectedDeliveydiv d-flex flex-column">
                                <span class="deliveryDate d-flex">Delivery by #local.formattedDate#
                                               <span class="deliveryFree ms-1"> | Free</span>
                                <span class="text-decoration-line-through ms-1">Rs.40</span>
                               <!---  <img src="assets/images/roundquestion.png" class="ms-1" alt=""> --->
                                </span>
                                <span class="orderDate">if ordered before 12:24 PM</span>
                                <a href="" class="checkSpan text-decoration-none">View Details</a>
                            </div>
                        </div>
                    </div>
                    <div class="productSeller d-none d-sm-flex">
                        <span class="colorSpan">Seller</span>
                        <div class="sellerDetailsdiv d-flex flex-column">
                            <div class="sellerName d-flex">
                                <a href="" class="checkSpan text-decoration-none ms-3 me-2">#local.productDetails.brand#</a>
                            </div>
                            <ul class="highlightUl">
                                <li class="highlightLi">7 Days Service Center Replacement/Repair</li>
                                <li class="highlightLi">GST invoice available</li>
                                <li class="highlightView"><a href="" class="checkSpan text-decoration-none">See other sellers</a>
                            </ul>
                        </div>
                    </div>
                    <div class="reviewsRatingdiv d-flex flex-column">
                        <div class="reviewHeaddiv d-flex justify-content-between">
                            <span class="reviewHead">Ratings & Reviews</span>
                            <div class="rateDiv">
                                <button class="ratingButton border-0 bg-white">Rate Product</button>
                            </div>
                        </div>
                        <div class="ratingDiv d-flex flex-column flex-xl-row">
                            <div class="ratingStardiv d-flex mx-auto mx-md-0">
                                <div class="starRatingdiv d-flex flex-column">
                                    <div class="ratingStar d-flex align-items-center justify-content-center">
                                        <div class="starRatenum">4.5</div>
                                        <div class="starRate">★</div>
                                    </div>
                                    <div class="reviewSpan mx-auto">49,765 Ratings &</div>
                                    <div class="reviewSpan mx-auto">1,596 Reviews</div>
                                </div>
                                <div class="progressBardiv d-flex flex-column px-3">
                                    <div class="progressRow d-flex align-items-center mb-1">
                                        <div class="progressStar">5</div>
                                        <div class="progressStar">★</div>
                                        <div class="progressBar ms-3">
                                            <div class="progressColor colorOne">
                                            </div>
                                        </div>
                                        <span class="progressNum ms-3">35,902</span>
                                    </div>
                                    <div class="progressRow d-flex align-items-center mb-1">
                                        <div class="progressStar">4</div>
                                        <div class="progressStar">★</div>
                                        <div class="progressBar ms-3">
                                            <div class="progressColor colorTwo">
                                            </div>
                                        </div>
                                        <span class="progressNum ms-3">18,500</span>
                                    </div>
                                    <div class="progressRow d-flex align-items-center mb-1">
                                        <div class="progressStar">3</div>
                                        <div class="progressStar">★</div>
                                        <div class="progressBar ms-3">
                                            <div class="progressColor colorThree">
                                            </div>
                                        </div>
                                        <span class="progressNum ms-3">10,769</span>
                                    </div>
                                    <div class="progressRow d-flex align-items-center mb-1">
                                        <div class="progressStar">2</div>
                                        <div class="progressStar">★</div>
                                        <div class="progressBar ms-3">
                                            <div class="progressColor colorFour">
                                            </div>
                                        </div>
                                        <span class="progressNum ms-3">1,400</span>
                                    </div>
                                    <div class="progressRow d-flex align-items-center mb-1">
                                        <div class="progressStar">1</div>
                                        <div class="progressStar">★</div>
                                        <div class="progressBar ms-3">
                                            <div class="progressColor colorFive">
                                            </div>
                                        </div>
                                        <span class="progressNum ms-3">2,350</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                
                        <div class="customerReviewdiv d-flex flex-column">
                            <div class="customerReviewhead">
                                <span class="reviewHead">Terrific purchase</span>
                            </div>
                            <div class="customerDetailsdiv d-flex flex-column flex-md-row w-100 justify-content-md-between pt-2">
                                <div class="customerDetails d-flex w-75 align-items-center">
                                    <span class="customerName">Sachin Roy</span>
                                    <span class="customerLocation">Certified Buyer, Kolkata</span>
                                    <span class="customerLocation ms-1">1 month ago</span>
                                </div>
                            </div>
                        </div>
                        <div class="customerReviewdiv d-flex flex-column">
                            <div class="customerReviewhead">
                                <span class="reviewHead">Worth every penny</span>
                            </div>
                            <div class="customerReview d-flex flex-column pt-2">
                                <span class="customerReviewspan">Good looking 🤩</span>
                                <span class="customerReviewspan">Price range all-over best.✅</span>
                            </div>
                            <div class="customerDetailsdiv d-flex flex-column flex-md-row w-100 justify-content-md-between pt-2">
                                <div class="customerDetails d-flex w-75 align-items-center">
                                    <span class="customerName">Deepak Sah</span>
                                    <span class="customerLocation">Certified Buyer, Pashchim Champaran District</span>
                                    <span class="customerLocation ms-1">2 months ago</span>
                                </div>
                            </div>
                        </div>
                        <div class="customerReviewdiv d-flex flex-column">
                            <div class="customerReviewhead">
                                <span class="reviewHead">Fabulous!</span>
                            </div>
                            <div class="customerReview d-flex flex-column pt-2">
                                <span class="customerReviewspan">Good 👍👍👍👍 love 💕💕💕💕💕</span>
                            </div>
                            <div class="customerDetailsdiv d-flex flex-column flex-md-row w-100 justify-content-md-between pt-2">
                                <div class="customerDetails d-flex w-75 align-items-center">
                                    <span class="customerName">Mukesh Hindustani</span>
                                    <span class="customerLocation">Certified Buyer, Mumbai</span>
                                    <span class="customerLocation ms-1">2 months ago</span>
                                </div>
                            </div>
                        </div>
                        <div class="customerReviewdiv d-flex flex-column">
                            <div class="customerReviewhead">
                                <span class="reviewHead">Terrific purchase</span>
                            </div>
                            <div class="customerDetailsdiv d-flex flex-column flex-md-row w-100 justify-content-md-between pt-2">
                                <div class="customerDetails d-flex w-75 align-items-center">
                                    <span class="customerName">Sachin Roy</span>
                                    <span class="customerLocation">Certified Buyer, Kolkata</span>
                                    <span class="customerLocation ms-1">1 month ago</span>
                                </div>
                            </div>
                        </div>
                        <a href="" class="viewFeatureslink text-decoration-none"><b>View 1598 reviews</b></a>
                    </div>
                    <div class="questionAnswerdiv d-flex flex-column">
                        <div class="questionAnswerrow d-flex justify-content-between align-items-center">
                            <span class="questionAnswerHead">Questions and Answers</span>
                        </div>
                        <div class="customerQuestiondiv d-flex flex-column">
                            <span class="questions">Q: What about gaming.. Like free fire how it performs</span>
                            <span class="answers mt-2"><b>A:</b> It's decent for heavy gaming</span>
                            <div class="questionCustomerdiv d-flex align-items-center justify-content-between">
                                <div class="answerdCustomer d-flex flex-column">
                                    <span class="customerName mt-1">Mayank Kashyap</span>
                                    <div class="questionCertified">
                                        <span class="customerLocation">Certified Buyer, Kolkata</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <a href="" class="viewFeatureslink text-decoration-none"><b>All questions</b></a>
                    </div>
                    <div class="safeBottomdiv d-flex justify-content-center align-items-center">
                       <!---  <img src="assets/images/safeguard.png" class="" alt=""> --->
                        <span class="safeBottom">Safe and Secure Payments.Easy returns.100% Authentic products.</span>
                    </div>
                </div>
            </div>
            <div class="similarProductsdiv d-flex flex-column">
                <span class="similarProductshead mt-4">Similar Products</span>
                <div class="similarProductsrow d-flex">
                    <cfset local.similarProducts = application.obj.randomProducts(subCategoryId = local.subcategoryId)>
                    <cfloop array="#local.similarProducts#" item="item">
                        <cfset local.encryptedSubcategoryId = urlEncodedFormat(encrypt(item.subcategoryId, application.secretKey, "AES", "Base64"))>
                        <cfset local.encryptedProductId = urlEncodedFormat(encrypt(item.productId, application.secretKey, "AES", "Base64"))>
                        <a href="product.cfm?productId=#local.encryptedProductId#&subcategoryId=#local.encryptedSubcategoryId#" class ="productbtn text-decoration-none">
                            <div class="randomProducts d-flex flex-column ms-4">
                                <img src="Assets/uploadImages/#item.productFileName#" class="similarImage mx-auto zoomHover" height="186" alt="">
                                <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                                    <span class="productsNamespan">#item.productName#</span>
                                    <div class="similarPriceDiv d-flex align-items-center mt-2">
                                        <span class="similarPrice text-success">RS.#item.price#</span>
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