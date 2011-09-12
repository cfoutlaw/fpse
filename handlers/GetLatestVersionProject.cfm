<cfscript>
	tick = getTickCount();
	username = fpServer.getUsernameOnly();

	qCheckedOutFiles = directoryList(event.getProjectLocation(), true, "query");

	checkedOutFiles = arrayNew(1);
	ext = arrayNew(1);

	for (i=1;i<=qCheckedOutFiles.recordCount;i++) {
		if (qCheckedOutFiles.type[i] != "dir" && !find("\.git", qCheckedOutFiles.directory[i]) && !find("\imaging", qCheckedOutFiles.directory[i])) {
			if (!arrayFindNoCase([username, "cp", "db", "svg", "ico", "log", "err", "config", "wpm", "old", "pdf", "wmv", "dll", "pdb", "jpg", "gif", "ach", "txt", "xml", "gitignore", "git", "png", "zip", "bak", "asa", "cab", "mlf", "swf", "project", "settings", "sql", "prefs"], listLast(qCheckedOutFiles.name[i], "."))) {
				arrayAppend(checkedOutFiles, qCheckedOutFiles.directory[i] & "\" & qCheckedOutFiles.name[i]);
				if (!arrayFindNoCase(ext, listLast(qCheckedOutFiles.name[i], "."))) {
					arrayAppend(ext, listLast(qCheckedOutFiles.name[i], "."));
				}
			}
		}
	}

	totalFiles = arrayLen(checkedOutFiles);

	writeLog("#event.getProjectName()# - #totalFiles# files remaining...", "Information", "yes", "fpExt.detail");
	tick1 = getTickCount();
	for (i=totalFiles;i>0;i--) {
		checkedOutFiles[i] = Replace(checkedOutFiles[i], "\", "/", "ALL");
		fpServer.parseFilename(checkedOutFiles[i]);
		fpServer.getLatestVersion(true);
		if (i % 50 == 0) {
			tick2 = getTickCount();
			writeLog("#event.getProjectName()# - time:#tick2-tick1# - #i# files remaining...", "Information", "yes", "fpExt.detail");
			tick1 = tick2;
		}
	}

	WriteLog("#event.getProjectName()# - 0 files remaining...", "Information", "yes", "fpExt.detail");

	/*SaveContent variable="test" {writeDump(ext);writeDump(arrayLen(checkedOutFiles));writeOutput("<br/>");WriteDump(checkedOutFiles);}*/
	saveContent variable="viewData" {
		writeOutput("<p>#event.getProjectName()#</p><p>Project updated to latest version.</p><p>time: #getTickCount()-tick#</p>");
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
