<cfscript>
	username = fpServer.GetUsernameOnly();

	qCheckedOutFiles = directoryList("#event.getEventData().event.ide.projectview.resource.XmlAttributes.path#", true, "query");

	checkedOutFiles = arrayNew(1);

	for (i=1;i<=qCheckedOutFiles.recordCount;i++) {
		if (qCheckedOutFiles.type[i] != "dir") {
			if (!arrayFind([username, "jpg", "gif", "ach", "txt", "xml", "gitignore", "git", "png", "zip", "bak", "asa", "cab", "mlf", "swf"], ListLast(qCheckedOutFiles.name[i], "."))) {
				arrayAppend(checkedOutFiles, qCheckedOutFiles.directory[i] & "/" & qCheckedOutFiles.name[i]);
			}
		}
	}
	tick = getTickCount();
	for (i=1;i<=arrayLen(checkedOutFiles);i++) {
		checkedOutFiles[i] = replace(checkedOutFiles[i], "\", "/", "ALL");
		fpServer.parseFilename(checkedOutFiles[i]);
		fpServer.getLatestVersion();
	}

	saveContent variable="viewData" {
		writeOutput("<p>#event.getProjectName()#</p><p>Folder update to latest version.</p><p>time: #getTickCount()-tick#</p>");
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
		</view>
		<body>
			<![CDATA[#viewData#]]>
		</body>
	</ide>
</response>
</cfoutput>
