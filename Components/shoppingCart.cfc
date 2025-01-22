<cfcomponent>

    <cffunction  name = "userSignUp" returnType = "any" access = "public">
        <cfargument  name = "firstName" required = "true" type = "string">
        <cfargument  name = "lastName" required = "true" type = "string">
        <cfargument  name = "userName" required = "true" type = "string">
        <cfargument  name = "userPhone" required = "true" type = "string">
        <cfargument  name = "password" required = "true" type = "string">
        <cfargument  name = "confirmPassword" required = "true" type = "string">

        <cfquery name = "local.selectUser" datasource = "cartDatasource">
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
            <cfreturn false>
        <cfelse>
            <cfset local.secretKey = generateSecretKey('AES')>
            <cfset local.hashedPassword = Hash(arguments.password & local.secretKey,"SHA-256")>
            <cfquery name="insertUser" datasource = "cartDatasource">
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
                    < cfqueryparam value = '#arguments.firstName#' cfsqltype = "varchar" >,
                    < cfqueryparam value = '#arguments.lastName#' cfsqltype = "varchar" >,
                    < cfqueryparam value = '#arguments.userName#' cfsqltype = "varchar" >,
                    < cfqueryparam value = '#arguments.userPhone#' cfsqltype = "varchar" >,
                    < cfqueryparam value = 2 cfsqltype = "integer" >,
                    < cfqueryparam value = '#local.hashedPassword#' cfsqltype = "varchar" >,
                    < cfqueryparam value = '#local.secretKey#' cfsqltype = "varchar" >
                )
            </cfquery>
        </cfif>
        <cfreturn true>
    </cffunction>

    <cffunction name = "userLogin" returnType = "struct" access = "public">
        <cfargument  name = "userName" required = "true" type = "string">
        <cfargument  name = "password" required = "true" type = "string">
        <cfset local.result = {}>
        <cfif NOT trim(len(arguments.userName))>
            <cfset local.result['Email'] = "UserName Required">
        <cfelseif  NOT(isValid("email", arguments.userName)) AND NOT(REFind("^\d{10}$", arguments.userName))> 
            <cfset local.result['Email'] = "UserName must be valid Email/Mobile">
        </cfif>
        <cfif NOT trim(len(arguments.password))>
            <cfset local.result['Password'] = "Password Required">
        </cfif>
        <cfif structCount(local.result)>
            <cfreturn local.result> 
        <cfelse>
            <cfquery name = "local.selectUser" datasource = "cartDatasource">
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
                    <cfset session.userName = local.selectUser.fldFirstName & local.selectUser.fldLastName>
                    <cfset session.role = local.selectUser.fldRoleName> 
                    <cfset session.userId = local.selectUser.fldUser_ID>
                    <cfset session.roleId = local.selectUser.fldRole_ID>
                    <cfset session.login = true>
                <cfelse>
                    <cfset local.result['User'] = "Invalid UserName/Password">
                </cfif>
            <cfelse>
                <cfset local.result['User'] = "Account does not exist">
            </cfif>
            <cfreturn local.result>
        </cfif>
    </cffunction>

    <cffunction name = "addCategory" returnType = "struct" access="public">
        <cfargument  name = "categoryName" required = "true" type = "string">
        <cfset local.result = {}>
        <cfif NOT len(arguments.categoryName)>
            <cfset local.result["Error"] = "Category Name Required">
            <cfreturn local.result> 
        </cfif>
        <cfquery name = "local.selectCategory" datasource = "cartDatasource">
            SELECT 1 
            FROM tblCategory
            WHERE 
                fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar" >
                AND fldActive = < cfqueryparam value = 1 cfsqltype = "varchar" >
        </cfquery> 
        <cfif queryRecordCount(local.selectCategory)>
            <cfset local.result["Error"] = "Category Name Already Exist">
        <cfelse>
            <cfquery name = "local.insertCategory" datasource = "cartDatasource">
                INSERT INTO tblCategory
                    (
                        fldCategoryName,
                        fldCreatedBy
                    )
                VALUES(
                    < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar" >,
                    < cfqueryparam value = '#session.userId#' cfsqltype = "integer" >
                )
            </cfquery>
            <cfset local.result["Success"] = "Success:Category Name Added">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name = "editCategory" returnType = "struct" returnFormat = "JSON" access="remote">
        <cfargument  name = "editId" required = "true" type = "integer">
        <cfquery name = "local.selectCategory" datasource = "cartDatasource">
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM tblCategory
            WHERE 
                fldCategory_ID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "varchar" >
        </cfquery>
        <cfset local.jsonData = QueryGetRow(local.selectCategory,1)>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction  name = "displayCategory" returnType = "query">
        <cfargument  name = "categoryId" default = "">
        <cfquery name = "local.selectCategory" datasource = "cartDatasource">
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM 
                tblCategory
            WHERE
                <cfif trim(len(arguments.categoryId))> 
                        fldCategory_ID = < cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer" > 
                        AND fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
                <cfelse>
                    fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
                </cfif>
        </cfquery>
        <cfreturn local.selectCategory>
    </cffunction>

    <cffunction  name = "viewCategory" access = "remote" returnformat = "json" returnType = "array">
        <cfargument  name="homeView" default="">
        <cfquery name = "local.selectCategory" datasource = "cartDatasource">
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM tblCategory
            WHERE
                fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
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

    <cffunction  name = "updateCategory" returnType = "struct">
        <cfargument  name = "editId" required = "true" type = "integer">
        <cfargument  name = "categoryName" required = "true" type = "string">
        <cfset local.result = {}>
        <cfif NOT len(arguments.categoryName)>
            <cfset local.result["Error"] = "Category Name Required">
            <cfreturn local.result> 
        </cfif>
        <cfquery name="local.selectCategory" datasource = "cartDatasource">
            SELECT 1 
            FROM tblCategory
            WHERE 
                fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar" >
                AND fldActive = < cfqueryparam value = 1 cfsqltype = "varchar" >
        </cfquery> 
        <cfif queryRecordCount(local.selectCategory)>
            <cfset local.result["Error"] = "Category Name Already Exist">
        <cfelse>
            <cfquery name="local.categoryUpadte" datasource = "cartDatasource">
                UPDATE 
                    tblCategory
                SET
                    fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar" >,
                    fldUpdatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "integer" >
                WHERE
                    fldCategory_ID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "integer" >
            </cfquery>
            <cfset local.result["Success"] = "Category Name Updated">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name = "insertSubcategory" access = "remote" returnFormat = "json" returnType = "struct">
        <cfargument  name = "subCategoryName" required = "true" type = "string">
        <cfargument  name = "categoryId" required = "true" type = "integer">
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
            <cfquery name = "local.fetchSubcategory" datasource = "cartDatasource">
                SELECT 
                    fldSubCategoryName,
                    fldSubcategory_ID,
                    fldCategoryId
                FROM 
                    tblSubcategory
                WHERE
                    fldSubCategoryName = < cfqueryparam value = '#arguments.subCategoryName #' cfsqltype = "varchar" >
                    AND fldCategoryId = < cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer" >
            </cfquery>
            <cfif queryRecordCount(local.fetchSubcategory)>
                <cfset local.result["addSubMessage"] = "Subcategory Name Already Exist">
            <cfelse>
                <cfquery name="local.insertSubcategory" datasource = "cartDatasource">
                    INSERT INTO tblSubcategory
                        (
                            fldSubcategoryName,
                            fldCategoryId,
                            fldCreatedBy
                        )
                    VALUES(
                        < cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "varchar" >,
                        < cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer" >,
                        < cfqueryparam value = '#session.userId#' cfsqltype = "integer" >
                    )
                </cfquery>
                <cfset local.result["addSubMessage"] = "Success:Subcategory Name Added">
            </cfif>
            <cfreturn local.result>
        </cfif>
    </cffunction>

    <cffunction  name="updateSubcategory" access = "remote" returnFormat = "json" returnType = "any">
        <cfargument  name="subCategoryId" required="true" type="integer">
        <cfargument  name = "categoryID" required = "true" type = "integer">
        <cfargument  name = "subCategoryName" required = "true" type = "string">
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
            <cfquery name = "local.fetchSubcategory" datasource = "cartDatasource">
                SELECT 
                    fldSubCategoryName,
                    fldSubcategory_ID,
                    fldCategoryId
                FROM 
                    tblSubcategory
                WHERE
                    fldSubCategoryName = < cfqueryparam value = '#arguments.subCategoryName #' cfsqltype = "varchar" >
                    AND fldCategoryId = < cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer" >
                    AND NOT fldSubcategory_ID = < cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer" >
            </cfquery>
            <cfif queryRecordCount(local.fetchSubcategory)>
                <cfset local.result["addSubMessage"] = "Subcategory Already Exist">
            <cfelse>
                <cfquery name = "local.updateSubcategory" datasource = "cartDatasource">
                    UPDATE tblSubcategory
                    SET
                        fldSubcategoryName = < cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "varchar" >,
                        fldCategoryId = < cfqueryparam value = '#arguments.categoryID#' cfsqltype = "integer" >,
                        fldUpdatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "integer" >
                    WHERE
                        fldSubcategory_ID = < cfqueryparam value = '#arguments.subCategoryID#' cfsqltype = "integer" >
                </cfquery>
                <cfset local.result["addSubMessage"] = "Success:Subcategory Updated">
            </cfif>
            <cfreturn local.result>
        </cfif>
    </cffunction>

    <cffunction  name = "viewSubcategory" returnType = "array" access = "remote" returnFormat = "json">
        <cfargument  name = "categoryId" required = "true" type = "integer">
        <cfquery name = "local.fetchSubcategory" datasource = "cartDatasource">
            SELECT
                fldSubcategoryName,
                fldSubcategory_ID
            FROM
                tblSubcategory
            WHERE
                fldCategoryId = < cfqueryparam value = '#arguments.categoryID#' cfsqltype = "integer" > 
                AND fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
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

    <cffunction  name = "viewSubcategoryEdit" returnType = "array" access = "remote" returnFormat = "json">
        <cfargument  name = "subCategoryId" required = "true" type = "integer">
        <cfquery name = "local.fetchSubcategory" datasource = "cartDatasource">
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
                fldSubcategory_ID = < cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "integer" >
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

    <cffunction  name = "deleteRow" returnType = "boolean" access = "remote">
        <cfargument  name = "tableName" required = "true" type = "string">
        <cfargument  name = "deleteId" required = "true" type = "integer">
        <cfif arguments.tableName EQ 'tblCategory'>
            <cfset local.columnName = 'fldCategory_ID'>
        <cfelseif arguments.tableName EQ 'tblProducts'>
            <cfset local.columnName = 'fldProduct_ID'>
        <cfelseif arguments.tableName EQ 'tblProductImages'>
            <cfset local.columnName = 'fldProductImage_ID'>
        <cfelse>
            <cfset local.columnName = 'fldSubcategory_ID'>
        </cfif>
        <cfquery name = "local.deleteData" datasource = "cartDatasource">
            UPDATE  
                #arguments.tablename#
            SET
                fldActive = < cfqueryparam value = 0 cfsqltype = "integer" >,
            <cfif arguments.tableName EQ 'tblProductImages'>
                fldDeactivatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "integer" >
            <cfelse>
                fldUpdatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "integer" >
            </cfif>
            WHERE
                #local.columnName# = < cfqueryparam value = '#arguments.deleteId#' cfsqltype = "integer" >
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name = "userLogout" returnType = "boolean" access = "remote">
        <cfset structClear(session)>
        <cfreturn true>
 </cffunction>

    <cffunction  name = "insertProduct" returnType = "struct"  access = "remote" returnFormat = "json">

        <cfargument  name = "addProductCategorySelect" required = "true" type = "integer">
        <cfargument  name = "addProductSubcategorySelect" required = "true" type = "integer">
        <cfargument  name = "addProductNameInput" required = "true" type = "string">
        <cfargument  name = "addProductBrandInput" required = "true" type = "integer">
        <cfargument  name = "addProductDescription" required = "true" type = "string">
        <cfargument  name = "addProductPrice" required = "true" type = "numeric">
        <cfargument  name = "addProductTax" required = "true" type = "numeric">
        <cfargument  name = "addProductImage" required = "true" type = "any">
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
            <cfquery name = "local.fetchContacts" datasource = "cartDatasource">
                SELECT 1 
                FROM tblProducts
                WHERE
                    fldProductName = < cfqueryparam value = "#arguments.addProductNameInput#" cfsqltype = "varchar" >
                    AND fldSubcategoryId = < cfqueryparam value = "#arguments.addProductSubcategorySelect#" cfsqltype = "varchar" >
            </cfquery>
            <cfif queryRecordCount(local.fetchContacts)>
                <cfset local.result["insertError"] = "Failed:Product Already Exist">
            <cfelse>
                <cfset local.uploadPath = expandPath('../Assets/uploadImages')>
                <cffile  action = "uploadAll" destination = "#local.uploadPath#" nameConflict = "MakeUnique" result = "local.imagePathArray"> 

                <cfquery name = "local.insertProduct" result = "local.productInsert" datasource = "cartDatasource">
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
                        < cfqueryparam value = '#arguments.addProductSubcategorySelect#' cfsqltype = "integer" >,
                        < cfqueryparam value = '#arguments.addProductNameInput#' cfsqltype = "varchar" >,
                        < cfqueryparam value = '#arguments.addProductBrandInput#' cfsqltype = "integer" >,
                        < cfqueryparam value = '#arguments.addProductDescription#' cfsqltype = "varchar" >,
                        < cfqueryparam value = '#arguments.addProductPrice#' cfsqltype = "decimal" >,
                        < cfqueryparam value = '#arguments.addProductTax#' cfsqltype = "decimal" >,
                        < cfqueryparam value = '#session.userId#' cfsqltype = "integer" >
                    )
                </cfquery>
                <cfset local.generatedKey = local.productInsert.generatedKey>
                <cfquery name="local.insertImages" datasource = "cartDatasource">
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
                                < cfqueryparam value = '#local.generatedKey#' cfsqltype = "integer" >,
                                < cfqueryparam value = '#item.serverFile#' cfsqltype = "varchar" >,
                                <cfif i EQ 1>
                                    < cfqueryparam value = 1 cfsqltype = "integer" >,
                                <cfelse>
                                    < cfqueryparam value = 0 cfsqltype = "integer" >,
                                </cfif>
                                < cfqueryparam value = '#session.userId#' cfsqltype = "integer" >
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

    <cffunction  name = "SubcategoryDisplay" returnType = "any" access = "remote" returnFormat = "json">
        <cfset local.jsonData = {}>
        <cfquery name = "local.fetchSubcategory" datasource = "cartDatasource">
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

    <cffunction  name = "viewBrand" returnType = "array" access = "remote" returnFormat = "json">
        <cfquery name = "local.selectBrand" datasource = "cartDatasource">
            SELECT
                fldBrandName,
                fldBrand_ID
            FROM
                tblBrand
            WHERE
                fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
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

    
    <cffunction  name = "updateProduct" access = "remote" returnType = "struct" returnFormat = "json">

        <cfargument  name = "addProductCategorySelect" required = "true" type = "integer">
        <cfargument  name = "addProductSubcategorySelect" required = "true" type = "integer">
        <cfargument  name = "addProductNameInput" required = "true" type = "string">
        <cfargument  name = "addProductBrandInput" required="true" type = "integer">
        <cfargument  name = "addProductDescription" required="true" type = "string">
        <cfargument  name = "addProductPrice" required = "true" type = "numeric">
        <cfargument  name = "addProductTax" required = "true" type = "numeric">
        <cfargument  name = "productId" required = "true" type = "integer">

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
            <cfquery name = "local.fetchContacts" datasource = "cartDatasource">
                SELECT 1 
                FROM tblProducts
                WHERE
                    fldProductName = < cfqueryparam value = "#arguments.addProductNameInput#" cfsqltype = "varchar" >
                    AND fldSubcategoryId = < cfqueryparam value = "#arguments.addProductSubcategorySelect#" cfsqltype = "varchar" >
                    AND NOT fldProduct_ID = < cfqueryparam value = "#arguments.productId#" cfsqltype = "varchar" > 
            </cfquery>
            <cfif queryRecordCount(local.fetchContacts)>
                <cfset local.result["insertError"] = "Failed:Product Already Exist">
            <cfelse>
                <cfquery name = "local.updatePoduct" datasource = "cartDatasource">
                    UPDATE 
                        tblProducts
                    SET
                        fldSubcategoryid = < cfqueryparam value = "#arguments.addProductSubcategorySelect#" cfsqltype = "integer" >,
                        fldProductName = < cfqueryparam value = "#arguments.addProductNameInput#" cfsqltype = "varchar" >,
                        fldBrandId = < cfqueryparam value = "#arguments.addProductBrandInput#" cfsqltype = "integer" >,
                        fldDescription = < cfqueryparam value = "#arguments.addProductDescription#" cfsqltype = "varchar" >,
                        fldPrice = < cfqueryparam value = "#arguments.addProductPrice#" cfsqltype = "decimal" >,
                        fldTax = < cfqueryparam value = "#arguments.addProductTax#" cfsqltype = "decimal" >,
                        fldUpdatedBy = < cfqueryparam value = "#session.userId#" cfsqltype = "integer" >
                    WHERE
                        fldProduct_ID=< cfqueryparam value = "#arguments.productId#" cfsqltype = "integer" >
                </cfquery>
                <cfset local.result["insertError"] = "Success:Product Uploaded">
            </cfif>
            <cfreturn local.result>
        </cfif>
    </cffunction>

    <cffunction  name = "viewImages" access = "remote"  returnType="array" returnFormat = "json">
        <cfargument  name = "productId" required = "true" type = "integer">
        <cfquery name = "local.fetchImages" datasource = "cartDatasource">
            SELECT 
                fldProductImage_ID,
                fldImageFileName,
                fldProductId,
                fldDefaultImage
            FROM
                tblProductImages
            WHERE
                fldProductId = < cfqueryparam value = "#arguments.productId#" cfsqltype = "integer" >
                AND fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
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


    <cffunction  name = "setThumbnail" access = "remote" returnType = "boolean">
        <cfargument  name = "ImageId" required = "true" type = "integer">
        <cfargument  name = "productId" required = "true" type = "integer">
        <cfquery name = "local.updateImages" datasource = "cartDatasource">
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = < cfqueryparam value = 0 cfsqltype = "integer" >
            WHERE
                fldProductId = < cfqueryparam value = "#arguments.productId#" cfsqltype = "integer" >
                AND
                fldDefaultImage = < cfqueryparam value = 1 cfsqltype = "integer" >
        </cfquery>
         <cfquery name = "local.setDefaultImage" datasource = "cartDatasource">
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = < cfqueryparam value = 1 cfsqltype = "integer" >
            WHERE
                fldProductImage_ID = < cfqueryparam value = "#arguments.ImageId#" cfsqltype = "integer" >
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="viewProducts" returnType = "array" returnFormat = "json" access = "remote">
        <cfargument  name = "columnName" required = "true" type = "string">
        <cfargument  name = "productSubId" required = "true" type = "integer">
        <cfquery name = "local.viewProduct" datasource = "cartDatasource">
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
            RIGHT JOIN
                tblProducts P ON B.fldBrand_ID = P.fldBrandId
            RIGHT JOIN
                tblProductImages I ON P.fldProduct_ID = I.fldProductId
            RIGHT JOIN
                tblSubcategory S ON S.fldSubcategory_ID = P.fldSubcategoryId
            RIGHT JOIN
                tblCategory C ON C.fldCategory_ID = S.fldCategoryId
            WHERE
                P.fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
                AND I.fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
                AND B.fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
                AND S.fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
                AND C.fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
                AND I.fldDefaultImage = < cfqueryparam value = 1 cfsqltype = "integer" >
                AND P.#arguments.columnName# = < cfqueryparam value ="#arguments.productSubId#" cfsqltype = "integer" >
        </cfquery>
        <cfset local.dataArray = []>
        <cfloop query="local.viewProduct">
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

    <cffunction  name = "randomProducts" returnType = "array">
        <cfargument  name = "subCategoryId" type = "any" default = 0 required = "false">
        <cfargument  name = "sortBy" type = "string" default = "noSort" required = "false">
        <cfargument  name = "min" type = "string" default = 0 required = "false">
        <cfargument  name = "max" type = "string" default = 0 required = "false">
        <cfargument  name = "search" type = "string" default = "" required = "false">
        <cfquery name = "local.fetchProducts" datasource = "cartDatasource">
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
                    P.fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
                    AND I.fldDefaultImage = < cfqueryparam value = 1 cfsqltype = "integer" >
                </cfif>
                <cfif arguments.subCategoryId NEQ 0>
                    AND P.fldSubcategoryId = < cfqueryparam value ="#arguments.subCategoryId#" cfsqltype = "integer" > 
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
                AND P.fldPrice >= < cfqueryparam value ="#arguments.min#" cfsqltype = "varchar" >
                <cfif NOT Find("+", arguments.max)>
                    AND P.fldPrice <= < cfqueryparam value ="#arguments.max#" cfsqltype = "varchar" >
                </cfif>
            <cfelseif arguments.search NEQ "">
                I.fldDefaultImage = < cfqueryparam value = 1 cfsqltype = "integer" >
                AND (
                P.fldProductName LIKE < cfqueryparam value = "%#arguments.search#%" cfsqltype = "varchar" >
                OR P.fldDescription LIKE < cfqueryparam value = "%#arguments.search#%" cfsqltype = "varchar" >
                OR S.fldSubcategoryName = < cfqueryparam value = #arguments.search# cfsqltype = "varchar" >
                )
                AND P.fldActive = < cfqueryparam value = 1 cfsqltype = "integer" >
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

    <cffunction  name = "displayProduct" returnType = "struct" returnFormat = "json" access = "remote">
        <cfargument  name = "productId" type = "integer" required = "true">
        <cfquery name = "local.fetchProduct" datasource = "cartDatasource">
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
                P.fldProduct_ID = < cfqueryparam value ="#arguments.productId#" cfsqltype = "integer" >
                AND I.fldDefaultImage = < cfqueryparam value =1 cfsqltype = "integer" >
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

    <cffunction  name = "subcategoryListing" returnType = "array" access = "public">
        <cfargument  name = "categoryId" required = "true" type = "integer">
        <cfquery name = "local.fetchSubcategory" datasource = "cartDatasource">
            SELECT
                fldSubCategoryName,
                fldSubcategory_ID
            FROM
                tblSubcategory
            WHERE
                fldCategoryId = < cfqueryparam value ="#arguments.categoryId#" cfsqltype = "integer" >
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

</cfcomponent>


