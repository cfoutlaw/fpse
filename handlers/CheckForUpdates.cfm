<cfscript>
	httpService = new http();
	httpService.setMethod("get");
	httpService.setCharset("utf-8");
	httpService.setTimeout(10);
	httpService.setUrl("http://fpse.cfoutlaw.com/getLatestVersion/?version=0.1.0");

	result = httpService.send().getPrefix();

	saveContent variable="viewData" {
		version = objectLoad(toBinary(result.fileContent));
		writeDump(version);
	}
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response showresponse="true">
	<ide>
		<view id="fpseView" title="FrontPage">
		</view>
		<body>
			<![CDATA[#viewData#]]>
		</body>
	</ide>
</response>
</cfoutput>
