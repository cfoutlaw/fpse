<cfscript>
	fpServer.parseFilename(event.getFullFileName());

	fpServer.getLatestVersion();
	currentFile = entityload("File", {projectID=fpServer.getProjectID(), filePath=fpServer.getCurrentFilePath()}, true);

	saveContent variable="viewData" {
		writeOutput("<p>#event.getProjectName()#:<br /><b>#event.getFileName()#</b><br />has been updated to the latest server version.</p>");
	}
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response showresponse="true">
	<ide>
		<commands>
			<command type="refreshFile">
				<params>
					<param key="filename" value="#fpServer.getCurrentFilePath()#" />
				</params>
			</command>
			<command type="refreshProject">
				<params>
					<param key="projectname" value="#event.getProjectName()#" />
				</params>
			</command>
		</commands>
		<view id="fpseView" title="FrontPage">
		</view>
		<body>
			<![CDATA[#viewData#]]>
		</body>
	</ide>
</response>
</cfoutput>
