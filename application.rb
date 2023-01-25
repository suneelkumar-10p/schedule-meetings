require_relative 'services/schedule_service'

meetings = [
  { name: 'Meeting 1', duration: 4, type: :offsite },
  { name: 'Meeting 2', duration: 4, type: :offsite }
]

schedule = ScheduleService.new(meetings)
schedule.schedule_meetings
schedule.display_scheduled_meetings
