/**
  * Manages and processes event info
  * @displayname Event
  * @author Michael Wilson
  * @createdate 12/13/2010
  */
component
	accessors="true"
	output="false"
{


property eventData; // This will be an XML document object
property string projectLocation;
property string projectName;
property struct userData;
property string fileName;
property string fullFileName;
property string eventType;


/**
  * Ensures eventData is a valid XML document object.
  * @displayname Set eventData
  * @author Michael Wilson
  * @createdate 12/13/2010
  */
public void function setEventData(required string eventXML)
	output="false"
{
	if (!isXML(arguments.eventXML)) {
		throw("fpse.event", "application", "eventXML is not a valid XML string");
	}

	variables.userData = structNew();

	variables.eventData = xmlParse(arguments.eventXML);
	parseInput();

	if (structKeyExists(getEventData().event.ide, "editor")) {
		setProjectLocation(getEventData().event.ide.editor.file.XmlAttributes.projectlocation & "/");
		setFileName(getEventData().event.ide.editor.file.XmlAttributes.projectrelativelocation);
		setFullFileName(getProjectlocation & getFileName);
		setProjectName(getEventData().event.ide.editor.file.xmlAttributes.project);
	} else if (structKeyExists(getEventData().event.ide, "projectview")) {
		setProjectLocation(getEventData().event.ide.projectview.XmlAttributes.projectlocation & "/");
		setFileName(replaceNoCase("#getEventData().event.ide.projectview.resource.XmlAttributes.path#", getProjectlocation(), ""));
		setFullFileName(getEventData().event.ide.projectview.resource.XmlAttributes.path);
		setProjectName(getEventData().event.ide.projectview.xmlAttributes.projectname);
		setEventType(eventData.event.ide.projectview.resource.XmlAttributes.type);
		if (getEventType() == "project") {
			setFileName("");
		}
	} else if (structKeyExists(getEventData().event.ide, "eventinfo")) {
		setProjectLocation(getEventData().event.ide.eventinfo.xmlAttributes.projectLocation & "/");
		setProjectName(getEventData().event.ide.eventinfo.xmlAttributes.projectname);
	} else {
		setProjectLocation("");
		setFileName("");
		setFullFileName("");
		setProjectName("");
	}
}
/**
  * Parse User Input
  * @displayname parseInput
  * @author Michael Wilson
  * @createdate 12/13/2010
  */
public any function parseInput()
	output="false"
{
	var extXMLInput = xmlSearch(getEventData(), "/event/user/input");

	for(var i=1;i<=arrayLen(extXMLInput);i++) {
		structInsert(variables.userData, extXMLInput[i].xmlAttributes.name, extXMLInput[i].xmlAttributes.value);
	}
}
public void function setUserData(required string keyName, required any value)
	output="false"
{
	structInsert(variables.userData, arguments.keyName, arguments.value, true);
}
public any function getUserData(required string keyName)
	output=false
{
	if (structKeyExists(variables.userData, arguments.keyName)) {
		return structFind(variables.userData, arguments.keyName);
	}
	return "";
}

}