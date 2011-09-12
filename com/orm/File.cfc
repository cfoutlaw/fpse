component
	persistent="true"
	table="File"
	output="false"
{
	/* properties */

	property name="fileID" column="fileID" type="numeric" ormtype="int" fieldtype="id" generator="increment";
	property name="projectID" column="projectID" type="numeric" ormtype="int";
	property name="filepath" column="filepath" type="string" ormtype="string" sqltype="varchar(2000)";
	property name="content" column="content" type="string" sqltype="varchar(max)";
}
