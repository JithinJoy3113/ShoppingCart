<cfoutput>
    <div class="userBodyMainDiv">
        <div class="userBodyImageDiv">
            
        </div>
        <div class="randomProductsMainDiv d-flex flex-column">
            <div class="randumHead ps-3">
                Random Products
            </div>
            <div class="randomProductsDiv pt-3">
                <cfset local.randomProducts = application.obj.randomProducts()>
                <cfloop array="#local.randomProducts#" item="item">
                    <div class="randomProducts d-flex flex-column ms-4">
                        <img src="Assets/uploadImages/#item.productFileName#" class="similarImage mx-auto zoomHover" height="186" alt="">
                        <div class="productDiscriptionsdiv d-flex flex-column align-items-center mt-3">
                            <span class="productsNamespan text-truncate">#item.productName#</span>
                            <div class="similarPriceDiv d-flex align-items-center mt-2">
                                <span class="similarPrice">RS.#item.price#</span>
                                <span class="productsReviewspan text-decoration-line-through ms-2">RS.16,999</span>
                                <span class="similarOff text-success ms-2">23% off</span>
                            </div>
                        </div>
                    </div>
                </cfloop>
            </div>
        </div>
    </div>
</cfoutput>

