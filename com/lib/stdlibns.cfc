<cfcomponent output="false">
	<cffunction name="setContentType" access="public" output="false" hint="">
		<cfcontent type="text/html; charset=UTF-8">
	</cffunction>

	<cffunction name="setRequestTimeOut" access="public" output="false" hint="">
		<cfsetting requesttimeout="600">
	</cffunction>

	<cffunction name="setShowDebugOutput" access="public" output="false" hint="">
		<cfargument name="showDebugOutput" type="boolean" default="false">

		<cfsetting showDebugOutput="#showDebugOutput#">
	</cffunction>
</cfcomponent>