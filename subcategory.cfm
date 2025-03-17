<cfoutput>
    <cfset variables.subCategoryName = decrypt(URL.subCategoryName, application.secretKey, "AES", "Base64")>
    <cfset variables.subCategoryId = decrypt(URL.subCategoryId, application.secretKey, "AES", "Base64")>
    <div class="randomProductsMainDiv " id="randomProductsMainDiv">
        <form action="" method="post" id="productForm">
            <div class="d-flex sortingDiv justify-content-end" >
                <div class="sortDiv">
                    <span>SortBy</span>
                    <button type="submit" class="border-0" value="min" name="sortProduct">
                        <img src="Assets/Images/upArrow.png" alt="" width="25" height="25">
                    </button>
                    <button type="submit" class="border-0" value="max" name="sortProduct">
                        <img src="Assets/Images/downArrow.png" alt="" width="25" height="25">
                    </button>
                </div>
                <div class = "sortDiv ms-3">
                    <button type = "button" class = "border-0" onclick = "return filterButton()">
                        <span class = "filterBtnSpan">Filter</span>
                    </button>
                </div>
                <div class="filterDiv" id="filterDiv">
                    <div class="filterMinDiv d-flex">
                        <select id="filterMin" name = "filterMin" class="form-control">
                            <option value="">--Min--</option>
                            <option value="500">500</option>
                            <option value="1500">1500</option>
                            <option value="3000">3000</option>
                            <option value="5000">5000</option>
                        </select>
                        <span>to</span>
                        <select id="filterMax" name = "filterMax" class="form-control">
                            <option value="">--Max--</option>
                            <option value="500">500</option>
                            <option value="1500">1500</option>
                            <option value="3000">3000</option>
                            <option value="5000+">5000+</option>
                        </select>
                    </div>
                    <span class = "text-danger" id = "filterError"></span>
                    <button type="submit" class="filterSubmit" name="filterSubmit" onclick="return filterValidate()">Filter</button>
                </div>
            </div>
        </form>

        <cfif structKeyExists(form, "sortProduct")>
            <cfset variables.randomProducts = application.obj.randomProducts(
                subCategoryId = variables.subcategoryId,
                sortBy = form.sortProduct
            )>
        <cfelseif structKeyExists(form, "filterSubmit")>
            <cfset variables.randomProducts = application.obj.randomProducts(
                subCategoryId = variables.subcategoryId,
                min = form.filterMin,
                max = form.filterMax
            )>
        <cfelse>
            <cfset variables.randomProducts = application.obj.randomProducts(subCategoryId = variables.subcategoryId)>
        </cfif>
        <cfif structCount(variables.randomProducts)>
            <div class="subCategoryHeadDiv">
                #variables.subCategoryName#
            </div>
            <div class="randomProductsDiv pt-3 viewHeight" id="viewHeight">
                <cfset variables.count = 0>
                <cfloop collection="#variables.randomProducts#" item="item">
                    <cfif item EQ 'orderTotal'>
                        <cfcontinue>
                    </cfif>
                    <cfset variables.itemsDetails = variables.randomProducts[item].productDetails>
                    <cfset variables.fileName = variables.randomProducts[item].imageDetails[1].fileName>
                    <cfset variables.encryptedSubcategoryId = urlEncodedFormat(encrypt(variables.itemsDetails.subcategoryId, application.secretKey, "AES", "Base64"))>
                    <cfset variables.encryptedProductId = urlEncodedFormat(encrypt(variables.itemsDetails.productId, application.secretKey, "AES", "Base64"))>
                    <div>
                        <a href="product.cfm?productId=#variables.encryptedProductId#&subcategoryId=#variables.encryptedSubcategoryId#" class ="productbtn text-decoration-none">
                            <div class="randomProducts d-flex flex-column ms-4 mt-3">
                                <cfset variables.count += 1>
                                <img src="Assets/uploadImages/#variables.fileName#" class="similarImage mx-auto zoomHover" height="186" alt="">
                                <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                                    <span class="productsNamespan d-flex justify-content-center">#variables.itemsDetails.productName#</span>
                                    <div class="similarPriceDiv d-flex align-items-center mt-2">
                                        <span class="similarPrice text-success">RS.#variables.itemsDetails.price#</span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                    <cfif variables.count == 5>
                        <cfbreak>
                    </cfif>
                </cfloop>
            </div>
            <input type = "hidden" id="viewHidden" value = "#variables.count#">
        <cfelse>
            <span class="fw-bold">No Products Found</span>
        </cfif>
        <cfif structCount(variables.randomProducts) GT 6>
            <div class = "viewMoreDiv d-flex justify-content-center mt-4" id = "viewMoreDiv">
                <button type = "button" class = "viewMoreSubmit" id = "viewMoreSubmit" value ="More" onclick = "return viewMoreSubmit(this,#variables.subCategoryId#)">View More</button>
                <button type = "button" class = "viewMoreSubmit d-none" id = "viewMoreSubmitLess" value ="Less" onclick = "return viewMoreSubmit(this)">View Less</button>
            </div>
        </cfif>
    </div>
</cfoutput>