<div class="w-100">  
    <cfoutput>
        <form action = "" method = "post" id="loginForm" enctype = "multipart/form-data">
            <button type="button" class="addCategory mt-3 addButton" name="addBtn" id="addCategory" value=""  onclick="categoryAdd(this)">Add Category</button>   
            <div class="d-flex justify-content-center">
                <div class="addCategoryDiv mt-3" id="addCategoryDiv">
                    <div class="d-flex flex-column">
                        <div class="createCloseDiv d-flex justify-content-end">
                            <button type = "button" class = "createClose border-0" value = "" onclick="addCategoryClose(this)"><img width="35" height="35" src="Assets/Images/close.png" alt="close-window"/></button>
                        </div>
                        <div class="categoryFieldDiv d-flex flex-column justify-content-center">
                            <div class="addCategoryHeading d-flex justify-content-center" id="addCategoryHeading">
                                
                            </div>
                            <div class="categoryInputDiv my-4 d-flex flex-column justify-content-center">
                                <input class="categoryInput productInput" name="categoryInput" id="categoryInput" placeholder="Enter Category Name">
                                <span class="removeSpan" id="categoryError"></span>
                                <button type="button" class="addCategoryButton mt-4" id="addCategoryButton" name="addCategoryButton" onclick = "addCategorySubmit('add')">Submit</button>
                                <button type="button" class="updateCategoryButton mt-4" id="updateCategoryButton" name="updateCategoryButton" onclick="addCategorySubmit('update')">Update</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!--- view and add subcategory --->

                <div class="addCategoryDiv mt-3" id="viewSubcategory">
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
                            <span class="addCategoryHeading d-flex justify-content-center" id="addSubcategoryHeading"></span>
                            <div class="mt-4 container">
                                <cfset local.result = application.obj.viewCategory()>
                                <span class="removeSpan" id="addSubMessage"></span>
                                <div class="categoryDropdown row" id="categoryDropdownDiv">
                                    <div class="col">
                                        <label for="categoryDropLabel" class="fw-bold">Category Name</label><br>
                                    </div>
                                    <div class="col">
                                        <select name="categoryDropdown" class="productInput" id="categoryDropdown">
                                            <cfloop array = "#local.result#" item = "item">
                                                <option value=#item.categoryId#>#item.categoryName#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <span id="addCategoryError" class=""></span>
                                <input type="hidden" id="categoryId" name="categoryIdHidden">
                                <div class="row mt-3">
                                    <div class="col">
                                        <label for="subCategoryInputLabel" class="mt-3 fw-bold">Subcategory Name</label>
                                    </div>
                                    <div class="col">
                                        <input type="text" class="productInput" name="subCategoryInput" id="subCategoryInput" placeholder="Subcategory Name">
                                    </div>
                                </div>
                                <span id="addSubCategoryError" class=""></span>
                                <button type="button" class="subCategorySubmit mx-auto mt-2" name="subCategorySubmit" value="" id="subCategorySubmit" onclick="return addSubcategorySubmit(this)">Submit</button>
                                <button type="button" class="subCategoryUpdate mx-auto mt-2" name="subCategoryUpdate" value="" id="subCategoryUpdate" onclick="return updateSubcategorySubmit(this)">Update</button>
                            </div>
                        </div>
                    </div>
                </div> 

                <div class="displayContent" id="displayContent">
                    <input type="hidden" name="editID" value="" id="categoryEditID">
                    <div class="d-flex flex-column" >
                        <span class="pageHead fw-bold mx-auto my-4">List of Categories</span>
                        <div class="pageListDiv d-flex justify-content-center flex-column">
                            <cfset local.result = application.obj.viewCategory()>
                            <cfloop array="#local.result#" item = "item">
                                <div class="pageDisplayDiv d-flex justify-content-between align-items-center" id="#item.categoryId#">
                                    <a href="" class="text-decoration-none text-dark">
                                        <div class="pageNameDiv d-flex text-dark fw-bold overflow-hidden text-truncate">
                                            #item.categoryName#
                                        </div>
                                    </a>
                                    <div class="pageButtonDiv d-flex">
                                        <button type="button" class="pageButton adminEditColor" name="editBtn" value=#item.categoryId#  onClick="return categoryAdd(this)"><img width="23" height="23" src="Assets/Images/editBtn.png" alt="create-new"/></button>
                                        <button type="button" class="pageButton adminDeleteColor " name="deleteBtn" value='tblCategory,#item.categoryId#' onClick="categoryDeleteButton(this)"><img width="26" height="26" src="Assets/Images/deleteBtn.png" alt="filled-trash"/></button>
                                        <button type="button" class="pageButton adminEditColor" name="viewBtn"  value=#item.categoryId# onClick="return viewSubButton(this)"><img src="Assets/Images/goArrow.png" alt="" width="18" height="18"></button>
                                    </div>
                                </div>
                            </cfloop>
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
            <div class="imagesUpdateDiv mt-4 mx-auto" id="imagesUpdateDiv">
                <div class="d-flex justify-content-end px-3 py-3">
                    <button type="button" class="createClose border-0" value="" onclick="imageEditClose()"><img width="35" height="35" src="Assets/Images/close.png" alt="close-window"/></button>
                </div>
                <span class="addCategoryHeading fw-bold mx-auto">Product Images</span>
                <div  class="imagesUpdateSubDiv" id = "imagesUpdateSubDiv">

                </div>
            </div>
        </form>
        <!-- ADD PRODUCT -->
        <form id="productForm" method="post" enctype = "multipart/form-data">
            <div class="addProductModal" id="addProductModal">
                <div class="addProductInputDiv d-flex flex-column mx-auto container">
                    <span class="addProductHeading mx-auto mb-3" id="addProductHeading"></span>
                    <span class="fw-bold" id="insertError"></span>
                    <div class="addProductCategoryDiv row">
                        <div class="col">
                            <label for="addProductCategory" class="productLabel">Category Name</label>
                        </div>
                        <div class="col">
                            <select name="addProductCategorySelect" id="addProductCategorySelect" value="" class="productInput">
                            
                            </select>
                            <span class="fw-bold text-danger" id="categoryError"></span>
                        </div>
                    </div>
                    <div class="addProductSubcategoryDiv row">
                        <div class="col">
                            <label for="addProductSubcategory" class="productLabel">SubCategory Name</label>
                        </div>
                        <div class="col">
                            <select name="addProductSubcategorySelect" id="addProductSubcategorySelect" value=""  class="productInput">
                                
                            </select>
                            <span class="fw-bold text-danger" id="subCategoryError"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <label for="addProductName" class="productLabel">Product Name</label>
                        </div>
                        <div class="col">
                            <input type="text" class="addProductNameInput productInput" name="addProductNameInput" id = "addProductNameInput" value = "" oninput="removeSpan('addProductNameInput')">
                            <span class="fw-bold text-danger" id="nameError"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <label for="addProductBrand" class="productLabel">Product Brand</label>
                        </div>
                        <div class="col">
                            <select name="addProductBrandInput" id="brandSelect" class="productInput">
                                
                            </select>
                            <span class="fw-bold text-danger" id="brandError"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <label for="addProductDescription" class="productLabel">Product Description</label>
                        </div>
                        <div class="col">
                            <textarea class="productInput" name = "addProductDescription" id = "addProductDescription" value = "" oninput="removeSpan('addProductDescription')"></textarea>
                            <span class="fw-bold text-danger" id="descriptionError"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <label for="addProductPrice" class="productLabel">Product Price</label>
                        </div>
                        <div class="col">
                            <input type="number" class="addProductPrice productInput" name = "addProductPrice" id = "addProductPrice" value = "" oninput="removeSpan('addProductPrice')">
                            <span class="fw-bold text-danger" id="priceError"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <label for="addProductTax" class="productLabel">Product Tax</label>
                        </div>
                        <div class="col">
                            <input type="number" class="addProductTax productInput" name = "addProductTax" id = "addProductTax" value = "" oninput="removeSpan('addProductTax')">
                            <span class="fw-bold text-danger" id="taxError"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <label for="addProductImage" id="addProductLabel" class="productLabel">Product Image</label>
                        </div>
                        <div class="col">
                            <input type="file" class="addProductImage productInput" name="addProductImage" id = "addProductImage" multiple oninput="removeSpan('addProductImage')">
                            <span class="fw-bold text-danger" id="fileError"></span>
                        </div>
                    </div>
                    <div class="addProductButtonDiv d-flex mx-auto mt-3">
                        <button type="button" class="addProductSubmit" name="addProductSubmit" id="addProductSubmit" value="" onclick="return addProductsubmit()">Submit</button>
                        <button type="button" class="updateProductSubmit" name="updateProductSubmit" id="updateProductSubmit" value="" onclick="return updateProductsubmit(this)">Update</button>
                        <button type="button" class="addProductClose ms-2" value="" id="addProductClose" onclick="addProductCloseBtn(this)">Close</button>
                    </div>
                </div>
            </div>
        </form>
    </cfoutput>
</div>