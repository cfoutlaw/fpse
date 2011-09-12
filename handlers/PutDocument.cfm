<cfscript>
	fpServer.parseFilename(event.getFullFileName());
	fpServer.putFile();
	saveContent variable="viewData" {
		writeOutput("<p>#event.getProjectName()#</p><p>file posted to server.</p>");
	}
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response showresponse="true">
	<ide>
		<commands>
			<command type="refreshFile">
				<params>
					<param key="filename" value="#fpServer.GetCurrentFilePath()#" />
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
