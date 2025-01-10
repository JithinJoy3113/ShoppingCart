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
        <cfquery name="local.selectCategory">
            SELECT 
                fldCategory_ID,
                fldCategoryName 
            FROM tblCategory
        </cfquery>
        <cfreturn local.selectCategory>
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
        <cfargument  name="categoryID">
        <cfset local.result = "">
        <cfquery name="local.fetchSubcategory">
            SELECT 1
            FROM 
                tblSubcategory
            WHERE
                fldSubcategoryName = < cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "varchar" >
        </cfquery>
        <cfif queryRecordCount(fetchSubcategory)>
            <cfset local.result = false>
        <cfelse>
            <cfquery name="local.insertSubcategory">
                INSERT INTO tblSubcategory
                    (
                        fldSubcategoryName,
                        fldCategoryId,
                        fldCreatedBy
                    )
                VALUES(
                    < cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "cf_sql_varchar" >,
                    < cfqueryparam value = '#arguments.categoryID#' cfsqltype = "cf_sql_varchar" >,
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
                fldCategoryId = < cfqueryparam value = '#arguments.categoryID#' cfsqltype = "cf_sql_integer" >
        </cfquery>
        <cfset local.jsonData = SerializeJSON(local.fetchSubcategory)>
        <!--- <cfloop query="local.fetchSubcategory">
            <cfset local.dataArray = []>

        </cfloop> --->
        <cfreturn local.jsonData >
    </cffunction>

    <cffunction  name="userLogout" returnType="boolean" access="remote">
        <cfset structClear(session)>
        <cflocation  url="adminLogin.cfm">
    </cffunction>

</cfcomponent>


