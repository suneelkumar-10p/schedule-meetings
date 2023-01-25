class ScheduleService
  attr_accessor :start_time, :meetings, :scheduled_meetings

  def initialize(meetings)
    @meetings = meetings
    @scheduled_meetings = []
    @start_time = 9
  end

  def schedule_meetings
    onsite_meetings = meetings.select { |meeting| meeting[:type] == :onsite }
    offsite_meetings = meetings.select { |meeting| meeting[:type] == :offsite }
    onsite_meetings.each do |meeting| # schedule onsite meetings
      scheduled_meetings.push({ start_time: start_time, end_time: start_time + meeting[:duration],
                                name: meeting[:name] })
      self.start_time += meeting[:duration]
    end

    self.start_time += 0.5 # add half an hour interval to travel

    offsite_meetings.each do |meeting| # schedule offsite meetings
      scheduled_meetings.push({ start_time: start_time, end_time: start_time + meeting[:duration],
                                name: meeting[:name] })
      self.start_time += meeting[:duration]
    end
    scheduled_meetings
  end
end
