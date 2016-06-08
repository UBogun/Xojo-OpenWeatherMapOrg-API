#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  print "pigpgio initialzed, revision "+pigpio.Initialise.ToText
		  Print "Caution!"
		  Print "This app expects a LCDDisplay connected to SignalPin 25, EnablePin 24, D4Pin 23, d5Pin 17, D6Pin 21 and D7Pin 22"
		  Print "Continue (Y/N)?"
		  dim response as string = input
		  if response = "y" then 
		    
		    setupLCD
		    
		    
		    DisplayUpdateTimer = new xojo.Core.Timer
		    AddHandler DisplayUpdateTimer.action, Addressof DisplayUpdate
		    DisplayUpdateTimer.Period = 1000
		    DisplayUpdateTimer.Mode = xojo.core.timer.Modes.Multiple
		    // 
		    WeatherPollTimer = new xojo.Core.Timer
		    AddHandler WeatherPollTimer.action, Addressof pollCurrentWeather
		    WeatherPollTimer.Period = 900000 // 15 min.
		    WeatherPollTimer.Mode = xojo.core.timer.modes.Multiple
		    pollCurrentWeather(new xojo.core.timer)
		    // 
		    while true
		      app.DoEvents
		    wend
		  end if
		  #pragma unused args
		  
		End Function
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  try
		    pigpio.Terminate
		  end try
		  print "The app must quit because of an exception "+error.ErrorNumber.ToText
		  print error.Reason
		  quit
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub DisplayUpdate(t as xojo.core.timer)
		  dim time as new Date
		  dim curloc as xojo.Core.Locale = xojo.core.Locale.Current
		  dim loc as text= "00"
		  dim datestring as string = time.GermanAbbrvWeekDay+","+Time.Day.ToText(curloc, loc)+"."+time.Month.ToText(curloc, loc)+"."+ _
		  "  "+time.Hour.ToText(curloc, loc) + _
		  if (ShowSeconds, ":", " ")+time.Minute.ToText(curloc, loc)
		  ShowSeconds = not ShowSeconds
		  Display.SetMessage(datestring, 1)
		  if CurrentWeather <> nil then
		    DisplayUpdateCounter = DisplayUpdateCounter +1
		    if DisplayUpdateCounter >=3 then
		      dim secondaryline as string
		      dim clearline as string = "                "
		      DisplayUpdateCounter = 0
		      SecondaryDisplayCount = SecondaryDisplayCount +1
		      select case SecondaryDisplayCount
		      case 0
		        secondaryline = "Wetter um "+CurrentWeather.DataTime.ToText (curloc, xojo.core.date.FormatStyles.None, xojo.core.date.FormatStyles.Short)
		      case 1
		        secondaryline = CurrentWeather.CityName.totext
		      case 2,3
		        secondaryline = CurrentWeather.Temperature.ToText(curloc, "+##.##")+ " °C"
		      case 4
		        secondaryline = "Wind "+ CurrentWeather.WindSpeedkmH.ToText(curloc, "##.##")+" km/h"
		      case 5
		        secondaryline ="Wind aus "+ CurrentWeather.WindDirection.ToText(curloc, "###.#")+ "°"
		      case 6
		        secondaryline = "Luftdr. "+CurrentWeather.Pressure.ToText(curloc, "####")+" hPa"
		      case 7
		        secondaryline = "Feuchtigk. "+CurrentWeather.Humidity.ToText(curloc, "###")+"%"
		      case 8
		        secondaryline = "Bewölkung "+CurrentWeather.Cloudiness.ToText(curloc, "###")+ "%"
		      case 9
		        secondaryline = "Sonnenauf. "+CurrentWeather.Sunrise.ToText(curloc, xojo.core.date.FormatStyles.none, xojo.core.date.FormatStyles.Short)
		      case 10
		        secondaryline = "Sonnenunt. "+CurrentWeather.Sunset.ToText(curloc, xojo.core.date.FormatStyles.none, xojo.core.date.FormatStyles.Short)
		      case 11
		        secondaryline = "Tagesl."+CurrentWeather.DayLight.Hours.ToText(curloc, "##")+":"+CurrentWeather.DayLight.Minutes.ToText(curloc, "@@")+":"+ _
		        CurrentWeather.DayLight.Seconds.ToText(curloc, "##")
		      case 12
		        SecondaryDisplayCount = -1
		      end select
		      Display.SetMessage (clearline, 2)
		      system.debuglog  secondaryline
		      Display.SetMessage(secondaryline, 2)
		    end if
		  end if
		  
		  #pragma unused t
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub pollCurrentWeather(t as xojo.core.timer)
		  dim curweather as OpenWeatherData = OpenWeather.GetCurrentWeather(LocationID, API_ID, _
		  "units=metric", "lang=de")
		  
		  // Berlin = id 7290255
		  if curweather <> nil then CurrentWeather = curweather
		  
		  #pragma unused t
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub setupLCD()
		  // Display text on 4-line LCD
		  
		  Const kRSPin = 25
		  Const kEPin = 24
		  Const kD4Pin = 23
		  Const kD5Pin = 17
		  Const kD6Pin = 21
		  Const kD7Pin = 22
		  
		  Display = New pigpio.LCDDisplay_HD44780(kRSPin, kEPin, kD4Pin, kD5Pin, kD6Pin, kD7Pin)
		  
		  Display.Clear
		  Display.Home
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private CurrentWeather As OpenWeatherData
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Display As pigpio.LCDDisplay_HD44780
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DisplayUpdateCounter As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected DisplayUpdateTimer As xojo.Core.Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SecondaryDisplayCount As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ShowSeconds As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected WeatherPollTimer As xojo.Core.Timer
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
