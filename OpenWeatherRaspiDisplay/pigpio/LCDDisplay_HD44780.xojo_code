#tag Class
Protected Class LCDDisplay_HD44780
	#tag Method, Flags = &h0, Description = 436C656172732074686520646973706C61792E
		Sub Clear()
		  SendByte(kClearDisplay)
		  pigpio.Sleep(0, 3000)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(RSgpioPin as Integer, EnablegpioPin as Integer, D4Pin as Integer, D5Pin as Integer, D6Pin as Integer, D7Pin as Integer, DisplayRows as Integer = 4, CharactersinRow as Integer = 16)
		  #If TargetARM And TargetLinux Then
		    // Saving the pins
		    mRSPin = RSgpioPin
		    mEnablePin = EnablegpioPin
		    mD4Pin = D4Pin
		    md5pin = d5pin
		    md6pin = d6Pin
		    md7pin= d7Pin
		    Rows = DisplayRows
		    CharactersPerRow = Charactersinrow
		    
		    if max(D4Pin, D5Pin, D6Pin, D6Pin) < 32 then // Creating a pin bitmask if all datapins are classic GPIOPins (0-31)
		      datapinsbitmask = SetBit (datapinsbitmask, d4pin)
		      datapinsbitmask = SetBit (datapinsbitmask, d5pin)
		      datapinsbitmask = SetBit (datapinsbitmask, d6pin)
		      datapinsbitmask = SetBit (datapinsbitmask, d7pin)
		    end if
		    
		    Setup
		  #else
		    PigpioErrorCheck
		    #pragma unused RSgpioPin
		    #pragma unused EnablegpioPin
		    #pragma unused D4Pin
		    #pragma unused D5Pin
		    #pragma unused D6Pin
		    #pragma unused D7Pin
		    #pragma unused DisplayRows
		    #pragma Unused CharactersinRow
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ConvertUmlauts(msg as String) As String
		  // I couldn’t find a conversion that produced the correct German characters.
		  // Hence a very quick & dirty one; feel free to add (or create a better solution)
		  
		  return msg.Replaceall("ö", chr(&hef)).Replaceall("ä", chr(&he1)).ReplaceAll("ü", chr(&hF5)).ReplaceAll("ß",chr(&he2)).ReplaceAll("°", chr(&hdf))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4D6F7665732074686520637572736F7220746F2074686520686F6D6520706F736974696F6E2028746F70206C6566742C20757375616C6C7929
		Sub Home()
		  SendByte(kReturnHome)
		  pigpio.Sleep(0, 3000)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PulseEnable()
		  // Pulse the enable pin: OFF->ON->OFF
		  pigpio.DigitalValue(mEnablePin) = false
		  call pigpio.Delay(5)
		  pigpio.DigitalValue(mEnablePin) = true
		  call pigpio.Delay(5)
		  pigpio.DigitalValue(mEnablePin) = false
		  call pigpio.Delay(5)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363726F6C6C732074686520646973706C6179206C65667420776974686F7574206368616E67696E67207468652052414D
		Sub ScrollDisplayLeft()
		  
		  
		  SendByte(Bitwise.BitOr(kCursorShift, kDisplayMove, kMoveLeft))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363726F6C6C732074686520646973706C617920726967687420776974686F7574206368616E67696E67207468652052414D
		Sub ScrollDisplayRight()
		  // Scrolls the display right without changing the RAM
		  
		  SendByte(Bitwise.BitOr(kCursorShift, kDisplayMove, kMoveRight))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendByte(bits As Integer, mode As Boolean = False)
		  // Sends a byte to the LCD by splitting it into 
		  pigpio.DigitalValue(mRSPin) = mode
		  
		  setAllDataPins(false)
		  
		  pigpio.DigitalValue(mD4Pin) = Bitwise.BitAnd(bits, &h10) = &h10
		  pigpio.DigitalValue(mD5Pin) = Bitwise.BitAnd(bits, &h20) = &h20
		  pigpio.DigitalValue(mD6Pin) = Bitwise.BitAnd(bits, &h40) = &h40 
		  pigpio.DigitalValue(mD7Pin) = Bitwise.BitAnd(bits, &h80) = &h80
		  
		  PulseEnable
		  
		  setAllDataPins (false)
		  
		  pigpio.DigitalValue(mD4Pin) = Bitwise.BitAnd(bits, &h01) = &h01
		  pigpio.DigitalValue(mD5Pin) = Bitwise.BitAnd(bits, &h02) = &h02
		  pigpio.DigitalValue(mD6Pin) = Bitwise.BitAnd(bits, &h04) = &h04 
		  pigpio.DigitalValue(mD7Pin) = Bitwise.BitAnd(bits, &h08) = &h08
		  
		  PulseEnable
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5365747320746865203420646174612070696E73206174206F6E636520746F206F6E65206469676974616C2076616C75652E
		Private Sub setAllDataPins(value as Boolean)
		  if datapinsbitmask > 0 then
		    if value then 
		      pigpio.SetBits_0_31(datapinsbitmask)
		    else
		      pigpio.ClearBits_0_31(datapinsbitmask)
		    end if
		  else
		    pigpio.DigitalValue(mD4Pin) = value
		    pigpio.DigitalValue(mD5Pin) = value
		    pigpio.DigitalValue(mD6Pin) = value
		    pigpio.DigitalValue(mD7Pin) = value
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 446973706C61797320612074657874206F6E2061206C696E652E2020446F6573206E6F7420636865636B20666F72206F766572666C6F7720746578742E
		Sub SetMessage(msg As string, line As Integer = 1)
		  Select Case line
		  Case 1
		    line = kLine1
		  Case 2
		    line = kLine2
		  Case 3
		    line = kLine3
		  Case 4
		    line = kLine4
		  Else
		    line = kLine1
		  End Select
		  
		  SendByte(line)
		  dim msgstring as String = convertUmlauts(msg)
		  Dim chars() As String = msgstring.Split("")
		  
		  'Dim maxWidth As Integer = Min(chars.Ubound, kCharWidth-1)
		  Dim maxWidth As Integer = chars.Ubound
		  
		  For i As Integer = 0 To maxWidth
		    SendByte(chars(i).Asc, True)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496E697469616C697A65732074686520646973706C61792E
		Private Sub SetUp()
		  pigpio.Mode(mRSPin) = PigpioMode.Output
		  pigpio.Mode(mEnablePin) = PigpioMode.Output
		  pigpio.Mode(mD4Pin) = PigpioMode.Output
		  pigpio.Mode(MD5Pin) = PigpioMode.Output
		  pigpio.Mode(mD6Pin) = PigpioMode.Output
		  pigpio.Mode(mD7Pin) = PigpioMode.Output
		  
		  // i2cHandle = pigpio.i2cOpen(1, &h27)
		  
		  SendByte(&h33) // 110011 Initialise
		  SendByte(&h32) // 110010 Initialise
		  SendByte(&h06) // 000110 Cursor move direction
		  SendByte(&h0C) // 001100 Display On,Cursor Off, Blink Off
		  SendByte(&h28) // 101000 Data length, number of lines, font size
		  SendByte(&h01) // 000001 Clear display
		End Sub
	#tag EndMethod


	#tag Note, Name = ReadMe
		
		This is a class for controlling typical LCD displays based on a Hitachi HD44780 curcuit – basically most of all.
		Most of the code is completely stolen from Paul Lefebvres https://github.com/xojo/GPIO repository and only slightly modified.
		Only included is 4 bit-support and a direct 2-wire digital connection. 
		You could address these modules with i2c too, see the examples on the pigpio site, or use bit banging.
		Also not included is a special handling for different display sizes, big fonts (rarely supported anyway) and one row-support (the same)
		
		
		Usage:
		
		Const kRSPin = 25 <- the signal pin
		Const kEPin = 24 <- enable pin
		Const kD4Pin = 23 <- data pins 0-3
		Const kD5Pin = 17
		Const kD6Pin = 21
		Const kD7Pin = 22
		
		Display = New pigpio.LCDDisplay_HD44780(kRSPin, kEPin, kD4Pin, kD5Pin, kD6Pin, kD7Pin, opt. displayrows, opt. charactersinRow)
		
		And then simply use the Properties and Methods. Their descriptions should give a clue how to.
	#tag EndNote


	#tag ComputedProperty, Flags = &h0, Description = 57686574686572206175746F7363726F6C6C696E6720697320656E61626C65642E
		#tag Getter
			Get
			  return Shift
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim mask as uint32= if ( value, 1, 0) // preserve Cursor Design
			  if Entrymode = LCDDisplay_HD44780.Entrymode.LeftToRight then mask = SetBit(mask, 1)
			  mask = SetBit(mask, 2) // Action bit for Entrymode set
			  SendByte(mask)
			  shift = value
			End Set
		#tag EndSetter
		AutoScroll As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private BigCharset As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 576865746865722074686520626C696E6B696E6720637572736F7220697320646973706C617965642E
		#tag Getter
			Get
			  return CursorOn
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim mask as uint32= if ( cursor = Cursortype.Block, 1, 0) // preserve Cursor Design
			  if value then mask = SetBit(mask, 1)
			  if DisplayOn then mask = SetBit(mask,2)
			  mask = SetBit(mask, 3) // Action bit for Cursor-Display-Shift
			  SendByte(mask)
			  CursorOn = value
			End Set
		#tag EndSetter
		Blink As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		CharactersPerRow As Integer = 16
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206B696E64206F6620637572736F7220746F20646973706C617920696620426C696E6B20697320547275652E
		#tag Getter
			Get
			  return mCursor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim mask as uint32= if ( value = Cursortype.Block, 1, 0) // preserve Cursor Design
			  if CursorOn then mask = SetBit(mask, 1)
			  if DisplayOn then mask = SetBit(mask,2)
			  mask = SetBit(mask, 3) // Action bit for Cursor-Display-Shift
			  SendByte(mask)
			  mCursor = value
			End Set
		#tag EndSetter
		Cursor As Cursortype
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private CursorOn As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mD4Pin
			End Get
		#tag EndGetter
		D4Pin As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mD5Pin
			End Get
		#tag EndGetter
		D5Pin As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mD6Pin
			End Get
		#tag EndGetter
		D6Pin As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mD7Pin
			End Get
		#tag EndGetter
		D7Pin As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private datapinsbitmask As uint32
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 53776974636865732074686520646973706C6179206F66207465787420636F6E74656E74206F6E20616E64206F66662E
		#tag Getter
			Get
			  return DisplayOn
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim mask as uint32= if ( cursor = Cursortype.Block, 1, 0) // preserve Cursor Design
			  if CursorOn then mask = SetBit(mask, 1)
			  if value then mask = SetBit(mask,2)
			  mask = SetBit(mask, 3) // Action bit for Cursor-Display-Shift
			  SendByte(mask)
			  DisplayOn = value
			End Set
		#tag EndSetter
		Display As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private DisplayOn As Boolean = true
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mEnablePin
			End Get
		#tag EndGetter
		EnablePin As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 53776974636865732074686520646973706C6179206F66207465787420636F6E74656E74206F6E20616E64206F66662E
		#tag Getter
			Get
			  return mEntryMode
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim mask as uint32= if ( shift, 1, 0) // preserve shift
			  if value = LCDDisplay_HD44780.Entrymode.LeftToRight then mask =SetBit(mask,2)
			  mask = SetBit(mask, 2) // Action bit for Entry mode set
			  SendByte(mask)
			  mEntrymode = value
			End Set
		#tag EndSetter
		Entrymode As EntryMode
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private i2cHandle As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCursor As Cursortype = cursortype.block
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mD4Pin As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mD5Pin As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mD6Pin As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mD7Pin As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEnablePin As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEntryMode As EntryMode = entrymode.LeftToRight
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRSPin As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Rows As Integer = 4
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mRSPin
			End Get
		#tag EndGetter
		RSPin As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Shift As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TwoRows As Boolean = true
	#tag EndProperty


	#tag Constant, Name = kBlinkOff, Type = Double, Dynamic = False, Default = \"0", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kBlinkOn, Type = Double, Dynamic = False, Default = \"1", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kCharWidth, Type = Double, Dynamic = False, Default = \"20", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kClearDisplay, Type = Double, Dynamic = False, Default = \"1", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kCursorOff, Type = Double, Dynamic = False, Default = \"0", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kCursorOn, Type = Double, Dynamic = False, Default = \"&h02", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kCursorShift, Type = Double, Dynamic = False, Default = \"&h10", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kDisplayControl, Type = Double, Dynamic = False, Default = \"&h08", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kDisplayMove, Type = Double, Dynamic = False, Default = \"&h08", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kDisplayOff, Type = Double, Dynamic = False, Default = \"0", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kDisplayOn, Type = Double, Dynamic = False, Default = \"&h04", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kEntryLeft, Type = Double, Dynamic = False, Default = \"2", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kEntryModeSet, Type = Double, Dynamic = False, Default = \"4", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kEntryShiftDecrement, Type = Double, Dynamic = False, Default = \"0", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kEntryShiftIncrement, Type = Double, Dynamic = False, Default = \"1", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kLine1, Type = Double, Dynamic = False, Default = \"&h80", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kLine2, Type = Double, Dynamic = False, Default = \"&hC0", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kLine3, Type = Double, Dynamic = False, Default = \"&h94", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kLine4, Type = Double, Dynamic = False, Default = \"&hD4", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kMoveLeft, Type = Double, Dynamic = False, Default = \"&h00", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kMoveRight, Type = Double, Dynamic = False, Default = \"&h04", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant

	#tag Constant, Name = kReturnHome, Type = Double, Dynamic = False, Default = \"2", Scope = Protected, Attributes = \"hidden"
	#tag EndConstant


	#tag Enum, Name = Cursortype, Type = Integer, Flags = &h0
		Block
		Underline
	#tag EndEnum

	#tag Enum, Name = EntryMode, Type = Integer, Flags = &h0
		LeftToRight
		RightToLeft
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="AutoScroll"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Blink"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CharactersPerRow"
			Group="Behavior"
			InitialValue="16"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Cursor"
			Group="Behavior"
			Type="Cursortype"
			EditorType="Enum"
			#tag EnumValues
				"0 - Block"
				"1 - Underline"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="D4Pin"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="D5Pin"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="D6Pin"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="D7Pin"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Display"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EnablePin"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Entrymode"
			Group="Behavior"
			Type="EntryMode"
			EditorType="Enum"
			#tag EnumValues
				"0 - LeftToRight"
				"1 - RightToLeft"
			#tag EndEnumValues
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
			Name="Rows"
			Group="Behavior"
			InitialValue="4"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RSPin"
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
	#tag EndViewBehavior
End Class
#tag EndClass
