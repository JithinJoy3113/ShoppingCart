            <cfif NOT find("login.cfm", CGI.SCRIPT_NAME) AND NOT find("userSignUp.cfm", CGI.SCRIPT_NAME)>
                <cfif find("product.cfm", CGI.SCRIPT_NAME)>
                    <div class="bottomContentsdiv d-flex flex-column">
                        <span class="bottomHead">Top Stories:Brand Directory</span>
                        <a href="" class="bottomLinks text-decoration-none">
                            <span class="linkSpan">
                                MOST SEARCHED IN MOBILES & ACCESSORIES: 
                                BLACKBERRY CLASSIC PRICE IN INDIA | GIONEE P4 PRICE | INTEX AQUA Y2 PRO | KARBONN TITANIUM HEXA | LENOVO SISLEY S90 | LG G2 PRICE IN INDIA | MICROMAX CANVAS KNIGHT 2 PRICE | MICROSOFT 535 PRICE IN INDIA | 8GB MEMORY CARD | APPLE ALL MOBILE PRICE | XIAOMI PHONE PRICE | NOKIA MOBILE UNDER 1000 | SAMSUNG PHONE PRICE IN INDIA | SONY MOBILES | 
                                MOBILES BELOW 15000 | NOKIA 210 | S4 MINI | SAMSUNG S5 MINI PRICE | XPERIA Z1 | SONY ZL | DELL TABS | SWIPE TABLET | HTC M8 PRICE IN INDIA | MICROMAX FIRE 2 | BUY LENOVO K6 POWER | MI NOTE 4 SPECS | MOTO C FEATURES | PANASONIC ELUGA A | SONY EXPERIA | ONEPLUS TWO PRICE IN INDIAs
                            </span>
                        </a>
                    </div>
                </cfif>
                <div class="sidebar" id="sidebar">
                    <cfoutput>
                    <cfset local.result = application.obj.viewCategory()>
                    <cfset local.subCategoryResult = application.obj.viewSubcategory()>
                    <a href="javascript:void(0)" class="close-btn" id="closeBtn">&times;</a>
                    <div class="accordion accordion-flush sideAccordian" id="accordionFlushExample">
                        <cfloop from = "9" to = "#arrayLen(local.result)#" index="i">
                            <div class="accordion-item">
                                <div class="d-flex categoryBtnHead" id="category#local.result[i].categoryId#">
                                    <div class="d-flex align-items-center">
                                        <cfset local.encryptedCategoryId = urlEncodedFormat(encrypt(local.result[i].categoryId, application.secretKey, "AES", "Base64"))>
                                        <cfset local.encryptedCategoryName = urlEncodedFormat(encrypt(local.result[i].categoryName, application.secretKey, "AES", "Base64"))>
                                        <a href="productListing.cfm?categoryId=#local.encryptedCategoryId#&categoryName=#local.encryptedCategoryName#" class="categoryLinkSide text-decoration-none fw-bold">#local.result[i].categoryName#</a>
                                    </div>
                                    <button class="accordion-button collapsed categoryBtnHead" type="button" data-bs-toggle="collapse" data-bs-target="##categoryId#local.result[i].categoryId#" aria-expanded="false" aria-controls="flush-collapseOne" value="category#local.result[i].categoryId#" onclick="accordianHead(this)">
                                        
                                    </button>
                                </div>
                                <div id="categoryId#local.result[i].categoryId#" class="accordion-collapse collapse" aria-labelledby="flush-headingOne" data-bs-parent="##accordionFlushExample">
                                    <div class="accordion-body d-flex flex-column">
                                        <cfloop array="#local.subCategoryResult#" item="data">
                                            <cfif data.categoryIdTblSub EQ local.result[i].categoryId>
                                                <cfset local.encryptedSubcategoryId = urlEncodedFormat(encrypt(data.subcategoryId, application.secretKey, "AES", "Base64"))>
                                                <cfset local.encryptedSubCategoryName = urlEncodedFormat(encrypt(data.subcategoryName, application.secretKey, "AES", "Base64"))>
                                                <a href="subcategory.cfm?subCategoryId=#local.encryptedSubcategoryId#&subCategoryName=#local.encryptedSubCategoryName#" class="subcategoryBtn text-decoration-none categoryLink" type="submit" name="subcategoryBtn" id="#data.subcategoryId#">#data.subcategoryName#</a>
                                            </cfif>
                                        </cfloop>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                    </div>
                </cfoutput>
            </div>
            <div class="footerDiv d-flex flex-column bg-dark">
                <div class="footerContents d-flex px-5 pt-5">
                    <div class="footerColOne d-flex w-75 justify-content-between ps-3 pe-5 me-4">
                        <div class="contentOne d-flex flex-column">
                            <div class="footerHead  mb-2">ABOUT</div>
                            <a href="" class="footerFont">Contact Us</a>
                            <a href="" class="footerFont">About Us</a>
                            <a href="" class="footerFont">Careers</a>
                            <a href="" class="footerFont">ClickCart Stories</a>
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
                    <div class="d-flex footerColTwo w-100 justify-content-between  ps-3 pe-4">
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
                            <p class="footerPara">ClickCart Internet Private Limited,</p>
                            <p class="footerPara">Buildings Alyssa, Begonia &</p>
                            <p class="footerPara">Clove Embassy Tech Village,</p>
                            <p class="footerPara">Outer Ring Road, Devarabeesanahalli Village,</p>
                            <p class="footerPara">Bengaluru, 560103,</p>
                            <p class="footerPara">Karnataka, India</p>
                            <div class="footerHead mb-2 mt-3">Social:</div>
                            <div class="socialImg">
                                <img src="Assets/Images/social.png" width="105" height="25" alt="">
                            </div>
                        </div>
                        <div class="d-flex flex-column">
                            <div class="footerHead mb-2">Registered Office Address:</div>
                            <p class="footerPara">ClickCart Internet Private Limited,</p>
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
                        <img src="Assets/Images/seller.png" alt="">
                        <a href="" class="baseLink">Become a Seller</a>
                    </div>
                    <div class="baseContents">
                        <img src="Assets/Images/star.png" alt="">
                        <a href="" class="baseLink">Advertise </a>
                    </div>
                    <div class="baseContents">
                        <img src="Assets/Images/gift.png" alt="">
                        <a href="" class="baseLink">Gift Cards</a>
                    </div>
                    <div class="baseContents">
                        <img src="Assets/Images/help.png" alt="">
                        <a href="" class="baseLink">Help Center</a>
                    </div>
                    <div class="baseContents">
                        <img src="Assets/Images/since.png" alt="">
                        <span class="baseLink">2007-2024 clickCart.com</span>
                    </div>
                    <div class="footerImgdiv">
                        <img class="footerImg" src="Assets/Images/footerimg.png" alt="">
                    </div>
                </div>
            </div>
        </cfif>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="Assets/js/bootstrap.bundle.min.js"></script>
        <script src="Assets/js/order.js"></script>
        <script src="Assets/js/script.js"></script>
        <script src="Assets/js/homePage.js"></script>
    </body>
</html>