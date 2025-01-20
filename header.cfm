<!DOCTYPE html>
<html lang = "en">
    <head>
        <meta charset = "UTF-8">
        <meta name = "viewport" content = "width=device-width, initial-scale=1.0">
        <title>Admin</title>
        <link rel = "stylesheet" href = "Assets/css/bootstrap.min.css">
        <link rel = "stylesheet" href = "Assets/css/style.css">
        <link rel = "stylesheet" href = "Assets/css/homePage.css">
        <link rel = "stylesheet" href = "Assets/css/product.css">
    </head>
    <body>
        <cfoutput>
            <div id = "adminBody" class = "adminBody d-flex flex-column justify-content-center align-items-center"> 
                <div class = "signUpHeader adminHeaderDiv w-100 d-flex justify-content-between px-4">
                    <div class = "d-flex align-items-center">
                        <div class = "cartLogoDiv d-flex justify-content-center align-items-center">
                            <img src = "Assets/Images/shoppingBag.png" alt = "" width="20" height = "20">
                            <span class="cartNameLogo ms-2">
                                clickCart
                            </span>
                        </div>
                        <cfif structKeyExists(session, "role") AND session.roleId EQ 1>
                            <span class="userTypeSpan ms-2 text-uppercase">
                                #session.role#
                            </span>
                        </cfif>
                    </div>
                    <cfif structKeyExists(session, "role") AND session.roleId EQ 2>
                        <div class="searchDiv d-flex h-100  align-items-center">
                            <img src = "Assets/Images/search.png" width = "23" height = "23" class="productSearch ms-2">
                            <div class = "searchBarDiv d-flex">
                                <input type = "text" placeholder = "Search for Products, Brands and More" class = "searchBar border-0 text-truncate">
                            </div>
                        </div> 
                    </cfif>
                    <cfif structKeyExists(session, "role")>
                        <div class="navButtonDiv d-flex align-items-center">
                            <cfif session.roleId EQ 2>
                                <a href="" class="menuLink text-white text-decoration-none fw-bold me-4">Profile</a>
                                <a href="" class="menuCartLink text-white text-decoration-none fw-bold me-4">Cart</a>
                                <div class="cartNumber">
                                    4
                                </div>
                            </cfif>
                            <button class = "logoutBtn fw-bold" type = "button" name = "logout" onclick="logoutValidate()">Logout</button>
                        </div>
                    </cfif>
                </div>
            </div>
            <cfif structKeyExists(session, "role") AND session.roleId EQ 2>
                <div class="homePageDiv">
                    <div class="navMenuDiv d-flex justify-content-between">
                        <cfset local.result= application.obj.viewCategory('Home')>
                        <cfset local.parsedData = DeserializeJSON(local.result)>
                        <cfset local.data = local.parsedData.DATA>
                        <cfset local.count = 1>
                        <cfloop array="#local.data#" item="array">
                            <div class="categoryNameDiv ">
                                <div class="categoryHeadDiv" data-value="#array[1]#">
                                    <a href="productListing.cfm?categoryId=#array[1]#&categoryName=#array[2]#" class="categoryLink text-decoration-none">#array[2]#</a>
                                </div>
                                <div class="subCategoryListDiv" id="#array[1]#">
                                    <cfset local.subCategoryResult= application.obj.viewSubcategory(
                                                                                            categoryId = #array[1]#
                                                                                            )>
                                    <cfset local.subCategoryParsedData = DeserializeJSON(local.subCategoryResult)>
                                    <cfset local.subCategorydata = local.subCategoryParsedData.DATA>
                                    <cfloop array="#local.subCategorydata#" item="item">
                                        <a href="subcategory.cfm?subCategoryId=#item[2]#&subCategoryName=#item[1]#" class="subcategoryBtn text-decoration-none" type="submit" name="subcategoryBtn" id="#item[2]#">#item[1]#</a>
                                    </cfloop>
                                </div>
                            </div>
                        </cfloop> 
                    </div>
                </div>
            </cfif>
            <div class="logoutConfirm mx-auto" id="logoutConfirm">
                <span class="logourtAlertHead py-2 d-flex justify-content-center fw-bold text-white">Logout Alert</span>
                <div class="logoutMesage  d-flex flex-column justify-content-center">
                    <span class="confirmMessage fw-bold">Are you sure want to logout?</span>
                    <button class="alertBtn mt-3" type="button" name="alertBtn" id="alertBtn" onClick="return logoutAlert('yes')">Logout</button>
                    <button class="alertCancelBtn mt-2" type="button" name="alertBtn" id="alertBtn" onClick="return logoutAlert('no')">Cancel</button>
                </div>
            </div>
        </cfoutput>