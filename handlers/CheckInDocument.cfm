<cfscript>
	fpServer.parseFilename(event.getFullFileName());
	fpServer.checkIn();
	saveContent variable="viewData" {
		writeDump("<p>#event.getProjectName()#</p><p>file checked in</p>");
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
			<toolbarcontributions>
				<toolbaritem icon="finAdjust.png" handlerid="viewstart" />
			</toolbarcontributions>
		</view>
		<body>
			<![CDATA[#viewData#]]>
		</body>
	</ide>
</response>
</cfoutput>
