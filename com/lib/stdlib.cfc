component
	extends="com.lib.stdlibns"
	output="false"
{

/**
  * Use this function to decrypt data that was encrypted using the encrypt data function.
  * @displayname Decrypt Data
  * @author Michael Wilson
  * @createdate 12/13/2010
  */
public string function decryptData(required string encryptedData)
	output="false"
{
	var key = left(arguments.encryptedData, 96);
	var data = replace(arguments.encryptedData, key, "");

	return decrypt(data, key);
}
/**
  * Use this function to encrypt data.
  * @displayname Encrypt Data
  * @author Michael Wilson
  * @createdate 12/13/2010
  */
public string function encryptData(required string decryptedData, string hData="")
	output="false"
{
	var hashdata = rand() & arguments.hData;
	var key = hash(hashdata, "SHA-384", "UTF-8");
	var data = encrypt(arguments.decryptedData, key);
	return key & data;
}

}