<cfscript>
	saveContent variable="viewData" {
		writeOutput("DeleteFolder needs to be completed.");
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
	folderPath = ReplaceNoCase("#event.getEventData().event.ide.projectview.resource.XmlAttributes.path#", projectlocation, "");

	qCheckedOutFiles = DirectoryList("#event.getEventData().event.ide.projectview.resource.XmlAttributes.path#", true, "query");

	if (qCheckedOutFiles.recordCount == 0) {
		fpServer.deleteFolder(folderPath);
	} else {
		SaveContent variable="test" {WriteOutput("A folder must be empty inorder to delete it from the server.<br />");WriteDump(qCheckedOutFiles);}
	}
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response showresponse="true">
	<ide>
		<commands>
			<command type="refreshProject">
				<params>
					<param key="projectname" value="#event.getProjectName()#" />
				</params>
			</command>
		</commands>

		<cfif isDefined("test")>
		<dialog width="800" height="400" />
		<body>
			<![CDATA[#test#]]>
		</body>
		</cfif>
	</ide>
</response>
</cfoutput>
