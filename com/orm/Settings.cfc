component
	persistent="true"
	table="Settings"
	schema="APP"
	output="false"
{
	/* properties */

	property name="settingID" column="settingsID" type="numeric" ormtype="int" fieldtype="id" generator="increment";
	property name="defaultURL" column="defaultURL" type="string" ormtype="string";
	property name="defaultUsername" column="defaultUsername" type="string" ormtype="string";
	property name="defaultPassword" column="defaultPassword" type="string" ormtype="string";
}
