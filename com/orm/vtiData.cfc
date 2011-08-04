component
	persistent="true"
	table="vtiData"
	schema="APP"
	output="false"
{
	/* properties */
	property name="vtiDataID" column="vtiDataID" type="numeric" ormtype="int" fieldtype="id" generator="increment";
	property name="projectID" column="projectID" type="numeric" ormtype="int";
	property name="fileID" column="fileID" type="numeric" ormtype="int";
	property name="vtiName" column="vtiName" type="string" ormtype="string";
	property name="vtiValue" column="vtiValue" type="string" sqltype="varchar(max)";
}
