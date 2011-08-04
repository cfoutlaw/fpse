<cfscript>
	saveContent variable="viewData" {
		writeOutput("Checkedoutfilelist needs to be completed.");
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
	checkedOutFiles = DirectoryList(projectLocation, true, "path", "*.wilson");

	myfile = FileOpen("C:\ColdFusion9\logs\FrontPage.log", "append");
	currentTime = dateFormat(Now(), "mm/dd/yyyy") & " " & TimeFormat(now(), "full");
	FileWriteLine(myfile, currentTime);
	fileWriteLine(myFile, "");
	fileWriteLine(myFile, projectName);

	for (i=1;i<=15;i++) {
		if (i <= arraylen(checkedOutFiles)) {
			curFile = replace(checkedOutFiles[i], "\", "/", "all");
			curFile = replace(curFile, projectLocation, "");
			curFile = replace(curFile, ".a.wilson", "");
			curFile = replace(curFile, ".wilson", "");
			fileWriteLine(myFile, " - " & curFile);
		} else {
			fileWriteLine(myFile, "");
		}
	}

	FileWriteLine(myfile, "");

	if (arrayLen(checkedOutFiles) == 0) {
		fileWriteLine(myfile, "No files currently checked out.");
	} else if (arrayLen(checkedOutFiles) <= 15) {
		fileWriteLine(myfile, "All checked out files listed.");
	} else {
		fileWriteLine(myfile, arrayLen(checkedOutFiles)-15 & " files checked out but not listed.");
	}
	FileWriteLine(myfile, "-----------------------------------------------");

	FileClose(myfile);
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response>
	<ide>
	</ide>
</response>
</cfoutput>
