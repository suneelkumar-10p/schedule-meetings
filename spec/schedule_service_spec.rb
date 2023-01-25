require 'rspec'
require_relative '../services/schedule_service'

describe 'ScheduleService' do
  describe '#schedule_meetings' do
    context 'when meeting can fit' do
      let(:meetings) do
        [
          { name: 'Meeting 1', duration: 3, type: :onsite },
          { name: 'Meeting 2', duration: 2, type: :offsite },
          { name: 'Meeting 3', duration: 1, type: :offsite },
          { name: 'Meeting 4', duration: 0.5, type: :onsite }
        ]
      end
      let(:schedule) { ScheduleService.new(meetings) }
      it 'schedules meetings' do
        scheduled_meetings = schedule.schedule_meetings
        expect(scheduled_meetings.count).to eq(4)
        expect(scheduled_meetings[0][:name]).to eq('Meeting 1')
        expect(scheduled_meetings[1][:name]).to eq('Meeting 4')
        expect(scheduled_meetings[2][:name]).to eq('Meeting 2')
        expect(scheduled_meetings[3][:name]).to eq('Meeting 3')
      end
    end

    context 'when meeting can\'t fit' do
      let(:meetings) do
        [
          { name: 'Meeting 1', duration: 4, type: :offsite },
          { name: 'Meeting 2', duration: 4, type: :offsite }
        ]
      end

      let(:schedule) { ScheduleService.new(meetings) }

      it 'schedules meetings' do
        scheduled_meetings = schedule.schedule_meetings
        expect(scheduled_meetings).to be_nil
      end
    end
  end
end
