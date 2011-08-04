<cfscript>
	saveContent variable="viewData" {
		writeOutput("CheckInProject2 needs to be completed.");
	}
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response showresponse="true">
	<ide>
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
<cfabort>
<cfsetting requesttimeout="#5*60#">
<cfscript>
	fpServer = new com.FrontPage(projectName, projectLocation);
	username = fpServer.getUsernameOnly();

	checkedOutFiles = directoryList(projectLocation, true, "path", "*.wilson");

	for (i=1;i<=arrayLen(checkedOutFiles);i++) {
		checkedOutFiles[i] = replace(checkedOutFiles[i], "\", "/", "ALL");
		checkedOutFiles[i] = replace(checkedOutFiles[i], ".a.#username#", "");
		checkedOutFiles[i] = replace(checkedOutFiles[i], "mike.wilson", "[{m.w}]");
		checkedOutFiles[i] = replace(checkedOutFiles[i], ".#username#", "");
		checkedOutFiles[i] = replace(checkedOutFiles[i], "[{m.w}]", "mike.wilson");
		fpServer.parseFilename(checkedOutFiles[i]);
		fpServer.checkIn();
	}
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response showresponse="true">
	<ide>
		<commands>
			<command type="refreshProject">
				<params>
					<param key="projectname" value="#projectName#" />
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
