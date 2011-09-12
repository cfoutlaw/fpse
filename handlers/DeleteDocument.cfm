<cfscript>
	saveContent variable="viewData" {
		writeOutput("DeleteDocument needs to be completed.");
	}
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response showresponse="true">
	<ide>
		<view id="fpseView" title="FrontPage">
		</view>
		<body>
			<![CDATA[#viewData#]]>
		</body>
	</ide>
</response>
</cfoutput>
<cfabort>
<cfscript>
	fpServer = new com.FrontPage(projectName, projectLocation);
	fpServer.ParseFilename(fullFileName);
	fpServer.DeleteFile();
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response>
	<ide>
		<commands>
			<command type="refreshProject">
				<params>
					<param key="projectname" value="#projectName#" />
				</params>
			</command>
		</commands>
	</ide>
</response>
</cfoutput>
