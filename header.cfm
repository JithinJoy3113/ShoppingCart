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
                        <form action="" method="post">
                            <button class="border-0 cartLogoDiv d-flex justify-content-center align-items-center" type="submit" name="homeBtn">
                                <img src = "Assets/Images/shoppingBag.png" alt = "" width="20" height = "20">
                                <span class="cartNameLogo ms-2">
                                    clickCart
                                </span>
                            </button>
                        </form> 
                        <cfif structKeyExists(form, "homeBtn") AND (NOT find("admin.cfm", CGI.SCRIPT_NAME))>
                            <cflocation  url="homePage.cfm">
                        </cfif>
                        <cfif structKeyExists(session, "role")>
                            <span class="userTypeSpan ms-2 text-uppercase">
                                #session.role#
                            </span>
                        </cfif>
                    </div>
                    <cfif NOT find("admin.cfm", CGI.SCRIPT_NAME) AND NOT find("login.cfm", CGI.SCRIPT_NAME) AND NOT find("userSignUp.cfm", CGI.SCRIPT_NAME)>
                        <div class="searchDiv d-flex h-100  align-items-center">
                            <img src = "Assets/Images/search.png" width = "23" height = "23" class="productSearch ms-2">
                            <form  id="searchForm" action="homePage.cfm" method="post">
                                <div class = "searchBarDiv d-flex">
                                    <input type = "search" id = "searchInput" name="searchInput" placeholder = "Search for Products, Brands and More" class = "searchBar border-0 text-truncate">
                                    <button type="submit" id="myButton" name="myButton" style="display: none;"></button>
                                </div>
                            </form>
                        </div> 
                    </cfif>
                    <div class="navButtonDiv d-flex align-items-center">
                        <cfif (NOT structKeyExists(session, "role") OR session.roleId NEQ 1)  AND (NOT find("login.cfm", CGI.SCRIPT_NAME) AND NOT find("userSignUp.cfm", CGI.SCRIPT_NAME))>
                            <a href="" class="menuLink text-white text-decoration-none fw-bold me-4">Profile</a>
                            <a href="" class="menuCartLink text-white text-decoration-none fw-bold me-4">Cart</a>
                            <div class="cartNumber">
                                4
                            </div>
                        </cfif>
                        <cfif structKeyExists(session, "role")>
                            <button class = "logoutBtn fw-bold" type = "button" name = "logout" onclick="logoutValidate()">Logout</button>
                        <cfelseif find("login.cfm", CGI.SCRIPT_NAME)>
                            <a href="userSignUp.cfm" class = "logoutBtn fw-bold text-decoration-none">SignUp</a>
                        <cfelseif find("userSignUp.cfm", CGI.SCRIPT_NAME) OR (NOT structKeyExists(session, "role"))>
                            <a href="login.cfm" class = "logoutBtn fw-bold text-decoration-none">Login</a>
                        </cfif>
                    </div>
                </div>
                <cfif (NOT structKeyExists(session, "role") OR session.roleId NEQ 1) AND (NOT find("login.cfm", CGI.SCRIPT_NAME) AND NOT find("userSignUp.cfm", CGI.SCRIPT_NAME))>
                    <div class="homePageDiv d-flex w-100" id="headerNav">
                        <div class="navMenuDiv d-flex justify-content-between w-100">
                            <cfset local.result= application.obj.viewCategory('Home')>
                            <cfloop array="#local.result#" item="struct">
                                <div class="categoryNameDiv ">
                                    <div class="categoryHeadDiv" data-value="#struct.categoryId#">
                                        <a href="productListing.cfm?categoryId=#struct.categoryId#&categoryName=#struct.categoryName#" class="categoryLink text-decoration-none">#struct.categoryName#</a>
                                    </div>
                                    <div class="subCategoryListDiv" id="#struct.categoryId#">
                                        <cfset local.subCategoryResult= application.obj.viewSubcategory(
                                                                                                categoryId = #struct.categoryId#
                                                                                                )>
                                        <cfloop array="#local.subCategoryResult#" item="struct">
                                            <a href="subcategory.cfm?subCategoryId=#struct.subcategoryId#&subCategoryName=#struct.subcategoryName#" class="subcategoryBtn text-decoration-none" type="submit" name="subcategoryBtn" id="#struct.subcategoryId#">#struct.subcategoryName#</a>
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
            </div>
        </cfoutput>