component
	persistent="true"
	table="FileHistory"
	output="false"
{
	/* properties */

	property name="fileHistoryID" column="fileHistoryID" type="numeric" ormtype="int" fieldtype="id" generator="increment";
	property name="projectID" column="projectID" type="numeric" ormtype="int";
	property name="fileID" column="fileID" type="numeric" ormtype="int";
	property name="content" column="content" type="string" sqltype="varchar(max)";
}
