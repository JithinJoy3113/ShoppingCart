<cfcomponent>
  <cfset this.name = "shoppingCart">
  <cfset this.sessionManagement = true>

<!---   <cffunction name = "onError">
    <cfargument name = "Exception" required = true>
    <cfargument type = "String" name = "EventName" required = true>
    <cflocation url = "error.cfm?Exception=#arguments.Exception#&EventName=#arguments.EventName#">
    <cfabort>
  </cffunction>
 --->
  <cffunction name="onMissingTemplate">
    <cfargument name="targetPage" type="string" required=true/>
    <cflog type="error" text="Missing template: #Arguments.targetPage#">
    <cflocation url = "error.cfm?page=#arguments.targetPage#">
  </cffunction>
  
  <cffunction  name="onApplicationStart" returnType="void">
    <cfset application.dataSource = "cartDatasource">
    <cfset application.obj = createObject("component", "Components.shoppingCart")>
    <cfset application.secretKey = "ga054hPJQYlv0YXpu4ZMIg==">
  </cffunction>

   <cffunction  name = "onRequestStart" returnType = "boolean">
    <cfargument  name = "requestPage" required = "true">
      <cfset onApplicationStart()>
      <cfset local.excludePages = ["/login.cfm","/userSignUp.cfm","/error.cfm","/Components/shoppingCart.cfc"]> 
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
    <cfif structKeyExists(session, "updateItems") AND arguments.requestPage NEQ '/order.cfm'>
        <cfset StructDelete(session, "updateItems")>
    </cfif>
    <cfif arguments.requestPage EQ '/error.cfm'>
      <cfinclude  template = "#arguments.requestPage#">
    <cfelse>
      <cfinclude  template = "header.cfm">
      <cfinclude  template = "#arguments.requestPage#">
      <cfinclude  template = "footer.cfm">
    </cfif>
  </cffunction>

 </cfcomponent>