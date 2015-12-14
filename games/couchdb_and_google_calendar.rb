# setup couch
require 'couchrest'

db = CouchRest.database!("http://127.0.0.1:5984/turing-portal-test")

# google.calendars
#   calendar_id
#   refresh token
#     # https://developers.google.com/accounts/docs/OAuth2

# google.attendees
#   id
#   email
#   display_name

# google.event
#   id
#   title (summary in the json)
#   calendar_id
#   location
#   html_link
#   google_event_id ('ojair...')
#   start_time (event.start_time # => 2015-02-13T07:00:00Z)
#   end_time

save_event = lambda do |event|
  # this "update or create" totally doesn't work,
  # and I'm getting duplicate events :/
  begin
    doc = db.get event.id
  rescue RestClient::ResourceNotFound
    doc = CouchRest::Document.new
  end

  # if it dne, create a new doc
  doc.id                   = event.id           # couch id == google calendar id
  doc[:type]               = 'google.events'
  doc[:start_time]         = event.start_time   # eg "2015-02-13T07:00:00Z"
  doc[:end_time]           = event.end_time     # eg "2015-02-18T07:00:00Z"
  doc[:google_event_id]    = event.id           # eg "abc123"
  doc[:title]              = event.title        # eg "Welcome & Staff Intros"
  doc[:location]           = event.location
  doc[:calendar_html_link] = event.html_link    # eg "https://www.google.com...
  doc[:calendar_id]        = '??'               # going to need to get this ...

  # this is probably wrong, b/c its directly saving
  # google calendar json in our db as if its our document
  doc[:attendees] = event.attendees    # => [{"email"=>"team@turing.io",
                                       #      "displayName"=>"Turing Team",
                                       #      "responseStatus"=>"needsAction"
                                       #    }]
  db.save_doc(doc)
  doc
end

# setup google calendar
require 'google_calendar'

# to get these env vars, source set_env.fish
# redirect_url is what Google uses for 'applications'
cal = Google::Calendar.new :client_id     => ENV['GOOGLE_CLIENT_ID'],
                           :client_secret => ENV['GOOGLE_CLIENT_SECRET'],
                           :calendar      => ENV['GOOGLE_CALENDAR_ID'],
                           :redirect_url  => "http://localhost:3000"

cal.login_with_refresh_token(ENV['GOOGLE_REFRESH_TOKEN'])
calendar_events = cal.find_events_in_range(
  Date.today.to_time,
  (Date.today + 7).to_time
)

calendar_events.each do |calendar_event|
  couch_event = save_event.call calendar_event
  p couch_event
end

require 'pry'
binding.pry
