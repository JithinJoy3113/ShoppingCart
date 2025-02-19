<cfoutput>
    <cfset local.categoryName = decrypt(URL.categoryName, application.secretKey, "AES", "Base64")>
    <cfset local.categoryId = decrypt(URL.categoryId, application.secretKey, "AES", "Base64")>
    <div class="randomProductsMainDiv d-flex flex-column" id="randomProductsMainDiv">
        <cfset local.result= application.obj.productListing(categoryId = local.categoryId)>
        <cfif structCount(local.result)>
            <div class="randumHead">
                #local.categoryName#
            </div>
            <cfloop collection="#local.result#" item="item">
                <div class="categoryNameDiv">
                    <cfif arrayLen(local.result[item])>
                        <div class="subCategoryHeadDiv">
                            #item#
                        </div>
                        <div class="randomProductsDiv pt-3">
                            <cfloop array="#local.result[item]#" item="product">
                                <cfset local.encryptedSubcategoryId = urlEncodedFormat(encrypt(product.subcategoryId, application.secretKey, "AES", "Base64"))>
                                <cfset local.encryptedProductId = urlEncodedFormat(encrypt(product.productId, application.secretKey, "AES", "Base64"))>
                                <a href="product.cfm?productId=#local.encryptedProductId#&subcategoryId=#local.encryptedSubcategoryId#" class ="productbtn text-decoration-none">
                                    <div class="randomProducts d-flex flex-column ms-4">
                                        <img src="Assets/uploadImages/#product.file#" class="similarImage mx-auto zoomHover" height="186" alt="">
                                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                                            <span class="productsNamespan mx-auto">#product.productName#</span>
                                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                                <span class="similarPrice text-success">RS.#product.price#</span>
                                                <!--- <span class="productsReviewspan text-decoration-line-through ms-2">RS.16,999</span>
                                                <span class="similarOff text-success ms-2">23% off</span> --->
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </cfloop>
                        </div>
                    </cfif>
                </div>
            </cfloop> 
        <cfelse>
            <span class="randumHead">No Products in #local.categoryName#</span>
        </cfif>
    </div>
</cfoutput>