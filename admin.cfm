<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin</title>
        <link rel = "stylesheet" href = "Assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="Assets/css/style.css">
    </head>
    <body>
        <cfoutput>
            <cfif structKeyExists(form, "alertBtn")>
                <cflocation  url="adminLogin.cfm">
            </cfif> 
            <form action="" method="post" id="loginForm">
                <div id="adminBody" class="adminBody d-flex flex-column justify-content-center align-items-center"> 
                    <div class="signUpHeader adminHeaderDiv w-100 d-flex justify-content-between px-4">
                        <div class="d-flex align-items-center">
                            <div class="cartLogoDiv d-flex justify-content-center align-items-center">
                                <img src="Assets/Images/shoppingBag.png" alt="" width="20" height="20">
                                <span class="cartNameLogo ms-2">
                                    clickCart
                                </span>
                            </div>
                            <span class="userTypeSpan ms-2">
                                Admin
                            </span>
                        </div>
                        <button class="logoutBtn fw-bold" type = "button" name="logout" onclick="logoutValidate()">Logout</button>
                    </div>  
                    <button type="button" class="addCategory mt-3 addButton" name="addBtn" id="addCategory" value=""  onclick="categoryAdd(this)">Add Category</button>   
                    <div class="d-flex justify-content-center">
                        <div class="addCategoryDiv" id="addCategoryDiv">
                            <div class="d-flex flex-column">
                                <div class="createCloseDiv d-flex justify-content-end">
                                    <button type="button" class="createClose border-0" value="" onclick="addCategoryClose(this)"><img width="35" height="35" src="Assets/Images/close.png" alt="close-window"/></button>
                                </div>
                                <div class="categoryFieldDiv d-flex flex-column justify-content-center">
                                    <div class="addCategoryHeading d-flex justify-content-center" id="addCategoryHeading">
                                        
                                    </div>
                                    <div class="categoryInputDiv my-4 d-flex flex-column justify-content-center">
                                        <input class="categoryInput form-control" name="categoryInput" id="categoryInput" placeholder="Enter Category Name">
                                        <span calss="text-danger" id="categoryError"></span>
                                        <button type="submit" class="addCategoryButton mt-4" id="addCategoryButton" name="addCategoryButton" onclick="return categoryValidate()">Submit</button>
                                        <button type="submit" class="updateCategoryButton mt-4" id="updateCategoryButton" name="updateCategoryButton" onclick="return categoryValidate()">Update</button>
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
                                   <!--- <input type="hidden" id="subCategoryHidden" name="subCategoryHidden" value="">
                                   <cfif StructKeyExists(form, "subCategoryHidden") AND Len(Trim(form.subCategoryHidden)) GT 0>
                                        <cfset local.obj = new Components.shoppingCart()>
                                        <cfset local.result = local.obj.viewSubcategory(categoryId = 11)>
                                        <cfif queryRecordCount(local.result)>
                                            <cfloop query="local.result">
                                                <div class="subCategoryItems">
                                                    #local.result.fldSubCategoryName#
                                                </div>
                                            </cfloop>
                                        </cfif> 
                                    </cfif> --->
                                </div>
                            </div>
                        </div>

                      <div class="addCategoryDiv" id="addSubcategoryDiv">
                            <div class="d-flex flex-column">
                                <div class="createCloseDiv d-flex justify-content-end">
                                    <button type="button" class="createClose border-0" value="" id="addCategoryCloseValue" onclick="addSubCategoryClose(this)"><img width="35" height="35" src="Assets/Images/close.png" alt="close-window"/></button>
                                </div>
                                <span class="addCategoryHeading">Add Subcategory</span>
                                <div class="addSubcategoryInput">
                                    <div class="addSubcategoryInputDiv">
                                        <input type="hidden" id="categoryId" name="categoryIdHidden">
                                        <input type="text" class="form-control" name="subCategoryInput" id="subCategoryInput">
                                        <span id="subcategoryError"></span>
                                        <button type="button" class="subCategorySubmit" name="subCategorySubmit" value="" id="subCategorySubmit" onclick="return addSubcategorySubmit(this)">Submit</button>
                                    </div>
                                </div>
                            </div>
                        </div> 
                                <!--- <div class="categoryInputDiv d-flex flex-column">
                                    <select name="categorySelect" id="categorySelect" class="categorySelect">
                                        <option value=""></option>
                                    </select>
                                    <input type="text" name="subCategoryInput" id="subCategoryInput">
                                </div> --->

                        <div class="displayContent" id="displayContent">
                            <input type="hidden" name="editID" value="" id="editingID">
                            <div class="d-flex flex-column" >
                                <span class="pageHead fw-bold mx-auto my-4">List of Categories</span>
                                <cfif structKeyExists(form, "addCategoryButton")> 
                                    <cfset local.obj = new components.shoppingCart()>
                                    <cfset local.result = local.obj.addCategory(categoryName = form.categoryInput)>
                                    <cfif FindNoCase("Success", local.result) GT 0>
                                        <span class="text-success fw-bold removeSpan">#local.result#</span>
                                    <cfelse>
                                        <span class="text-danger fw-bold removeSpan">#local.result#</span>
                                    </cfif>
                                </cfif>
                                <cfif structKeyExists(form, "updateCategoryButton")>
                                    <cfset local.obj = new components.shoppingCart()>
                                    <cfset local.result = local.obj.updateCategory(
                                                            editId = form.editID,
                                                            categoryName=form.categoryInput
                                                            )>
                                    <cfif FindNoCase("Success", local.result) GT 0>
                                        <span class="text-success fw-bold removeSpan">#local.result#</span>
                                    <cfelse>
                                        <span class="text-danger fw-bold removeSpan">#local.result#</span>
                                    </cfif>
                                </cfif>
                                <div class="pageListDiv d-flex justify-content-center">
                                    <div class="displayDiv d-flex flex-column justify-content-center">
                                        <cfset local.obj = new components.shoppingCart()>
                                        <cfset local.result = local.obj.displayCategory()>
                                        <cfloop query="#local.result#" startRow = "1" endRow = "#QueryRecordCount(local.result)#">
                                            <div class="pageDisplayDiv d-flex justify-content-between align-items-center">
                                                <a href="" class="text-decoration-none text-dark">
                                                    <div class="pageNameDiv d-flex text-dark fw-bold overflow-hidden text-truncate">
                                                        #local.result.fldCategoryName#
                                                    </div>
                                                </a>
                                                <div class="pageButtonDiv d-flex">
                                                    <button type="button" class="pageButton adminEditColor" name="editBtn" value=#local.result.fldCategory_ID#  onClick="return categoryAdd(this)"><img width="23" height="23" src="Assets/Images/editBtn.png" alt="create-new"/></button>
                                                    <button type="button" class="pageButton adminDeleteColor " name="deleteBtn" value=#local.result.fldCategory_ID# onClick="deleteButton(this)"><img width="26" height="26" src="Assets/Images/deleteBtn.png" alt="filled-trash"/></button>
                                                    <button type="button" class="pageButton adminEditColor" name="viewBtn"  value=#local.result.fldCategory_ID# onClick="return viewSubButton(this)"><img src="Assets/Images/goArrow.png" alt="" width="18" height="18"></button>
                                                </div>
                                            </div>
                                        </cfloop>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="logoutConfirm" id="logoutConfirm">
                        <span class="logourtAlertHead py-2 d-flex justify-content-center fw-bold text-white">Logout Alert</span>
                        <div class="logoutMesage  d-flex flex-column justify-content-center">
                            <span class="confirmMessage fw-bold">Are you sure want to logout?</span>
                            <button class="alertBtn mt-3" type="submit" name="alertBtn" id="alertBtn" onClick="return logoutAlert('yes')">Logout</button>
                            <button class="alertCancelBtn mt-2" type="submit" name="alertBtn" id="alertBtn" onClick="return logoutAlert('no')">Cancel</button>
                        </div>
                    </div>
                    <div class="deleteConfirm" id="deleteConfirm">
                        <span class="logourtAlertHead py-2 d-flex justify-content-center fw-bold text-white">Delete Page</span>
                        <div class="logoutMesage  d-flex flex-column justify-content-center">
                            <span class="confirmMessage fw-bold">Are you sure want to Delete?</span>
                            <button class="alertBtn mt-3" type="submit" name="alertDeleteBtn" id="alertDeleteBtn" onClick="return deleteAlert('yes')">Delete</button>
                            <button class="alertCancelBtn mt-2" type="sumbit" name="alertDeleteBtn" id="alertDeleteBtn" onClick="return deleteAlert('no')">Cancel</button>
                        </div>
                    </div>
                </div>
            </form>
        </cfoutput>
      
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
        <script src="Assets/js/script.js"></script>
    </body>
</html>