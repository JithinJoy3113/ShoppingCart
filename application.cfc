<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.sessionManagement = true>

    <cffunction name="onError">
        <cfargument name="Exception" required=true>
        <cfargument type="String" name="EventName" required=true>
        <cflog file="#This.Name#" type="error"
        text="Event Name: #Arguments.Eventname#" >
        <cflog file="#This.Name#" type="error"
        text="Message: #Arguments.Exception.message#">
        <cfif NOT (Arguments.EventName IS "onSessionEnd") OR
        (Arguments.EventName IS "onApplicationEnd")>
            <cfoutput>
                <h2>An unexpected error occurred.</h2>
                <p>Please provide the following information to technical support:</p>
                <p>Error Event: #Arguments.EventName#</p>
                <p>Error details:<br>
                <cfdump var=#Arguments.Exception#></p>
            </cfoutput>
        </cfif>
    </cffunction>
    
    <cffunction  name="onApplicationStart" returnType="void">
        <cfset application.dataSource = "cartDatasource">
        <cfset application.obj = createObject("component", "Components.shoppingCart")>
        <!--- <cfset application.secretKey = generateSecretKey("AES")>  --->
    </cffunction>

     <cffunction  name="onRequestStart" returnType="boolean">
        <cfargument  name="requestPage" required="true">
            <cfset onApplicationStart()>
            <cfset local.excludePages = ["/login.cfm","/userSignUp.cfm"]> 
            <cfif ArrayContains(local.excludePages,arguments.requestPage)>
                <cfif arguments.requestPage EQ '/userSignUp.cfm'>
                    <cfset structClear(session)>
                </cfif>
                <cfreturn true>
            <cfelseif structKeyExists(session, "role") AND session.roleId EQ 1 AND arguments.requestPage EQ '/admin.cfm'>
                <cfreturn true>
            <cfelseif (NOT structKeyExists(session, "role") OR (structKeyExists(session, "role") AND session.roleId EQ 2)) AND arguments.requestPage NEQ '/admin.cfm'>
                <cfreturn true>
            <cfelseif (structKeyExists(session, "role") AND session.roleId EQ 1) AND NOT ArrayContains(local.excludePages,arguments.requestPage)>
                <cflocation  url="/login.cfm">
            </cfif>
    </cffunction>

    <cffunction  name = "onRequest"  returnType = "void">
        <cfargument  name = "requestPage" required = "true"> 
        <cfinclude  template = "header.cfm">
        <cfinclude  template = "#arguments.requestPage#">
        <cfinclude  template = "footer.cfm">
    </cffunction>

    
 </cfcomponent>