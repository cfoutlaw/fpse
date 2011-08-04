/**
  * process builder requests for FrontPage actions
  */
component
	accessors="true"
	output="false"
{

// task: add move file option

property string projectName;
property string projectDir;
property string username;
property string password;
property string projectURL;
property string filename;
property string vtiDataValid;
property numeric projectID;
property name="fileSubdir" getter="false";
property name="fpService" getter="false" setter="false";
property vti;

/**
  * hint: Initialze component
  */
public FrontPage function init(required string projectName)
	displayname="Initalize Component"
	output="false"
{
	setUsername("");
	setPassword("");
	setProjectName(arguments.projectName);
	loadProjectDetails();
	variables.fpService = new com.core.fpService(getUsername(), getPassword());
	variables.fpservice.setFrontPageURL(getProjectURL());
	return this;
}
public void function loadProjectDetails()
	output="false"
{
	var project = entityLoad("Project", {projectName='#getProjectName()#'});
	if (arrayLen(project) != 1) {
		return;
	}
	setProjectURL(project[1].getProjectURL());
	setUsername(project[1].getUsername());
	setPassword(project[1].getPassword());
	setProjectDir(project[1].getProjectDir());
	setProjectID(project[1].getProjectID());
}
public void function saveProjectDetails()
	output="false"
{
	var project = entityLoad("Project", {projectName='#getProjectName()#'}, true);
	if (isNull(project)) {
		project = entityNew("Project");
		project.setProjectName(getProjectName());
	}
	project.setProjectURL(getProjectURL());
	project.setUsername(getUsername());
	project.setPassword(getPassword());
	project.setProjectDir(getProjectDir());
	entitySave(project);
	//ormFlush();
	setProjectID(project.getProjectID());
	variables.fpService = new com.core.fpService(getUsername(), getPassword());
	variables.fpservice.setFrontPageURL(getProjectURL());
}
/**
  * Loads files and directories form FrontPage and creates any missing items in local directory.
  * @displayname Refresh Directory
  */
public any function refreshDirectory(required string directory)
	output="false"
{
	variables.fpService.createListDocMethod(arguments.directory);
	writeLog("#getProjectName()# - Getting directory list...", "Information", "yes", "fpExt.detail");
	var fpResult = variables.fpService.makeMethodCall();
	writeLog("#getProjectName()# - Updating local file system...", "Information", "yes", "fpExt.detail");
	var dirList = variables.fpService.CreateDirListArray(variables.fpService.DecodeMetaInfo(fpResult.filecontent));
	var fileList = variables.fpService.CreateDocListArray(variables.fpService.DecodeMetaInfo(fpResult.filecontent));
	var dir = "";
	var i = 0;

	writeLog("#getProjectName()# - Updating local directories...", "Information", "yes", "fpExt.detail");
	var remaining = arrayLen(dirList);
	writeLog("#getProjectName()# - #remaining# directories remaining...", "Information", "yes", "fpExt.detail");
	for (i=1;i<=arrayLen(dirList);i++) {
		if (--remaining % 50 == 0) {
			writeLog("#getProjectName()# - #remaining# directories remaining...", "Information", "yes", "fpExt.detail");
		}
		if (dirList[i].filename.filename != "") {
			dir = getProjectDir() & dirList[i].filename.subDir & dirList[i].filename.fileName;
			if (!directoryExists("#dir#")) {
				directoryCreate("#dir#");
			}
		}
	}

	var fileID = 0;

	writeLog("#getProjectName()# - Updating local files...", "Information", "yes", "fpExt.detail");
	remaining = arrayLen(fileList);

	var tickCount = getTickCount();
	var tick1 = 0;
	writeLog("#getProjectName()# - #remaining# files remaining...", "Information", "yes", "fpExt.detail");

	for (i=1;i<=arrayLen(fileList);i++) {
		if (--remaining % 50 == 0) {
			tick1 = getTickCount();
			writeLog("#getProjectName()# - totalTime:#tick1-tickCount# - #remaining# files remaining...", "Information", "yes", "fpExt.detail");
			tickCount = tick1;
		}

		setFileSubdir(fileList[i].filename.subDir);
		setFilename(fileList[i].filename.fileName);
		newFile = entityload("File", {projectID=getProjectID(), filePath=getCurrentFilePath()}, true);
		if (isNull(newFile)) {
			newFile = entityNew("File");
		}
		newFile.setProjectID(getProjectID());
		newFile.setFilePath(getCurrentFilePath());
		entitySave(newFile);
		//ormFlush();
		fileID = newFile.getFileID();
		saveVtiData(fileList[i].metaInfo, fileID);

		if (!fileExists("#getCurrentFilePath()#")) {
			fileWrite("#getCurrentFilePath()#", "", "utf-8");
			fileSetAttribute("#getCurrentFilePath()#", "readonly");
		}
	}
	writeLog("#getProjectName()# - Folder refresh complete.", "Information", "yes", "fpExt.detail");
}
private void function saveVtiData(required struct vtiData, required numeric fileID)
	displayname="Get Front Page Vti Data"
	output="false"
{
	var tick = getTickCount();
	var vti = entityLoad("vtiData", {fileID=arguments.fileID});
	if (!isNull(vti)) {
		for (var i=arrayLen(vti);i>0;i--) {
			vti[i].setVtiValue("");
			entitySave(vti[i]);
		}
	}

	for (item in vtiData) {
		var vtiEntity = entityLoad("vtiData", {fileID=arguments.fileID, vtiName=item}, true);
		if (isNull(vtiEntity)) {
			vtiEntity = entityNew("vtiData");
		}
		vtiEntity.setProjectID(getProjectID());
		vtiEntity.setFileID(arguments.fileID);
		vtiEntity.setVtiName(item);
		vtiEntity.setVtiValue(listRest(vtiData[item], "|"));
		entitySave(vtiEntity);

	}
	//writeLog("#getProjectName()# - saveVtiData Time: #getTickCount()-tick#", "Information", "yes", "fpExt.detail");
}
public string function getCurrentFilePath()
	displayname="Get Current File path"
	output="false"
{
	return replace(getProjectDir() & getFileSubdir() & getFileName(), "//", "/", "ALL");
}
public string function getFileSubDir()
	displayname="Get File Sub-Directory"
	output="false"
{
	return (variables.fileSubdir == "" ? "" : variables.fileSubdir & "/");
}
public void function parseFilename(required string filename)
	displayname="Parse Filename"
	output="false"
{
	var filePath = replaceNoCase(arguments.filename, getProjectDir(), "");
	setFilename(reverse(listFirst(reverse(arguments.filename), "/")));
	setFileSubdir(reverse(listRest(reverse(filepath), "/")));
}
public void function getLatestVersion(noLog=false)
	displayname="Get Latest Version"
	output="false"
{
	variables.fpService.createGetDocMethod(getFileSubDir() & getFilename());
	var fpResult = variables.fpService.makeMethodCall();

	try {
		var vtiData = variables.fpService.parseMetaInfo(variables.fpService.getDocument(variables.fpService.decodeMetaInfo(fpResult.filecontent)));
		var fileContent = removeBOM(variables.fpService.getDocumentContent(fpResult.filecontent));
	}
	catch (any e) {
		return;
	}

	setVti(vtiData);
	var currentFile = entityload("File", {projectID=getProjectID(), filePath=getCurrentFilePath()}, true);

	saveVtiData(vtiData, currentFile.getFileID());

	currentFile.setContent(fileContent);
	entitySave(currentFile);
	// todo: save current contents of file to file history table

	fileSetAttribute("#getCurrentFilePath()#", "normal");
	fileWrite("#getCurrentFilePath()#", fileContent, "utf-8");
	fileSetAttribute("#getCurrentFilePath()#", "readonly");
}
private string function removeBOM(required string content)
	displayname="Remove Byte Order Mark"
	output="false"
{
	var bomString = chr(239) & chr(187) & chr(191);

	if (left(arguments.content, 3) == bomString) {
		return right(arguments.content, len(arguments.content)-3);
	}
	return arguments.content;
}
private boolean function isCheckedOut(required numeric fileID)
	output="false"
{
	var vtiEntity = entityLoad("vtiData", {projectID=getProjectID(), fileID=arguments.fileID, vtiName="vti_sourcecontrolcheckedoutby"}, true);
	if (isNull(vtiEntity)) {
		return false;
	}
	return vtiEntity.getVtiValue() != "";
}
public string function getCheckedOutBy(required numeric fileID)
	displayname=""
	output="false"
{
	var vtiEntity = entityLoad("vtiData", {projectID=getProjectID(), fileID=arguments.fileID, vtiName="vti_sourcecontrolcheckedoutby"}, true);
	if (isNull(vtiEntity)) {
		return "";
	}
	return listLast(vtiEntity.getVtiValue(), "\");
}
public string function getTimeLastModified(required numeric fileID)
	displayname=""
	output="false"
{
	var vtiEntity = entityLoad("vtiData", {projectID=getProjectID(), fileID=arguments.fileID, vtiName="vti_timelastmodified"}, true);
	if (isNull(vtiEntity)) {
		return "";
	}
	return vtiEntity.getVtiValue();
}
public string function getUsernameOnly()
	displayname=""
	output="false"
{
	return reverse(listFirst(reverse(getUsername()), "\"));
}
public void function checkOut()
	displayname="Check Out"
	output="false"
{
	variables.fpService.createGetDocMethod(getFileSubDir() & getFilename());
	var fpResult = variables.fpService.makeMethodCall();
	var vtiData = variables.fpService.parseMetaInfo(variables.fpService.getDocument(variables.fpService.decodeMetaInfo(fpResult.filecontent)));

	var currentFile = entityload("File", {projectID=getProjectID(), filePath=getCurrentFilePath()}, true);

	saveVtiData(vtiData, currentFile.getFileID());
	setVti(vtiData);

	if (isCheckedOut(currentFile.getFileID())) {
		return;
	}

	variables.fpService.createGetDocMethod(getFileSubDir() & getFilename(), true);
	fpResult = variables.fpService.makeMethodCall();
	vtiData = variables.fpService.parseMetaInfo(variables.fpService.getDocument(variables.fpService.decodeMetaInfo(fpResult.filecontent)));
	var fileContent = removeBOM(variables.fpService.getDocumentContent(fpResult.filecontent));

	saveVtiData(vtiData, currentFile.getFileID());
	setVti(vtiData);
	// todo: use vti data to set correct charset for file
	fileSetAttribute("#getCurrentFilePath()#", "normal");
	fileWrite("#getCurrentFilePath()#", fileContent, "utf-8");
	fileWrite("#getCurrentFilePath()#.#getUsernameOnly()#", fileContent, "utf-8");
}
public void function addFile()
	displayname="Add File"
	output="false"
{
	var fileContents = fileRead("#GetCurrentFilePath()#");
	// todo: save archive of file contnents.
	variables.fpService.createAddDocMethod(getFileSubDir() & getFilename(), fileContents);
	var fpResult = variables.fpService.makeMethodCall();
	var vtiData = variables.fpService.parseMetaInfo(variables.fpService.getDocument(variables.fpService.decodeMetaInfo(fpResult.filecontent)));

	var currentFile = entityNew("File");
	currentFile.setProjectID(getProjectID());
	currentFile.setFilePath(getCurrentFilePath());
	currentFile.setContent(fileContents);
	entitySave(currentFile);

	saveVtiData(vtiData, currentFile.getFileID());
	setVti(vtiData);

}
public void function addFolder(required string directory)
	displayname="Add Folder"
	output="false"
{
	variables.fpService.createAddFolderMethod(arguments.directory);
	var fpResult = variables.fpService.makeMethodCall();
}
public void function CheckIn()
	displayname="Check In"
	output="false"
{
	putFile(true);

	variables.fpService.createUncheckoutMethod(getFileSubDir() & getFilename());
	var fpResult = variables.fpService.makeMethodCall();
	var vtiData = variables.fpService.parseMetaInfo(variables.fpService.getMetaInfo(variables.fpService.decodeMetaInfo(fpResult.filecontent)));

	var currentFile = entityload("File", {projectID=getProjectID(), filePath=getCurrentFilePath()}, true);

	setVti(vtiData);

	saveVtiData(vtiData, currentFile.getFileID());

	fileSetAttribute("#getCurrentFilePath()#", "readonly");

	if (fileExists("#getCurrentFilePath()#.#getUsernameOnly()#")) {
		fileDelete("#getCurrentFilePath()#.#getUsernameOnly()#");
	}
}
public void function putFile(boolean isCheckIn="false")
	displayname="Put File"
	output="false"
{
	var fileContents = fileRead("#getCurrentFilePath()#");
	var currentFile = entityload("File", {projectID=getProjectID(), filePath=getCurrentFilePath()}, true);

	if (getCheckedOutBy(currentFile.getFileID()) != getUsernameOnly()) {
		return;
	}
	currentFile.setContent(fileContents);
	entitySave(currentFile);

	variables.fpService.createPutDocMethod(getFileSubDir() & getFilename(), getTimeLastModified(currentFile.getFileID()), fileContents);
	var fpResult = variables.fpService.makeMethodCall();
	var vtiData = variables.fpService.parseMetaInfo(variables.fpService.getDocument(variables.fpService.decodeMetaInfo(fpResult.filecontent)));

	setVti(vtiData);

	saveVtiData(vtiData, currentFile.getFileID());

	// todo: log archive of file.
}

}
