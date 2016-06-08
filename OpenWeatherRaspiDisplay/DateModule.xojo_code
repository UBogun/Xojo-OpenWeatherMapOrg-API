#tag Module
Protected Module DateModule
	#tag Method, Flags = &h0
		Function GermanAbbrvWeekDay(extends d as date) As string
		  select case d.DayOfWeek
		  case 1
		    Return "SO"
		  case 2
		    Return "MO"
		  case 3
		    return "DI"
		  case 4
		    return "MI"
		  case 5
		    return "DO"
		  case 6
		    return "FR"
		  case 7
		    Return "SA"
		  end select
		End Function
	#tag EndMethod


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
End Module
#tag EndModule
