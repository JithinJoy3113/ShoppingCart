<cfoutput>
    <cfset local.subCategoryName = decrypt(URL.subCategoryName, application.secretKey, "AES", "Base64")>
    <cfset local.subCategoryId = decrypt(URL.subcategoryId, application.secretKey, "AES", "Base64")>
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
            <cfset local.randomProducts = application.obj.randomProducts(
                subCategoryId = local.subcategoryId,
                sortBy = form.sortProduct
            )>
        <cfelseif structKeyExists(form, "filterSubmit")>
            <cfset local.randomProducts = application.obj.randomProducts(
                subCategoryId = local.subcategoryId,
                min = form.filterMin,
                max = form.filterMax
            )>
        <cfelse>
            <cfset local.randomProducts = application.obj.randomProducts(subCategoryId = local.subcategoryId)>
        </cfif>
        <cfif arrayLen(local.randomProducts)>
            <div class="subCategoryHeadDiv">
                #local.subCategoryName#
            </div>
            <div class="randomProductsDiv pt-3 viewHeight" id="viewHeight">
                <cfset local.count = 0>
                <cfloop array="#local.randomProducts#" item="item">
                    <cfset local.encryptedSubcategoryId = urlEncodedFormat(encrypt(item.subcategoryId, application.secretKey, "AES", "Base64"))>
                    <cfset local.encryptedProductId = urlEncodedFormat(encrypt(item.productId, application.secretKey, "AES", "Base64"))>
                    <a href="product.cfm?productId=#local.encryptedProductId#&subcategoryId=#local.encryptedSubcategoryId#" class ="productbtn text-decoration-none">
                        <div class="randomProducts d-flex flex-column ms-4 mt-3">
                            <cfset local.count += 1>
                            <img src="Assets/uploadImages/#item.productFileName#" class="similarImage mx-auto zoomHover" height="186" alt="">
                            <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                                <span class="productsNamespan mx-auto">#item.productName#</span>
                                <div class="similarPriceDiv d-flex align-items-center mt-2">
                                    <span class="similarPrice text-success">RS.#item.price#</span>
                                    <!--- <span class="productsReviewspan text-decoration-line-through ms-2">RS.16,999</span>
                                    <span class="similarOff text-success ms-2">23% off</span> --->
                                </div>
                            </div>
                        </div>
                    </a>
                </cfloop>
            </div>
            <input type = "hidden" id="viewHidden" value = "#local.count#">
        <cfelse>
            <span class="fw-bold">No Products Found</span>
        </cfif>
        <cfif arrayLen(local.randomProducts) GT 5>
            <div class = "viewMoreDiv d-flex justify-content-center mt-4" id = "viewMoreDiv">
                <button type = "button" class = "viewMoreSubmit" id = "viewMoreSubmit" value ="More" onclick = "return viewMoreSubmit(this)">View More</button>
            </div>
        </cfif>
    </div>
</cfoutput>