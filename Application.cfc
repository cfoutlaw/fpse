/**
  * displayname Application
  * author Michael Wilson
  * createdate 12/13/2010
  */
component
	accessors="true"
	output="false"
{

this.customTagPaths = getDirectoryFromPath(getCurrentTemplatePath());

this.name = left("FPSEv2" & hash(getCurrentTemplatePath()), 20);
this.sessionManagement = true;
this.SetClientCookies = true;
this.sessionTimeout = createTimeSpan(0,0,59,0);
this.ormenabled = "true";
this.datasource = "fpse";
//this.ormsettings = {autorebuild="true", dbcreate="dropcreate"};

/**
  * Sets default data when application starts
  * @displayname onApplicationStart
  * @author Michael Wilson
  * @createdate 03/03/2011
  */
public string function onApplicationStart()
	output="false"
{
}

/**
  * Handles request event
  * @displayname On Request
  * @author Michael Wilson
  * @createdate 12/13/2010
  */
public void function onRequest(string targetPage)
{
	//applicationStop();
	//ormReload();
	stdlib = new com.lib.stdlib();

	stdlib.setContentType();
	stdlib.setRequestTimeOut();
	stdlib.setShowDebugOutput(false);
	stdlib.setContentType();

	event = new com.lib.Event();

	if (structKeyExists(form, "ideeventinfo")) {
		event.setEventData(form.ideeventinfo);
	}

	fpServer = new com.core.FrontPage(event.getProjectName());

	fpServer.setProjectDir(event.getProjectLocation());
	fpServer.parseFilename(event.getFullFileName());

	include arguments.targetPage;
}

}