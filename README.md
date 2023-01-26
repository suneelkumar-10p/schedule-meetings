# schedule-meetings
## Explanation of Algorithm
To resolve this challenge, I have divided code into tree parts: service, spec, and errors. The entry point of the application is ```application.rb``` file, where you can define the meetings which you want to schedule. The scheduling of meetings is handled by the ScheduleService class in the ```services/schedule_service.rb``` file. This class uses several attribute accessors to schedule the meetings.

In service ```services/schedule_service.rb``` ```meetings``` is variable that is assigned with meetings which user want to schedule, in ```scheduled_meeting``` there will be scheduled meetings with start time and end time with name. ```start_time & end_time``` will keep track of start time and end time of each meeting to be scheduled, once meeting is schduled, start time and end time will updated with new time depending on last meeting start time and end time.

Function ```schedule_meetings``` will check for validity of meetings, if provided meetings are invalide(duration & type are missing or empty) then It will raise an exception, here I am using custom exception, and class for this custom exception is ```InvalidMeetings``` in file ```errors/invalid_meetings```. If provided meetings are valid then for scheduling onsite meetings I have wrote method ```schedule_onsite_meeting``` and for offsite ```schedule_offsite_meeting``` because scheduling for both types is little different, in offsite we need to add 30 mins break to travel to home.

Last thing is how to decide if meetings are getting fit into the day or not. For that if ```end_time``` is going over 17 that means its going over 5, in 24 hours time format 17 is 5 pm. Return ```nil``` if meetings can't get scheduled in day.

## How to run the program
- Go into the projects directory and run ```ruby application.rb```
- For running specs go into the projects directory and run ```rspec spec/schedule_service_spec.rb```
