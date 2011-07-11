﻿[CmdletBinding()]
param( 
	[Parameter(ValueFromPipeline=$true)] 
	[string]
	# the path to a test fixture data file; defaults to ./splunk.fixture.ps1
	$fixtureFilePath = './splunk.fixture.ps1',
	
	[Parameter()] 
	[string]
	# the pattern of fixtures to run
	$filter = "*.Tests.*"
	
)

Import-Module Pester;
Import-Module ../Splunk;

try
{
	$local:root = $MyInvocation.myCommand.Path | Split-Path;
	. "$local:root/_testfunctions.ps1";

	if( Test-Path $fixtureFilePath )
	{
		$script:fixture = & $fixtureFilePath;
	}

	reset-connection $script:fixture;
	Invoke-Pester -fixture $script:fixture -filepattern $filter 
}
finally
{
	remove-Module Pester;
	remove-Module Splunk;
}