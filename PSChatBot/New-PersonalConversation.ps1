Function New-PersonalConversation
{
	<#
	.SYNOPSIS
		Create 1:1 personal conversation.

	.PARAMETER Token
		Access token from Get-ChatBotToken.

	.PARAMETER TenantId
		Tenant id.

	.PARAMETER BotId
		ClientId of Bot Application from Entra ID.

	.PARAMETER MemberId
		ObjectId of recipient.

	.EXAMPLE
		$ConversationId = New-PersonalConversation -Token $Token -TenantId $TenantId -BotId $BotId -MemberId $MemberId

	.NOTES
		Author: Michal Gajda

	.LINK
		https://learn.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#create-conversation
#>
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true)]$Token,
		[Parameter(Mandatory = $true)]$TenantId,
		[Parameter(Mandatory = $true)]$BotId,
		[Parameter(Mandatory = $true)]$MemberId
	)

	#Set token in authorization header
	$Headers = @{
		Authorization = "Bearer $($Token)"
	}

	#Build conversation body
	$ServiceUrl = "https://smba.trafficmanager.net/teams/v3/conversations"
	$Body = [Ordered]@{
		bot = @{
			id = $BotId
		}
		isGroup = $false
		members = @(
			@{
				id = $MemberId
			}
		)
		tenantId = $TenantId
	}

	#Create conversation
	$ConversationParams = @{
		Uri         = $ServiceUrl
		Method      = "POST"
		Body        = $Body | ConvertTo-Json
		ContentType = "application/json;charset=utf-8"
		Headers     = $Headers
		ErrorAction = "Stop"
	}
	$Response = Invoke-RestMethod @ConversationParams

	Return $Response.Id
}
