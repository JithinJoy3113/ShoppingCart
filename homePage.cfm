<cfoutput>
    <div class="userBodyMainDiv" id="randomProductsMainDiv">
        <cfif NOT structKeyExists(form, "myButton")>
            <div class="userBodyImageDiv">
                <img src="Assets/Images/cartImage.jpg" alt="" class="w-100 h-50">
            </div>
        </cfif>
        <div class="randomProductsMainDiv d-flex flex-column">
            <cfif structKeyExists(form, "myButton")>
                <cfset variables.randomProducts = application.obj.randomProducts(search = form.searchInput)>
                <div class="randumHead ps-3">
                    <cfif NOT structCount(variables.randomProducts) LT 1>
                        No
                    </cfif>
                    Search Result for "#form.searchInput#"
                </div>
            <cfelse>
                <cfset variables.randomProducts = application.obj.randomProducts(random = true)>
                <div class="randumHead ps-3">
                    Random Products
                </div>
            </cfif>
            <div class="randomProductsDiv pt-3">
                <cfloop collection="#variables.randomProducts#" item="item">
                <cfif item NEQ 'orderTotal' AND item NEQ 'subCategoryName'>
                    <cfset variables.productData = variables.randomProducts[item]['productDetails']>
                    <cfset variables.imageData = variables.randomProducts[item]['imageDetails'][1]>
                    <a href="product.cfm?productId=#variables.productData.encryptedProductId#&subCategoryId=#variables.productData.encryptedSubId#" class ="productbtn text-decoration-none">
                        <div class="randomProducts d-flex flex-column ms-4 mt-3">
                            <img src="Assets/uploadImages/#variables.imageData.fileName#" class="similarImage mx-auto zoomHover" height="186" alt="">
                            <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                                <span class="productsNamespanUser d-flex justify-content-center">#variables.productData.productName#</span>
                                <div class="similarPriceDiv d-flex align-items-center mt-2">
                                    <span class="similarPrice text-success">RS.#variables.productData.price#</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </cfif>
                </cfloop>
            </div>
        </div>
    </div>
</cfoutput>

