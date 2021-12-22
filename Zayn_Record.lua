local ESX = nil

Citizen.CreateThread(function()

	while ESX == nil do

		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

		Citizen.Wait(0)
	end

end)

function RecordingMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recording_menu',

	{

		title		= '🔴Recoding Menu',

		align		= 'right',

		elements	= {

			{value = "start_recording", label = "🎥Ξεκίνα την εγγραφή"},

			{value = "stop_recording", label = "🎬Σταμάτα την εγγραφή"},

			{value = "editor", label = "📝Άνοιξε το Rockstar Editor"},

		}

	}, function(data, menu2)

		if data.current.value == "start_recording" then

			if IsRecording() then

				ESX.ShowNotification("~rAlready Using Recording")
			else
				StartRecording(1)

				ESX.ShowNotification("Recording has started. You can stop it whenever you want")
			end

		elseif data.current.value == "stop_recording" then

			if not IsRecording() then

				ESX.ShowNotification("Recording has started. You can stop it whenever you want")
			else
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recording_menu_stop',

				{

					title		= '🔴Choose what to do with your clip!',

					align		= 'right',

					elements	= {

						{value = "save_clip", label = "💾Σταμάτα κι αποθήκευσε το clip"},

						{value = "discard_clip", label = "❌Σταμάτα και διέγραψε το clip"},

					}

				}, function(data, menu)

					menu.close()

					if data.current.value == "save_clip" then

						if not IsRecording() then

							ESX.ShowNotification("~r~You are not recording")
						else
							StopRecordingAndSaveClip()

							ESX.ShowNotification("~g~Your Recording has stopped and the clip just got saved")
						end

					elseif data.current.value == "discard_clip" then
						
						if not IsRecording() then

							ESX.ShowNotification("~r~You are not recording")

						else

							StopRecordingAndDiscardClip()

							ESX.ShowNotification("~g~The recording has stopped and the clip just got deleted")
						end

					end

				end,function(data,menu)

					menu.close()
				end)

			end

		elseif data.current.value == "editor" then

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'open_rockstar_editor',

				{

					title		= 'Ανοίγοντας το Rockstar Editor, θα αποσυνδεθείτε από τον διακοσμιτή. Είστε σίγουρος/η;',

					align		= 'right',

					elements	= {

						{value = "yes", label = "Ναι"},

						{value = "no", label = "Όχι"},

					}

				}, function(data, menu)

					menu.close()

					if data.current.value == "yes" then

						NetworkSessionEnd(true,true)

						ActivateRockstarEditor()
					end

				end,function(data,menu)

					menu.close()
				end)

		end
	end,function(data,menu2)

		menu2.close()
	end)

end

--------------------
--Command Creation--
--------------------

RegisterCommand("record", function()

	RecordingMenu()
end)

Citizen.CreateThread(function()
	
    TriggerEvent( "chat:addSuggestion","/record", "Open Recording Menu")
end)