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

    <cffunction  name="addCategory" returnType="boolean">
        <cfargument  name="categoryName" required="true">
        <cfquery name="local.selectCategory">
            SELECT 1 
            FROM tblCategory
            WHERE 
                fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "cf_sql_varchar" >
        </cfquery> 
        <cfif queryRecordCount(local.selectCategory)>
            <cfreturn false>
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
        </cfif>
        <cfreturn true>
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
        <cfquery name="local.categoryUpadte">
            UPDATE 
                tblCategory
            SET
                fldCategoryName = < cfqueryparam value = '#arguments.categoryName#' cfsqltype = "cf_sql_varchar" >,
                fldUpdatedBy = < cfqueryparam value = '#session.userId#' cfsqltype = "cf_sql_integer" >
            WHERE
                fldCategory_ID = < cfqueryparam value = '#arguments.editId#' cfsqltype = "cf_sql_integer" >,
        </cfquery>
    </cffunction>

    <cffunction  name="userLogout" returnType="boolean" access="remote">
        <cfset structClear(session)>
        <cflocation  url="adminLogin.cfm">
    </cffunction>

</cfcomponent>


