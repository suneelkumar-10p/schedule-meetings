require 'byebug'
require_relative '../errors/invalid_meetings'
class ScheduleService
  attr_accessor :start_time, :meetings, :scheduled_meetings, :end_time

  def initialize(meetings)
    @meetings = meetings
    @scheduled_meetings = []
    @start_time = 9
    @end_time = 9
  end

  def schedule_meetings
    raise InvalidMeetings, 'Invalid meetings' if meetings.map { |meeting| true if valid_meeting(meeting) }.include?(nil)

    onsite_meetings, offsite_meetings = meetings.partition { |meeting| meeting[:type] == :onsite }
    (onsite_meetings + offsite_meetings).each do |meeting|
      case meeting[:type]
      when :onsite
        schedule_onsite_meeting(meeting)
      when :offsite
        schedule_offsite_meeting(meeting)
      end
    end

    fit_into_schedule ? scheduled_meetings : nil
  end

  def display_scheduled_meetings
    if fit_into_schedule
      puts 'Yes, can fit. One possible solution would be:'
      scheduled_meetings.each do |meeting|
        puts "#{meeting[:start_time]} - #{meeting[:end_time]} - #{meeting[:name]}"
      end
    else
      puts 'No, can\'t fit.'
    end
  end

  private

  def valid_meeting(meeting)
    meeting[:duration] && meeting[:duration] != '' && meeting[:type] && meeting[:type] != ''
  end

  def schedule_onsite_meeting(meeting)
    self.end_time = start_time + meeting[:duration]
    scheduled_meetings.push({ start_time: convert_time(start_time), end_time: convert_time(end_time),
                              name: meeting[:name] })
    self.start_time += meeting[:duration]
  end

  def schedule_offsite_meeting(meeting)
    self.start_time += 0.5
    self.end_time = start_time + meeting[:duration]
    scheduled_meetings.push({ start_time: convert_time(start_time), end_time: convert_time(end_time),
                              name: meeting[:name] })
    self.start_time += meeting[:duration]
  end

  def fit_into_schedule
    end_time <= 17
  end

  def convert_time(time)
    hour, minute = time.to_f.divmod(1)
    minute = (minute * 60).round
    hour -= 12 if hour > 12
    "#{hour}:#{format '%02d', minute}"
  end
end
