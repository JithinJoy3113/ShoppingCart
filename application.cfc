<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.sessionManagement = true>
    
    <cffunction  name="onApplicationStart" returnType="void">
        <cfset application.dataSource = "cartDatasource">
        <cfset application.obj = createObject("component", "Components.shoppingCart")>
<!---         <cfset application.secretKey = generateSecretKey("AES")>  --->
    </cffunction>

     <cffunction  name="onRequestStart" returnType="void">
        <cfset onApplicationStart()>

        <!--- <cfargument  name="requestPage" required="true"> 

        <cfset local.pages = {1:["/jithin/ShoppingCart/ShoppingCart/admin.cfm","/jithin/ShoppingCart/ShoppingCart/user.cfm"],
                              2:["/jithin/ShoppingCart/ShoppingCart/home.cfm"]}>
        <cfset local.excludePages = ["/jithin/ShoppingCart/ShoppingCart/userLogin.cfm","/jithin/ShoppingCart/ShoppingCart/userSignUp.cfm"]> 

        <cfif ArrayContains(local.excludePages,arguments.requestPage)>
            <cfinclude  template="#arguments.requestPage#">         
        <cfelseif structKeyExists(session, "login") AND session.login EQ true AND ArrayContains(local.pages[session.role],arguments.requestPage)>
            <cfinclude  template="#arguments.requestPage#">
        <cfelse>
            <cfset structClear(session)>
            <cfinclude  template="userLogin.cfm">
        </cfif> --->
    </cffunction>

    <cffunction  name = "onRequest">
        <cfargument  name = "requestPage" required = "true"> 
        <cfinclude  template = "header.cfm">
        <cfinclude  template = "#arguments.requestPage#">
        <cfinclude  template = "footer.cfm">
    </cffunction>
    
 </cfcomponent>