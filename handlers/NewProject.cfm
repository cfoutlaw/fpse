<cfscript>
	defaultUsername = "idmi\wilson";
</cfscript>


<cfheader name="Content-Type" value="text/xml">
<response status="success" type="default" showresponse="true">
	<ide handlerfile="CreateProject.cfm">
		<dialog height="350" width="465" title="Open Web Site">
			<input name="fpURL" label="URL:" type="string" default=".ptsapp.com" />
			<input name="fpPassword" label="Password:" type="password" />
			<input name="fpUsername" label="Username:" type="string" default="<cfoutput>#defaultUsername#</cfoutput>" />
		</dialog>
	</ide>
</response>
