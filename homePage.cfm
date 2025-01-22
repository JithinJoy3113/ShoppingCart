<cfoutput>
    <div class="userBodyMainDiv" id="userBodyMainDiv">
        <div class="userBodyImageDiv">
            
        </div>
        <div class="randomProductsMainDiv d-flex flex-column">
            <cfif structKeyExists(form, "myButton")>
                <cfset local.randomProducts = application.obj.randomProducts(search = form.searchInput)>
                <div class="randumHead ps-3">
                    Search Result for "#form.searchInput#"
                </div>
            <cfelse>
                <cfset local.randomProducts = application.obj.randomProducts()>
                <div class="randumHead ps-3">
                    Random Products
                </div>
            </cfif>
            <div class="randomProductsDiv pt-3">
                <cfloop array="#local.randomProducts#" item="item">
                    <a href="product.cfm?productId=#item.productId#&subcategoryId=#item.subcategoryId#" class ="productbtn text-decoration-none">
                        <div class="randomProducts d-flex flex-column ms-4">
                            <img src="Assets/uploadImages/#item.productFileName#" class="similarImage mx-auto zoomHover" height="186" alt="">
                            <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                                <span class="productsNamespan text-truncate">#item.productName#</span>
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
        </div>
    </div>
</cfoutput>

