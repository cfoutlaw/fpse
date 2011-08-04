component
	accessors="true"
	output="false"
{

property string username;
property string password;
property string frontPageURL;
property string entryPoint;
property string methodType;
property string userAgent;
property string currentMethod;
property string currentContentType;

/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public fpService function init(required string username, required string password)
{
	setUsername(arguments.username);
	setPassword(arguments.password);
	setEntryPoint("_vti_bin/_vti_aut/author.dll");
	setMethodType("post");
	setUserAgent("MSFrontPage/12.0");
	setCurrentContentType("application/x-vermeer-urlencoded");
	return this;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public void function encodeMethod()
	output="false"
{
	// task: change this to return the endoded method, also pass the string to be encoded into the function.
	setCurrentMethod(replace(replace(replace(urlEncodedFormat(getCurrentMethod()), "%20", "+", "ALL"), "%26", "&", "ALL"), "%3D", "=", "ALL"));
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public string function decodeMetaInfo(required string fpMetaInfo)
	output="false"
{
	var metaInfo = arguments.fpMetaInfo;

	metaInfo = replaceNoCase(metaInfo, "<p>", "&", "ALL");
	metaInfo = replaceNoCase(metaInfo, chr(10) & "<ul>" & chr(10) & "<li>", "[", "ALL");
	metaInfo = replaceNoCase(metaInfo, chr(10) & "<ul>", "[", "ALL");
	metaInfo = replaceNoCase(metaInfo, chr(10) & "</ul>", "]", "ALL");
	metaInfo = replaceNoCase(metaInfo, chr(10) & "<li>", chr(7), "ALL");
	metaInfo = replaceNoCase(metaInfo, "&##92;", "\", "ALL");
	metaInfo = replaceNoCase(metaInfo, "&##61;", "=", "ALL");
	metaInfo = replaceNoCase(metaInfo, "&##59;", ";", "ALL");
	metaInfo = replaceNoCase(metaInfo, "&##38;", "&", "ALL");

	return metaInfo;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public string function getDocumentList(required string fpResult)
	output="false"
{
	var docListTag = "&document_list=[";
	var startPos = findNoCase(docListTag, arguments.fpResult, 1) + len(docListTag);
	var tagLength = findNoCase("]]]", arguments.fpResult, startPos) - startPos + 2;

	// task: check startPos and tagLength for valid values.
	var docList = mid(arguments.fpResult, startPos, tagLength);
	docList = replaceNoCase(docList, "=[", "={", "ALL");
	docList = replaceNoCase(docList, "]]", "}]", "ALL");
	return docList;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public string function getDocument(required string fpResult)
	output="false"
{
	var docListTag = "&document=[";
	var startPos = findNoCase(docListTag, arguments.fpResult, 1) + len(docListTag);
	var tagLength = findNoCase("]]", arguments.fpResult, startPos) - startPos + 2;

	// task: check startPos and tagLength for valid values.
	var docList = mid(arguments.fpResult, startPos, tagLength);
	docList = replaceNoCase(docList, "=[", "={", "ALL");
	docList = replaceNoCase(docList, "]]", "", "ALL");
	return docList;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public string function getMetaInfo(required string fpResult)
	output="false"
{
	var docListTag = "&meta_info=[";
	var startPos = findNoCase(docListTag, arguments.fpResult, 1);
	var tagLength = findNoCase("]", arguments.fpResult, startPos) - startPos;

	// task: check startPos and tagLength for valid values.
	var docList = chr(7) & mid(arguments.fpResult, startPos, tagLength);
	return docList;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public string function getDocumentContent(required string fpResult)
	output="false"
{
	headerArray = reMatchNoCase("<html>.+</html>#chr(10)#", arguments.fpResult);
	// task: validate headerArray has only one item in it
	header = headerArray[1];
	return replace("#arguments.fpResult#", "#header#", "");
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public string function getDirectoryList(required string fpResult)
	output="false"
{
	var docListTag = "&urldirs=[";
	var startPos = findNoCase(docListTag, arguments.fpResult, 1) + len(docListTag);
	var tagLength = findNoCase("]]]", arguments.fpResult, startPos) - startPos + 2;

	// task: check startPos and tagLength for valid values.
	var docList = mid(arguments.fpResult, startPos, tagLength);
	docList = replaceNoCase(docList, "=[", "={", "ALL");
	docList = replaceNoCase(docList, "]]", "}]", "ALL");
	return docList;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public array function createDocListArray(required string fpResult)
	output="false"
{
	var docList = getDocumentList(arguments.fpResult);
	var reMatchArray = reMatchNoCase("\[document_name=[^\]]+\]", docList);
	docListArray = arrayNew(1);
	for (var i=1;i<=arrayLen(reMatchArray);i++) {
		reMatchArray[i] = replace(replace(reMatchArray[i], "]", ""), "[document_name=", "");
		docListArray[i] = structNew();
		docListArray[i]["fileName"] = parseFileName(reMatchArray[i]);
		docListArray[i]["metaInfo"] = parseMetaInfo(reMatchArray[i]);
	}
	return docListArray;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public array function createDirListArray(required string fpResult)
	output="false"
{
	var docList = getDirectoryList(arguments.fpResult);
	var reMatchArray = reMatchNoCase("\[url=[^\]]+\]", "#docList#");
	var docListArray = arrayNew(1);
	for (var i=1;i<=arrayLen(reMatchArray);i++) {
		reMatchArray[i] = replace(replace(reMatchArray[i], "]", ""), "[url=", "");
		docListArray[i] = structNew();
		docListArray[i]["fileName"] = parseFileName(reMatchArray[i]);
		docListArray[i]["metaInfo"] = parseMetaInfo(reMatchArray[i]);
	}
	return docListArray;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public struct function parseFilename(required string docListItem)
	output="false"
{
	var length = find(chr(7), arguments.docListItem) ? find(chr(7), arguments.docListItem)-1 : len(arguments.docListItem);
	var filename = length ? left(arguments.docListItem, length) : "";
	var fileInfo = structNew();
	if (filename == "") {
		fileInfo.filename = "";
		fileInfo.subDir = "";
	} else {
		fileInfo.filename = reverse(listFirst(reverse(filename), "/"));
		fileInfo.subDir = reverse(listRest(reverse(filename), "/"));
		fileInfo.subDir &= len(fileInfo.subDir) != 0 ? "/" : "";
	}

	return fileInfo;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public struct function parseMetaInfo(required string docListItem)
	output="false"
{
	var metaInfoStruct = structNew();

	var length = find("#chr(7)#meta_info=", arguments.docListItem);
	if (length) {
		length += len("#chr(7)#meta_info=");
		var metaInfo = replace(arguments.docListItem, left(arguments.docListItem, length), "");
		var metaInfoArray = listToArray(metaInfo, chr(7), true);
		metaInfoStruct = structNew();

		for (var i=1;i<=arrayLen(metaInfoArray);i+=2) {
			metaInfoStruct[metaInfoArray[i]] = metaInfoArray[i+1];
		}
	}
	return metaInfoStruct;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public struct function makeMethodCall()
	output="false"
{
	var fpService = new http();
	fpService.addParam(type="header", name="Content-Type", value="#getCurrentContentType()#");
	fpService.addParam(type="header", name="X-Vermeer-Content-Type", value="#getCurrentContentType()#");
	fpService.addParam(type="body", value="method=#getCurrentMethod()#");
	fpService.setMethod(getMethodType());
	fpService.setUsername(getUsername());
	fpService.setPassword(getPassword());
	fpService.setUseragent(getUserAgent());
	fpService.setUrl("#getFrontPageURL()#/#getEntryPoint()#");
	var result = fpService.send().getPrefix();
//	SaveContent variable="resultText" {WriteOutput(result.filecontent);}
//	WriteLog("#resultText#", "information", "yes", "fpExt.fp.response");

	return result;
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public void function createListDocMethod(required string directory)
	output="false"
{
	var method = "list documents";
	method &= "&folderList=[" & arguments.directory & ";]";
	method &= "&initialUrl=" & arguments.directory;
	method &= "&listBorders=false";
	method &= "&listChildWebs=false";
	method &= "&listDerived=false";
	method &= "&listFiles=true";
	method &= "&listFolders=true";
	method &= "&listHiddenDocs=false";
	method &= "&listIncludeParent=false";
	method &= "&listLinkInfo=false";
	method &= "&listRecurse=true";
	method &= "&listThickets=false";

	setCurrentMethod(method);
	setCurrentContentType("application/x-www-form-urlencoded");
	setEntryPoint("_vti_bin/_vti_aut/author.dll");
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public void function createGetDocMethod(required string filename, boolean checkout=false)
	output="false"
{
	var getOption = "";
	var timeout = "";

	if (arguments.checkout) {
		getOption = "chkoutExclusive";
		timeout = "43200";
	} else {
		getOption = "none";
		timeout = "0";
	}

	var method = "get document";
	method &= "&document_name=/" & arguments.fileName;
	method &= "&get_option=" & getOption;
	method &= "&timeout=" & timeout;

	setCurrentMethod(method);
	setCurrentContentType("application/x-www-form-urlencoded");
	setEntryPoint("_vti_bin/_vti_aut/author.dll");
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public void function createPutDocMethod(required string filename, required string timeLastMod, required string fileContent)
	output="false"
{
	var method = "put document";
	method &= "&document=";
	method &= "[";
	method &= "document_name=/";
	method &= arguments.fileName;
	method &= ";";
	method &= "meta_info=";
	method &= "[vti_timelastmodified;" & arguments.timeLastMod & "]";
	method &= "]";
	method &= "&put_option=edit";
	method &= "&comment=";
	method &= "&keep_checked_out=false";
	method &= chr(10);
	method &= arguments.fileContent;

	setCurrentMethod(method);
	setCurrentContentType("application/x-vermeer-urlencoded");
	setEntryPoint("_vti_bin/_vti_aut/author.dll");
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public void function createUncheckoutMethod(required string filename)
	output="false"
{
	var method = "uncheckout document";
	method &= "&document_name=/";
	method &= arguments.fileName;
	method &= "&force=false";
	method &= "&rlsshortterm=true";

	setCurrentMethod(method);
	setCurrentContentType("application/x-www-form-urlencoded");
	setEntryPoint("_vti_bin/_vti_aut/author.dll");
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public void function createAddDocMethod(required string filename, required string fileContent)
	output="false"
{
	var method = "put document";
	method &= "&document=";
	method &= "[";
	method &= "document_name=/";
	method &= arguments.fileName;
	method &= ";";
	method &= "meta_info=[]]";
	method &= "&put_option=edit";
	method &= "&comment=";
	method &= "&keep_checked_out=false";
	method &= chr(10);
	method &= arguments.fileContent;

	setCurrentMethod(method);
	setCurrentContentType("application/x-www-form-urlencoded");
	setEntryPoint("_vti_bin/_vti_aut/author.dll");
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public void function createRemoveDocMethod(required string filename)
	output="false"
{
	var method = "remove documents";
	method &= "&url_list=";
	method &= "[";
	method &= arguments.fileName;
	method &= "]";

	setCurrentMethod(method);
	setCurrentContentType("application/x-www-form-urlencoded");
	setEntryPoint("_vti_bin/_vti_aut/author.dll");
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public void function createAddFolderMethod(required string filename)
	output="false"
{
	var method = "create url-directories";
	method &= "&urldirs=[[url=";
	method &= arguments.fileName;
	method &= ";meta_info=[]]]";

	setCurrentMethod(method);
	setCurrentContentType("application/x-www-form-urlencoded");
	setEntryPoint("_vti_bin/_vti_aut/author.dll");
}
/**
  *
  * @displayname init
  * @author Michael Wilson
  *
  */
public void function createDeleteFolderMethod(required string filename)
	output="false"
{
	var method = "remove documents";
	method &= "&url_list=";
	method &= "[";
	method &= arguments.fileName;
	method &= "]";

	setCurrentMethod(method);
	setCurrentContentType("application/x-www-form-urlencoded");
	setEntryPoint("_vti_bin/_vti_aut/author.dll");
}

}