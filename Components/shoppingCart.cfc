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
        <cfelse>
            <cfset local.columnName = 'fldSubcategory_ID'>
        </cfif>
        <cfquery name="local.deleteData">
            UPDATE  
                #arguments.tablename#
            SET
                fldActive = < cfqueryparam value = 0 cfsqltype = "cf_sql_integer" >,
                fldUpdatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
            WHERE
                #local.columnName# = < cfqueryparam value = '#arguments.deleteId#' cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="userLogout" returnType="boolean" access="remote">
        <cfset structClear(session)>
        <cflocation  url="adminLogin.cfm">
    </cffunction>



</cfcomponent>


