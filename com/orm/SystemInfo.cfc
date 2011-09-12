component
	persistent="true"
	table="SystemInfo"
	output="false"
{
	/* properties */
	property name="systemInfoID" column="systemInfoID" type="numeric" ormtype="int" fieldtype="id" generator="increment";
	property name="setting" column="setting" type="string";
	property name="value" column="value" type="string";
}
