Function Send-ChatBotMessage
{
<#
	.SYNOPSIS
		Create 1:1 personal conversation.

	.PARAMETER Token
		Access token from Get-ChatBotToken.

	.PARAMETER ConversationId
		Conversation id.

	.PARAMETER Message
		Message to send.

	.PARAMETER Attachments
		JSON Attachment objects that defines additional information to include in the message. For example adaptive card.

	.EXAMPLE
		Send-ChatBotMessage -Token $Token -ConversationId $ConversationId -Message "New message"

	.NOTES
		Author: Michal Gajda

	.LINK
		https://learn.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#send-to-conversation
#>
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true)]
		[String]$Token,
		[Parameter(Mandatory = $true)]
		[String]$ConversationId,
		[Parameter(ParameterSetName = 'Message', Mandatory = $true)]
		[String]$Message,
		[Parameter(ParameterSetName = 'Attachments', Mandatory = $true)]
		[Parameter(ParameterSetName = 'Message')]
		[Hashtable]$Attachments
	)

	#Set token in authorization header
	$Headers = @{
		Authorization = "Bearer $($Token)"
	}

	#Build message body
	$ServiceUrl = "https://smba.trafficmanager.net/teams/v3/conversations/$ConversationId/activities"
	$Body = @{
		type = 'message'
		conversation = @{
			id = $ConversationId
		}
	}

	if($Message) { $Body['text'] = $Message }
	if($Attachments) { $Body['attachments'] = @($Attachments) }

	#Send message
	$MessageParams = @{
		Uri         = $ServiceUrl
		Method      = 'POST'
		Body        = $Body | ConvertTo-Json -Depth 15
		ContentType = 'application/json;charset=utf-8'
		Headers     = $Headers
		ErrorAction = "Stop"
	}

	$Response = Invoke-RestMethod @MessageParams

	Return $Response.Id
}
