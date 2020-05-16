# Powershell telegram bot beta, v2020-05-15
# Telegram bot | https://core.telegram.org/bots
# Poshgram | https://github.com/techthoughts2/PoshGram

# Your telegram bot Chat ID and Token
$MyToken = ""
$ChatID = 

# Start date
Write-Host "Powershell Bot start:" $(get-date -f yyyy-MM-dd)

# infinite loop
while (1 -eq 1 ) {
    $LastMessageID_previous = $LastMessageID_temp

    $MyBotUpdates = Invoke-WebRequest -Uri "https://api.telegram.org/bot$($MyToken)/getUpdates"
    # Convert the result from json and put them in an array
    $jsonresult = [array]($MyBotUpdates | ConvertFrom-Json).result

    $LastMessage = ""
    Foreach ($Result in $jsonresult)  {
        If ($Result.message.chat.id -eq $ChatID)  {
            $LastMessage = $Result.message.text
            $LastMessageID = $Result.message.message_id
            $LastMessageDate = $result.message.date
    }
    }

    Write-Host "Last message:" $LastMessage
    Write-Host "Last message time:" $LastMessageDate
    Write-Host "Last message ID:" $LastMessageID
    Write-Host "Previous last message ID:" $LastMessageID_previous
    
    if ($LastMessageID_previous -ne $LastMessageID) {
        
        $LastMessageID_temp = $LastMessageID 

        if ($LastMessage -eq "/start") {
# Send message
Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message "Telegram bot commands:
/start - list commands
/hello - Hello msg
/uptime - Pc uptime
/vpnstart - Start VPN
/vpnstop - Stop VPN"
# waiting 1 sec
Start-Sleep -s 1
        } 
        elseif ($LastMessage -eq "/hello") {
            # Send message
            Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message "Helló, I am SzreverBot!"
            Start-Sleep -s 1
        }
        else {
                # Send message
                Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message "Mag-ház online"
                Start-Sleep -s 1
            }
        } 
        elseif ($LastMessage -eq "/uptime") {
            Write-Host "Pc Uptime.."
            $uptime = $null
            $uptime = @()
            $uptime = (get-date) - (gcim Win32_OperatingSystem).LastBootUpTime
            $uptime_msg = "Uptime: $uptime"
            # Send message
            Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message $uptime_msg
            Start-Sleep -s 1
        } 
        elseif ($LastMessage -eq "/vpnstart") {
            Write-Host "VPN Start wait ~ 50sec"
            # Send message
            Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message "VPN starting.."
            Start-Process "C:\Program Files (x86)\OpenVPN Technologies\OpenVPN Client\OpenVpn.exe"
            # wait 50 sec
            Start-Sleep -s 50
            Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message "VPN start OK!"
            Start-Sleep -s 1
        } 
        elseif ($LastMessage -eq "/vpnstop") {
            Write-Host "VPN Stop ~ 30sec"
            # Send message
            Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message "VPN stop.."
            Stop-Process -name  'OpenVpn' -Force
            # wait 30 sec
            Start-Sleep -s 30
            Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message "VPN stop OK!"
            Start-Sleep -s 1
        }
        else {
            Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message "The bot does not understand the command"
            Start-Sleep -s 1
        }
    }
}
