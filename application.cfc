<cfcomponent>
    
    <cfset this.name = 'this.cart'>
    <cfset this.sessionManagement = true>
    <cfset this.datasource = "cartDatasource">
    
    <!--- <cffunction  name="onRequest" returnType="void">

        <cfargument  name="requestPage" required="true"> 

        <cfset local.pages = {1:["/jithin/coldfusion/qstn-28/admin.cfm","/jithin/coldfusion/qstn-28/add.cfm"],
                              2:["/jithin/coldfusion/qstn-28/user.cfm"]}>
        <cfset local.excludePages = ["/jithin/coldfusion/qstn-28/signup.cfm","/jithin/coldfusion/qstn-28/login.cfm"]> 

        <cfif ArrayContains(local.excludePages,arguments.requestPage)>
            <cfinclude  template="#arguments.requestPage#">         
        <cfelseif structKeyExists(session, "login") AND session.login EQ true AND ArrayContains(local.pages[session.role],arguments.requestPage)>
            <cfinclude  template="#arguments.requestPage#">
        <cfelse>
            <cfset structClear(session)>
            <cfinclude  template="login.cfm">
        </cfif>
    </cffunction> --->
 </cfcomponent>