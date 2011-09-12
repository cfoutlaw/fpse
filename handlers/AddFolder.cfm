<cfscript>
	fpServer.addFolder(event.getFileName());
	saveContent variable="viewData" {
		writeOutput("<p>#event.getProjectName()#</p><p>Folder added</p>");
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
