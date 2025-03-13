Function Get-ChatBotToken
{
<#
	.SYNOPSIS
		Generate access token for bot.

	.PARAMETER TenantId
		Tenant id.

	.PARAMETER BotId
		ClientId of Bot Application from Entra ID.

	.PARAMETER Secret
		Secret of Bot Application from Entra ID.

	.EXAMPLE
		$Token = Get-ChatBotToken -TenantId $TenantId -BotId $BotId -Secret $Secret

	.NOTES
		Author: Michal Gajda

	.LINK
		https://learn.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-authentication?view=azure-bot-service-4.0&tabs=multitenant#bot-to-connector
#>
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true)]$TenantId,
		[Parameter(Mandatory = $true)]$BotId,
		[Parameter(Mandatory = $true)]$Secret
	)

	$AuthUrl = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"

	$Payload = @{
		grant_type    = 'client_credentials'
		client_id     = $BotId
		client_secret = $Secret
		scope         = 'https://api.botframework.com/.default'
	}
	$Response = Invoke-RestMethod -Uri $AuthUrl -Method POST -Body $Payload

	Return $Response.access_token
}
