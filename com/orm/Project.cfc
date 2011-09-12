component
	persistent="true"
	table="Project"
	output="false"
{
	/* properties */

	property name="projectID" column="projectID" type="numeric" ormtype="int" fieldtype="id" generator="increment";
	property name="projectURL" column="projectURL" type="string" ormtype="string";
	property name="username" column="username" type="string" ormtype="string";
	property name="password" column="password" type="string" ormtype="string";
	property name="projectName" column="projectName" type="string" ormtype="string" unique="true";
	property name="projectDir" column="projectDir" type="string" ormtype="string";
}
