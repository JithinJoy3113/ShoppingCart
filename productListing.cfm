<cfoutput>
    <cfset variables.categoryId = decrypt(URL.categoryId, application.secretKey, "AES", "Base64")>
    <div class="randomProductsMainDiv d-flex flex-column" id="randomProductsMainDiv">
        <cfset variables.result= application.obj.productListing(categoryId = variables.categoryId)>
        <cfif structCount(variables.result)>
            <div class="randumHead">
                #variables.result.categoryName#
            </div>
            <cfloop collection="#variables.result#" item="item">
                <div class="categoryNameDiv">
                    <cfif item NEQ 'categoryName'>
                        <div class="subCategoryHeadDiv">
                            <cfset variables.encryptedSubcategoryId = urlEncodedFormat(encrypt(variables.result[item][1].subcategoryId, application.secretKey, "AES", "Base64"))>
                            <a href="subcategory.cfm?subCategoryId=#variables.encryptedSubcategoryId#" class ="subCategoryHeadDiv text-decoration-none">#item#</a>
                        </div>
                        <div class="randomProductsDiv pt-3">
                            <cfloop array="#variables.result[item]#" item="product">
                                <cfset variables.encryptedSubcategoryId = urlEncodedFormat(encrypt(product.subcategoryId, application.secretKey, "AES", "Base64"))>
                                <cfset variables.encryptedProductId = urlEncodedFormat(encrypt(product.productId, application.secretKey, "AES", "Base64"))>
                                <a href="product.cfm?productId=#variables.encryptedProductId#&subCategoryId=#variables.encryptedSubcategoryId#" class ="productbtn text-decoration-none">
                                    <div class="randomProducts d-flex flex-column ms-4">
                                        <img src="Assets/uploadImages/#product.file#" class="similarImage mx-auto zoomHover" height="186" alt="">
                                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                                            <span class="productsNamespanUser d-flex justify-content-center">#product.productName#</span>
                                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                                <span class="similarPrice text-success">RS.#product.price#</span>
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
            <span class="randumHead">No Products in #variables.categoryName#</span>
        </cfif>
    </div>
</cfoutput>