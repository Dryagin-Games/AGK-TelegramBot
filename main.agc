
// Simple Telegram Bot Example

#Option_Explicit
SetErrorMode(2)
SetWindowTitle("TelegramBot")
SetWindowSize(640, 480, 0)
SetSyncRate(30, 0)

token As String = "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11" // unique authentication token
delay As Float = 3.0 // delay between updates

Type ChatType
	id As String
EndType

Type MessageType
	chat As ChatType
	text As String
EndType

Type UpdateType
	update_id As Integer
	_message As MessageType
EndType

Type ResponseType
	ok As Integer
	result As UpdateType []
	error_code As Integer
	description As String
EndType

http As Integer
response As ResponseType
offset As Integer

http = CreateHTTPConnection()
SetHTTPHost(http, "api.telegram.org", 1)

Repeat
	If Timer() => delay
		response.FromJSON(SendHTTPRequest(http, "bot" + token + "/getUpdates", "offset=" + Str(offset) + "&allowed_updates=["+Chr(34)+"message"+Chr(34)+"]"))
		If response.ok
			While response.result.length => 0
				SendHTTPRequest(http, "bot" + token + "/sendMessage", "chat_id=" + response.result[0]._message.chat.id + "&text=" + response.result[0]._message.text)
				If response.result[0].update_id => offset Then offset = response.result[0].update_id + 1
				response.result.Remove(0)
			EndWhile
		Else
			Message("Error " + Str(response.error_code) + Chr(10) + response.description)
			End
		EndIf
		ResetTimer()
	EndIf
	Print("Press ESC to exit...")
	Print(offset)
	Print(ScreenFPS())
	Print(Timer())
	Sync()
Until GetRawKeyPressed(27)

CloseHTTPConnection(http)
DeleteHTTPConnection(http)
