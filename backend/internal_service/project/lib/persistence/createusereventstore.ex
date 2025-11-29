# defmodule Persistence.Createusereventstore do
#   alias Project.Eventstore
#   alias EventStore.EventData

#   def append_events(event) do
#     stream_uuid = event.localuserid
#     expected_version = 0

#     events = [
#       %EventData{
#         event_type: "Elixir.Createuserevent",
#         data: event,
#       }
#     ]

#     :ok = Eventstore.append_to_stream(stream_uuid,expected_version,events)
#   end
# end
