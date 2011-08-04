<cfscript>
	username = fpServer.getUsernameOnly();

	checkedOutFiles = directoryList("#event.getEventData().event.ide.projectview.resource.XmlAttributes.path#", true, "path", "*.#username#");

	for (i=1;i<=ArrayLen(checkedOutFiles);i++) {
		checkedOutFiles[i] = Replace(checkedOutFiles[i], "\", "/", "ALL");
		checkedOutFiles[i] = Replace(checkedOutFiles[i], ".a.#username#", "");
		checkedOutFiles[i] = Replace(checkedOutFiles[i], "mike.wilson", "[{m.w}]");
		checkedOutFiles[i] = Replace(checkedOutFiles[i], ".#username#", "");
		checkedOutFiles[i] = Replace(checkedOutFiles[i], "[{m.w}]", "mike.wilson");
		fpServer.parseFilename(checkedOutFiles[i]);
		fpServer.checkIn();
	}

	saveContent variable="viewData" {
		writeOutput("<p>#event.getProjectName()#</p><p>Folder checked in.</p>");
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
