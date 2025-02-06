<cfcomponent>

    <cffunction name = "userSignUp" returnType = "struct" access = "remote" returnFormat = "json">
        <cfargument name = "firstName" required = "true" type = "string">
        <cfargument name = "lastName" required = "true" type = "string">
        <cfargument name = "userName" required = "true" type = "string">
        <cfargument name = "userPhone" required = "true" type = "string">
        <cfargument name = "password" required = "true" type = "string">
        <cfargument name = "confirmPassword" required = "true" type = "string">
        <cfset local.jsonData = {}>
        <cfif arguments.firstName EQ "">
            <cfset local.jsonData['fnameError'] = 'FirstName Required'>
        </cfif>
        <cfif arguments.lastName EQ "">
            <cfset local.jsonData['lnameError'] = 'LastName Required'>
        </cfif>
        <cfif arguments.userName EQ "">
            <cfset local.jsonData['mailError'] = 'User Mail Required'>
        <cfelseif NOT(isValid("email", arguments.userName))>
            <cfset local.jsonData['mailError'] = 'Invalid Pattern'>
        </cfif>
        <cfif arguments.userPhone EQ "">
            <cfset local.jsonData['phoneError'] = 'Mobile Number Required'>
        <cfelseif NOT(REFind("^\d{10}$", arguments.userPhone))>
            <cfset local.jsonData['phoneError'] = 'Mobile Number should be 10 digits'>
        </cfif>
        <cfif arguments.password EQ "">
            <cfset local.jsonData['passwordError'] = 'Password Required'>
        <cfelseif NOT reFind("^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",arguments.password)>
            <cfset local.jsonData['passwordError'] = 'Password Must be Strong'>
        </cfif>
        <cfif arguments.password NEQ arguments.confirmPassword>
            <cfset local.jsonData['confirmpasswordError'] = 'Password mismatch'>
        </cfif>

        <cfif structCount(local.jsonData)>
            <cfset local.jsonData['signUpResult'] = 'Error'>
            <cfreturn local.jsonData>
        <cfelse>
            <cfquery name = "local.selectUser" datasource = #application.dataSource#>
                SELECT
                    fldEmail,
                    fldPhoneNumber
                FROM 
                    tblUser
                WHERE
                    fldEmail = <cfqueryparam value = '#arguments.userName#' cfsqltype = 'varchar'>
                    OR fldPhoneNumber = <cfqueryparam value = '#arguments.userPhone#' cfsqltype = 'varchar'> 
            </cfquery>
            <cfif queryRecordCount(local.selectUser)>
                <cfset local.jsonData['signUpResult'] = 'Failed'>
                <cfreturn local.jsonData>
            <cfelse>
                <cfset local.secretKey = generateSecretKey('AES')>
                <cfset local.hashedPassword = Hash(arguments.password & local.secretKey,"SHA-256")>
                <cfquery name="insertUser" datasource = #application.dataSource#>
                    INSERT INTO
                        tblUser(
                            fldFirstName,
                            fldLastName,
                            fldEmail,
                            fldPhoneNumber,
                            fldUserRoleID,
                            fldHashedPassword,
                            fldUserSaltString
                        )
                    VALUES(
                        <cfqueryparam value = '#arguments.firstName#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.lastName#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.userName#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.userPhone#' cfsqltype = "varchar">,
                        <cfqueryparam value = 2 cfsqltype = "integer">,
                        <cfqueryparam value = '#local.hashedPassword#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#local.secretKey#' cfsqltype = "varchar">
                    )
                </cfquery>
            </cfif>
            <cfset local.jsonData['signUpResult'] = 'Success'>
        </cfif>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction name = "userLogin" returnType = "any" access = "remote" returnFormat = "json">
        <cfargument name = "userName" required = "true" type = "string">
        <cfargument name = "password" required = "true" type = "string">
        <cfset local.result = {}>
        <cfif NOT trim(len(arguments.userName))>
            <cfset local.result['loginMailError'] = "UserName Required">
        <cfelseif  NOT isValid("email", arguments.userName) AND NOT REFind("^\d{10}$", arguments.userName)> 
            <cfset local.result['loginMailError'] = "UserName must be valid Email/Mobile">
        </cfif>
        <cfif NOT trim(len(arguments.password))>
            <cfset local.result['loginPasswordError'] = "Password Required">
        </cfif>
        <cfif structCount(local.result)>
            <cfset local.result['loginResult'] = "Error">
            <cfreturn local.result> 
        <cfelse>
            <cfquery name = "local.selectUser" datasource = #application.dataSource#>
                SELECT
                    u.fldUser_ID,
                    u.fldFirstName,
                    u.fldLastName,
                    u.fldEmail,
                    u.fldPhoneNumber,
                    u.fldHashedPassword,
                    u.fldUserSaltString,
                    u.fldUserRoleID,
                    r.fldRoleName,
                    r.fldRole_ID
                FROM 
                    tblUser u
                LEFT JOIN 
                    tblRole r
                ON
                    u.fldUserRoleID = r.fldRole_ID
                WHERE
                    fldEmail = <cfqueryparam value = '#arguments.userName#' cfsqltype = 'varchar'>
                    OR fldPhoneNumber = <cfqueryparam value = '#arguments.userName#' cfsqltype = 'varchar'> 
            </cfquery>
            <cfif queryRecordCount(local.selectUser)>
                <cfif (local.selectUser.fldHashedPassword EQ Hash(arguments.password & local.selectUser.fldUserSaltString,"SHA-256"))>
                    <cfset session.firstName = local.selectUser.fldFirstName>
                    <cfset session.lastName = local.selectUser.fldLastName>
                    <cfset session.role = local.selectUser.fldRoleName> 
                    <cfset session.userId = local.selectUser.fldUser_ID>
                    <cfset session.roleId = local.selectUser.fldRole_ID>
                    <cfset session.userMail = local.selectUser.fldEmail>
                    <cfset session.phone = local.selectUser.fldPhoneNumber>
                    <cfset session.login = true>
                    <cfset local.result['loginResult'] = "Success">
                <cfelse>
                    <cfset local.result['loginResult'] = "Invalid UserName/Password">
                </cfif>
            <cfelse>
                <cfset local.result['loginResult'] = "Account does not exist">
            </cfif>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "addCategory" returnType = "struct" access="public">
        <cfargument name = "categoryName" required = "true" type = "string">
        <cfset local.result = {}>
        <cfif NOT len(arguments.categoryName)>
            <cfset local.result["Error"] = "Category Name Required">
            <cfreturn local.result> 
        </cfif>
        <cfquery name = "local.selectCategory" datasource = #application.dataSource#>
            SELECT 1 
            FROM tblCategory
            WHERE 
                fldCategoryName = <cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar">
                AND fldActive = <cfqueryparam value = 1 cfsqltype = "varchar">
        </cfquery> 
        <cfif queryRecordCount(local.selectCategory)>
            <cfset local.result["Error"] = "Category Name Already Exist">
        <cfelse>
            <cfquery name = "local.insertCategory" datasource = #application.dataSource#>
                INSERT INTO tblCategory
                    (
                        fldCategoryName,
                        fldCreatedBy
                    )
                VALUES(
                    <cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar">,
                    <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                )
            </cfquery>
            <cfset local.result["Success"] = "Success:Category Name Added">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "editCategory" returnType = "struct" returnFormat = "JSON" access="remote">
        <cfargument name = "editId" required = "true" type = "integer">
        <cfquery name = "local.selectCategory" datasource = #application.dataSource#>
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM tblCategory
            WHERE 
                fldCategory_ID = <cfqueryparam value = '#arguments.editId#' cfsqltype = "varchar">
        </cfquery>
        <cfset local.jsonData = QueryGetRow(local.selectCategory,1)>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction name = "displayCategory" returnType = "query">
        <cfargument name = "categoryId" default = "">
        <cfquery name = "local.selectCategory" datasource = #application.dataSource#>
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM 
                tblCategory
            WHERE
                <cfif trim(len(arguments.categoryId))> 
                        fldCategory_ID = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer"> 
                        AND fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
                <cfelse>
                    fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfreturn local.selectCategory>
    </cffunction>

    <cffunction name = "viewCategory" access = "remote" returnformat = "json" returnType = "array">
        <cfargument name="homeView" default="">
        <cfquery name = "local.selectCategory" datasource = #application.dataSource#>
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM tblCategory
            WHERE
                fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
            <cfif arguments.homeView EQ 'Home'>
                LIMIT 10
            </cfif>
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query="local.selectCategory">
            <cfset local.jsonData = {}>
            <cfset local.jsonData['categoryId'] = local.selectCategory.fldCategory_ID>
            <cfset local.jsonData['categoryName'] = local.selectCategory.fldCategoryName>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
        </cfloop>
        <cfreturn local.dataArray>
    </cffunction>

    <cffunction name = "updateCategory" returnType = "struct">
        <cfargument name = "editId" required = "true" type = "integer">
        <cfargument name = "categoryName" required = "true" type = "string">
        <cfset local.result = {}>
        <cfif NOT len(arguments.categoryName)>
            <cfset local.result["Error"] = "Category Name Required">
            <cfreturn local.result> 
        </cfif>
        <cfquery name="local.selectCategory" datasource = #application.dataSource#>
            SELECT 1 
            FROM tblCategory
            WHERE 
                fldCategoryName = <cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar">
                AND fldActive = <cfqueryparam value = 1 cfsqltype = "varchar">
        </cfquery> 
        <cfif queryRecordCount(local.selectCategory)>
            <cfset local.result["Error"] = "Category Name Already Exist">
        <cfelse>
            <cfquery name="local.categoryUpadte" datasource = #application.dataSource#>
                UPDATE 
                    tblCategory
                SET
                    fldCategoryName = <cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar">,
                    fldUpdatedBy = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                WHERE
                    fldCategory_ID = <cfqueryparam value = '#arguments.editId#' cfsqltype = "integer">
            </cfquery>
            <cfset local.result["Success"] = "Category Name Updated">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "insertSubcategory" access = "remote" returnFormat = "json" returnType = "struct">
        <cfargument name = "subCategoryName" required = "true" type = "string">
        <cfargument name = "categoryId" required = "true" type = "integer">
        <cfset local.result = {}>
        <cfif NOT trim(len(arguments.subCategoryName))>
            <cfset local.result["addSubCategoryError"] = "SubCategory Name Required">
        </cfif>
        <cfif NOT trim(len(arguments.categoryId))>
            <cfset local.result["addCategoryError"] = "Category Name Required">
        </cfif>
        <cfif structCount(local.result)>
            <cfreturn local.result>
        <cfelse>
            <cfquery name = "local.fetchSubcategory" datasource = #application.dataSource#>
                SELECT 
                    fldSubCategoryName,
                    fldSubcategory_ID,
                    fldCategoryId
                FROM 
                    tblSubcategory
                WHERE
                    fldSubCategoryName = <cfqueryparam value = '#arguments.subCategoryName #' cfsqltype = "varchar">
                    AND fldCategoryId = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
            </cfquery>
            <cfif queryRecordCount(local.fetchSubcategory)>
                <cfset local.result["addSubMessage"] = "Subcategory Name Already Exist">
            <cfelse>
                <cfquery name="local.insertSubcategory" datasource = #application.dataSource#>
                    INSERT INTO tblSubcategory
                        (
                            fldSubcategoryName,
                            fldCategoryId,
                            fldCreatedBy
                        )
                    VALUES(
                        <cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">,
                        <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                    )
                </cfquery>
                <cfset local.result["addSubMessage"] = "Success:Subcategory Name Added">
            </cfif>
            <cfreturn local.result>
        </cfif>
    </cffunction>

    <cffunction name="updateSubcategory" access = "remote" returnFormat = "json" returnType = "any">
        <cfargument name="subCategoryId" required="true" type="integer">
        <cfargument name = "categoryID" required = "true" type = "integer">
        <cfargument name = "subCategoryName" required = "true" type = "string">
        <cfset local.result = {}>
        <cfif NOT trim(len(arguments.subCategoryName))>
            <cfset local.result["addSubCategoryError"] = "SubCategory Name Required">
        </cfif>
        <cfif NOT trim(len(arguments.categoryId))>
            <cfset local.result["addCategoryError"] = "Category Name Required">
        </cfif>
        <cfif structCount(local.result)>
            <cfreturn local.result>
        <cfelse>
            <cfquery name = "local.fetchSubcategory" datasource = #application.dataSource#>
                SELECT 
                    fldSubCategoryName,
                    fldSubcategory_ID,
                    fldCategoryId
                FROM 
                    tblSubcategory
                WHERE
                    fldSubCategoryName = <cfqueryparam value = '#arguments.subCategoryName #' cfsqltype = "varchar">
                    AND fldCategoryId = <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">
                    AND NOT fldSubcategory_ID = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
            </cfquery>
            <cfif queryRecordCount(local.fetchSubcategory)>
                <cfset local.result["addSubMessage"] = "Subcategory Already Exist">
            <cfelse>
                <cfquery name = "local.updateSubcategory" datasource = #application.dataSource#>
                    UPDATE tblSubcategory
                    SET
                        fldSubcategoryName = <cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "varchar">,
                        fldCategoryId = <cfqueryparam value = '#arguments.categoryID#' cfsqltype = "integer">,
                        fldUpdatedBy = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                    WHERE
                        fldSubcategory_ID = <cfqueryparam value = '#arguments.subCategoryID#' cfsqltype = "integer">
                </cfquery>
                <cfset local.result["addSubMessage"] = "Success:Subcategory Updated">
            </cfif>
            <cfreturn local.result>
        </cfif>
    </cffunction>

    <cffunction name = "viewSubcategory" returnType = "array" access = "remote" returnFormat = "json">
        <cfargument name = "categoryId" required = "true" type = "integer">
        <cfquery name = "local.fetchSubcategory" datasource = #application.dataSource#>
            SELECT
                fldSubcategoryName,
                fldSubcategory_ID
            FROM
                tblSubcategory
            WHERE
                fldCategoryId = <cfqueryparam value = '#arguments.categoryID#' cfsqltype = "integer"> 
                AND fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query="local.fetchSubcategory">
            <cfset local.jsonData = {}>
            <cfset local.jsonData['subcategoryName'] = local.fetchSubcategory.fldSubcategoryName>
            <cfset local.jsonData['subcategoryId'] = local.fetchSubcategory.fldSubcategory_ID>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
        </cfloop>
        <cfreturn local.dataArray >
    </cffunction>

    <cffunction name = "viewSubcategoryEdit" returnType = "array" access = "remote" returnFormat = "json">
        <cfargument name = "subCategoryId" required = "true" type = "integer">
        <cfquery name = "local.fetchSubcategory" datasource = #application.dataSource#>
            SELECT
                S.fldSubcategoryName,
                S.fldSubcategory_ID,
                C.fldCategoryName,
                C.fldCategory_ID
            FROM
                tblSubcategory S
            LEFT JOIN
                tblCategory C ON C.fldCategory_ID = S.fldCategoryId
            WHERE
                fldSubcategory_ID = <cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer">
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query="local.fetchSubcategory">
             <cfset local.jsonData = {}>
            <cfset local.jsonData['subcategoryId'] = local.fetchSubcategory.fldSubcategory_ID>
            <cfset local.jsonData['subcategoryName'] = local.fetchSubcategory.fldSubcategoryName>
            <cfset local.jsonData['categoryId'] = local.fetchSubcategory.fldCategory_ID>
            <cfset local.jsonData['categoryName'] = local.fetchSubcategory.fldCategoryName>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
        </cfloop>
        <cfreturn local.dataArray >
    </cffunction>

    <cffunction name = "deleteRow" returnType = "boolean" access = "remote">
        <cfargument name = "tableName" required = "true" type = "string">
        <cfargument name = "deleteId" required = "true" type = "integer">
        <cfif arguments.tableName EQ 'tblCategory'>
            <cfset local.columnName = 'fldCategory_ID'>
        <cfelseif arguments.tableName EQ 'tblProducts'>
            <cfset local.columnName = 'fldProduct_ID'>
        <cfelseif arguments.tableName EQ 'tblProductImages'>
            <cfset local.columnName = 'fldProductImage_ID'>
        <cfelse>
            <cfset local.columnName = 'fldSubcategory_ID'>
        </cfif>
        <cfquery name = "local.deleteData" datasource = #application.dataSource#>
            UPDATE  
                #arguments.tablename#
            SET
                fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
            <cfif arguments.tableName EQ 'tblProductImages'>
                fldDeactivatedBy = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
            <cfelse>
                fldUpdatedBy = <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
            </cfif>
            WHERE
                #local.columnName# = <cfqueryparam value = '#arguments.deleteId#' cfsqltype = "integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction name = "userLogout" returnType = "boolean" access = "remote">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

    <cffunction name = "insertProduct" returnType = "struct"  access = "remote" returnFormat = "json">

        <cfargument name = "addProductCategorySelect" required = "true" type = "integer">
        <cfargument name = "addProductSubcategorySelect" required = "true" type = "integer">
        <cfargument name = "addProductNameInput" required = "true" type = "string">
        <cfargument name = "addProductBrandInput" required = "true" type = "integer">
        <cfargument name = "addProductDescription" required = "true" type = "string">
        <cfargument name = "addProductPrice" required = "true" type = "numeric">
        <cfargument name = "addProductTax" required = "true" type = "numeric">
        <cfargument name = "addProductImage" required = "true" type = "any">
        <cfset local.result = {}>

        <cfif len(trim(arguments.addProductCategorySelect)) LT 1>
            <cfset local.result['categoryError'] = "Category Name Missing">
        </cfif>
        <cfif len(trim(arguments.addProductSubcategorySelect)) LT 1>
            <cfset local.result['subCategoryError'] = "SubCategory Name Missing">
        </cfif>
        <cfif len(trim(arguments.addProductNameInput)) LT 1>
            <cfset local.result['nameError'] = "Product Name Missing">
        </cfif>
        <cfif len(trim(arguments.addProductDescription)) LT 1>
            <cfset local.result['descriptionError'] = "Description Missing">
        </cfif>
        <cfif len(trim(arguments.addProductPrice)) LT 1>
            <cfset local.result['priceError'] = "Price Missing">
        <cfelseif NOT isNumeric(arguments.addProductPrice)>
            <cfset local.result['priceError'] = "Price must be number">
        </cfif>
        <cfif len(trim(arguments.addProductTax)) LT 1>
            <cfset local.result['taxError'] = "Tax Missing">
        <cfelseif NOT isNumeric(arguments.addProductTax)>
            <cfset local.result['taxError'] = "Tax must be number">
        </cfif>
        <cfif len(trim(arguments.addProductBrandInput)) LT 1>
            <cfset local.result['brandError'] = "Brand Name Missing">
        </cfif>
        <cfif len(trim(arguments.addProductImage)) LT 1>
            <cfset local.result['fileError'] = "Images Missing">
        </cfif>
        <cfif StructCount(local.result) GT 0>
            <cfreturn local.result>
        <cfelse>
            <cfquery name = "local.fetchContacts" datasource = #application.dataSource#>
                SELECT 1 
                FROM tblProducts
                WHERE
                    fldProductName = <cfqueryparam value = "#arguments.addProductNameInput#" cfsqltype = "varchar">
                    AND fldSubcategoryId = <cfqueryparam value = "#arguments.addProductSubcategorySelect#" cfsqltype = "varchar">
            </cfquery>
            <cfif queryRecordCount(local.fetchContacts)>
                <cfset local.result["insertError"] = "Failed:Product Already Exist">
            <cfelse>
                <cfset local.uploadPath = expandPath('../Assets/uploadImages')>
                <cffile  action = "uploadAll" destination = "#local.uploadPath#" nameConflict = "MakeUnique" result = "local.imagePathArray"> 

                <cfquery name = "local.insertProduct" result = "local.productInsert" datasource = #application.dataSource#>
                    INSERT INTO
                        tblProducts(
                            fldSubcategoryId,
                            fldProductName,
                            fldBrandId,
                            fldDescription,
                            fldPrice,
                            fldTax,
                            fldCreatedBy
                        )
                    VALUES(
                        <cfqueryparam value = '#arguments.addProductSubcategorySelect#' cfsqltype = "integer">,
                        <cfqueryparam value = '#arguments.addProductNameInput#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.addProductBrandInput#' cfsqltype = "integer">,
                        <cfqueryparam value = '#arguments.addProductDescription#' cfsqltype = "varchar">,
                        <cfqueryparam value = '#arguments.addProductPrice#' cfsqltype = "decimal">,
                        <cfqueryparam value = '#arguments.addProductTax#' cfsqltype = "decimal">,
                        <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                    )
                </cfquery>
                <cfset local.generatedKey = local.productInsert.generatedKey>
                <cfquery name="local.insertImages" datasource = #application.dataSource#>
                    INSERT INTO
                        tblProductImages(
                            fldProductId,
                            fldImageFileName,
                            fldDefaultImage,
                            fldCreatedBy
                        )
                    VALUES
                        <cfloop array="#local.imagePathArray#" item="item" index="i"> 
                            (
                                <cfqueryparam value = '#local.generatedKey#' cfsqltype = "integer">,
                                <cfqueryparam value = '#item.serverFile#' cfsqltype = "varchar">,
                                <cfif i EQ 1>
                                    <cfqueryparam value = 1 cfsqltype = "integer">,
                                <cfelse>
                                    <cfqueryparam value = 0 cfsqltype = "integer">,
                                </cfif>
                                <cfqueryparam value = '#session.userId#' cfsqltype = "integer">
                            )
                            <cfif i NEQ arrayLen(local.imagePathArray)>
                                ,
                            </cfif>
                        </cfloop>
                        <cfset local.result["insertError"] = "Success:Product Added">
                </cfquery>
            </cfif>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction name = "SubcategoryDisplay" returnType = "any" access = "remote" returnFormat = "json">
        <cfset local.jsonData = {}>
        <cfquery name = "local.fetchSubcategory" datasource = #application.dataSource#>
            SELECT
                C.fldCategory_ID,
                C.fldCategoryName,
                GROUP_CONCAT(S.fldSubcategoryName ORDER BY S.fldSubcategoryName ASC SEPARATOR ', ') AS Subcategories,
                GROUP_CONCAT(S.fldSubcategory_ID ORDER BY S.fldSubcategory_ID ASC SEPARATOR ', ') AS fldSubcategory_ID
            FROM
                tblSubcategory S
            LEFT JOIN
                tblCategory C ON C.fldCategory_ID = S.fldCategoryId
            WHERE
                C.fldActive = 1 AND
                S.fldActive = 1
            GROUP BY
                C.fldCategory_ID, C.fldCategoryName;
        </cfquery>

        <cfreturn local.fetchSubcategory >
    </cffunction>

    <cffunction name = "viewBrand" returnType = "array" access = "remote" returnFormat = "json">
        <cfquery name = "local.selectBrand" datasource = #application.dataSource#>
            SELECT
                fldBrandName,
                fldBrand_ID
            FROM
                tblBrand
            WHERE
                fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        </cfquery>
        <cfset local.arrayData = []>
        <cfloop query="local.selectBrand">
            <cfset local.jsonData = {}>
            <cfset local.jsonData['brandName'] = local.selectBrand.fldBrandName>
            <cfset local.jsonData['brandId'] = local.selectBrand.fldBrand_ID>
            <cfset arrayAppend(local.arrayData, local.jsonData)>
        </cfloop>
        <cfreturn local.arrayData>
    </cffunction>

    
    <cffunction name = "updateProduct" access = "remote" returnType = "struct" returnFormat = "json">

        <cfargument name = "addProductCategorySelect" required = "true" type = "integer">
        <cfargument name = "addProductSubcategorySelect" required = "true" type = "integer">
        <cfargument name = "addProductNameInput" required = "true" type = "string">
        <cfargument name = "addProductBrandInput" required="true" type = "integer">
        <cfargument name = "addProductDescription" required="true" type = "string">
        <cfargument name = "addProductPrice" required = "true" type = "numeric">
        <cfargument name = "addProductTax" required = "true" type = "numeric">
        <cfargument name = "productId" required = "true" type = "integer">

        <cfset local.result = {}>

        <cfif len(trim(arguments.addProductCategorySelect)) LT 1>
            <cfset local.result['categoryError'] = "Category Name Missing">
        </cfif>
        <cfif len(trim(arguments.addProductSubcategorySelect)) LT 1>
            <cfset local.result['subCategoryError'] = "SubCategory Name Missing">
        </cfif>
        <cfif len(trim(arguments.addProductNameInput)) LT 1>
            <cfset local.result['nameError'] = "Product Name Missing">
        </cfif>
        <cfif len(trim(arguments.addProductDescription)) LT 1>
            <cfset local.result['descriptionError'] = "Description Missing">
        </cfif>
        <cfif len(trim(arguments.addProductPrice)) LT 1>
            <cfset local.result['priceError'] = "Price Missing">
        <cfelseif NOT isNumeric(arguments.addProductPrice)>
            <cfset local.result['priceError'] = "Price must be number">
        </cfif>
        <cfif len(trim(arguments.addProductTax)) LT 1>
            <cfset local.result['taxError'] = "Tax Missing">
        <cfelseif NOT isNumeric(arguments.addProductTax)>
            <cfset local.result['taxError'] = "Tax must be number">
        </cfif>
        <cfif len(trim(arguments.addProductBrandInput)) LT 1>
            <cfset local.result['brandError'] = "Brand Name Missing">
        </cfif>
        <cfif StructCount(local.result) GT 0>
            <cfreturn local.result>
        <cfelse>
            <cfquery name = "local.fetchContacts" datasource = #application.dataSource#>
                SELECT 1 
                FROM tblProducts
                WHERE
                    fldProductName = <cfqueryparam value = "#arguments.addProductNameInput#" cfsqltype = "varchar">
                    AND fldSubcategoryId = <cfqueryparam value = "#arguments.addProductSubcategorySelect#" cfsqltype = "varchar">
                    AND NOT fldProduct_ID = <cfqueryparam value = "#arguments.productId#" cfsqltype = "varchar"> 
            </cfquery>
            <cfif queryRecordCount(local.fetchContacts)>
                <cfset local.result["insertError"] = "Failed:Product Already Exist">
            <cfelse>
                <cfquery name = "local.updatePoduct" datasource = #application.dataSource#>
                    UPDATE 
                        tblProducts
                    SET
                        fldSubcategoryid = <cfqueryparam value = "#arguments.addProductSubcategorySelect#" cfsqltype = "integer">,
                        fldProductName = <cfqueryparam value = "#arguments.addProductNameInput#" cfsqltype = "varchar">,
                        fldBrandId = <cfqueryparam value = "#arguments.addProductBrandInput#" cfsqltype = "integer">,
                        fldDescription = <cfqueryparam value = "#arguments.addProductDescription#" cfsqltype = "varchar">,
                        fldPrice = <cfqueryparam value = "#arguments.addProductPrice#" cfsqltype = "decimal">,
                        fldTax = <cfqueryparam value = "#arguments.addProductTax#" cfsqltype = "decimal">,
                        fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                    WHERE
                        fldProduct_ID=<cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                </cfquery>
                <cfset local.result["insertError"] = "Success:Product Uploaded">
            </cfif>
            <cfreturn local.result>
        </cfif>
    </cffunction>

    <cffunction name = "viewImages" access = "remote"  returnType="array" returnFormat = "json">
        <cfargument name = "productId" required = "true" type = "integer">
        <cfquery name = "local.fetchImages" datasource = #application.dataSource#>
            SELECT 
                fldProductImage_ID,
                fldImageFileName,
                fldProductId,
                fldDefaultImage
            FROM
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                AND fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query="local.fetchImages">
            <cfset local.jsonData = {}>
            <cfset local.jsonData['imageId'] = local.fetchImages.fldProductImage_ID>
            <cfset local.jsonData['imageFileName'] = local.fetchImages.fldImageFileName>
            <cfset local.jsonData['productId'] = local.fetchImages.fldProductId>
            <cfset local.jsonData['defaultImage'] = local.fetchImages.fldDefaultImage>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
        </cfloop>
        <cfreturn local.dataArray>
    </cffunction>


    <cffunction name = "setThumbnail" access = "remote" returnType = "boolean">
        <cfargument name = "ImageId" required = "true" type = "integer">
        <cfargument name = "productId" required = "true" type = "integer">
        <cfquery name = "local.updateImages" datasource = #application.dataSource#>
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = <cfqueryparam value = 0 cfsqltype = "integer">
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                AND
                fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
        </cfquery>
        <cfquery name = "local.setDefaultImage" datasource = #application.dataSource#>
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
            WHERE
                fldProductImage_ID = <cfqueryparam value = "#arguments.ImageId#" cfsqltype = "integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction name = "viewProducts" returnType = "array" returnFormat = "json" access = "remote">
        <cfargument name = "columnName" required = "false" type = "string">
        <cfargument name = "productSubId" required = "false" type = "integer">
        <cfargument name = "productId" default=0 required = "false" type = "integer">
        <cfquery name = "local.viewProduct" datasource = #application.dataSource#>
            SELECT
                P.fldProductName,
                P.fldPrice,
                P.fldProduct_ID,
                P.fldDescription,
                P.fldTax,
                C.fldCategoryName,
                C.fldCategory_ID,
                S.fldSubcategory_ID,
                S.fldSubcategoryName,
                I.fldImageFileName,
                B.fldBrand_ID,
                B.fldBrandName
            FROM
                tblBrand B
            INNER JOIN
                tblProducts P ON B.fldBrand_ID = P.fldBrandId
            INNER JOIN
                tblProductImages I ON P.fldProduct_ID = I.fldProductId
            INNER JOIN
                tblSubcategory S ON S.fldSubcategory_ID = P.fldSubcategoryId
            INNER JOIN
                tblCategory C ON C.fldCategory_ID = S.fldCategoryId
            WHERE
                P.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
                AND I.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
                AND B.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
                AND S.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
                AND C.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
                AND I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
                <cfif arguments.productId NEQ 0>
                    AND P.fldProduct_ID = <cfqueryparam value ="#arguments.productId#" cfsqltype = "integer">
                <cfelse>
                    AND P.#arguments.columnName# = <cfqueryparam value ="#arguments.productSubId#" cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query = "local.viewProduct">
            <cfset local.jsonData = {}>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
            <cfset local.jsonData['productName'] = local.viewProduct.fldProductName>
            <cfset local.jsonData['price'] = local.viewProduct.fldPrice>
            <cfset local.jsonData['tax'] = local.viewProduct.fldTax>
            <cfset local.jsonData['description'] = local.viewProduct.fldDescription>
            <cfset local.jsonData['productId'] = local.viewProduct.fldProduct_ID>
            <cfset local.jsonData['categoryId'] = local.viewProduct.fldCategory_ID>
            <cfset local.jsonData['categoryName'] = local.viewProduct.fldCategoryName>
            <cfset local.jsonData['subcategoryName'] = local.viewProduct.fldSubcategoryName>
            <cfset local.jsonData['subcategoryId'] = local.viewProduct.fldSubcategory_ID>
            <cfset local.jsonData['file'] = local.viewProduct.fldImageFileName>
            <cfset local.jsonData['brandId'] = local.viewProduct.fldBrand_ID>
            <cfset local.jsonData['brandName'] = local.viewProduct.fldBrandName>
        </cfloop>
        <cfreturn local.dataArray>
    </cffunction>

    <cffunction name = "randomProducts" returnType = "array">
        <cfargument name = "subCategoryId" type = "any" default = 0 required = "false">
        <cfargument name = "sortBy" type = "string" default = "noSort" required = "false">
        <cfargument name = "min" type = "string" default = 0 required = "false">
        <cfargument name = "max" type = "string" default = 0 required = "false">
        <cfargument name = "search" type = "string" default = "" required = "false">
        <cfquery name = "local.fetchProducts" datasource = #application.dataSource#>
            SELECT
                P.fldProduct_ID, 
                P.fldProductName,
                P.fldPrice,
                P.fldTax,
                P.fldSubcategoryId,
                P.fldDescription,
                I.fldImageFileName,
                I.fldDefaultImage
            FROM tblProducts P
            INNER JOIN
                tblProductImages I ON P.fldProduct_ID = I.fldProductId
            INNER JOIN
                tblSubcategory S ON S.fldSubcategory_ID = P.fldSubcategoryId
            WHERE 
                <cfif arguments.search EQ "">
                    P.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
                    AND I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
                </cfif>
                <cfif arguments.subCategoryId NEQ 0>
                    AND P.fldSubcategoryId = <cfqueryparam value ="#arguments.subCategoryId#" cfsqltype = "integer"> 
                </cfif>
                <cfif arguments.subCategoryId EQ 0 AND arguments.search EQ "">
                    ORDER BY 
                        RAND()
                    LIMIT 10
                <cfelseif arguments.sortBy EQ "min">
                    ORDER BY P.fldPrice
                <cfelseif arguments.sortBy EQ "max">
                    ORDER BY P.fldPrice DESC;
                <cfelseif arguments.min NEQ 0 AND arguments.max NEQ 0>
                    AND P.fldPrice >= <cfqueryparam value ="#arguments.min#" cfsqltype = "varchar">
                    <cfif NOT Find("+", arguments.max)>
                        AND P.fldPrice <= <cfqueryparam value ="#arguments.max#" cfsqltype = "varchar">
                    </cfif>
                <cfelseif arguments.search NEQ "">
                    I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
                    AND (
                    P.fldProductName LIKE <cfqueryparam value = "%#arguments.search#%" cfsqltype = "varchar">
                    OR P.fldDescription LIKE <cfqueryparam value = "%#arguments.search#%" cfsqltype = "varchar">
                    OR S.fldSubcategoryName = <cfqueryparam value = #arguments.search# cfsqltype = "varchar">
                    )
                    AND P.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query = "local.fetchProducts">
            <cfset local.jsonData = {}>
            <cfset local.jsonData['productId'] = local.fetchProducts.fldProduct_ID>
            <cfset local.jsonData['productName'] = local.fetchProducts.fldProductName>
            <cfset local.jsonData['price'] = local.fetchProducts.fldPrice>
            <cfset local.jsonData['productFileName'] = local.fetchProducts.fldImageFileName>
            <cfset local.jsonData['subcategoryId'] = local.fetchProducts.fldSubcategoryId>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
        </cfloop>
        <cfreturn local.dataArray>
    </cffunction>

    <cffunction name = "displayProduct" returnType = "struct" returnFormat = "json" access = "remote">
        <cfargument name = "productId" type = "integer" required = "true">
        <cfquery name = "local.fetchProduct" datasource = #application.dataSource#>
            SELECT 
                P.fldProduct_ID,
                P.fldProductName,
                P.fldDescription,
                P.fldPrice,
                P.fldTax,
                B.fldBrand_ID,
                B.fldBrandName,
                I.fldImageFileName,
                S.fldSubcategoryName,
                S.fldSubcategory_ID,
                C.fldCategoryName,
                C.fldCategory_ID
            FROM
                tblProducts P
            INNER JOIN
                tblBrand B ON B.fldBrand_ID = P.fldBrandId
            INNER JOIN
                tblProductImages I ON P.fldProduct_ID = I.fldProductId
            INNER JOIN
                tblSubcategory S ON S.fldSubcategory_ID = P.fldSubcategoryId
            INNER JOIN
                tblCategory C ON C.fldCategory_ID = S.fldCategoryId
            WHERE 
                P.fldProduct_ID = <cfqueryparam value ="#arguments.productId#" cfsqltype = "integer">
                AND I.fldDefaultImage = <cfqueryparam value =1 cfsqltype = "integer">
        </cfquery>
        <cfset local.jsonData = {}>
        <cfloop query = "local.fetchProduct">
            <cfset local.jsonData['productId'] = local.fetchProduct.fldProduct_ID>
            <cfset local.jsonData['productName'] = local.fetchProduct.fldProductName>
            <cfset local.jsonData['description'] = local.fetchProduct.fldDescription>
            <cfset local.jsonData['price'] = local.fetchProduct.fldPrice>
            <cfset local.jsonData['tax'] = local.fetchProduct.fldTax>
            <cfset local.jsonData['brand'] = local.fetchProduct.fldBrandName>
            <cfset local.jsonData['brandId'] = local.fetchProduct.fldBrand_ID>
            <cfset local.jsonData['file'] = local.fetchProduct.fldImageFileName>
            <cfset local.jsonData['subCategoryName'] = local.fetchProduct.fldSubcategoryName>
            <cfset local.jsonData['subCategoryId'] = local.fetchProduct.fldSubcategory_ID>
            <cfset local.jsonData['categoryName'] = local.fetchProduct.fldCategoryName>
            <cfset local.jsonData['categoryId'] = local.fetchProduct.fldCategory_ID>
        </cfloop>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction name = "subcategoryListing" returnType = "array" access = "public">
        <cfargument name = "categoryId" required = "true" type = "integer">
        <cfquery name = "local.fetchSubcategory" datasource = #application.dataSource#>
            SELECT
                fldSubCategoryName,
                fldSubcategory_ID
            FROM
                tblSubcategory
            WHERE
                fldCategoryId = <cfqueryparam value ="#arguments.categoryId#" cfsqltype = "integer">
        </cfquery>
         <cfset local.dataArray = []>
        <cfloop query="local.fetchSubcategory">
            <cfset local.jsonData = {}>
            <cfset local.jsonData['subcategoryId'] = local.fetchSubcategory.fldSubcategory_ID>
            <cfset local.jsonData['subcategoryName'] = local.fetchSubcategory.fldSubCategoryName>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
        </cfloop>
        <cfreturn local.dataArray>

    </cffunction>

    <cffunction name = "addToCart" returnType = "any" access = "remote" returnFormat = "json">
        <cfargument name = "productId" type = "integer" required = "true">
        <cfif structKeyExists(session, "role")>
            <cfquery name = "local.fetchCart" datasource = "#application.dataSource#">
                SELECT 1 
                FROM
                    tblCart
                WHERE 
                    fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                    AND fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
            </cfquery>
            <cfif queryRecordCount(local.fetchCart)>
                <cfreturn 'cart exist'>
            <cfelse>
                <cfquery name = "local.insertCart" datasource = "#application.dataSource#" result = "local.cartResult">
                    INSERT INTO
                        tblCart(
                            fldProductId,
                            fldUserId,
                            fldQuantity
                        ) 
                    VALUES(
                        <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">,
                        <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                        <cfqueryparam value = 1 cfsqltype = "integer">
                        )
                </cfquery>
                <cfreturn local.cartResult.generatedKey>
            </cfif>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>

    <cffunction name = "cartItems" returnType = "array" access = "remote" returnFormat="json">
        <cfargument name = "cartId" default = 0 type = "integer" required = "false">
        <cfargument name = "productId" default = 0 type = "integer"  required = "false">
        <cfquery name = "local.fetchCart" datasource = #application.dataSource#>
            SELECT
                C.fldCartItem_ID,
                C.fldProductId,
                C.fldQuantity,
                P.fldProductName,
                P.fldSubCategoryId,
                P.fldPrice,
                P.fldTax,
                (C.fldQuantity * P.fldPrice) AS totalPrice,
                (C.fldQuantity * P.fldTax) AS totalTax,
                P.fldTax,
                I.fldImageFileName
            FROM
                tblCart C
            INNER JOIN 
                tblProducts P ON P.fldProduct_ID = C.fldProductId
            INNER JOIN
                tblProductImages I ON P.fldProduct_ID = I.fldProductId
            WHERE
                C.fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                AND I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
                <cfif arguments.cartId NEQ 0>
                    AND C.fldCart_ID = <cfqueryparam value = "#arguments.cartId#" cfsqltype = "integer">
                </cfif>
                <cfif arguments.productId NEQ 0>
                    AND C.fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query="local.fetchCart">
            <cfset local.data = {}>
            <cfset local.data['cartId'] = local.fetchCart.fldCartItem_ID>
            <cfset local.data['productId'] = local.fetchCart.fldProductId>
            <cfset local.data['quantity'] = local.fetchCart.fldQuantity>
            <cfset local.data['productName'] = local.fetchCart.fldProductName>
            <cfset local.data['subcategoryId'] = local.fetchCart.fldSubCategoryId>
            <cfset local.data['totalPrice'] = local.fetchCart.totalPrice>
            <cfset local.data['totalTax'] = local.fetchCart.totalTax>
            <cfset local.data['price'] = local.fetchCart.fldPrice>
            <cfset local.data['tax'] = local.fetchCart.fldTax>
            <cfset local.data['file'] = local.fetchCart.fldImageFileName>
            <cfset arrayAppend(local.dataArray, local.data)>
        </cfloop>
        <cfreturn local.dataArray>
    </cffunction>

    <cffunction name = "updateCart" returnType="array" returnFormat = "json" access = "remote">
        <cfargument name = "cartId" required = "true" type = "integer">
        <cfargument name = "operation" required = "true" type = "string">
        <cfquery name = "local.updateCart" datasource = #application.dataSource#>
            UPDATE 
                tblCart
            SET
                <cfif arguments.operation EQ "Plus">
                    fldQuantity = fldQuantity + 1
                <cfelse>
                    fldQuantity = fldQuantity - 1
                </cfif>
            WHERE
                fldCartItem_ID = <cfqueryparam value = "#arguments.cartId#" cfsqltype = "integer">
        </cfquery>
        <cfset local.dataArray = cartItems()>
        <cfreturn local.dataArray>
    </cffunction>

    <cffunction name = "deleteCartItem" returnType="array" returnFormat = "json" access = "remote">
        <cfargument name = "cartId" required = "false" type = "integer">
        <cfargument name = "productId" required = "false" type = "integer">
        <cfquery name = "local.deleteCartItem" datasource = #application.dataSource#>
            DELETE FROM
                tblCart
            WHERE 
                <cfif structKeyExists(arguments, "cartId")>
                    fldCartItem_ID = <cfqueryparam value = "#arguments.cartId#" cfsqltype = "integer">
                </cfif>
                <cfif structKeyExists(arguments, "productId")>
                     fldProductId= <cfqueryparam value = "#arguments.productId#" cfsqltype = "integer">
                </cfif>
        </cfquery>
        <cfset local.dataArray = cartItems()>
        <cfreturn local.dataArray>
    </cffunction>

    <cffunction name = "updateProfile" returnType = "any" returnFormat = "json" access = "remote">
        <cfargument name = "profileFirstName" required = "true" type = "string">
        <cfargument name = "profileLastName" required = "true" type = "string">
        <cfargument name = "profileEmail" required = "true" type = "string">
        <cfargument name = "profilePhone" required="true" type = "string">
        <cfquery name = "local.selectUser" datasource = #application.dataSource#>
            SELECT
                fldEmail,
                fldPhoneNumber
            FROM 
                tblUser
            WHERE
                (fldEmail = <cfqueryparam value = '#arguments.profileEmail#' cfsqltype = 'varchar'>
                OR fldPhoneNumber = <cfqueryparam value = '#arguments.profilePhone#' cfsqltype = 'varchar'>) 
                AND NOT fldUser_ID = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
        </cfquery>
        <cfif queryRecordCount(local.selectUser)>
            <cfreturn false>
        <cfelse>
            <cfquery name = "local.updateUser" datasource = #application.dataSource# result = "local.updateResult">
                UPDATE
                    tblUser
                SET
                    fldFirstName = <cfqueryparam value = "#arguments.profileFirstName#" cfsqltype = "varchar">,
                    fldLastName = <cfqueryparam value = "#arguments.profileLastName#" cfsqltype = "varchar">,
                    fldPhoneNumber = <cfqueryparam value = "#arguments.profilePhone#" cfsqltype = "varchar">,
                    fldEmail = <cfqueryparam value = "#arguments.profileEmail#" cfsqltype = "varchar">,
                    fldUpdatedBy = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                WHERE
                    fldUser_ID = <cfqueryparam value = "#session.userId#" cfsqltype = "varchar">
            </cfquery>
            <cfset local.jsonData = {}>
            <cfset local.jsonData['firstName'] = local.updateResult.SQLPARAMETERS[1]>
            <cfset local.jsonData['lastName'] = local.updateResult.SQLPARAMETERS[2]>
            <cfset local.jsonData['phone'] = local.updateResult.SQLPARAMETERS[3]>
            <cfset local.jsonData['email'] = local.updateResult.SQLPARAMETERS[4]>
            <cfset session.firstName = local.updateResult.SQLPARAMETERS[1]>
            <cfset session.lastName = local.updateResult.SQLPARAMETERS[2]>
            <cfset session.phone = local.updateResult.SQLPARAMETERS[3]>
            <cfset session.userMail = local.updateResult.SQLPARAMETERS[4]>
            <cfreturn local.jsonData>
        </cfif>
    </cffunction>

    <cffunction name = "addAddress" access = "remote" returnType = "struct" returnFormat = "json">
        <cfargument name = "firstName" type = "string" required = "true">
        <cfargument name = "lastName" type = "string" required = "true">
        <cfargument name = "addressOne" type = "string" required = "true">
        <cfargument name = "addressTwo" type = "string" required = "true">
        <cfargument name = "state" type = "string" required = "true">
        <cfargument name = "city" type = "string" required = "true">
        <cfargument name = "pincode" type = "string" required = "true">
        <cfargument name = "phone" type = "string" required = "true">
        <cfset local.result = {}>
        <cfif NOT len(arguments.firstName)>
            <cfset local.result['profileFirstNameError'] = 'FirstName is Required'>
        </cfif>
        <cfif NOT len(arguments.addressOne)>
            <cfset local.result['profileAddressOneError'] = 'Address is Required'>
        </cfif>
        <cfif NOT len(arguments.state)>
            <cfset local.result['profileStateError'] = 'State is Required'>
        <cfelseif  NOT REFind("^[A-Za-z\s\-\']+$", arguments.state)>
            <cfset local.result['profileCityError'] = 'State can only contain letters'>
        </cfif>
        <cfif NOT len(arguments.city)>
            <cfset local.result['profileCityError'] = 'City is Required'>
        <cfelseif  NOT REFind("^[A-Za-z\s\-\']+$", arguments.city)>
            <cfset local.result['profileCityError'] = 'City can only contain letters'>
        </cfif>
        <cfif NOT len(arguments.pincode)>
            <cfset local.result['profilePincodeError'] = 'Pincode is Required'>
        <cfelseif NOT(REFind("^\d{6}$", "#arguments.pincode#"))>
            <cfset local.result['profilePincodeError'] = 'Pincode Must be 6 Digit'>
        </cfif>
        <cfif NOT len(arguments.phone)>
            <cfset local.result['profilePhoneError'] = 'Mobile is Required'>
        <cfelseif NOT(REFind("^\d{10}$", "#arguments.phone#"))>
            <cfset local.result['profilePincodeError'] = 'Mobile Must be 10 Digit'>
        </cfif>
        <cfif structCount(local.result)>
            <cfset local.result['Result'] = 'Error'>
            <cfreturn local.result>
        <cfelse>
            <cfquery name = "local.city" datasource = #application.dataSource# result = "local.addressResult">
                INSERT INTO
                    tblAddress(
                        fldUserId,
                        fldFirstName,
                        fldLastName,
                        fldAddressLine1,
                        fldAddressLine2,
                        fldState,
                        fldCity,
                        fldPincode,
                        fldPhoneNumber
                    )
                VALUES(
                    <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                    <cfqueryparam value = "#arguments.firstName#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.lastName#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.addressOne#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.addressTwo#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.state#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.city#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.pincode#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#arguments.phone#" cfsqltype = "varchar">
                )
            </cfquery>
            <cfset local.result['Result'] = 'Success'>
            <cfset local.result['addressId'] = local.addressResult.generatedKey>
            <cfreturn local.result>
        </cfif>
    </cffunction>

    <cffunction name = "fetchAddress" returnType = "array">
        <cfquery name = "local.fetchAddress" datasource = #application.dataSource#>
            SELECT
                fldAddress_ID,
                fldFirstName,
                fldlastname,
                fldAddressLine1,
                fldAddressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhoneNumber
            FROM
                tblAddress
            WHERE 
                fldUserId = <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                AND fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query="local.fetchAddress">
            <cfset local.jsonData = {}>
            <cfset local.jsonData['addressID'] = local.fetchAddress.fldAddress_ID>
            <cfset local.jsonData['firstName'] = local.fetchAddress.fldFirstName>
            <cfset local.jsonData['lastName'] = local.fetchAddress.fldlastname>
            <cfset local.jsonData['addressOne'] = local.fetchAddress.fldAddressLine1>
            <cfset local.jsonData['addressTwo'] = local.fetchAddress.fldAddressLine2>
            <cfset local.jsonData['city'] = local.fetchAddress.fldCity>
            <cfset local.jsonData['state'] = local.fetchAddress.fldState>
            <cfset local.jsonData['pincode'] = local.fetchAddress.fldPincode>
            <cfset local.jsonData['phone'] = local.fetchAddress.fldPhoneNumber>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
        </cfloop>
        <cfreturn local.dataArray>
    </cffunction>

    <cffunction name = "buyProduct" access = "remote" returnType = "struct" returnFormat = "json">
        <cfargument name = "totalOrderPrice" type = "numeric" required = "true">
        <cfargument name = "totalOrderTax" type = "numeric" required = "true">
        <cfargument name = "addressId" type = "integer" required = "true">
        <cfargument name = "cardNumber" type = "numeric" required = "true" default = 1>
        <cfargument name = "cvv" type = "numeric" required = "true" default = 1>
        <cfargument name = "detailsStruct" type = "struct" required = "true">
        <cfset local.cardNumber = 123456789123>
        <cfset local.cvv = 123>
        <cfset local.jsonData = {}>
        <cfset local.payAmount = arguments.totalOrderPrice + arguments.totalOrderTax>
        <cfif (arguments.cardNumber EQ local.cardNumber) AND (arguments.cvv EQ local.cvv)>
            <cfset local.generatedUUID = createUUID()>
            <cfquery name = "local.buyProduct"  datasource = #application.dataSource# result = "local.buyProductResult">
                INSERT INTO
                    tblOrders(
                        fldOrder_ID,
                        fldUserId,
                        fldAddressId,
                        fldTotalPrice,
                        fldTotalTax
                    )
                VALUES(
                    <cfqueryparam value = "#local.generatedUUID#" cfsqltype = "varchar">,
                    <cfqueryparam value = "#session.userId#" cfsqltype = "integer">,
                    <cfqueryparam value = "#arguments.addressId#" cfsqltype = "integer">,
                    <cfqueryparam value = "#arguments.totalOrderPrice#" cfsqltype = "decimal">,
                    <cfqueryparam value = "#arguments.totalOrderTax#" cfsqltype = "decimal">
                )
            </cfquery>
            <cfloop collection="#arguments.detailsStruct#" item="item">
                <cfif isStruct(arguments.detailsStruct[item])>
                    <cfquery name = "local.orderItems" datasource = #application.dataSource#>
                        INSERT INTO 
                            tblOrderItems( 
                                fldOrderId,
                                fldProductId,
                                fldQuantity,
                                fldUnitPrice,
                                fldUnitTax
                            )
                        VALUES(
                            <cfqueryparam value = "#local.generatedUUID#" cfsqltype = "varchar">,
                            <cfqueryparam value = #arguments.detailsStruct[item].productId# cfsqltype = "integer">,
                            <cfqueryparam value = #arguments.detailsStruct[item].totalQuantity# cfsqltype = "integer">,
                            <cfqueryparam value = "#arguments.detailsStruct[item].unitPrice#" cfsqltype = "decimal">,
                            <cfqueryparam value = "#arguments.detailsStruct[item].unitTax#" cfsqltype = "decimal">
                        )
                    </cfquery>
                    <cfset deleteCartItem(productId = arguments.detailsStruct[item].productId)>
                </cfif>
            </cfloop>
            <cfset local.jsonData['Result'] = true>
            <cfmail  from="jithinj3113@gmail.com" subject="Order Placed" to="jithinj403113@gmail.com" type = "html">
                Order placed successfully!
                <table  border="1" cellpadding="5" cellspacing="0">
                    <tr>
                        <th>Order Id</th>
                        <td>#local.generatedUUID#</td>
                    </tr>
                    <tr>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Tax</th>
                    </tr>
                    <cfloop collection="#arguments.detailsStruct#" item="item">
                        <cfif isStruct(arguments.detailsStruct[item])>
                            <tr>
                                <td>#arguments.detailsStruct[item].productName#</td>
                                <td> #arguments.detailsStruct[item].totalQuantity#</td>
                                <td>#arguments.detailsStruct[item].totalPrice#</td>
                                <td> #arguments.detailsStruct[item].totalTax#</td>
                            </tr>
                        </cfif>
                    </cfloop>
                    <tr>
                        <th>Total Amount</th>
                        <td> #local.payAmount#</td>
                    </tr>
                </table>
            </cfmail>
        <cfelse>
            <cfset local.jsonData['Result'] = false>
        </cfif>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction name = "getOrders" access = "public" returnType = "array">
        <cfargument name = "search" required = "false" type = "string">
        <cfquery name = "local.orders" datasource = #application.dataSource#>
            SELECT
                O.fldOrder_ID,
                O.fldTotalPrice,
                O.fldTotalTax,
                DATE_FORMAT(O.fldOrderDate, '%d-%m-%Y %H:%i:%s') AS datetime,
                A.fldAddress_Id,
                A.fldFirstName,
                A.fldlastname,
                A.fldAddressLine1,
                A.fldAddressLine2,
                A.fldCity,
                A.fldState,
                A.fldPincode,
                A.fldPhoneNumber
            FROM
                tblOrders O
            INNER JOIN
                tblAddress A ON O.fldAddressId = A.fldAddress_ID
            WHERE 
                O.fldUserId =  <cfqueryparam value = "#session.userId#" cfsqltype = "integer">
                <cfif structKeyExists(arguments, 'search')>
                    AND O.fldOrder_ID =<cfqueryparam value = "#arguments.search#" cfsqltype = "varchar">
                </cfif>
            ORDER BY 
                O.fldOrderDate DESC
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query = "local.orders">
            <cfset local.jsonData = {}>
            <cfset local.jsonData['orderId'] = local.orders.fldOrder_ID>
            <cfset local.jsonData['totalPrice'] = local.orders.fldTotalPrice>
            <cfset local.jsonData['totalTax'] = local.orders.fldTotalTax>
            <cfset local.jsonData['orderDate'] = local.orders.datetime>
            <cfset local.jsonData['addressId'] = local.orders.fldAddress_Id>
            <cfset local.jsonData['firstName'] = local.orders.fldFirstName>
            <cfset local.jsonData['lastName'] = local.orders.fldlastname>
            <cfset local.jsonData['address1'] = local.orders.fldAddressLine1>
            <cfset local.jsonData['address2'] = local.orders.fldAddressLine2>
            <cfset local.jsonData['city'] = local.orders.fldCity>
            <cfset local.jsonData['state'] = local.orders.fldState>
            <cfset local.jsonData['pincode'] = local.orders.fldPincode>
            <cfset local.jsonData['phone'] = local.orders.fldPhoneNumber>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
        </cfloop>
        <cfreturn local.dataArray>
    </cffunction>

    <cffunction name = "getOrderItems" access = "public" returnType = "array">
        <cfargument name = "orderId" required = "true" type = "string">
        <cfquery name = "local.getItems" datasource = #application.dataSource#>
            SELECT
                OI.fldQuantity,
                OI.fldUnitPrice,
                OI.fldUnitTax,
                P.fldProductName,
                I.fldImageFileName,
                B.fldBrandName
            FROM
                tblorderItems OI
            INNER JOIN
                tblProducts P ON P.fldProduct_ID = OI.fldProductId
            INNER JOIN
                tblProductImages I ON I.fldProductId = P.fldProduct_ID
            INNER JOIN
                tblBrand B ON B.fldBrand_ID = P.fldBrandId
            WHERE 
                OI.fldOrderId = <cfqueryparam value = "#arguments.orderId#" cfsqltype = "varchar">
                AND I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query = "local.getItems">
            <cfset local.jsonData = {}>
            <cfset local.jsonData['quantity'] = local.getItems.fldQuantity>
            <cfset local.jsonData['unitPrice'] = local.getItems.fldUnitPrice>
            <cfset local.jsonData['unitTax'] = local.getItems.fldUnitTax>
            <cfset local.jsonData['productName'] = local.getItems.fldProductName>
            <cfset local.jsonData['fileName'] = local.getItems.fldImageFileName>
            <cfset local.jsonData['brandName'] = local.getItems.fldBrandName>
            <cfset arrayAppend(local.dataArray, local.jsonData)>
        </cfloop>
        <cfreturn local.dataArray>
    </cffunction>

    <cffunction name = "getPdf" returnType = "string" access = "remote" returnFormat="json"> 
        <cfargument name="orderId" default = 1 required = "true">
        <cfset local.pdf = getOrderItems(orderId = arguments.orderId)>
        <cfset local.address = getOrders(search = arguments.orderId)>
        <cfset local.address = local.address[1]>
        <cfset local.nameDate = "#arguments.orderId#.pdf">
        <cfset local.count = 1>
        <cfset local.totalAmount = 0>
        <cfoutput>
            <cfdocument format = "pdf"
                filename = "../Assets/Pdfs/#local.nameDate#" 
                overwrite = "true"
                bookmark = "no" 
                orientation = "landscape"
                localUrl = "yes"> 
                <style>
                    table, th, td {
                        padding:10px 20px;
                        border-collapse: collapse;
                        text-align: left;
                    }
                    .headSpan{
                        font-size:18px;
                        font-weight: bold;
                        margin-left:400px;
                    }
                </style>
                <cfoutput>
                    <div class = "pdfDiv">
                        <div class="pdfAddressDiv">
                            Shipping Address : <br><br>
                            <span>
                                #local.address.firstName# #local.address.lastName# <br>
                                #local.address.address1#, #local.address.address2#<br>
                                #local.address.city#, #local.address.state#<br>
                                #local.address.pincode#<br>
                                #local.address.phone#  
                            </span>
                        <div><br>
                        Order ID : #arguments.orderId#<br>
                        Order Date :  #local.address.orderDate#
                    <div>
                </cfoutput>
                <table>
                    <tr>
                        <th>Si.No</th>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Tax</th>
                        <th>Total</th>
                    </tr>
                    <cfloop array = "#local.pdf#" item = "item">
                        <cfset local.totalAmount += item.quantity*(item.unitTax + item.unitPrice)>
                        <tr>
                            <td>#local.count#</td>
                            <td>#item.productName#</td>
                            <td>#item.quantity#</td>
                            <td>#item.unitPrice#</td>
                            <td>#item.unitTax#</td>
                            <td>#item.quantity*(item.unitTax + item.unitPrice)#</td>
                        </tr>
                        <cfset local.count += 1>
                    </cfloop>
                    <tr>
                        <th>Total:</th>
                        <td>#local.totalAmount#</td>
                    </tr>
                </table>
            </cfdocument>
        </cfoutput>
        <cfreturn local.nameDate>
    </cffunction>

    <cffunction name = "addressDelete" access = "remote" returnType = "boolean" returnFormat = "json">
        <cfargument name = "addressId" required = "true" default = 1>
        <cfquery name = "local.deleteAddress" datasource = #application.dataSource#>
            UPDATE
                tblAddress
            SET
                fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
                fldDeactivatedDate =  <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
            WHERE
                fldAddress_ID = <cfqueryparam value = "#arguments.addressId#" cfsqltype = "integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

</cfcomponent>


