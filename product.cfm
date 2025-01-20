<cfoutput>
    <cfset local.productId = URL.productId>
    <cfset local.file = "">
    <div class="productBodydiv">
            <div class="productImgMaindiv d-flex flex-column flex-md-row">
                <div class="productLeft d-flex flex-column">
                    <div class="productImgdiv d-flex">
                        <div class="productImagesdivLeft d-none d-md-flex flex-md-column">
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
                        <div class="productImagesdivRight ps-2 pt-3">
                            <div class="productMainimg ms-md-5">
                                <img src="Assets/uploadImages/#local.file#" class="mainImg" alt="">
                            </div>
                        </div>
                    </div>
                    <div class="productButtondiv d-none d-md-flex ">
                        <div class="cartButtondiv w-50 me-1">
                            <button class="cartBtn border-0 text-white ">
                                <img src="assets/images/cart.png" class="cartButtonImg mb-1 me-1" alt="">ADD TO CART
                            </button>
                        </div>
                        <div class="buyButtondiv w-50 ms-1">
                            <button class="buy border-0 text-white">
                                <img src="assets/images/buy.png" class="cartButtonImg mb-1 me-1" alt="">BUY NOW
                            </button>
                        </div>
                    </div>
                    <div class="productButtondiv d-flex d-sm-none w-100 px-2">
                        <img src="assets/images/mobilecart.webp" class="" alt="">
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
                                <a href="" class="pathLink text-decoration-none">Home</a>
                                <img src="assets/images/rightarrowgrey.png" class="me-1" alt="">
                            </div>
                            <div class="pathMobile">
                                <a href="" class="pathLink mobile text-decoration-none">Mobile & Accessories</a>
                                <img src="assets/images/rightarrowgrey.png" class="me-1" alt="">
                            </div>
                            <div class="pathMobile">
                                <a href="" class="pathLink text-decoration-none">Mobiles</a>
                                <img src="assets/images/rightarrowgrey.png" class="me-1" alt="">
                            </div>
                            <div class="pathMobile">
                                <a href="" class="pathLink text-decoration-none">OPPO Mobile</a>
                                <img src="assets/images/rightarrowgrey.png" class="me-1" alt="">
                            </div>
                            <div class="pathMobile pt-1">
                                <span class="pathLink">OPPO K12x...</span>
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
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" class="shareIcon">
                                    <path d="M14.78 5.883L9.032 0v3.362C3.284 4.202.822 8.404 0 12.606 2.053 9.666 4.927 8.32 9.032 8.32v3.446l5.748-5.883z" class="g9gS7K" fill-rule="evenodd"></path>
                                </svg>
                                <span class="share">Share</span>
                            </div>
                        </div>
                    </div>
                    <div class="productButtondiv d-none d-sm-flex d-md-none">
                        <div class="cartButtondiv w-50 me-1">
                            <button class="cartBtn border-0 text-white ">
                                <img src="assets/images/cart.png" class="cartButtonImg mb-1 me-1" alt="">ADD TO CART </button>
                        </div>
                        <div class="buyButtondiv w-50 ms-1">
                            <button class="buy border-0 text-white">
                                <img src="assets/images/buy.png" class="cartButtonImg mb-1 me-1" alt="">BUY NOW </button>
                        </div>
                    </div>
                    <div class="mobileSelectdiv d-flex flex-column d-md-none">
                        <div class="selectVarient">Select Varient</div>
                        <div class="selectVarient d-flex justify-content-between">
                            <div class="selectColorspan">Color:
                                <span class="colerType">Feather Pink</span>
                            </div>
                            <div class="colorNum">3 more
                                <img src="assets/images/rightarrow.png" alt="">
                            </div>
                        </div>
                        <div class="selectVarient d-flex justify-content-between">
                            <div class="selectColorspan">Storage:
                                <span class="colerType">256 GB</span>
                            </div>
                            <div class="colorNum">3 more
                                <img src="assets/images/rightarrow.png" alt="">
                            </div>
                        </div>
                        <div class="selectVarient d-flex justify-content-between">
                            <div class="selectColorspan">RAM:
                                <span class="colerType">8 GB</span>
                            </div>
                            <div class="colorNum">3 more
                                <img src="assets/images/rightarrow.png" alt="">
                            </div>
                        </div>
                    </div>
                    <div class="mobileDetailsdiv">
                        <cfset local.productDetails = application.obj.displayProduct(productId = local.productId )>
                        <div class="headingDiv">#local.productDetails.productName#</div>
                        <div class="mobileRatingdiv">
                            <div class="rating d-none d-md-flex align-items-center py-1">
                                <img src="assets/images/rating.png" class="" alt="">
                                <span class="ratingSpan ms-2">37,817 Ratings & 1,431 Reviews</span>
                                <img src="assets/images/assured.png" class="ms-2" alt="">
                            </div>
                            <div class="rating d-flex d-md-none align-items-center justify-content-between py-1">
                                <div class="d-flex">
                                    <img src="assets/images/ratingstar.png" class="" alt="">
                                    <a class="ratingSpan ms-2 text-decoration-none">8,715 ratings</a>
                                </div>
                                <div class="">
                                    <img src="assets/images/flipassured.png" class="ms-auto" alt="">
                                </div>
                            </div>
                            <!--- <div class="discountDiv mt-1">
                                <span class="discount text-success">Extra ₹4000 off</span>
                            </div> --->
                            <div class="priceDiv d-none d-md-flex align-items-center">
                                <span class="price">RS. #local.productDetails.price#</span>
                                <!--- <span class="actualAmount text-decoration-line-through">₹16,999</span>
                                <span class="off text-success">23% off</span> --->
                            </div>
                            <!--- <div class="priceDiv d-flex d-md-none align-items-center">
                                <span class="off text-success">23% off</span>
                                <span class="actualAmount text-decoration-line-through">₹16,999</span>
                                <span class="price">₹12,999</span>
                            </div> --->
                            <div class="fee mt-2 m-sm-none">+ ₹59 Secured Packaging Fee</div>
                            <div class="freeDeliver d-flex d-sm-none">Free delivery by Oct 10</div>
                            <div class="fee d-flex">No cost EMI RS.2,345/month<a href="" class="d-flex d-sm-none deliverPlans text-decoration-none ms-1">View Plans</a></div>
                            <div class="sellerFinddiv d-flex d-sm-none justify-content-between align-items-center">
                                <span class="findSeller">Find a seller that delivers to you</span>
                                <div class="findPin d-flex">
                                    <a href="" class="pinLink text-decoration-none">Enter pincode</a>
                                </div>
                            </div>
                            <div class="deliveryDatediv d-flex d-sm-none align-items-center py-3">
                                <img src="assets/images/truck.png" class="" alt="" height="25">
                                <div class="deliveryDate d-flex flex-column ms-2">
                                    <div class="deliverySpandiv d-flex ">
                                        <span class="greenFree text-success">Free Delivery</span>
                                        <span class="deliveryCharge text-decoration-line-through ms-2">₹40</span>
                                        <span class="dateSpan ms-2">Delivered by 10 Oct, Thursday</span>
                                    </div>
                                    <div class="ifOrdereddiv d-flex">
                                        <span class="ifOrdered">If ordered within</span>
                                        <span class="ifOrderedcolor ms-2">01h 13m 53s</span>
                                    </div>
                                </div>
                            </div>
                            <div class="replacementMainDiv d-flex d-sm-none w-100 mt-3 justify-content-between">
                                <div class="replacementDiv d-flex flex-column align-items-center">
                                    <img src="assets/images/servicecenter.png" class="mt-1" width="30" alt="">
                                    <span class="replacementSpan mx-auto mt-2 text-center">7 Days Service Center Replacement/Repair</span>
                                </div>
                                <div class="replacementDiv d-flex flex-column  align-items-center">
                                    <img src="assets/images/cashdelivery.png" class="" width="30" alt="">
                                    <span class="replacementSpan mx-auto mt-2 text-center">Cash On Delivery available</span>
                                </div>
                                <div class="replacementDiv d-flex flex-column  align-items-center">
                                    <img src="assets/images/fassured.png" class="" alt="">
                                    <span class="replacementSpan mx-auto mt-4">F-Assured</span>
                                </div>
                            </div>
                            <!--- <div class="offersMaindiv d-none d-sm-flex flex-column">
                                <div class="offerHeaddiv py-2">
                                    <span class="offerHead">Available offers</span>
                                </div>
                                <div class="offersDiv d-flex flex-column">
                                    <span class="offerSpan pb-2">
                                            <img src="assets/images/tag.png" class="me-1" alt="">
                                            <span class="offer">
                                                <b>Bank Offer </b>5% Unlimited Cashback on Flipkart Axis Bank Credit Card <a href="" class="text-decoration-none">T&C</a>
                                            </span>
                                    </span>
                                    <span class="offerSpan pb-2">
                                            <img src="assets/images/tag.png" class="me-1" alt="">
                                            <span class="offer">
                                                <b>Bank Offer </b>10% off up to ₹500 on HDFC Bank Credit Card and Credit EMI Transactions. Min Txn Value: ₹4,999 <a href="" class="text-decoration-none">T&C</a>
                                            </span>
                                    </span>
                                    <span class="offerSpan pb-2">
                                            <img src="assets/images/tag.png" class="me-1" alt="">
                                            <span class="offer">
                                                <b>Bank Offer </b>5% Additional ₹600 off on Credit and Debit card Transaction <a href="" class="text-decoration-none">T&C</a>
                                            </span>
                                    </span>
                                    <span class="offerSpan pb-2">
                                            <img src="assets/images/tag.png" class="me-1" alt="">
                                            <span class="offer">
                                                <b>Bank Offer </b>5% Get extra ₹4000 off (price inclusive of cashback/coupon) <a href="" class="text-decoration-none">T&C</a>
                                            </span>
                                    </span>
                                    <div class="offerViewdiv">
                                        <a href="" class="offerView text-decoration-none">
                                            <b>View 3 more offers</b>
                                        </a>
                                    </div>
                                </div>
                            </div> --->
                        </div>
                    </div>
                    <div class="withoutExchangediv d-none d-sm-flex">
                        <div class="exchangeTable d-flex flex-column">
                            <div class="tableRowone forColor d-flex">
                                <input type="radio" class="radioInput">
                                <div class="buyExchange d-flex">
                                    <span class="spanOne">Buy without Exchange</span>
                                    <span class="spanTwo ms-auto">₹12,999</span>
                                </div>
                            </div>
                            <div class="tableRowone">
                                <div class="exchangeDiv d-flex flex-column">
                                    <div class="withExchange d-flex">
                                        <input type="radio" class="radioInput" disabled>
                                        <div class="withExchangediv d-flex">
                                            <span class="spanOne buyGrey">Buy with Exchange</span>
                                            <span class="spanTwo buyGrey ms-auto">up to ₹7,950 off</span>
                                        </div>
                                    </div>
                                    <span class="checkPin text-danger">Enter pincode to check if exchange is available</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- <div class="manufactureWarrantydiv">
                        <div class="warrantyDiv d-flex">
                            <div class="logoDiv">
                                <img src="assets/images/oppoText.jpg" class="oppoImg" alt="">
                            </div>
                            <div class="warrantyText d-flex">
                                <span class="warrantySpan">1 Year Manufacturer Warranty for Device and 6 Months Manufacturer Warranty for Inbox Accessories
                                   <a href="" class="checkSpan text-decoration-none">Know More</a>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="otherHighlightsdiv d-flex flex-column d-sm-none">
                        <div class="otherHighlightsHead">
                            Highlights
                        </div>
                        <div class="highDiv d-flex align-items-center mt-3">
                            <img src="assets/images/ram.webp" class="" alt="" height="32" width="32">
                            <div class="partDiv d-flex flex-column ms-4">
                                <span class="part mb-2">RAM | ROM</span>
                                <span class="capability">8 GB RAM | 256 GB ROM </span>
                            </div>
                        </div>
                        <div class="highDiv d-flex align-items-center mt-3">
                            <img src="assets/images/processor.webp" class="" alt="" height="32" width="32">
                            <div class="partDiv d-flex flex-column ms-4">
                                <span class="part mb-2">Processor</span>
                                <span class="capability">Dimensity 6300 | Octa Core | 2.4 GHz</span>
                            </div>
                        </div>
                        <div class="highDiv d-flex align-items-center mt-3">
                            <img src="assets/images/rcamera.webp" class="" alt="" height="32" width="32">
                            <div class="partDiv d-flex flex-column ms-4">
                                <span class="part mb-2">Rear Camera</span>
                                <span class="capability">32MP + 2MP</span>
                            </div>
                        </div>
                        <div class="highDiv d-flex align-items-center mt-3">
                            <img src="assets/images/fcamera.webp" class="" alt="" height="32" width="32">
                            <div class="partDiv d-flex flex-column ms-4">
                                <span class="part mb-2">Front Camera</span>
                                <span class="capability">8 MP</span>
                            </div>
                        </div>
                        <div class="highDiv d-flex align-items-center mt-3">
                            <img src="assets/images/display.webp" class="" alt="" height="32" width="32">
                            <div class="partDiv d-flex flex-column ms-4">
                                <span class="part mb-2">display</span>
                                <span class="capability">6.67 inch LCD</span>
                            </div>
                        </div>
                        <div class="highDiv d-flex align-items-center mt-3">
                            <img src="assets/images/battery.webp" class="" alt="" height="32" width="32">
                            <div class="partDiv d-flex flex-column ms-4">
                                <span class="part">Battery</span>
                                <span class="capability">5100 mAh</span>
                            </div>
                        </div>
                    </div>
                    <div class="specDiv d-flex flex-column d-none d-sm-flex">
                        <div class="specRow1 d-flex">
                            <div class="colorDiv d-flex">
                                <span class="colorSpan">Color</span>
                                <div class="specImgrow d-flex">
                                    <div class="specImgdiv">
                                        <img src="assets/images/oppoblue.webp" class="specImg" alt="">
                                    </div>
                                    <div class="specImgdiv">
                                        <img src="assets/images/oppopink.webp" class="specImg" alt="">
                                    </div>
                                    <div class="specImgdiv">
                                        <img src="assets/images/oppoviolet.webp" class="specImg" alt="">
                                    </div>
                                </div>
                            </div>
                            <div class="storageDiv d-flex d-flex">
                                <span class="colorSpan">Storage</span>
                                <div class="storageRow d-flex">
                                    <div class="storage">
                                        128 GB
                                    </div>
                                    <div class="storageGrey">
                                        256 GB
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="specRow2">
                            <div class="ramDiv d-flex">
                                <span class="colorSpan">RAM</span>
                                <div class="ramRow d-flex">
                                    <div class="ram">
                                        6 GB
                                    </div>
                                    <div class="ramGrey">
                                        8 GB
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> --->
                    <div class="deliveryPindiv d-none d-sm-flex">
                        <div class="deliveryPin d-flex flex-column">
                            <div class="pinDin d-flex">
                                <span class="colorSpan">Delivery</span>
                                <div class="pinInputdiv d-flex">
                                    <img src="assets/images/loc.png" class="locImg" alt="">
                                    <input type="text" class="pinInput border-0" placeholder="Enter Delivey Pincode">
                                    <a href="" class="checkSpan text-decoration-none me-3">Check</a>
                                </div>
                                <div class="enterPindiv ms-3">
                                    Enter Pincode
                                </div>
                            </div>
                            <div class="expectedDeliveydiv d-flex flex-column">
                                <span class="deliveryDate d-flex">Delivery by9 Oct, Wednesday 
                                               <span class="deliveryFree ms-1"> | Free</span>
                                <span class="text-decoration-line-through ms-1">₹40</span>
                                <img src="assets/images/roundquestion.png" class="ms-1" alt="">
                                </span>
                                <span class="orderDate">if ordered before 12:24 PM</span>
                                <a href="" class="checkSpan text-decoration-none">View Details</a>
                            </div>
                        </div>
                    </div>
                    <!--- <div class="highlightMaindiv d-none d-sm-flex flex-column flex-md-row">
                        <div class="highlightDiv d-flex">
                            <span class="colorSpan">Highlights</span>
                            <ul class="highlightUl ms-md-3 pe-5">
                                <li class="highlightLi">6 GB RAM | 128 GB ROM | Expandable Upto 1 TB</li>
                                <li class="highlightLi">16.94 cm (6.67 inch) HD Display</li>
                                <li class="highlightLi">32MP + 2MP | 8MP Front Camera</li>
                                <li class="highlightLi">5100 mAh Battery</li>
                                <li class="highlightLi">Dimensity 6300 Processor</li>
                            </ul>
                        </div>
                        <div class="easyPaymentdiv d-flex">
                            <span class="colorSpan easy">Easy Payment Options</span>
                            <ul class="highlightUl">
                                <li class="highlightLi">No cost EMI starting from ₹4,333/month</li>
                                <li class="highlightLi">Cash on Delivery</li>
                                <li class="highlightLi">Net banking & Credit/ Debit/ ATM card</li>
                                <li class="highlightView"><a href="" class="checkSpan text-decoration-none">View Details</a>
                            </ul>
                        </div>
                    </div> --->
                    <div class="productSeller d-none d-sm-flex">
                        <span class="colorSpan">Seller</span>
                        <div class="sellerDetailsdiv d-flex flex-column">
                            <div class="sellerName d-flex">
                                <a href="" class="checkSpan text-decoration-none ms-3 me-2">BUZZINDIA</a>
                                <img src="assets/images/sellerrating.png" alt="">
                            </div>
                            <ul class="highlightUl">
                                <li class="highlightLi">7 Days Service Center Replacement/Repair <img src="assets/images/roundquestion.png" alt=""></li>
                                <li class="highlightLi">GST invoice available <img src="assets/images/roundquestion.png" alt=""></li>
                                <li class="highlightView"><a href="" class="checkSpan text-decoration-none">See other sellers</a>
                            </ul>
                        </div>
                    </div>
                    <div class="superCoindiv d-none d-sm-flex">
                        <img src="assets/images/supercoin.png" class="superImg w-100" alt="">
                    </div>
                    <div class="discriptionDiv d-none d-sm-flex">
                        <span class="colorSpan">Discription</span>
                        <span class="discription"># local.productDetails.description#</span>
                    </div>
                    <!--- <div class="productDecriptiondiv d-none d-sm-flex flex-column">
                        <span class="descriptionHead">Product Description</span>
                        <div class="ultraThindiv d-flex">
                            <div class="ultraLeft">
                                <img src="assets/images/ultrathin.webp" class="" width="168" alt="">
                            </div>
                            <div class="ultraRight d-flex flex-column">
                                <span class="ultraHead">7.68 mm Ultra-Slim Premium Gleaming Design</span>
                                <span class="ultraDescription">Sleek, aesthetic and light, this is the ultimate stylish device that will turn heads wherever you go. Classy, cool and bright vibes, this phone packs a big battery in a slim 7.68 mm casing. - Weight about 186 g</span>
                            </div>
                        </div>
                        <div class="pocketDiv d-flex">
                            <div class="pocketLeft d-flex flex-column">
                                <span class="ultraHead">Carry the Sky in Your Pocket</span>
                                <span class="ultraDescription">Imagine taking a clear blue sky over lush meadows with you wherever you go. The innovative magnetic particle design creates a feeling of movement, evoking a gentle summer’s breeze. Evoking the night sky touched by glittering moonlight, this sophisticated colour with shimmering OPPO Glow texture whispers fashion classic and understated elegance.</span>
                            </div>
                            <div class="pocketRight">
                                <img src="assets/images/pocket.webp" class="" width="168" alt="">
                            </div>
                        </div>
                        <a href="" class="viewFeatureslink text-decoration-none">View all features</a>
                    </div> --->
                    <!--- <div class="productDecriptiondiv d-none d-sm-flex flex-column">
                        <span class="descriptionHead">Specifications</span>
                        <div class="generalDiv d-flex flex-column">
                            <span class="generalHead">General</span>
                            <table class="generalTable">
                                <tr class="tableRow">
                                    <td class="tableDataleft">In The Box</td>
                                    <td class="tableDataright">Handset, Charger, USB Data Cable, Sim Ejector Tool, Quick Guide, Protective Case</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Model Number</td>
                                    <td class="tableDataright">CPH2667</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Model Name</td>
                                    <td class="tableDataright">K12x 5G</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Color</td>
                                    <td class="tableDataright">Feather Pink</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Browse Type</td>
                                    <td class="tableDataright">Smartphones</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">SIM Type</td>
                                    <td class="tableDataright">Duel Sim</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Hybrid Slot</td>
                                    <td class="tableDataright">Yes</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Touch Screen</td>
                                    <td class="tableDataright">Yes</td>
                                </tr>
                            </table>
                        </div>
                        <a href="" class="viewFeatureslink text-decoration-none">Read More</a>
                    </div> --->
                    <!--- <div class="productDecriptiondiv d-flex d-sm-none flex-column">
                        <div class="generalDiv d-flex flex-column">
                            <span class="generalHead">Other Details</span>
                            <table class="generalTable">
                                <tr class="tableRow">
                                    <td class="tableDataleft">Network Type</td>
                                    <td class="tableDataright">5G, 4G, 3G, 2G</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Sim Type</td>
                                    <td class="tableDataright">Duel Sim</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Expandale Storage</td>
                                    <td class="tableDataright">Yes</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Audio Jack</td>
                                    <td class="tableDataright">No</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">Quick Charging</td>
                                    <td class="tableDataright">Yes</td>
                                </tr>
                                <tr class="tableRow">
                                    <td class="tableDataleft">In the box</td>
                                    <td class="tableDataright">Handset, Charger, USB Data Cable, Sim Ejector Tool, Quick Guide, Protective Case</td>
                                </tr>
                            </table>
                        </div>
                    </div> --->
                    <div class="productHighlightdiv d-flex flex-column d-sm-none">
                        <div class="d-flex align-items-center justify-content-between">
                            <span class="productHighlightHead px-4 py-3">Product Highlights</span>
                            <img src="assets/images/productarrow.png" class="" height="20" alt="">
                        </div>
                        <div class="productHighlightsImages d-flex flex-column">
                            <img src="assets/images/highlight1.webp" class="" alt="">
                            <img src="assets/images/highlight2.webp" class="" alt="">
                            <img src="assets/images/highlight3.webp" class="" alt="">
                            <img src="assets/images/highlight4.webp" class="" alt="">
                            <img src="assets/images/highlight5.webp" class="" alt="">
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
                            <div class="progressCirclediv d-flex mx-auto mx-md-3 ">
                                <div class="progressCircle d-flex flex-column">
                                    <img src="assets/images/rate3.9.png" class="progressImg" width="70" alt="">
                                    <span class="progressCategory mx-auto">Camera</span>
                                </div>
                                <div class="progressCircle d-flex flex-column">
                                    <img src="assets/images/rate4.png" class="progressImg" width="70" alt="">
                                    <span class="progressCategory mx-auto">Battery</span>
                                </div>
                                <div class="progressCircle d-flex flex-column">
                                    <img src="assets/images/rate4.2.png" class="progressImg" width="70" alt="">
                                    <span class="progressCategory mx-auto">Display</span>
                                </div>
                                <div class="progressCircle d-flex flex-column">
                                    <img src="assets/images/rate4.png" class="progressImg" width="70" alt="">
                                    <span class="progressCategory mx-auto">design</span>
                                </div>
                            </div>
                        </div>
                        <div class="reviewPhotosdiv d-flex">
                            <img src="assets/images/review1.png" class="reviewImg" width="90" alt="">
                            <img src="assets/images/review2.png" class="reviewImg" width="90" alt="">
                            <img src="assets/images/review3.png" class="reviewImg" width="90" alt="">
                            <img src="assets/images/review4.png" class="reviewImg" width="90" alt="">
                            <img src="assets/images/review5.png" class="reviewImg" width="90" alt="">
                            <img src="assets/images/review6.png" class="reviewImg" width="90" alt="">
                            <img src="assets/images/review7.png" class="reviewImg" width="90" alt="">
                            <img src="assets/images/review8.png" class="reviewImg" width="90" alt="">
                            <img src="assets/images/reviewplus.png" class="reviewImg" width="90" alt="">
                        </div>
                        <div class="customerReviewdiv d-flex flex-column">
                            <div class="customerReviewhead">
                                <img src="assets/images/fivestar.png" class="" width="35" height="23" alt="">
                                <span class="reviewHead">Terrific purchase</span>
                            </div>
                            <div class="customerReview d-flex flex-column pt-2">
                                <span class="customerReviewspan">Nice camera 😍😍</span>
                                <span class="customerReviewspan">Nice battery 😊😊</span>
                            </div>
                            <div class="customerReviewphotos d-flex pt-3">
                                <img src="assets/images/review1.png" class="reviewImg" width="60" alt="">
                                <img src="assets/images/review2.png" class="reviewImg" width="60" alt="">
                                <img src="assets/images/review3.png" class="reviewImg" width="60" alt="">
                            </div>
                            <div class="customerDetailsdiv d-flex flex-column flex-md-row w-100 justify-content-md-between pt-2">
                                <div class="customerDetails d-flex w-75 align-items-center">
                                    <span class="customerName">Sachin Roy</span>
                                    <img src="assets/images/certified.png" class="" width="20" height="20" alt="">
                                    <span class="customerLocation">Certified Buyer, Kolkata</span>
                                    <span class="customerLocation ms-1">1 month ago</span>
                                </div>
                                <div class="responseDiv d-flex align-items-center">
                                    <img src="assets/images/like.png" class="" alt="">
                                    <span class="likeCount me-4">1318</span>
                                    <img src="assets/images/dislike.png" class="" alt="">
                                    <span class="likeCount me-4">415</span>
                                    <img src="assets/images/arrowdown.png" class="" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="customerReviewdiv d-flex flex-column">
                            <div class="customerReviewhead">
                                <img src="assets/images/fivestar.png" class="" width="35" height="23" alt="">
                                <span class="reviewHead">Worth every penny</span>
                            </div>
                            <div class="customerReview d-flex flex-column pt-2">
                                <span class="customerReviewspan">Good looking 🤩</span>
                                <span class="customerReviewspan">battery backup 95% good 👍</span>
                                <span class="customerReviewspan">Camera 📸 quality batter 🤏</span>
                                <span class="customerReviewspan">Nice Processor for BGMI</span>
                                <span class="customerReviewspan">Price range all-over best.✅</span>
                            </div>
                            <div class="customerReviewphotos d-flex pt-3">
                                <img src="assets/images/review4.png" class="reviewImg" width="60" alt="">
                                <img src="assets/images/review5.png" class="reviewImg" width="60" alt="">
                                <img src="assets/images/review6.png" class="reviewImg" width="60" alt="">
                            </div>
                            <div class="customerDetailsdiv d-flex flex-column flex-md-row w-100 justify-content-md-between pt-2">
                                <div class="customerDetails d-flex w-75 align-items-center">
                                    <span class="customerName">Deepak Sah</span>
                                    <img src="assets/images/certified.png" class="" width="20" height="20" alt="">
                                    <span class="customerLocation">Certified Buyer, Pashchim Champaran District</span>
                                    <span class="customerLocation ms-1">2 months ago</span>
                                </div>
                                <div class="responseDiv d-flex align-items-center">
                                    <img src="assets/images/like.png" class="" alt="">
                                    <span class="likeCount me-4">1678</span>
                                    <img src="assets/images/dislike.png" class="" alt="">
                                    <span class="likeCount me-4">455</span>
                                    <img src="assets/images/arrowdown.png" class="" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="customerReviewdiv d-flex flex-column">
                            <div class="customerReviewhead">
                                <img src="assets/images/fivestar.png" class="" width="35" height="23" alt="">
                                <span class="reviewHead">Fabulous!</span>
                            </div>
                            <div class="customerReview d-flex flex-column pt-2">
                                <span class="customerReviewspan">Good 👍👍👍👍 love 💕💕💕💕💕</span>
                            </div>
                            <div class="customerReviewphotos d-flex pt-3">
                                <img src="assets/images/review7.png" class="reviewImg" width="60" alt="">
                                <img src="assets/images/review8.png" class="reviewImg" width="60" alt="">
                            </div>
                            <div class="customerDetailsdiv d-flex flex-column flex-md-row w-100 justify-content-md-between pt-2">
                                <div class="customerDetails d-flex w-75 align-items-center">
                                    <span class="customerName">Mukesh Hindustani</span>
                                    <img src="assets/images/certified.png" class="" width="20" height="20" alt="">
                                    <span class="customerLocation">Certified Buyer, Mumbai</span>
                                    <span class="customerLocation ms-1">2 months ago</span>
                                </div>
                                <div class="responseDiv d-flex align-items-center">
                                    <img src="assets/images/like.png" class="" alt="">
                                    <span class="likeCount me-4">2318</span>
                                    <img src="assets/images/dislike.png" class="" alt="">
                                    <span class="likeCount me-4">345</span>
                                    <img src="assets/images/arrowdown.png" class="" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="customerReviewdiv d-flex flex-column">
                            <div class="customerReviewhead">
                                <img src="assets/images/fivestar.png" class="" width="35" height="23" alt="">
                                <span class="reviewHead">Terrific purchase</span>
                            </div>
                            <div class="customerReview d-flex flex-column pt-2">
                                <span class="customerReviewspan">Nice camera 😍😍</span>
                                <span class="customerReviewspan">Nice battery 😊😊</span>
                            </div>
                            <div class="customerReviewphotos d-flex pt-3">
                                <img src="assets/images/review1.png" class="reviewImg" width="60" alt="">
                                <img src="assets/images/review2.png" class="reviewImg" width="60" alt="">
                                <img src="assets/images/review3.png" class="reviewImg" width="60" alt="">
                            </div>
                            <div class="customerDetailsdiv d-flex flex-column flex-md-row w-100 justify-content-md-between pt-2">
                                <div class="customerDetails d-flex w-75 align-items-center">
                                    <span class="customerName">Sachin Roy</span>
                                    <img src="assets/images/certified.png" class="" width="20" height="20" alt="">
                                    <span class="customerLocation">Certified Buyer, Kolkata</span>
                                    <span class="customerLocation ms-1">1 month ago</span>
                                </div>
                                <div class="responseDiv d-flex align-items-center">
                                    <img src="assets/images/like.png" class="" alt="">
                                    <span class="likeCount me-4">1318</span>
                                    <img src="assets/images/dislike.png" class="" alt="">
                                    <span class="likeCount me-4">415</span>
                                    <img src="assets/images/arrowdown.png" class="" alt="">
                                </div>
                            </div>
                        </div>
                        <a href="" class="viewFeatureslink text-decoration-none"><b>View 1598 reviews</b></a>
                    </div>
                    <div class="questionAnswerdiv d-flex flex-column">
                        <div class="questionAnswerrow d-flex justify-content-between align-items-center">
                            <span class="questionAnswerHead">Questions and Answers</span>
                            <img src="assets/images/searchanswer.png" class="" alt="">
                        </div>
                        <div class="customerQuestiondiv d-flex flex-column">
                            <span class="questions">Q: What about gaming.. Like free fire how it performs</span>
                            <span class="answers mt-2"><b>A:</b> It's decent for heavy gaming</span>
                            <div class="questionCustomerdiv d-flex align-items-center justify-content-between">
                                <div class="answerdCustomer d-flex flex-column">
                                    <span class="customerName mt-1">Mayank Kashyap</span>
                                    <div class="questionCertified">
                                        <img src="assets/images/certified.png" class="" width="20" height="20" alt="">
                                        <span class="customerLocation">Certified Buyer, Kolkata</span>
                                    </div>
                                </div>
                                <div class="responseDiv d-flex align-items-center">
                                    <img src="assets/images/like.png" class="" alt="">
                                    <span class="likeCount me-4">1318</span>
                                    <img src="assets/images/dislike.png" class="" alt="">
                                    <span class="likeCount me-4">415</span>
                                    <img src="assets/images/arrowdown.png" class="" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="customerQuestiondiv d-flex flex-column">
                            <span class="questions">Q: Jio sim accept in this phone</span>
                            <span class="answers mt-2"><b>A:</b> Jio pio Lio all are fine working</span>
                            <div class="questionCustomerdiv d-flex align-items-center justify-content-between">
                                <div class="answerdCustomer d-flex flex-column">
                                    <span class="customerName mt-1">Anonymous</span>
                                    <div class="questionCertified">
                                        <img src="assets/images/certified.png" class="" width="20" height="20" alt="">
                                        <span class="customerLocation">Certified Buyer, Kolkata</span>
                                    </div>
                                </div>
                                <div class="responseDiv d-flex align-items-center">
                                    <img src="assets/images/like.png" class="" alt="">
                                    <span class="likeCount me-4">1318</span>
                                    <img src="assets/images/dislike.png" class="" alt="">
                                    <span class="likeCount me-4">415</span>
                                    <img src="assets/images/arrowdown.png" class="" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="customerQuestiondiv d-flex flex-column">
                            <span class="questions">Q: In this phone has a game turbo in voice change option yes or not</span>
                            <span class="answers mt-2"><b>A:</b> Yes</span>
                            <div class="questionCustomerdiv d-flex align-items-center justify-content-between">
                                <div class="answerdCustomer d-flex flex-column">
                                    <span class="customerName mt-1">Mayank Kashyap</span>
                                    <div class="questionCertified">
                                        <img src="assets/images/certified.png" class="" width="20" height="20" alt="">
                                        <span class="customerLocation">Certified Buyer, Kolkata</span>
                                    </div>
                                </div>
                                <div class="responseDiv d-flex align-items-center">
                                    <img src="assets/images/like.png" class="" alt="">
                                    <span class="likeCount me-4">1318</span>
                                    <img src="assets/images/dislike.png" class="" alt="">
                                    <span class="likeCount me-4">415</span>
                                    <img src="assets/images/arrowdown.png" class="" alt="">
                                </div>
                            </div>
                        </div>
                        <a href="" class="viewFeatureslink text-decoration-none"><b>All questions</b></a>
                    </div>
                    <div class="safeBottomdiv d-flex justify-content-center align-items-center">
                        <img src="assets/images/safeguard.png" class="" alt="">
                        <span class="safeBottom">Safe and Secure Payments.Easy returns.100% Authentic products.</span>
                    </div>
                </div>
            </div>
            <div class="similarProductsdiv d-flex flex-column mb-5 mb-lg-0">
                <span class="similarProductshead mt-4">Similar Products</span>
                <div class="similarProductsrow d-flex">
                    <div class="similarProductcol d-flex flex-column">
                        <img src="assets/images/moto.webp" class="similarImage mx-auto" height="186" alt="">
                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                            <span class="productsNamespan">Moto G85 5G</span>
                            <div class="d-flex mt-1 align-items-center">
                                <img src="assets/images/rating.png" class="w-100" alt="">
                                <span class="productsReviewspan ms-2">(71,876)</span>
                                <img src="assets/images/assured.png" class="ms-2" alt="">
                            </div>
                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                <span class="similarPrice">₹12,999</span>
                                <span class="productsReviewspan text-decoration-line-through ms-2">₹16,999</span>
                                <span class="similarOff text-success ms-2">23% off</span>
                            </div>
                        </div>
                    </div>
                    <div class="similarProductcol d-flex flex-column ms-2">
                        <img src="assets/images/a40.webp" class="similarImage mx-auto" height="186" alt="">
                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                            <span class="productsNamespan">Samsung A40</span>
                            <div class="d-flex mt-1 align-items-center">
                                <img src="assets/images/rating.png" class="w-100" alt="">
                                <span class="productsReviewspan ms-2">(71,876)</span>
                                <img src="assets/images/assured.png" class="w-100 ms-2" alt="">
                            </div>
                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                <span class="similarPrice">₹12,999</span>
                                <span class="productsReviewspan text-decoration-line-through ms-2">₹16,999</span>
                                <span class="similarOff text-success ms-2">23% off</span>
                            </div>
                        </div>
                    </div>
                    <div class="similarProductcol d-flex flex-column ms-2">
                        <img src="assets/images/oppo1.webp" class="similarImage mx-auto" height="186" alt="">
                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                            <span class="productsNamespan">Moto G85 5G</span>
                            <div class="d-flex mt-1 align-items-center">
                                <img src="assets/images/rating.png" class="w-100" alt="">
                                <span class="productsReviewspan ms-2">(71,876)</span>
                                <img src="assets/images/assured.png" class="w-100 ms-2" alt="">
                            </div>
                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                <span class="similarPrice">₹12,999</span>
                                <span class="productsReviewspan text-decoration-line-through ms-2">₹16,999</span>
                                <span class="similarOff text-success ms-2">23% off</span>
                            </div>
                        </div>
                    </div>
                    <div class="similarProductcol d-flex flex-column ms-2">
                        <img src="assets/images/pixel.webp" class="similarImage mx-auto" height="186" alt="">
                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                            <span class="productsNamespan">Google Pixel 7a</span>
                            <div class="d-flex mt-1 align-items-center">
                                <img src="assets/images/rating.png" class="w-100" alt="">
                                <span class="productsReviewspan ms-2">(71,876)</span>
                                <img src="assets/images/assured.png" class="w-100 ms-2" alt="">
                            </div>
                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                <span class="similarPrice">₹12,999</span>
                                <span class="productsReviewspan text-decoration-line-through ms-2">₹16,999</span>
                                <span class="similarOff text-success ms-2">23% off</span>
                            </div>
                        </div>
                    </div>
                    <div class="similarProductcol d-flex flex-column ms-2">
                        <img src="assets/images/oppo3.webp" class="similarImage mx-auto" height="186" alt="">
                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                            <span class="productsNamespan">OPPO Reno 12 Pro 5G</span>
                            <div class="d-flex mt-1 align-items-center">
                                <img src="assets/images/rating.png" class="w-100" alt="">
                                <span class="productsReviewspan ms-2">(71,876)</span>
                                <img src="assets/images/assured.png" class="w-100 ms-2" alt="">
                            </div>
                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                <span class="similarPrice">₹12,999</span>
                                <span class="productsReviewspan text-decoration-line-through ms-2">₹16,999</span>
                                <span class="similarOff text-success ms-2">23% off</span>
                            </div>
                        </div>
                    </div>
                    <div class="similarProductcol d-flex flex-column ms-2">
                        <img src="assets/images/oppoviolet.webp" class="similarImage mx-auto" height="186" alt="">
                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                            <span class="productsNamespan">OPPO Reno 12 Pro 5G</span>
                            <div class="d-flex mt-1 align-items-center">
                                <img src="assets/images/rating.png" class="w-100" alt="">
                                <span class="productsReviewspan ms-2">(71,876)</span>
                                <img src="assets/images/assured.png" class="w-100 ms-2" alt="">
                            </div>
                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                <span class="similarPrice">₹12,999</span>
                                <span class="productsReviewspan text-decoration-line-through ms-2">₹16,999</span>
                                <span class="similarOff text-success ms-2">23% off</span>
                            </div>
                        </div>
                    </div>
                    <div class="similarProductcol d-flex flex-column ms-2">
                        <img src="assets/images/oppo6.webp" class="similarImage mx-auto" height="186" alt="">
                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                            <span class="productsNamespan">OPPO K12x 5G with 45W</span>
                            <div class="d-flex mt-1 align-items-center">
                                <img src="assets/images/rating.png" class="w-100" alt="">
                                <span class="productsReviewspan ms-2">(71,876)</span>
                                <img src="assets/images/assured.png" class="w-100 ms-2" alt="">
                            </div>
                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                <span class="similarPrice">₹12,999</span>
                                <span class="productsReviewspan text-decoration-line-through ms-2">₹16,999</span>
                                <span class="similarOff text-success ms-2">23% off</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="bottomContentsdiv d-none d-lg-flex flex-column">
            <span class="bottomHead">Top Stories:Brand Directory</span>
            <a href="" class="bottomLinks text-decoration-none">
                <span class="linkSpan">
                                  MOST SEARCHED IN MOBILES & ACCESSORIES: 
                                 BLACKBERRY CLASSIC PRICE IN INDIA | GIONEE P4 PRICE | INTEX AQUA Y2 PRO | KARBONN TITANIUM HEXA | LENOVO SISLEY S90 | LG G2 PRICE IN INDIA | MICROMAX CANVAS KNIGHT 2 PRICE | MICROSOFT 535 PRICE IN INDIA | 8GB MEMORY CARD | APPLE ALL MOBILE PRICE | XIAOMI PHONE PRICE | NOKIA MOBILE UNDER 1000 | SAMSUNG PHONE PRICE IN INDIA | SONY MOBILES | 
                                     MOBILES BELOW 15000 | NOKIA 210 | S4 MINI | SAMSUNG S5 MINI PRICE | XPERIA Z1 | SONY ZL | DELL TABS | SWIPE TABLET | HTC M8 PRICE IN INDIA | MICROMAX FIRE 2 | BUY LENOVO K6 POWER | MI NOTE 4 SPECS | MOTO C FEATURES | PANASONIC ELUGA A | SONY EXPERIA | ONEPLUS TWO PRICE IN INDIAs
                           </span>
            </a>
        </div>
    </div>
    <div class="footerDiv d-none d-sm-flex flex-column bg-dark">
        <div class="footerContents d-flex flex-column flex-xl-row px-5 pt-5">
            <div class="footerColOne d-flex flex-column flex-md-row w-75 justify-content-between ps-3 pe-5 me-4">
                <div class="contentOne d-flex flex-column">
                    <div class="footerHead  mb-2">ABOUT</div>
                    <a href="" class="footerFont">Contact Us</a>
                    <a href="" class="footerFont">About Us</a>
                    <a href="" class="footerFont">Careers</a>
                    <a href="" class="footerFont">Flipkart Stories</a>
                    <a href="" class="footerFont">Press</a>
                    <a href="" class="footerFont">Corporate Information</a>
                </div>
                <div class="contentOne companyDiv d-flex flex-column ">
                    <div class="footerHead mb-2">GROUP COMPANIES</div>
                    <a href="" class="footerFont">Myntra</a>
                    <a href="" class="footerFont">Cleartrip</a>
                    <a href="" class="footerFont">Shopsy</a>
                </div>
                <div class="contentOne d-flex flex-column ">
                    <div class="footerHead mb-2">HELP</div>
                    <a href="" class="footerFont">Payments</a>
                    <a href="" class="footerFont">Shipping</a>
                    <a href="" class="footerFont">Cancellation & Returns</a>
                    <a href="" class="footerFont">FQA</a>
                    <a href="" class="footerFont">Report Infringement</a>
                    <a href="" class="footerFont">Corporate Information</a>
                </div>
            </div>
            <div class="d-flex  flex-column flex-md-row footerColTwo w-100 justify-content-between  ps-3 pe-4">
                <div class="d-flex flex-column a">
                    <div class="footerHead mb-2">CONSUMER POLICY</div>
                    <a href="" class="footerFont">Cancellation & Returns</a>
                    <a href="" class="footerFont">Terms Of Use</a>
                    <a href="" class="footerFont">Security</a>
                    <a href="" class="footerFont">Privacy</a>
                    <a href="" class="footerFont">Sitemap</a>
                    <a href="" class="footerFont">Grievance Redressal</a>
                    <a href="" class="footerFont">EPR Compliance</a>
                </div>
                <div class="mailDiv d-flex flex-column ps-5">
                    <div class="footerHead mb-2">Mail Us:</div>
                    <p class="footerPara">Flipkart Internet Private Limited,</p>
                    <p class="footerPara">Buildings Alyssa, Begonia &</p>
                    <p class="footerPara">Clove Embassy Tech Village,</p>
                    <p class="footerPara">Outer Ring Road, Devarabeesanahalli Village,</p>
                    <p class="footerPara">Bengaluru, 560103,</p>
                    <p class="footerPara">Karnataka, India</p>
                    <div class="footerHead mb-2 mt-3">Social:</div>
                    <div class="socialImg">
                        <img src="assets/images/social.png" width="105" height="25" alt="">
                    </div>
                </div>
                <div class="d-flex flex-column">
                    <div class="footerHead mb-2">Registered Office Address:</div>
                    <p class="footerPara">Flipkart Internet Private Limited,</p>
                    <p class="footerPara">Buildings Alyssa, Begonia &</p>
                    <p class="footerPara">Clove Embassy Tech Village,</p>
                    <p class="footerPara">Outer Ring Road, Devarabeesanahalli Village,</p>
                    <p class="footerPara">Bengaluru, 560103,</p>
                    <p class="footerPara">Karnataka, India</p>
                    <p class="footerPara">CIN : U51109KA2012PTC066107</p>
                    <p class="footerPara">Telephone: 044-45614700 / 044-67415800</p>
                </div>
            </div>
        </div>
        <div class="footerBase d-flex flex-column flex-md-row justify-content-between mt-4 py-4 px-xl-5 mx-xl-3">
            <div class="baseContents">
                <img src="assets/images/seller.png" alt="">
                <a href="" class="baseLink">Become a Seller</a>
            </div>
            <div class="baseContents">
                <img src="assets/images/star.png" alt="">
                <a href="" class="baseLink">Advertise </a>
            </div>
            <div class="baseContents">
                <img src="assets/images/gift.png" alt="">
                <a href="" class="baseLink">Gift Cards</a>
            </div>
            <div class="baseContents">
                <img src="assets/images/help.png" alt="">
                <a href="" class="baseLink">Help Center</a>
            </div>
            <div class="baseContents">
                <img src="assets/images/since.png" alt="">
                <span class="baseLink">2007-2024 Flipkart.com</span>
            </div>
            <div class="footerImgdiv">
                <img class="footerImg" src="assets/images/footerimg.png" alt="">
            </div>
        </div>
    </div>
</cfoutput>