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

  <cffunction name = "userLogin" returnType = "struct" access = "remote" returnFormat = "json">
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
          U.fldUser_ID,
          U.fldFirstName,
          U.fldLastName,
          U.fldEmail,
          U.fldPhoneNumber,
          U.fldHashedPassword,
          U.fldUserSaltString,
          U.fldUserRoleID,
          R.fldRoleName,
          R.fldRole_ID
        FROM
          tblUser U
          LEFT JOIN tblRole R ON U.fldUserRoleID = R.fldRole_ID
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

  <cffunction name = "addCategory" returnType = "struct" access = "remote" returnFormat = "json">
    <cfargument name = "categoryName" required = "true" type = "string">
    <cfset local.result = {}>
    <cfif NOT len(arguments.categoryName)>
      <cfset local.result["Error"] = "Category Name Required">
      <cfreturn local.result> 
    </cfif>
    <cfquery name = "local.selectCategory" datasource = #application.dataSource#>
      SELECT
        1
      FROM
        tblCategory
      WHERE
        fldCategoryName = <cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar">
        AND fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
    </cfquery> 
    <cfif queryRecordCount(local.selectCategory)>
      <cfset local.result["Error"] = "Category Name Already Exist">
    <cfelse>
      <cfquery name = "local.insertCategory" datasource = #application.dataSource#>
        INSERT INTO 
          tblCategory(
            fldCategoryName,
            fldCreatedBy
          )
        VALUES(
          <cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar">,
          <cfqueryparam value = #session.userId# cfsqltype = "integer">
        )
      </cfquery>
      <cfset local.result["Success"] = "Category Name Added">
    </cfif>
    <cfreturn local.result>
  </cffunction>

  <cffunction name = "viewCategory" access = "remote" returnformat = "json" returnType = "array">
    <cfargument name = "editId" required = "false" type = "integer">
    <cfquery name = "local.selectCategory" datasource = #application.dataSource#>
      SELECT 
        fldCategory_ID,
        fldCategoryName 
      FROM 
        tblCategory
      WHERE
        fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        <cfif structKeyExists(arguments, "editId")>
          AND fldCategory_ID = <cfqueryparam value = '#arguments.editId#' cfsqltype = "integer">
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

  <cffunction name = "updateCategory" returnType = "struct" access = "remote" returnformat = "json">
    <cfargument name = "editId" required = "true" type = "integer">
    <cfargument name = "categoryName" required = "true" type = "string">
    <cfset local.result = {}>
    <cfif NOT len(arguments.categoryName)>
      <cfset local.result["Error"] = "Category Name Required">
      <cfreturn local.result> 
    </cfif>
    <cfquery name = "local.selectCategory" datasource = #application.dataSource#>
      SELECT
        1
      FROM
        tblCategory
      WHERE
        fldCategoryName = <cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar">
        AND fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
    </cfquery> 
    <cfif queryRecordCount(local.selectCategory)>
      <cfset local.result["Error"] = "Category Name Already Exist">
    <cfelse>
      <cfquery name = "local.categoryUpadte" datasource = #application.dataSource#>
        UPDATE 
          tblCategory
        SET
          fldCategoryName = <cfqueryparam value = '#arguments.categoryName#' cfsqltype = "varchar">,
          fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">
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
          AND fldCategoryId = <cfqueryparam value = #arguments.categoryId# cfsqltype = "integer">
      </cfquery>
      <cfif queryRecordCount(local.fetchSubcategory)>
        <cfset local.result["addSubMessage"] = "Subcategory Name Already Exist">
      <cfelse>
        <cfquery name = "local.insertSubcategory" datasource = #application.dataSource#>
          INSERT INTO
             tblSubcategory(
              fldSubcategoryName,
              fldCategoryId,
              fldCreatedBy
            )
          VALUES(
            <cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "varchar">,
            <cfqueryparam value = '#arguments.categoryId#' cfsqltype = "integer">,
            <cfqueryparam value = #session.userId# cfsqltype = "integer">
          )
        </cfquery>
        <cfset local.result["addSubMessage"] = "Success:Subcategory Name Added">
      </cfif>
      <cfreturn local.result>
    </cfif>
  </cffunction>

  <cffunction name="updateSubcategory" access = "remote" returnFormat = "json" returnType = "struct">
    <cfargument name = "subCategoryId" required = "true" type = "integer">
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
          AND fldCategoryId = <cfqueryparam value = #arguments.categoryId# cfsqltype = "integer">
          AND NOT fldSubcategory_ID = <cfqueryparam value = #arguments.subCategoryId# cfsqltype = "integer">
      </cfquery>
      <cfif queryRecordCount(local.fetchSubcategory)>
        <cfset local.result["addSubMessage"] = "Subcategory Already Exist">
      <cfelse>
        <cfquery name = "local.updateSubcategory" datasource = #application.dataSource#>
          UPDATE tblSubcategory
          SET
            fldSubcategoryName = <cfqueryparam value = '#arguments.subCategoryName#' cfsqltype = "varchar">,
            fldCategoryId = <cfqueryparam value = #arguments.categoryID# cfsqltype = "integer">,
            fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">
          WHERE
            fldSubcategory_ID = <cfqueryparam value = #arguments.subCategoryID# cfsqltype = "integer">
        </cfquery>
        <cfset local.result["addSubMessage"] = "Success:Subcategory Updated">
      </cfif>
      <cfreturn local.result>
    </cfif>
  </cffunction>

  <cffunction  name = "productListing" returnType = "struct" access = "public">
    <cfargument  name = "categoryId" required = "true" type = "integer">
    <cfquery name = "local.productListing" datasource = "#application.dataSource#">
        SELECT
          SC.fldSubcategory_ID,
          SC.fldSubcategoryName,
          P.fldProductName,
          P.fldPrice,
          P.fldProduct_ID,
          P.fldDescription,
          P.fldTax,
          PI.fldImageFileName,
          B.fldBrand_ID,
          B.fldBrandName
        FROM
          tblSubCategory SC
          INNER JOIN tblProducts P ON SC.fldSubCategory_ID = P.fldSubCategoryId
          INNER JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId
          INNER JOIN tblBrand B ON B.fldBrand_ID = P.fldBrandId
        WHERE
          SC.fldcategoryId = <cfqueryparam value = #arguments.categoryId# cfsqltype = "integer">
          AND SC.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND P.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND PI.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND PI.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
      </cfquery>
      <cfset local.dataStruct = {}>
      <cfloop query = "local.productListing">
        <cfset local.jsonData = {}>
        <cfset local.jsonData['productName'] = local.productListing.fldProductName>
        <cfset local.jsonData['price'] = local.productListing.fldPrice>
        <cfset local.jsonData['tax'] = local.productListing.fldTax>
        <cfset local.jsonData['description'] = local.productListing.fldDescription>
        <cfset local.jsonData['productId'] = local.productListing.fldProduct_ID>
        <cfset local.jsonData['subcategoryName'] = local.productListing.fldSubcategoryName>
        <cfset local.jsonData['subcategoryId'] = local.productListing.fldSubcategory_ID>
        <cfset local.jsonData['file'] = local.productListing.fldImageFileName>
        <cfset local.jsonData['brand'] = local.productListing.fldBrandName>

        <cfset local.subCategoryName = local.productListing.fldSubcategoryName>
        <cfif structKeyExists(local.dataStruct, local.subCategoryName)>
          <cfset arrayAppend(local.dataStruct['#local.subCategoryName#'], local.jsonData)>
        <cfelse>
          <cfset local.dataStruct['#local.subCategoryName#'] = []>
          <cfset arrayAppend(local.dataStruct['#local.subCategoryName#'], local.jsonData)>
        </cfif>
      </cfloop>
      <cfreturn local.dataStruct>
  </cffunction>

  <cffunction name = "viewSubcategory" returnType = "array" access = "remote" returnFormat = "json">
    <cfargument name = "categoryId" required = "false" type = "integer">
    <cfargument name = "subCategoryId" required = "false" type = "integer">
    <cfquery name = "local.fetchSubcategory" datasource = #application.dataSource#>
      SELECT
        S.fldSubcategoryName,
        S.fldSubcategory_ID,
        S.fldCategoryID,
        C.fldCategoryName,
        C.fldCategory_ID,
        S.fldActive
      FROM
        tblCategory C
        LEFT JOIN tblSubCategory S ON C.fldCategory_ID = S.fldCategoryId
      WHERE
        <cfif structKeyExists(arguments, "categoryId")>
          S.fldCategoryId = <cfqueryparam value = #arguments.categoryID# cfsqltype = "integer">
          AND C.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND S.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        <cfelseif structKeyExists(arguments, "subCategoryId")>
          S.fldSubcategory_ID = <cfqueryparam value = #arguments.subCategoryId# cfsqltype = "integer">
          AND C.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND S.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        <cfelse>
          C.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND S.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        </cfif>
    </cfquery>
    <cfset local.dataArray = []>
    <cfloop query="local.fetchSubcategory">
      <cfset local.jsonData = {}>
      <cfset local.jsonData['subcategoryId'] = local.fetchSubcategory.fldSubcategory_ID>
      <cfset local.jsonData['subcategoryName'] = local.fetchSubcategory.fldSubcategoryName>
      <cfset local.jsonData['categoryIdTblSub'] = local.fetchSubcategory.fldCategoryID>
      <cfset local.jsonData['categoryId'] = local.fetchSubcategory.fldCategory_ID>
      <cfset local.jsonData['categoryName'] = local.fetchSubcategory.fldCategoryName>
      <cfset arrayAppend(local.dataArray, local.jsonData)>
    </cfloop>
    <cfreturn local.dataArray >
  </cffunction>

  <cffunction name = "deleteRow" access = "remote" returnType = "struct" returnFormat = "json">
    <cfargument name = "tableName" required = "true" type = "string">
    <cfargument name = "deleteId" required = "true" type = "integer">
    <cfif arguments.tableName EQ "tblCategory">
      <cfquery name = "local.deleteItems" datasource = "#application.dataSource#">
        UPDATE 
          tblCategory C
          LEFT JOIN tblSubCategory SC ON C.fldCategory_ID = SC.fldCategoryId
          LEFT JOIN tblProducts P ON SC.fldSubCategory_ID = P.fldSubCategoryId
          LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId
        SET
          C.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          C.fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">,
          SC.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          SC.fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">,
          P.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          P.fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">,
          PI.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          PI.fldDeactivatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">
        WHERE
          C.fldCategory_ID = <cfqueryparam value = #arguments.deleteId# cfsqltype = "integer">
      </cfquery>
    <cfelseif arguments.tableName EQ "tblSubcategory">
      <cfquery name = "local.deleteItems" datasource = "#application.dataSource#">
        UPDATE 
          tblSubCategory SC
          LEFT JOIN tblProducts P ON SC.fldSubCategory_ID = P.fldSubCategoryId
          LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId
        SET
          SC.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          SC.fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">,
          P.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          P.fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">,
          PI.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          PI.fldDeactivatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">
        WHERE
          SC.fldSubCategory_ID = <cfqueryparam value = #arguments.deleteId# cfsqltype = "integer">
      </cfquery>
    <cfelseif arguments.tableName EQ "tblProducts">
      <cfquery name = "local.deleteItems" datasource = "#application.dataSource#">
        UPDATE 
          tblProducts P
          LEFT JOIN tblProductImages PI ON P.fldProduct_ID = PI.fldProductId
        SET
          P.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          P.fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">,
          PI.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          PI.fldDeactivatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">
        WHERE
          P.fldProduct_ID = <cfqueryparam value = #arguments.deleteId# cfsqltype = "integer">
      </cfquery>
    <cfelseif arguments.tableName EQ "tblProductImages">
      <cfquery name = "local.deleteItems" datasource = "#application.dataSource#">
        UPDATE 
          tblProductImages PI
        SET
          PI.fldActive = <cfqueryparam value = 0 cfsqltype = "integer">,
          PI.fldDeactivatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">
        WHERE
          PI.fldProductImage_ID = <cfqueryparam value = #arguments.deleteId# cfsqltype = "integer">
      </cfquery>
    </cfif>
    <cfreturn {"status":"true"}>
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
        SELECT
          1
        FROM
          tblProducts
        WHERE
          fldProductName = <cfqueryparam value = "#arguments.addProductNameInput#" cfsqltype = "varchar">
          AND fldSubcategoryId = <cfqueryparam value = #arguments.addProductSubcategorySelect# cfsqltype = "integer">
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
            <cfqueryparam value = #arguments.addProductSubcategorySelect# cfsqltype = "integer">,
            <cfqueryparam value = '#arguments.addProductNameInput#' cfsqltype = "varchar">,
            <cfqueryparam value = #arguments.addProductBrandInput# cfsqltype = "integer">,
            <cfqueryparam value = '#arguments.addProductDescription#' cfsqltype = "varchar">,
            <cfqueryparam value = '#arguments.addProductPrice#' cfsqltype = "decimal">,
            <cfqueryparam value = '#arguments.addProductTax#' cfsqltype = "decimal">,
            <cfqueryparam value = #session.userId# cfsqltype = "integer">
          )
        </cfquery>
        <cfset local.generatedKey = local.productInsert.generatedKey>
        <cfquery name = "local.insertImages" datasource = #application.dataSource#>
          INSERT INTO
            tblProductImages(
              fldProductId,
              fldImageFileName,
              fldDefaultImage,
              fldCreatedBy
            )
          VALUES
            <cfloop array = "#local.imagePathArray#" item = "item" index = "i"> 
              (
                <cfqueryparam value = #local.generatedKey# cfsqltype = "integer">,
                <cfqueryparam value = '#item.serverFile#' cfsqltype = "varchar">,
                <cfif i EQ 1>
                  <cfqueryparam value = 1 cfsqltype = "integer">,
                <cfelse>
                  <cfqueryparam value = 0 cfsqltype = "integer">,
                </cfif>
                <cfqueryparam value = #session.userId# cfsqltype = "integer">
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
    <cfargument name = "addProductBrandInput" required = "true" type = "integer">
    <cfargument name = "addProductDescription" required = "true" type = "string">
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
      <cfquery name = "local.fetchProducts" datasource = #application.dataSource#>
        SELECT
          1
        FROM
          tblProducts
        WHERE
          fldProductName = <cfqueryparam value = "#arguments.addProductNameInput#" cfsqltype = "varchar">
          AND fldSubcategoryId = <cfqueryparam value = #arguments.addProductSubcategorySelect# cfsqltype = "integer">
          AND NOT fldProduct_ID = <cfqueryparam value = #arguments.productId# cfsqltype = "integer"> 
      </cfquery>
      <cfif queryRecordCount(local.fetchProducts)>
        <cfset local.result["insertError"] = "Failed:Product Already Exist">
      <cfelse>
        <cfquery name = "local.updatePoduct" datasource = #application.dataSource#>
          UPDATE 
            tblProducts
          SET
            fldSubcategoryid = <cfqueryparam value = "#arguments.addProductSubcategorySelect#" cfsqltype = "integer">,
            fldProductName = <cfqueryparam value = "#arguments.addProductNameInput#" cfsqltype = "varchar">,
            fldBrandId = <cfqueryparam value = #arguments.addProductBrandInput# cfsqltype = "integer">,
            fldDescription = <cfqueryparam value = "#arguments.addProductDescription#" cfsqltype = "varchar">,
            fldPrice = <cfqueryparam value = "#arguments.addProductPrice#" cfsqltype = "decimal">,
            fldTax = <cfqueryparam value = "#arguments.addProductTax#" cfsqltype = "decimal">,
            fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">
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
        fldProductId = <cfqueryparam value = #arguments.productId# cfsqltype = "integer">
        AND fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
    </cfquery>
    <cfset local.dataArray = []>
    <cfloop query = "local.fetchImages">
      <cfset local.jsonData = {}>
      <cfset local.jsonData['imageId'] = local.fetchImages.fldProductImage_ID>
      <cfset local.jsonData['imageFileName'] = local.fetchImages.fldImageFileName>
      <cfset local.jsonData['productId'] = local.fetchImages.fldProductId>
      <cfset local.jsonData['defaultImage'] = local.fetchImages.fldDefaultImage>
      <cfset arrayAppend(local.dataArray, local.jsonData)>
    </cfloop>
    <cfreturn local.dataArray>
  </cffunction>

  <cffunction name = "setThumbnail" access = "remote" returnType = "boolean" returnFormat = "json">
    <cfargument name = "ImageId" required = "true" type = "integer">
    <cfargument name = "productId" required = "true" type = "integer">
    <cfquery name = "local.updateImages" datasource = #application.dataSource#>
      UPDATE
        tblProductImages
      SET
        fldDefaultImage = <cfqueryparam value = 0 cfsqltype = "integer">
      WHERE
        fldProductId = <cfqueryparam value = #arguments.productId# cfsqltype = "integer">
        AND fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
    </cfquery>
    <cfquery name = "local.setDefaultImage" datasource = #application.dataSource#>
      UPDATE
        tblProductImages
      SET
        fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
      WHERE
        fldProductImage_ID = <cfqueryparam value = #arguments.ImageId# cfsqltype = "integer">
    </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name = "randomProducts" returnType = "array" returnformat = "json" access="remote">
    <cfargument name = "subCategoryId" type = "integer" default = 0 required = "false">
    <cfargument name = "offset" type = "integer" required = "false">
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
      FROM 
        tblProducts P
        LEFT JOIN tblProductImages I ON P.fldProduct_ID = I.fldProductId
        LEFT JOIN tblSubcategory S ON S.fldSubcategory_ID = P.fldSubcategoryId
      WHERE 
        P.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        AND I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
        AND I.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        AND S.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
        <cfif arguments.subCategoryId NEQ 0>
          AND P.fldSubcategoryId = <cfqueryparam value = #arguments.subCategoryId# cfsqltype = "integer"> 
        </cfif>
        <cfif structKeyExists(arguments, "offset")>
          LIMIT 5 OFFSET #arguments.offset#
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
          AND(
            P.fldProductName LIKE <cfqueryparam value = "%#arguments.search#%" cfsqltype = "varchar">
            OR P.fldDescription LIKE <cfqueryparam value = "%#arguments.search#%" cfsqltype = "varchar">
            OR S.fldSubcategoryName = <cfqueryparam value = #arguments.search# cfsqltype = "varchar">
          )
        <cfelse>
          ORDER BY
            RAND()
            LIMIT 10
        </cfif>
    </cfquery>
    <cfset local.dataArray = []>
    <cfloop query = "local.fetchProducts">
      <cfset local.jsonData = {}>
      <cfset local.encryptedSubcategoryId = urlEncodedFormat(encrypt(local.fetchProducts.fldSubcategoryId, application.secretKey, "AES", "Base64"))>
      <cfset local.encryptedProductId = urlEncodedFormat(encrypt(local.fetchProducts.fldProduct_ID, application.secretKey, "AES", "Base64"))>
      <cfset local.jsonData['productId'] = local.fetchProducts.fldProduct_ID>
      <cfset local.jsonData['productName'] = local.fetchProducts.fldProductName>
      <cfset local.jsonData['price'] = local.fetchProducts.fldPrice>
      <cfset local.jsonData['productFileName'] = local.fetchProducts.fldImageFileName>
      <cfset local.jsonData['subcategoryId'] = local.fetchProducts.fldSubcategoryId>
      <cfset local.jsonData['encryptedSubId'] = local.encryptedSubcategoryId>
      <cfset local.jsonData['encryptedProductId'] = local.encryptedProductId>
      <cfset arrayAppend(local.dataArray, local.jsonData)>
    </cfloop>
    <cfreturn local.dataArray>
  </cffunction>

  <cffunction name = "viewProducts" returnType = "array" returnFormat = "json" access = "remote">
    <cfargument name = "columnName" required = "false" type = "string">
    <cfargument name = "productSubId" required = "false" type = "integer">
    <cfargument name = "productId" default = 0 required = "false" type = "integer">
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
        tblProducts P
        LEFT JOIN tblBrand B ON P.fldBrandId = B.fldBrand_ID
        LEFT JOIN tblProductImages I ON P.fldProduct_ID = I.fldProductId
        LEFT JOIN tblSubcategory S ON S.fldSubcategory_ID = P.fldSubcategoryId
        LEFT JOIN tblCategory C ON C.fldCategory_ID = S.fldCategoryId
      WHERE
        <cfif structKeyExists(arguments, "productSubId")>
          P.fldSubCategoryId = <cfqueryparam value = #arguments.productSubId# cfsqltype = "integer">
          AND P.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          <cfif structKeyExists(arguments, "columnName")>
             AND I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
          </cfif>
        <cfelse>
          P.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND I.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND B.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND S.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND C.fldActive = <cfqueryparam value = 1 cfsqltype = "integer">
          AND I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
          <cfif arguments.productId NEQ 0>
            AND P.fldProduct_ID = <cfqueryparam value = #arguments.productId# cfsqltype = "integer">
          <cfelseif structKeyExists(arguments, "columnName")>
            AND P.#arguments.columnName# = <cfqueryparam value = #arguments.productSubId# cfsqltype = "integer">
          </cfif>
        </cfif>
    </cfquery>
    <cfset local.dataArray = []>
    <cfloop query = "local.viewProduct">
      <cfset local.jsonData = {}>
      <cfset arrayAppend(local.dataArray, local.jsonData)>
      <cfset local.jsonData['productName'] = local.viewProduct.fldProductName>
      <cfset local.jsonData['price'] = local.viewProduct.fldPrice>
      <cfset local.jsonData['tax'] = local.viewProduct.fldTax>
      <cfset local.jsonData['totalPrice'] = local.viewProduct.fldPrice>
      <cfset local.jsonData['totalTax'] = (local.viewProduct.fldPrice/100)*local.viewProduct.fldTax>
      <cfset local.jsonData['orderAmount'] = local.viewProduct.fldPrice>
      <cfset local.jsonData['orderTax'] = local.viewProduct.fldTax>
      <cfset local.jsonData['description'] = local.viewProduct.fldDescription>
      <cfset local.jsonData['productId'] = local.viewProduct.fldProduct_ID>
      <cfset local.jsonData['categoryId'] = local.viewProduct.fldCategory_ID>
      <cfset local.jsonData['categoryName'] = local.viewProduct.fldCategoryName>
      <cfset local.jsonData['subcategoryName'] = local.viewProduct.fldSubcategoryName>
      <cfset local.jsonData['subcategoryId'] = local.viewProduct.fldSubcategory_ID>
      <cfset local.jsonData['file'] = local.viewProduct.fldImageFileName>
      <cfset local.jsonData['brandId'] = local.viewProduct.fldBrand_ID>
      <cfset local.jsonData['brandName'] = local.viewProduct.fldBrandName>
      <cfset local.jsonData['quantity'] = 1>
    </cfloop>
    <cfset arrayAppend(local.dataArray, {"orderAmount" :   local.viewProduct.fldPrice, "orderTax" : (local.viewProduct.fldPrice/100)*local.viewProduct.fldTax})>
    <cfreturn local.dataArray>
  </cffunction>

  <cffunction name = "addToCart" returnType = "boolean" access = "remote" returnFormat = "json">
    <cfargument name = "productId" type = "integer" required = "true">
    <cfif structKeyExists(session, "role")>
      <cfquery name = "local.fetchCart" datasource = "#application.dataSource#">
        SELECT 
          1
        FROM
          tblCart
        WHERE 
          fldProductId = <cfqueryparam value = #arguments.productId# cfsqltype = "integer">
          AND fldUserId = <cfqueryparam value = #session.userId# cfsqltype = "integer">
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
            <cfqueryparam value = #arguments.productId# cfsqltype = "integer">,
            <cfqueryparam value = #session.userId# cfsqltype = "integer">,
            <cfqueryparam value = 1 cfsqltype = "integer">
          )
        </cfquery>
        <cfreturn true>
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
        B.fldBrandName,
        (C.fldQuantity * P.fldPrice) AS totalPrice,
        (((C.fldQuantity * P.fldPrice)/100)*P.fldTax) AS totalTax,
        P.fldTax,
        I.fldImageFileName
      FROM
        tblCart C
        INNER JOIN tblProducts P ON P.fldProduct_ID = C.fldProductId
        INNER JOIN tblProductImages I ON P.fldProduct_ID = I.fldProductId
        INNER JOIN tblBrand B ON B.fldBrand_ID = P.fldBrandId
      WHERE
        C.fldUserId = <cfqueryparam value = #session.userId# cfsqltype = "integer">
        AND I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
        <cfif arguments.cartId NEQ 0>
          AND C.fldCartItem_ID = <cfqueryparam value = #arguments.cartId# cfsqltype = "integer">
        </cfif>
        <cfif arguments.productId NEQ 0>
          AND C.fldProductId = <cfqueryparam value = #arguments.productId# cfsqltype = "integer">
        </cfif>
    </cfquery>
    <cfset local.dataArray = []>
    <cfset local.orderAmount = 0>
    <cfset local.orderTax = 0>
    <cfif queryRecordCount(local.fetchCart)>
      <cfloop query="local.fetchCart">
        <cfset local.data = {}>
        <cfset local.orderAmount += local.fetchCart.totalPrice>
        <cfset local.orderTax += local.fetchCart.totalTax>
        <cfset local.data['cartId'] = local.fetchCart.fldCartItem_ID>
        <cfset local.data['productId'] = local.fetchCart.fldProductId>
        <cfset local.data['quantity'] = local.fetchCart.fldQuantity>
        <cfset local.data['brandName'] = local.fetchCart.fldBrandName>
        <cfset local.data['productName'] = local.fetchCart.fldProductName>
        <cfset local.data['subcategoryId'] = local.fetchCart.fldSubCategoryId>
        <cfset local.data['totalPrice'] = local.fetchCart.totalPrice>
        <cfset local.data['totalTax'] = local.fetchCart.totalTax>
        <cfset local.data['price'] = local.fetchCart.fldPrice>
        <cfset local.data['tax'] = local.fetchCart.fldTax>
        <cfset local.data['file'] = local.fetchCart.fldImageFileName>
        <cfset arrayAppend(local.dataArray, local.data)>
      </cfloop>
    </cfif>
    <cfset arrayAppend(local.dataArray, {"orderAmount" :  local.orderAmount, "orderTax" : local.orderTax})>
    <cfreturn local.dataArray>
  </cffunction>

  <cffunction name="updateCart" returnType="array" returnFormat="json" access="remote">
    <cfargument name="cartId" required="true" type="integer">
    <cfargument name="operation" required="true" type="string">
    <cftry>
      <cfquery name="local.updateCart" datasource="#application.dataSource#">
        UPDATE
          tblCart
        SET
          <cfif arguments.operation EQ "Plus">
            fldQuantity = fldQuantity + 1
          <cfelseif arguments.operation EQ "Minus">
            fldQuantity = fldQuantity - 1
          </cfif>
        WHERE
          fldCartItem_ID = <cfqueryparam value="#arguments.cartId#" cfsqltype="integer">
      </cfquery>
      <cfset local.dataArray = cartItems()>
      <cfreturn local.dataArray>
    <cfcatch type="any">
      <cfreturn [{
        "status" = "error",
        "message" = "An error occurred while updating the cart. Please try again later."
      }]>
    </cfcatch>
    </cftry>
  </cffunction>

  <cffunction name = "deleteCartItem" returnType="array" returnFormat = "json" access = "remote">
    <cfargument name = "cartId" required = "false" type = "integer">
    <cfargument name = "productId" required = "false" type = "integer">
    <cfquery name = "local.deleteCartItem" datasource = #application.dataSource#>
      DELETE
      FROM
        tblCart
      WHERE 
        <cfif structKeyExists(arguments, "cartId")>
          fldCartItem_ID = <cfqueryparam value = #arguments.cartId# cfsqltype = "integer">
        <cfelseif structKeyExists(arguments, "productId")>
           fldProductId = <cfqueryparam value = #arguments.productId# cfsqltype = "integer">
        </cfif>
    </cfquery>
    <cfset local.dataArray = cartItems()>
    <cfreturn local.dataArray>
  </cffunction>

  <cffunction name = "updateProductquantity" returnType = "array" returnFormat = "json" access = "remote">
    <cfargument  name = "productId" required = "false" type = "integer">
    <cfargument  name = "cartId" required = "false" type = "integer">
    <cfif arguments.productId NEQ 0>
      <cfset local.queryData = viewProducts(productId = arguments.productId)>
    <cfelse>
      <cfset local.queryData = cartItems()>
    </cfif>
    <cfset session.updateItems = local.queryData>
    <cfreturn local.queryData>
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
        AND NOT fldUser_ID = <cfqueryparam value = #session.userId# cfsqltype = "integer">
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
          fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype = "integer">
        WHERE
          fldUser_ID = <cfqueryparam value = #session.userId# cfsqltype = "integer">
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
          <cfqueryparam value = #session.userId# cfsqltype = "integer">,
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
        fldUserId = <cfqueryparam value = #session.userId# cfsqltype = "integer">
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
    <cfargument name = "addressId" type = "integer" required = "true">
    <cfargument name = "cardNumber" type = "numeric" required = "true" default = 1>
    <cfargument name = "cvv" type = "numeric" required = "true" default = 1>
    <cfset local.cardNumber = 123456789123>
    <cfset local.cvv = 123>
    <cfset local.jsonData = {}>
    <cfif (arguments.cardNumber EQ local.cardNumber) AND (arguments.cvv EQ local.cvv)>
    <cfset local.generatedUUID = createUUID()>
    <cfset detailsStructJSON = []>
      <cfloop array = "#session.updateItems#" index = "item">
        <cfif structKeyExists(item, "productId")>
          <cfset productJson = {
            "productId" = item.productId,
            "totalQuantity" = item.quantity,
            "unitPrice" = item.price,
            "unitTax" = item.tax
          }>
          <cfset arrayAppend(detailsStructJSON, productJson)>
          <cfelse>
            <cfset local.payAmount = item.orderAmount + item.orderTax>
            <cfset local.orderAmount = item.orderAmount>
            <cfset local.orderTax = item.orderTax>
        </cfif>
      </cfloop>
      <cfset detailsStructJSON = serializeJSON(detailsStructJSON)>
      <cfstoredproc procedure="sp_CreateOrder" datasource = "#application.dataSource#" result = "local.sp_CreateOrder">
        <cfprocparam type="in" value="#session.userId#" cfsqltype="integer">
        <cfprocparam type="in" value="#arguments.addressId#" cfsqltype="integer">
        <cfprocparam type="in" value="#local.orderAmount#" cfsqltype="decimal">
        <cfprocparam type="in" value="#local.orderTax#" cfsqltype="decimal">
        <cfprocparam type="in" value="#detailsStructJSON#" cfsqltype="varchar">
         <cfprocparam type="in" value="#local.generatedUUID#" cfsqltype="varchar">
      </cfstoredproc>
      <cfset local.jsonData['Result'] = true>
      <cfmail from="jithinj3113@gmail.com" subject="Order Placed" to="jithinj403113@gmail.com" type = "html">
        Order placed successfully!<br>
        Dear #session.firstName#,<br>
        Thank you for your order! We are pleased to confirm that we have received your order and are processing it.
        Below are the details of your order:
        <table border="1" cellpadding="5" cellspacing="0">
          <tr>
            <th>Order Id</th>
            <td>#local.generatedUUID#</td>
          </tr>
          <tr>
            <th>Product</th>
            <th>Quantity</th>
            <th>Price</th>
            <th>Tax</th>
            <th>Total</th>
          </tr>
          <cfset local.getOrders = getOrders(search = local.generatedUUID)>
          <cfloop collection = "#local.getOrders#" item = "items">
            <cfloop array="#local.getOrders[items]#" item="item">
              <cfset local.itemTotal = (item.unitPrice*item.quantity+((item.unitPrice*item.quantity)/100)*item.unitTax)>
              <tr>
                <td>#item.productName#</td>
                <td>#item.quantity#</td>
                <td>#item.unitPrice*item.quantity#</td>
                <td>#((item.unitPrice*item.quantity)/100)*item.unitTax#</td>
                <td>#local.itemTotal#</td>
              </tr>
            </cfloop>
          </cfloop>
          <tr>
            <th>Total Amount</th>
            <td>#DecimalFormat(local.payAmount)#</td>
          </tr>
        </table><br>
        If you have any questions or need assistance, please feel free to contact us at <a href="">clickCark.com</a>. We're here to help!<br>
        Thank you for shopping with us! We look forward to serving you again soon.<br>
        Best regards,<br>
        ClickCart<br>
        <a href="">ClickCart.com</a><br>
      </cfmail>
    <cfelse>
      <cfset local.jsonData['Result'] = false>
    </cfif>
    <cfreturn local.jsonData>
  </cffunction>

  <cffunction name = "getOrders" access = "remote" returnType = "struct" returnFormat = "json">
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
        A.fldPhoneNumber,
        OI.fldQuantity,
        OI.fldUnitPrice,
        OI.fldUnitTax,
        P.fldProductName,
        I.fldImageFileName,
        B.fldBrandName
      FROM
        tblOrders O
        INNER JOIN tblOrderItems OI ON O.fldOrder_ID = OI.fldOrderId
        INNER JOIN tblAddress A ON O.fldAddressId = A.fldAddress_ID
        INNER JOIN tblProducts P ON P.fldProduct_ID = OI.fldProductId
        INNER JOIN tblProductImages I ON I.fldProductId = P.fldProduct_ID
        INNER JOIN tblBrand B ON B.fldBrand_ID = P.fldBrandId
      WHERE
        O.fldUserId =  <cfqueryparam value = #session.userId# cfsqltype = "integer">
        AND I.fldDefaultImage = <cfqueryparam value = 1 cfsqltype = "integer">
        <cfif structKeyExists(arguments, 'search') AND arguments.search NEQ 0>
          AND O.fldOrder_ID =<cfqueryparam value = "#arguments.search#" cfsqltype = "varchar">
        </cfif>
      ORDER BY 
        O.fldOrderDate DESC
    </cfquery>
    <cfset local.dataStruct = structNew('ordered')>
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
      <cfset local.jsonData['quantity'] = local.orders.fldQuantity>
      <cfset local.jsonData['unitPrice'] = local.orders.fldUnitPrice>
      <cfset local.jsonData['unitTax'] = local.orders.fldUnitTax>
      <cfset local.jsonData['productName'] = local.orders.fldProductName>
      <cfset local.jsonData['fileName'] = local.orders.fldImageFileName>
      <cfset local.jsonData['brandName'] = local.orders.fldBrandName>
      <cfset local.orderId = local.orders.fldOrder_ID>
      <cfif structKeyExists(local.dataStruct, local.orderId)>
        <cfset arrayAppend(local.dataStruct['#local.orderId#'], local.jsonData)>
      <cfelse>
        <cfset local.dataStruct['#local.orderId#'] = []>
        <cfset arrayAppend(local.dataStruct['#local.orderId#'], local.jsonData)>
      </cfif>
    </cfloop>
    <cfreturn local.dataStruct>
  </cffunction>

  <cffunction name = "getPdf" returnType = "string" access = "remote" returnFormat="json"> 
    <cfargument name="orderId" default = 1 required = "true">
    <cfset local.orders = getOrders(search = arguments.orderId)>
    <cfset local.orderDetails = local.orders[arguments.orderId][1]>
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
                #local.orderDetails.firstName# #local.orderDetails.lastName# <br>
                #local.orderDetails.address1#, #local.orderDetails.address2#<br>
                #local.orderDetails.city#, #local.orderDetails.state#<br>
                #local.orderDetails.pincode#<br>
                #local.orderDetails.phone#  
              </span>
            <div><br>
            Order ID : #arguments.orderId#<br>
            Order Date : #local.orderDetails.orderDate#
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
          <cfset local.getOrders = getOrders(search = arguments.orderId)>
          <cfloop collection = "#local.getOrders#" item = "items">
            <cfloop array="#local.getOrders[items]#" item="item">
            <cfset local.itemTotal = (item.unitPrice*item.quantity+((item.unitPrice*item.quantity)/100)*item.unitTax)>
            <tr>
              <td>#local.count#</td>
              <td>#item.productName#</td>
              <td>#item.quantity#</td>
              <td>#item.unitPrice*item.quantity#</td>
              <td>#((item.unitPrice*item.quantity)/100)*item.unitTax#</td>
              <td>#local.itemTotal#</td>
            </tr>
            <cfset local.count += 1>
           </cfloop>
          </cfloop>
          <tr>
            <th>Total:</th>
            <td>#item.totalPrice + item.totalTax#</td>
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
        fldDeactivatedDate = <cfqueryparam value = "#now()#" cfsqltype = "timestamp">
      WHERE
        fldAddress_ID = <cfqueryparam value = #arguments.addressId# cfsqltype = "integer">
    </cfquery>
    <cfreturn true>
  </cffunction>
  
  <cffunction  name = "updateOrderItems" access = "remote" returnType = "array" returnFormat = "json">
    <cfargument  name = "productId" required = "true" type = "integer">
    <cfargument  name = "operation" required = "true" type = "string">
    <cfset local.arrayLength = arrayLen(session.updateItems)>
    <cfset local.totalPrice = 0>
    <cfset local.totalTax = 0>
    <cfloop array = "#session.updateItems#" index = "item">
      <cfif structKeyExists(item, "productName") AND item.productId EQ arguments.productId AND arguments.operation EQ 'Plus'>
        <cfset item.totalPrice += item.price>
        <cfset item.totalTax += (item.price/100)*item.tax>
        <cfset item.quantity += 1>
        <cfset local.price = item.price>
        <cfset local.tax = (item.price/100)*item.tax>
      <cfelseif structKeyExists(item, "productName") AND item.productId EQ arguments.productId AND arguments.operation EQ 'Minus'>
        <cfset item.totalPrice -= item.price>
        <cfset item.totalTax -= (item.price/100)*item.tax>
        <cfset item.quantity -= 1>
        <cfset local.price = item.price>
        <cfset local.tax = (item.price/100)*item.tax>
      <cfelseif structKeyExists(item, "productName") AND item.productId EQ arguments.productId AND arguments.operation EQ 'Remove'>
        <cfset local.totalPrice = item.totalPrice>
        <cfset local.totalTax = (item.totalPrice/100)*item.tax>
        <cfset local.index = ArrayFind(session.updateItems, item)>
        <cfset ArrayDeleteAt(session.updateItems, local.index)>
        <cfset local.arrayLength = arrayLen(session.updateItems)>
        <cfbreak>
      </cfif>
    </cfloop>
    <cfif arguments.operation EQ 'Plus'>
      <cfset session.updateItems[local.arrayLength].orderAmount += local.price>
      <cfset session.updateItems[local.arrayLength].orderTax += local.tax>
    <cfelseif arguments.operation EQ 'Minus'>
      <cfset session.updateItems[local.arrayLength].orderAmount -= local.price>
      <cfset session.updateItems[local.arrayLength].orderTax -= local.tax>
    <cfelseif arguments.operation EQ 'Remove'>
      <cfset session.updateItems[local.arrayLength].orderAmount -= local.totalPrice>
      <cfset session.updateItems[local.arrayLength].orderTax -= local.totalTax>
    </cfif>
    <cfreturn session.updateItems>
  </cffunction>

</cfcomponent>