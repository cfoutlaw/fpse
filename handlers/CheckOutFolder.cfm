<cfscript>
	username = fpServer.getUsernameOnly();

	qCheckedOutFiles = directoryList("#event.getEventData().event.ide.projectview.resource.XmlAttributes.path#", true, "query");

	checkedOutFiles = arrayNew(1);

	for (i=1;i<=qCheckedOutFiles.recordCount;i++) {
		if (qCheckedOutFiles.type[i] != "dir") {
			if (listLast(qCheckedOutFiles.name[i], ".") != username) {
				arrayAppend(checkedOutFiles, qCheckedOutFiles.directory[i] & "/" & qCheckedOutFiles.name[i]);
			}
		}
	}

	for (i=1;i<=arrayLen(checkedOutFiles);i++) {
		checkedOutFiles[i] = replace(checkedOutFiles[i], "\", "/", "ALL");
		fpServer.parseFilename(checkedOutFiles[i]);
		fpServer.checkOut();
	}

	saveContent variable="viewData" {
		writeOutput("<p>#event.getProjectName()#</p><p>Folder checked out.</p>");
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
