<cfcomponent>

    <cffunction name="userLogin" returnType="any">
        <cfargument  name="userName">
        <cfargument  name="password" required="true">
        <cfset local.result = true>
        <cfquery name="local.selectUser">
            SELECT
                u.fldUser_ID,
                u.fldFirstName,
                u.fldLastName,
                u.fldEmail,
                u.fldPhoneNumber,
                u.fldHashedPassword,
                u.fldUserSaltString,
                u.fldUserRoleID,
                r.fldRoleName
            FROM 
                tblUser u
            LEFT JOIN 
                tblRole r
            ON
                u.fldUserRoleID = r.fldRole_ID
            WHERE
                fldEmail = <cfqueryparam value = '#arguments.userName#' cfsqltype = 'cf_sql_varchar'> OR
                fldPhoneNumber = <cfqueryparam value = '#arguments.userName#' cfsqltype = 'cf_sql_varchar'> 
        </cfquery>
        <cfif queryRecordCount(local.selectUser)>
            <cfif (local.selectUser.fldHashedPassword EQ Hash(arguments.password & local.selectUser.fldUserSaltString,"SHA-256"))>
                <cfset session.userName = selectUser.fldFirstName & selectUser.fldLastName>
                <cfset session.role = selectUser.fldRoleName> 
                <cfset session.userId = selectUser.fldUser_ID>
                <cfset session.login = true>
                <cfreturn local.result>
            <cfelse>
                <cfset local.result = "Invalid UserName/Password">
            </cfif>
        <cfelse>
            <cfset local.result = "User Not Exist">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="addCategory" returnType="string">
        <cfargument  name="categoryName" required="true">
        <cfset local.result = "">
        <cfquery name="local.selectCategory">
            SELECT 1 
            FROM tblCategory
            WHERE 
                fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "cf_sql_varchar" >
        </cfquery> 
        <cfif queryRecordCount(local.selectCategory)>
            <cfset local.result = "Error:Category Name Already Exist">
        <cfelse>
            <cfquery name="local.insertCategory">
                INSERT INTO tblCategory
                    (
                        fldCategoryName,
                        fldCreatedBy
                    )
                VALUES(
                    < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
                )
            </cfquery>
            <cfset local.result = "Success:Category Name Added">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="editCategory" returnType = "struct" returnFormat = "JSON" access="remote">
        <cfargument  name="editId" required="true">
        <cfquery name="local.selectCategory">
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM tblCategory
            WHERE 
                fldCategory_ID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfset local.jsonData = QueryGetRow(local.selectCategory,1)>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction  name="displayCategory">
        <cfargument  name="categoryName" default="">
        <cfquery name="local.selectCategory">
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM tblCategory
            WHERE
                <cfif trim(len(arguments.categoryName))> 
                        fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "cf_sql_varchar" > AND
                        fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
                <cfelse>
                    fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
                </cfif>
        </cfquery>
        <cfreturn local.selectCategory>
    </cffunction>

    <cffunction  name="viewCategory" access="remote" returnformat="json" returnType="any">
        <cfargument  name="categoryName" default="">
        <cfset local.jsonData = {}>
        <cfquery name="local.selectCategory">
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM tblCategory
            WHERE
                fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfset local.jsonData = SerializeJSON(local.selectCategory)>
        <cfreturn local.jsonData>
    </cffunction>


    <cffunction  name="updateCategory">
        <cfargument  name="editId">
        <cfargument  name="categoryName">
        <cfset local.result = "">
        <cfquery name="local.selectCategory">
            SELECT 1 
            FROM tblCategory
            WHERE 
                fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "cf_sql_varchar" >
        </cfquery> 
        <cfif queryRecordCount(local.selectCategory)>
            <cfset local.result = "Error:Category Name Already Exist">
        <cfelse>
            <cfquery name="local.categoryUpadte">
                UPDATE 
                    tblCategory
                SET
                    fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "cf_sql_varchar" >,
                    fldUpdatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
                WHERE
                    fldCategory_ID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_integer" >
            </cfquery>
             <cfset local.result = "Success:Category Name Updated">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="insertSubcategory" access="remote" returnFormat="json">
        <cfargument  name="subCategoryName">
        <cfargument  name="categoryName">
        <cfargument  name="categoryID">
        <cfset local.subCategoryID = ''>
        <cfif Find(',', arguments.categoryID) GT 0>
            <cfset local.idArray = listToArray(arguments.categoryID)>
            <cfset local.subCategoryID = local.idArray[2]>
        </cfif>
        <cfset local.result = "">
        <cfquery name="local.fetchSubcategory">
            SELECT 
                S.fldSubCategoryName,
                S.fldSubcategory_ID,
                S.fldCategoryId,
                C.fldCategoryName,
                C.fldCategory_ID
            FROM 
                tblSubcategory S
            LEFT JOIN
                tblCategory C ON C.fldCategory_ID =  S.fldCategoryId
            WHERE
                <cfif len(local.subCategoryID) GT 0>
                    S.fldSubcategory_ID = < cfqueryparam value = '#local.subCategoryID #' cfsqltype = "cf_sql_integer" >
                <cfelse>
                    S.fldSubcategoryName = < cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "cf_sql_varchar" > AND
                    C.fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "cf_sql_varchar" >
                </cfif>
            GROUP BY 
                S.fldSubcategoryName,
                S.fldSubcategory_ID,
                S.fldCategoryId,
                C.fldCategoryName,
                C.fldCategory_ID
        </cfquery>

        <cfif len(local.subCategoryID) GT 0>
            <cfset local.category = displayCategory(categoryName = arguments.categoryName)>
            <cfquery name="local.updateSubcategory">
                    UPDATE tblSubcategory
                    SET
                        fldSubcategoryName = < cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "cf_sql_varchar" >,
                        fldCategoryId = < cfqueryparam value = '#local.category.fldCategory_ID#' cfsqltype = "cf_sql_integer" >,
                        fldUpdatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
                    WHERE
                        fldSubcategory_ID = < cfqueryparam value = '#local.fetchSubcategory.fldSubcategory_ID#' cfsqltype = "cf_sql_integer" >
                </cfquery>
                <cfset local.result = true>
        <cfelseif queryRecordCount(local.fetchSubcategory)>
            <cfset local.result = false>
        <cfelse>
            <cfset local.category = displayCategory(categoryName=arguments.categoryName)>
            <cfquery name="local.insertSubcategory">
                INSERT INTO tblSubcategory
                    (
                        fldSubcategoryName,
                        fldCategoryId,
                        fldCreatedBy
                    )
                VALUES(
                    < cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#local.category.fldCategory_ID#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
                )
            </cfquery>
            <cfset local.result = true>
        </cfif>
        <cfreturn local.result>
    </cffunction>
 
 
    <cffunction  name="viewSubcategory" returnType = "any" access="remote" returnFormat="json">
        <cfargument  name="categoryId">
        <cfset local.jsonData = {}>
        <cfquery name="local.fetchSubcategory">
            SELECT
                fldSubcategoryName,
                fldSubcategory_ID
            FROM
                tblSubcategory
            WHERE
                fldCategoryId = < cfqueryparam value = '#arguments.categoryID#' cfsqltype = "cf_sql_integer" > AND
                fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfset local.jsonData = SerializeJSON(local.fetchSubcategory)>
        <cfreturn local.jsonData >
    </cffunction>

    <cffunction  name="viewSubcategoryEdit" returnType = "any" access="remote" returnFormat="json">
        <cfargument  name="subCategoryId">
        <cfset local.jsonData = {}>
        <cfquery name="local.fetchSubcategory">
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
                fldSubcategory_ID = < cfqueryparam value = '#arguments.subCategoryId#' cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfset local.jsonData = SerializeJSON(local.fetchSubcategory)>
        <cfreturn local.jsonData >
    </cffunction>

    <cffunction  name="viewSubcategories" returnType = "any" access="remote" returnFormat="json">
    <cfargument  name="categoryId">
        <cfset local.jsonData = {}>
        <cfquery name="local.fetchSubcategory">
            SELECT
                fldSubcategoryName,
                fldSubcategory_ID
            FROM
                tblSubcategory
            WHERE
                fldCategoryId = < cfqueryparam value = '#arguments.categoryId#' cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfset local.jsonData = SerializeJSON(local.fetchSubcategory)>
        <cfreturn local.jsonData >
    </cffunction>

    <cffunction  name = "deleteRow" returnType = "boolean" access = "remote">
        <cfargument  name="tableName">
        <cfargument  name="deleteId">
        <cfif arguments.tableName EQ 'tblCategory'>
            <cfset local.columnName = 'fldCategory_ID'>
        <cfelseif arguments.tableName EQ 'tblProducts'>
            <cfset local.columnName = 'fldProduct_ID'>
        <cfelseif arguments.tableName EQ 'tblProductImages'>
            <cfset local.columnName = 'fldProductImage_ID'>
        <cfelse>
            <cfset local.columnName = 'fldSubcategory_ID'>
        </cfif>
        <cfquery name="local.deleteData">
            UPDATE  
                #arguments.tablename#
            SET
                fldActive = < cfqueryparam value = 0 cfsqltype = "cf_sql_integer" >,
            <cfif arguments.tableName EQ 'tblProductImages'>
                fldDeactivatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
            <cfelse>
                fldUpdatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
            </cfif>
            WHERE
                #local.columnName# = < cfqueryparam value = '#arguments.deleteId#' cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="userLogout" returnType="boolean" access="remote">
        <cfset structClear(session)>
        <cflocation  url="adminLogin.cfm">
    </cffunction>

    <cffunction  name="insertProduct" returnType="any"  access="remote" returnFormat="json">
        <cfargument  name="addProductCategorySelect">
        <cfargument  name="addProductSubcategorySelect">
        <cfargument  name="addProductNameInput">
        <cfargument  name="addProductBrandInput">
        <cfargument  name="addProductDescription">
        <cfargument  name="addProductPrice">
        <cfargument  name="addProductTax">
        <cfargument  name="addProductImage">

        <cfset local.result = "">

        <cfquery name="local.fetchContacts">
            SELECT 1 
            FROM tblProducts
            WHERE
                 fldProductName = < cfqueryparam value ="#arguments.addProductNameInput#" cfsqltype = "cf_sql_varchar" > AND
                 fldSubcategoryId = < cfqueryparam value ="#arguments.addProductSubcategorySelect#" cfsqltype = "cf_sql_varchar" >
        </cfquery>
        <cfif queryRecordCount(local.fetchContacts)>
            <cfset local.result = "Failed:Product Already Exist">
        <cfelse>
            <cfset local.uploadPath = expandPath('../Assets/uploadImages')>
            <cffile  action="uploadAll" destination="#local.uploadPath#" nameConflict="MakeUnique" result="local.imagePathArray"> 

            <cfquery name="local.insertProduct" result="local.productInsert">
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
                    < cfqueryparam value = '#arguments.addProductSubcategorySelect#' cfsqltype = "cf_sql_integer" >,
                    < cfqueryparam value = '#arguments.addProductNameInput#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.addProductBrandInput#' cfsqltype = "cf_sql_integer" >,
                    < cfqueryparam value = '#arguments.addProductDescription#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.addProductPrice#' cfsqltype = "cf_sql_decimal" >,
                    < cfqueryparam value = '#arguments.addProductTax#' cfsqltype = "cf_sql_decimal" >,
                    < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
                )
            </cfquery>
            <cfset local.generatedKey = local.productInsert.generatedKey>
            <cfquery name="local.insertImages">
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
                            < cfqueryparam value = '#local.generatedKey#' cfsqltype = "cf_sql_integer" >,
                            < cfqueryparam value = '#item.serverFile#' cfsqltype = "cf_sql_varchar" >,
                            <cfif i EQ 1>
                                < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >,
                            <cfelse>
                                < cfqueryparam value = 0 cfsqltype = "cf_sql_integer" >,
                            </cfif>
                            < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
                        )
                        <cfif i NEQ arrayLen(local.imagePathArray)>
                            ,
                        </cfif>
                    </cfloop>
                    <cfset local.result = "Success:Product Uploaded">
            </cfquery>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="viewBrand" returnType="any" access="remote" returnFormat="json">
        <cfargument  name="brandId" default="">
        <cfquery name="local.selectBrand">
            SELECT
                fldBrandName,
                fldBrand_ID
            FROM
                tblBrand
            WHERE
                fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
                <cfif trim(len(arguments.brandId))>
                    AND
                        fldBrand_ID = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
                </cfif>
        </cfquery>
        <cfif trim(len(arguments.brandId))>
            <cfset local.jsonData = {}>
            <cfset local.jsonData = SerializeJSON(local.selectBrand)>
            <cfreturn local.jsonData>
        </cfif>
        <cfreturn local.selectBrand>
    </cffunction>

    <cffunction  name="viewProducts" returnType="any" returnFormat="json" access="remote">
        <cfargument  name="columnName">
        <cfargument  name="productSubId">
        <cfset local.jsonData = {}>
        <cfquery name="local.viewProduct">
            SELECT
                B.fldBrandName,
                P.fldProductName,
                P.fldPrice,
                I.fldImageFileName,
                P.fldProduct_ID,
                P.fldDescription,
                P.fldTax,
                S.fldSubcategoryName,
                C.fldCategoryName,
                C.fldCategory_ID,
                S.fldSubcategory_ID,
                B.fldBrand_ID
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
                P.fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" > AND
                I.fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" > AND
                B.fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" > AND
                S.fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" > AND
                C.fldActive = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" > AND
                I.fldDefaultImage = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" > AND
                P.#arguments.columnName# = < cfqueryparam value ="#arguments.productSubId#" cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfset local.jsonData = SerializeJSON(local.viewProduct)>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction  name="updateProduct" access="remote" returnType="any" returnFormat="json">

        <cfargument  name="addProductCategorySelect">
        <cfargument  name="addProductSubcategorySelect">
        <cfargument  name="addProductNameInput">
        <cfargument  name="addProductBrandInput">
        <cfargument  name="addProductDescription">
        <cfargument  name="addProductPrice">
        <cfargument  name="addProductTax">
        <cfargument  name="addProductImage">
        <cfargument  name="productId">

        <cfset local.result="">
        <cfquery name="local.fetchContacts">
            SELECT 1 
            FROM tblProducts
            WHERE
                 fldProductName = < cfqueryparam value ="#arguments.addProductNameInput#" cfsqltype = "cf_sql_varchar" > AND
                 fldSubcategoryId = < cfqueryparam value ="#arguments.addProductSubcategorySelect#" cfsqltype = "cf_sql_varchar" >AND
                 NOT 
                 fldProduct_ID = < cfqueryparam value ="#arguments.productId#" cfsqltype = "cf_sql_varchar" > 
        </cfquery>
        <cfif queryRecordCount(local.fetchContacts)>
            <cfset local.result = "Failed:Product Already Exist">
        <cfelse>
            <cfquery name="local.updatePoduct">
                UPDATE 
                    tblProducts
                SET
                    fldSubcategoryid = < cfqueryparam value ="#arguments.addProductSubcategorySelect#" cfsqltype = "cf_sql_integer" >,
                    fldProductName = < cfqueryparam value ="#arguments.addProductNameInput#" cfsqltype = "cf_sql_varchar" >,
                    fldBrandId = < cfqueryparam value ="#arguments.addProductBrandInput#" cfsqltype = "cf_sql_integer" >,
                    fldDescription = < cfqueryparam value ="#arguments.addProductDescription#" cfsqltype = "cf_sql_varchar" >,
                    fldPrice = < cfqueryparam value ="#arguments.addProductPrice#" cfsqltype = "cf_sql_decimal" >,
                    fldTax = < cfqueryparam value ="#arguments.addProductTax#" cfsqltype = "cf_sql_decimal" >,
                    fldUpdatedBy = < cfqueryparam value ="#session.userId#" cfsqltype = "cf_sql_integer" >
                WHERE
                    fldProduct_ID=< cfqueryparam value ="#arguments.productId#" cfsqltype = "cf_sql_integer" >
            </cfquery>
            <cfset local.result = "Success:Product Uploaded">
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="viewImages" access="remote" returnFormat="json">
        <cfargument  name="productId">
        <cfset local.jsonData = {}>
        <cfquery name="local.fetchIamges">
            SELECT 
                fldProductImage_ID,
                fldImageFileName,
                fldProductId
            FROM
                tblProductImages
            WHERE
                fldProductId = < cfqueryparam value ="#arguments.productId#" cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfset local.jsonData = SerializeJSON(local.fetchIamges)>
        <cfreturn local.jsonData>
    </cffunction>

    <cffunction  name="setThumbnail" access="remote">
        <cfargument  name="ImageId">
        <cfargument  name="productId">
        <cfquery name="local.updateImages">
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = < cfqueryparam value = 0 cfsqltype = "cf_sql_integer" >
            WHERE
                fldProductId = < cfqueryparam value ="#arguments.productId#" cfsqltype = "cf_sql_integer" >
                AND
                fldDefaultImage = < cfqueryparam value =1 cfsqltype = "cf_sql_integer" >
        </cfquery>
         <cfquery name="local.setDefaultImage">
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = < cfqueryparam value = 1 cfsqltype = "cf_sql_integer" >
            WHERE
                fldProductImage_ID = < cfqueryparam value ="#arguments.ImageId#" cfsqltype = "cf_sql_integer" >
        </cfquery>

    </cffunction>

</cfcomponent>


