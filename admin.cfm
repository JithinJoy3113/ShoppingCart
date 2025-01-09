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
                    <button type="button" class="addCategory mt-3 addButton" name="addBtn" id="addCategory"  onclick="categoryAdd()">Add Category</button>   
                    <div class="d-flex justify-content-center">
                        <div class="addCategoryDiv" id="addCategoryDiv">
                            <div class="d-flex flex-column">
                                <div class="createCloseDiv d-flex justify-content-end">
                                    <button type="button" class="createClose border-0" value="" onclick="addCategoryClose(this)"><img width="35" height="35" src="Assets/Images/close.png" alt="close-window"/></button>
                                </div>
                                <div class="categoryFieldDiv d-flex flex-column justify-content-center">
                                    <div class="addCategoryHeading d-flex justify-content-center">
                                        Add New Category
                                    </div>
                                    <div class="categoryInputDiv my-4 d-flex flex-column justify-content-center">
                                        <input class="categoryInput form-control" name="categoryInput" id="categoryInput" placeholder="Enter Category Name">
                                        <button type="submit" class="addCategoryButton mt-4" id="addCategoryButton" name="addCategoryButton">Submit</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="displayContent" id="displayContent">
                        
                            <div class="d-flex flex-column" >
                                <span class="pageHead fw-bold mx-auto my-4">List of Categories</span>
                                <div class="pageListDiv d-flex justify-content-center">
                                    <div class="displayDiv d-flex flex-column justify-content-center">
                                       <!---  <div class="pageDisplayDiv d-flex justify-content-between align-items-center">
                                            <a href="" class="text-decoration-none text-dark">
                                                <div class="pageNameDiv d-flex text-dark fw-bold overflow-hidden text-truncate">
                                                    category 1
                                                </div>
                                            </a>
                                            <div class="pageButtonDiv d-flex">
                                                <input type="hidden" name="editingID" value="" id="editingID">
                                                <button type="submit" class="pageButton adminEditColor" name="editBtn" value=4  onClick="return deleteButton(this)"><img width="23" height="23" src="Assets/Images/editBtn.png" alt="create-new"/></button>
                                                <button type="button" class="pageButton adminDeleteColor " name="deleteBtn" value="" onClick="deleteButton(this)"><img width="26" height="26" src="Assets/Images/deleteBtn.png" alt="filled-trash"/></button>
                                                <button type="button" class="pageButton adminEditColor" name="deleteBtn"  value="" onClick="editButton(this)"><img src="Assets/Images/goArrow.png" alt="" width="18" height="18"></button>
                                            </div>
        
                                        </div>
                                        <div class="pageDisplayDiv d-flex justify-content-between align-items-center">
                                            <a href="" class="text-decoration-none text-dark">
                                                <div class="pageNameDiv d-flex text-dark fw-bold overflow-hidden text-truncate">
                                                    category 1
                                                </div>
                                            </a>
                                            <div class="pageButtonDiv d-flex">
                                                <button type="submit" class="pageButton adminEditColor" name="editBtn" value=""><img width="24" height="24" src="https://img.icons8.com/material-outlined/24/FFFFFF/create-new.png" alt="create-new"/></button>
                                                <button type="button" class="pageButton adminDeleteColor " name="deleteBtn" value="" onClick="deleteButton(this)"><img width="26" height="26" src="https://img.icons8.com/sf-black/64/FFFFFF/filled-trash.png" alt="filled-trash"/></button>
                                            </div>
        
                                        </div> --->
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
                                                    <input type="hidden" name="editingID" value="" id="editingID">
                                                    <button type="button" class="pageButton adminEditColor" name="editBtn" value=#local.result.fldCategory_ID#  onClick="return categoryAdd(this)"><img width="23" height="23" src="Assets/Images/editBtn.png" alt="create-new"/></button>
                                                    <button type="button" class="pageButton adminDeleteColor " name="deleteBtn" value="" onClick="deleteButton(this)"><img width="26" height="26" src="Assets/Images/deleteBtn.png" alt="filled-trash"/></button>
                                                    <button type="button" class="pageButton adminEditColor" name="deleteBtn"  value="" onClick="editButton(this)"><img src="Assets/Images/goArrow.png" alt="" width="18" height="18"></button>
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
            <cfif structKeyExists(form, "addCategoryButton")> 
                <cfset local.obj = new components.shoppingCart()>
                <cfset local.result = local.obj.addCategory(categoryName = form.categoryInput)>
            </cfif>
          
            <cfif structKeyExists(form, "alertBtn")>
                <cflocation  url="adminLogin.cfm">
            </cfif> 

            <cfif structKeyExists(form, "editBtn")>
                <cfset local.obj = new components.shoppingCart()>
                <cfset local.result = local.obj.updateCategory(
                                        editId = form.editingID,
                                        categoryName=form.categoryInput
                                        )>
            </cfif>
          
        </cfoutput>
        <script src="Assets/js/script.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
    </body>
</html>