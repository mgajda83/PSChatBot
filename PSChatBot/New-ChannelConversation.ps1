Function New-ChannelConversation
{
<#
	.SYNOPSIS
		Create teams channel conversation.

	.PARAMETER Token
		Access token from Get-ChatBotToken.

	.PARAMETER TenantId
		Tenant id.

	.PARAMETER TeamId
		Team id.

	.PARAMETER ChannelId
		Channel id.

	.PARAMETER BotId
		ClientId of Bot Application from Entra ID.

	.PARAMETER Message
		The initial message to send to the conversation when it's created.

	.PARAMETER Attachments
		The initial attachmet to send to the conversation when it's created.

	.EXAMPLE
		$ConversationId = New-ChannelConversation -Token $Token -TenantId $TenantId -TeamId $TeamId -ChannelId $ChannelId -BotId $BotId -Message "New conversation"

	.NOTES
		Author: Michal Gajda

	.LINK
		https://learn.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#create-conversation
#>
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true)]$Token,
		[Parameter(Mandatory = $true)]$TenantId,
		[Parameter(Mandatory = $true)]$TeamId,
		[Parameter(Mandatory = $true)]$ChannelId,
		[Parameter(Mandatory = $true)]$BotId,
		[Parameter(ParameterSetName = 'Message', Mandatory = $true)]
		[String]$Message,
		[Parameter(ParameterSetName = 'Attachments', Mandatory = $true)]
		[Hashtable]$Attachments
	)

	#Set token in authorization header
	$Headers = @{
		Authorization = "Bearer $($Token)"
	}

	#Build conversation body
	$ServiceUrl = "https://smba.trafficmanager.net/teams/v3/conversations"
	$Body = [Ordered]@{
		activity = @{
			type = "message"
		}
		bot = @{
			id = $BotId
		}
		channelData = @{
			channel = @{
				id = $ChannelId
			}
			team = @{
				id = $TeamId
			}
			tenant = @{
				id = $TenantId
			}
		}
		isGroup = $true
		tenantId = $TenantId
	}
	if($Message) { $Body['activity']['text'] = $Message }
	if($Attachments) { $Body['activity']['attachments'] = @($Attachments) }

	#Create conversation
	$ConversationParams = @{
		Uri         = $ServiceUrl
		Method      = "POST"
		Body        = $Body | ConvertTo-Json -Depth 15
		ContentType = "application/json;charset=utf-8"
		Headers     = $Headers
		ErrorAction = "Stop"
	}
	$Response = Invoke-RestMethod @ConversationParams

	Return $Response.Id
}

New-Alias -Name "Send-ChatBotChannelMessage" New-ChannelConversation
