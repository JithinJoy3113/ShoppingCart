<div class="w-100">  
    <cfoutput>
        <form action = "" method = "post" id="loginForm" enctype = "multipart/form-data">
            <button type="button" class="addCategory mt-3 addButton" name="addBtn" id="addCategory" value=""  onclick="categoryAdd(this)">Add Category</button>   
            <div class="d-flex justify-content-center">
                <div class="addCategoryDiv" id="addCategoryDiv">
                    <div class="d-flex flex-column">
                        <div class="createCloseDiv d-flex justify-content-end">
                            <button type = "button" class = "createClose border-0" value = "" onclick="addCategoryClose(this)"><img width="35" height="35" src="Assets/Images/close.png" alt="close-window"/></button>
                        </div>
                        <div class="categoryFieldDiv d-flex flex-column justify-content-center">
                            <div class="addCategoryHeading d-flex justify-content-center" id="addCategoryHeading">
                                
                            </div>
                            <div class="categoryInputDiv my-4 d-flex flex-column justify-content-center">
                                <input class="categoryInput form-control" name="categoryInput" id="categoryInput" placeholder="Enter Category Name">
                                <span calss="text-danger" id="categoryError"></span>
                                <button type="submit" class="addCategoryButton mt-4" id="addCategoryButton" name="addCategoryButton">Submit</button>
                                <button type="submit" class="updateCategoryButton mt-4" id="updateCategoryButton" name="updateCategoryButton">Update</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!--- view and add subcategory --->

                <div class="addCategoryDiv" id="viewSubcategory">
                    <div class="d-flex flex-column">
                        <div class="createCloseDiv d-flex justify-content-end">
                            <button type="button" class="createClose border-0" value="" onclick="addCategoryClose(this)"><img width="35" height="35" src="Assets/Images/close.png" alt="close-window"/></button>
                        </div>
                        <div class="subCategoryDiv d-flex justify-content-center">
                            <span class="addCategoryHeading">Subcategory</span>
                            <button type="button" class="subAddButton border-0" name="subAddButton" value="" id="subAddButton" onclick="return addSubCategory(this)"><img src="Assets/Images/addBtn.png" alt="" width="25" height="25"></button>
                        </div>
                            <div class="categoryFieldDiv" id="categoryFieldDiv">
                            
                        </div>
                        
                    </div>
                </div>

                <div class="addCategoryDiv" id="addSubcategoryDiv">
                    <div class="d-flex flex-column">
                        <div class="createCloseDiv d-flex justify-content-end">
                            <button type="button" class="createClose border-0" value="" id="addCategoryCloseValue" onclick="addSubCategoryClose()"><img width="35" height="35" src="Assets/Images/close.png" alt="close-window"/></button>
                        </div>
                        <div class="addSubcategoryInput categoryFieldDiv">
                            <span class="addCategoryHeading" id="addSubcategoryHeading"></span>
                            <div class="addSubcategoryInputDiv mt-4">
                                <!--- <cfset local.obj = new Components.shoppingCart()> --->
                                <cfset local.result = application.obj.displayCategory()>
                                <span class="removeSpan" id="addSubMessage"></span>
                                <div class="categoryDropdown" id="categoryDropdownDiv">
                                    <label for="categoryDropLabel" class="fw-bold">Category Name</label><br>
                                    <select name="categoryDropdown" id="categoryDropdown">
                                        <cfloop query="local.result">
                                            <option value="#local.result.fldCategory_ID#">#local.result.fldCategoryName#</option>
                                        </cfloop>
                                    </select>
                                </div>
                                <span id="addCategoryError" class=""></span>
                                <input type="hidden" id="categoryId" name="categoryIdHidden">
                                <label for="subCategoryInputLabel" class="mt-3 fw-bold">Subcategory Name</label>
                                <input type="text" class="form-control" name="subCategoryInput" id="subCategoryInput" placeholder="Subcategory Name">
                                <span id="addSubCategoryError" class=""></span>
                                <button type="button" class="subCategorySubmit" name="subCategorySubmit" value="" id="subCategorySubmit" onclick="return addSubcategorySubmit(this)">Submit</button>
                                <button type="button" class="subCategoryUpdate" name="subCategoryUpdate" value="" id="subCategoryUpdate" onclick="return updateSubcategorySubmit(this)">Update</button>
                            </div>
                        </div>
                    </div>
                </div> 

                <div class="displayContent" id="displayContent">
                    <input type="hidden" name="editID" value="" id="editingID">
                    <div class="d-flex flex-column" >
                        <span class="pageHead fw-bold mx-auto my-4">List of Categories</span>
                        <cfif structKeyExists(form, "addCategoryButton")> 
                            <!--- <cfset local.obj = new components.shoppingCart()> --->
                            <cfset local.result = application.obj.addCategory(categoryName = form.categoryInput)>
                            <cfloop collection="#local.result#" item="key">
                                <cfif key EQ "Success">
                                    <span class="text-success fw-bold removeSpan">#local.result[key]#</span>
                                <cfelse>
                                    <span class="text-danger fw-bold removeSpan">#local.result[key]#</span>
                                </cfif>
                            </cfloop>
                        </cfif>
                        <cfif structKeyExists(form, "updateCategoryButton")>
                            <!--- <cfset local.obj = new components.shoppingCart()> --->
                            <cfset local.result = application.obj.updateCategory(
                                                    editId = form.editID,
                                                    categoryName=form.categoryInput
                                                    )>
                            <cfloop collection="#local.result#" item="key">
                                <cfif key EQ "Success">
                                    <span class="text-success fw-bold removeSpan">#local.result[key]#</span>
                                <cfelse>
                                    <span class="text-danger fw-bold removeSpan">#local.result[key]#</span>
                                </cfif>
                            </cfloop>
                        </cfif>
                        <div class="pageListDiv d-flex justify-content-center">
                            <div class="displayDiv d-flex flex-column justify-content-center">
                                <!---   <cfset local.obj = new components.shoppingCart()> --->
                                <cfset local.result = application.obj.displayCategory()>
                                <cfloop query="#local.result#" startRow = "1" endRow = "#QueryRecordCount(local.result)#">
                                    <div class="pageDisplayDiv d-flex justify-content-between align-items-center" id="#local.result.fldCategory_ID#">
                                        <a href="" class="text-decoration-none text-dark">
                                            <div class="pageNameDiv d-flex text-dark fw-bold overflow-hidden text-truncate">
                                                #local.result.fldCategoryName#
                                            </div>
                                        </a>
                                        <div class="pageButtonDiv d-flex">
                                            <button type="button" class="pageButton adminEditColor" name="editBtn" value=#local.result.fldCategory_ID#  onClick="return categoryAdd(this)"><img width="23" height="23" src="Assets/Images/editBtn.png" alt="create-new"/></button>
                                            <button type="button" class="pageButton adminDeleteColor " name="deleteBtn" value='tblCategory,#local.result.fldCategory_ID#' onClick="categoryDeleteButton(this)"><img width="26" height="26" src="Assets/Images/deleteBtn.png" alt="filled-trash"/></button>
                                            <button type="button" class="pageButton adminEditColor" name="viewBtn"  value=#local.result.fldCategory_ID# onClick="return viewSubButton(this)"><img src="Assets/Images/goArrow.png" alt="" width="18" height="18"></button>
                                        </div>
                                    </div>
                                </cfloop>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="logoutConfirm mx-auto" id="logoutConfirm">
                    <span class="logourtAlertHead py-2 d-flex justify-content-center fw-bold text-white">Logout Alert</span>
                    <div class="logoutMesage  d-flex flex-column justify-content-center">
                        <span class="confirmMessage fw-bold">Are you sure want to logout?</span>
                        <button class="alertBtn mt-3" type="submit" name="alertBtn" id="alertBtn" onClick="return logoutAlert('yes')">Logout</button>
                        <button class="alertCancelBtn mt-2" type="button" name="alertBtn" id="alertBtn" onClick="return logoutAlert('no')">Cancel</button>
                    </div>
                </div>
                <div class="deleteConfirm mx-auto" id="deleteConfirm">
                    <span class="logourtAlertHead py-2 d-flex justify-content-center fw-bold text-white">Delete Page</span>
                    <div class="logoutMesage  d-flex flex-column justify-content-center">
                        <span class="confirmMessage fw-bold">Are you sure want to Delete?</span>
                        <button class="alertBtn mt-3" type="button" name="alertDeleteBtn" id="alertDeleteBtn" value="" onClick="return deleteAlert(this)">Delete</button>
                        <button class="alertCancelBtn mt-2" type="button" name="alertDeleteBtn" id="" value="cancel" onClick="return deleteAlert(this)">Cancel</button>
                    </div>
                </div>
            </div>

            <div class="productViewMainDiv" id="productViewMainDiv">
                <div class="subCategoryHeadDiv">
                    <span class = "subCategoryHead" id="subCategoryHead"></span>
                    <button type="button" class="subAddButton border-0" name="addProductButton" value="" id="addProductButton" onclick="return addProduct(this)"><img src="Assets/Images/addBtn.png" alt="" width="25" height="25"></button>
                    <button type="button" class="productClose border-0" value="" onclick="viewProductsClose()">Back To Subcategory</button>
                </div>
                <div class="subcategoryProductDiv d-flex" id="subcategoryProductDiv">

                </div>
            </div>
            <div class="imagesUpdateDiv mt-4" id="imagesUpdateDiv">
                <div class="d-flex justify-content-end px-3 py-3">
                    <button type="button" class="createClose border-0" value="" onclick="imageEditClose()"><img width="35" height="35" src="Assets/Images/close.png" alt="close-window"/></button>
                </div>
                <div  class="imagesUpdateSubDiv" id = "imagesUpdateSubDiv">

                </div>
            </div>
        </form>
        <!-- ADD PRODUCT -->
        <form id="productForm" method="post" enctype = "multipart/form-data">
            <div class="addProductModal" id="addProductModal">
                <div class="addProductInputDiv d-flex flex-column mx-auto">
                    <span class="addProductHeading mx-auto" id="addProductHeading"></span>
                    <span class="fw-bold" id="insertError"></span>
                    <div class="addProductCategoryDiv">
                        <label for="addProductCategory" class="productLabel">Category Name</label>
                        <select name="addProductCategorySelect" id="addProductCategorySelect" value="" class="form-control">
                        
                        </select>
                        <span class="fw-bold text-danger" id="categoryError"></span>
                    </div>
                    <div class="addProductSubcategoryDiv">
                        <label for="addProductSubcategory" class="productLabel">SubCategory Name</label>
                        <select name="addProductSubcategorySelect" id="addProductSubcategorySelect" value="" class="form-control">
                            
                        </select>
                        <span class="fw-bold text-danger" id="subCategoryError"></span>
                    </div>
                    <label for="addProductName" class="productLabel">Product Name</label>
                    <input type="text" class="addProductNameInput form-control" name="addProductNameInput" id = "addProductNameInput" value = "" >
                    <span class="fw-bold text-danger" id="nameError"></span>
                    <label for="addProductBrand" class="productLabel">Product Brand</label>
                    <select name="addProductBrandInput" id="brandSelect" class="form-control">
                        
                    </select>
                    <span class="fw-bold text-danger" id="brandError"></span>
                    <label for="addProductDescription" class="productLabel">Product Description</label>
                    <input type="text" class="addProductDescription form-control" name = "addProductDescription" id = "addProductDescription" value = "">
                    <span class="fw-bold text-danger" id="descriptionError"></span>
                    <label for="addProductPrice" class="productLabel">Product Price</label>
                    <input type="text" class="addProductPrice form-control" name = "addProductPrice" id = "addProductPrice" value = "">
                    <span class="fw-bold text-danger" id="priceError"></span>
                    <label for="addProductTax" class="productLabel">Product Tax</label>
                    <input type="text" class="addProductTax form-control" name = "addProductTax" id = "addProductTax" value = "">
                    <span class="fw-bold text-danger" id="taxError"></span>
                    <label for="addProductImage" id="addProductLabel" class="productLabel">Product Image</label>
                    <input type="file" class="addProductImage form-control" name="addProductImage" id = "addProductImage" multiple>
                    <span class="fw-bold text-danger" id="fileError"></span>
                    <div class="addProductButtonDiv d-flex ms-auto mt-3">
                        <button type="button" class="addProductSubmit" name="addProductSubmit" id="addProductSubmit" value="" onclick="return addProductsubmit()">Submit</button>
                        <button type="button" class="updateProductSubmit" name="updateProductSubmit" id="updateProductSubmit" value="" onclick="return updateProductsubmit(this)">Update</button>
                        <button type="button" class="addProductClose ms-2" value="" id="addProductClose" onclick="addProductCloseBtn(this)">Close</button>
                    </div>
                </div>
            </div>
        </form>
    </cfoutput>
</div>