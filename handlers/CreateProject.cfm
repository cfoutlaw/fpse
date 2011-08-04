<cfscript>
	if (!findNoCase("http://", event.getUserData("fpURL"), 1) && !findNoCase("https://", event.getUserData("fpURL"), 1)) {
		event.setUserData("fpURL", "http://" & event.getUserData("fpURL"));
	}

	fpServer.setProjectURL(event.getUserData("fpURL"));
	fpServer.setUsername(event.getUserData("fpUsername"));
	fpServer.setPassword(event.getUserData("fpPassword"));
	fpServer.setProjectDir(event.getProjectLocation());
	fpServer.saveProjectDetails();
	fpServer.refreshDirectory("");

	saveContent variable="viewData" {
		writeOutput("<p>#event.getProjectName()#</p><p>Project created.</p>");
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
