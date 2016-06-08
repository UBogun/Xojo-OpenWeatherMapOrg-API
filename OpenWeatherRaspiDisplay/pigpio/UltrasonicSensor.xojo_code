#tag Class
Protected Class UltrasonicSensor
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(TriggerPin as Integer, SensorPin as Integer)
		  mTriggerPin = TriggerPin
		  mSensorPin = SensorPin
		  pigpio.Mode(TriggerPin)= PigpioMode.Output
		  pigpio.DigitalValue(TriggerPin) = false
		  pigpio.Mode(SensorPin) = PigpioMode.Input
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4C657473207468652073656E736F7220706572666F726D206F6E65206D65737572656D656E742E2052657475726E732074686520726573756C7420696E20636D206F72202D3120696620746865206D6561737572656D656E74206661696C65642E0A596F752063616E20646566696E65207468652063757272656E74206169722074656D706572617475726520666F72206D6F726520616363757261746520726573756C74732E
		Function MeasureDistance(AirTempCelsius as Double = 20.0) As double
		  dim StartTime, EndTime as Uinteger
		  pigpio.DigitalValue(mTriggerPin) = true
		  call pigpio.Delay(10)
		  pigpio.DigitalValue(mTriggerPin) = false
		  
		  while pigpio.DigitalValue(mSensorPin) = false
		    // wait for low level
		  wend
		  StartTime = pigpio.Tick
		  while pigpio.DigitalValue(mSensorPin) = true
		    // wait for high level
		  wend
		  EndTime = pigpio.Tick
		  pigpio.DigitalValue(mTriggerPin) = false
		  Dim timeDelta as UInteger = (endTime - startTime)
		  
		  dim speedOfSound as double = 331.5 + (0.6 * AirTempCelsius)
		  return if(timeDelta >= 20000, -1, timeDelta * 0.000001* (SpeedOfSound / 2) * 100) // * 100 to get it in cm
		  
		  
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 4669726573207768656E20746F6F206D616E79206D6561737572656D656E747320696E206120726F77206661696C65642E0A557365204572726F72546F6C6572616E636520746F2073657420746869732076616C75652E
		Event Error()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 4669726573207768656E20746F6F206D616E79206D6561737572656D656E747320696E206120726F77206661696C65642E0A557365204572726F72546F6C6572616E636520746F2073657420746869732076616C75652E
		Event MeasureResult(Distance as Double)
	#tag EndHook


	#tag Note, Name = Read me
		Again, the code to read this sensor was taken from Einhugur’s Tech Blog.
		See https://einhugur.com/blog/index.php/xojo-gpio/hc-sr04-ultrasonic-sensor/ for wiring and important resistors!
		
		I included a bad result check and taking air temperatur into account.
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private mSensorPin As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTriggerPin As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mSensorPin
			End Get
		#tag EndGetter
		SensorPin As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mTriggerPin
			End Get
		#tag EndGetter
		TriggerPin As Integer
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SensorPin"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TriggerPin"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
