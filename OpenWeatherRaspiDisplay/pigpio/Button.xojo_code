#tag Class
Protected Class Button
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(GpioPin as Integer)
		  mGpioPin = GpioPin
		  pigpio.Mode(GpioPin) = PigpioMode.Input
		  pigpio.PullUpValue(GpioPin) = PigpioPud.Up
		  pigpio.InterruptFunction (GpioPin, PigpioEdge.Either, 0) = addressof PressReceiver
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 546865207374616E64617264206D6574686F6420746861742069732063616C6C6564207768656E206120627574746F6E207374617465206368616E6765732E200A55736520697420617320612074656D706C617465206F72206275696C64206120737562636C617373207468617420706572666F726D7320746865206E656365737361727920616374696F6E732E0A0A43415554494F4E21212054686973206D6574686F642072756E73206F6E2061206261636B67726F756E64207468726561642E20446F206E6F7420637265617465206F626A6563747320616E6420757365206E6F20696E7374616E6365206D6574686F64732E20596F752063616E20757365207468652065787465726E616C2070696770696F206465636C6172657320616E79776179206C696B652063616C6C204750494F77726974652831392C20616273286C6576656C2D31292920746F20696E766572742074686520627574746F6E207374617465206F6E20612050696E20746861742069732073657420746F206F75747075742E
		Protected Shared Sub PressReceiver(GPIO As Integer, Level as Integer, Tick as Uint32)
		  #pragma StackOverflowChecking false
		  
		  #if TargetConsole then
		    print "Button on Pin "+gpio.ToText+" changed to level "+level.ToText+" at tick "+tick.ToText
		  #elseif TargetDesktop
		    System.DebugLog  "Button on Pin "+gpio.ToText+" changed to level "+level.ToText+" at tick "+tick.ToText
		  #endif
		  
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Read Me
		
		In theory, a button should be pulled down and its state should get high when its a normal Close-on-press switch.
		The button I tested didn’t like that. 
		He became sensitive to capacities around (like my finger without touching it) or stopped responding completely.
		
		It worked reliable with a PullUp-Resistor, but then the state came in reversed.
		If the demo should not work ith your set-up, try a different pullUpDown resistor setting and maybe don’t invert the level.
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
