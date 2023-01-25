class ScheduleService
  attr_accessor :start_time, :meetings, :scheduled_meetings, :end_time

  def initialize(meetings)
    @meetings = meetings
    @scheduled_meetings = []
    @start_time = 9
    @end_time = 9
  end

  def schedule_meetings
    onsite_meetings = meetings.select { |meeting| meeting[:type] == :onsite }
    offsite_meetings = meetings.select { |meeting| meeting[:type] == :offsite }

    schedule_onsite_meetings(onsite_meetings)
    schedule_offsite_meetings(offsite_meetings)

    fit_into_schedule ? scheduled_meetings : nil
  end

  def display_scheduled_meetings
    if fit_into_schedule
      puts 'Yes, can fit. One possible solution would be:'
      scheduled_meetings.each do |meeting|
        start_time = convert_time(meeting[:start_time])
        end_time = convert_time(meeting[:end_time])
        puts "#{start_time} - #{end_time} - #{meeting[:name]}"
      end
    else
      puts 'No, can\'t fit.'
    end
  end

  private

  def schedule_onsite_meetings(onsite_meetings)
    onsite_meetings.each do |meeting| # schedule onsite meetings
      self.end_time = start_time + meeting[:duration]
      scheduled_meetings.push({ start_time: start_time, end_time: end_time,
                                name: meeting[:name] })
      self.start_time += meeting[:duration]
    end
  end

  def schedule_offsite_meetings(offsite_meetings)
    offsite_meetings.each do |meeting| # schedule offsite meetings
      self.start_time += 0.5
      self.end_time = start_time + meeting[:duration]
      scheduled_meetings.push({ start_time: start_time, end_time: end_time,
                                name: meeting[:name] })
      self.start_time += meeting[:duration]
    end
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
