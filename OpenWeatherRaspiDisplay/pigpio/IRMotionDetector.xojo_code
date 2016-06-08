#tag Class
Protected Class IRMotionDetector
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(GpioPin as Integer)
		  mGpioPin = GpioPin
		  pigpio.Mode(GpioPin) = PigpioMode.Input
		  pigpio.PullUpValue(GpioPin) = PigpioPud.Up
		  pigpio.InterruptFunction (GpioPin, PigpioEdge.Either, 0) = addressof MotionReceiver
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 546865207374616E64617264206D6574686F6420746861742069732063616C6C6564207768656E206120627574746F6E207374617465206368616E6765732E200A55736520697420617320612074656D706C617465206F72206275696C64206120737562636C617373207468617420706572666F726D7320746865206E656365737361727920616374696F6E732E0A0A43415554494F4E21212054686973206D6574686F642072756E73206F6E2061206261636B67726F756E64207468726561642E20446F206E6F7420637265617465206F626A6563747320616E6420757365206E6F20696E7374616E6365206D6574686F64732E20596F752063616E20757365207468652065787465726E616C2070696770696F206465636C6172657320616E79776179206C696B652063616C6C204750494F77726974652831392C20616273286C6576656C2D31292920746F20696E766572742074686520627574746F6E207374617465206F6E20612050696E20746861742069732073657420746F206F75747075742E
		Protected Shared Sub MotionReceiver(GPIO As Integer, Level as Integer, Tick as Uint32)
		  #pragma StackOverflowChecking false
		  #pragma BackgroundTasks false
		  #if TargetConsole then
		    if level = 1 then
		      print "Motion detected on pin "+gpio.ToText+" at tick "+tick.ToText
		    else
		      print "Fell back to normal at pin "+gpio.ToText+" at tick "+tick.ToText
		    end if
		  #elseif TargetDesktop
		    if level = 1 then
		      System.DebugLog  "Motion detected on pin "+gpio.ToText+" at tick "+tick.ToText
		    else
		      System.DebugLog  "Fell back to normal at pin "+gpio.ToText+" at tick "+tick.ToText
		    end if
		  #endif
		  
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Read Me
		
		This is a module for infrared motion detectors like the HC-SR501. 
		It will probably work with other sensors that use one GPIO too, like the ST-00082 Mini
		
		This code is mainly from Björn Eiríksson’s Einhugur Tech blog:
		https://einhugur.com/blog/index.php/xojo-gpio/hc-sr501-sensor/
		and was only tweaked to use the MotionReceiver shared method instead of a timer poll
		(which is also not a bad idea).
		
		Best method to use this class is to subclass it and override constructor and the MotionReceiver method just like the DemoButton class does.
		
		This sensor may take a bit of time to initialize. See its documentation:
		https://www.mpja.com/download/31227sc.pdf
		
		Please note that the HC-SR501 has two potentiometers. 
		The first sets the distance ( ~3 - 7 m) and the second the delay after which the sensor resets to normal state (5–300 seconds)
		The jumper determines if the active time can be prolonged by continued movements or if the sensor will fall back in any case (default)
		
		After each change of states it will remain in that state for a period of 2,5 seconds regardless of any motion in its vicinity.
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mGpioPin
			End Get
		#tag EndGetter
		GpioPin As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mGpioPin As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="GpioPin"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
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
	#tag EndViewBehavior
End Class
#tag EndClass
