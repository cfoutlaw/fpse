﻿<cfscript>
	fpServer.parseFilename(event.getFullFileName());
	fpServer.addFile();
	saveContent variable="viewData" {
		writeOutput("
			<p>#event.getProjectName()#</p>
			<p>#event.getFileName()# added.</p>");
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
		</commands>
		<view id="fpseView" title="FrontPage">
		</view>
		<body>
			<![CDATA[#viewData#]]>
		</body>
	</ide>
</response>
</cfoutput>
