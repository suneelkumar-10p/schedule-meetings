require 'rspec'
require_relative '../services/schedule_service'

describe 'ScheduleService' do
  let(:schedule) { ScheduleService.new(meetings) }
  describe '#schedule_meetings' do
    context 'when meeting can fit' do
      context 'given combination 1' do
        let(:meetings) do
          [
            { name: 'Meeting 1', duration: 3, type: :onsite },
            { name: 'Meeting 2', duration: 2, type: :offsite },
            { name: 'Meeting 3', duration: 1, type: :offsite },
            { name: 'Meeting 4', duration: 0.5, type: :onsite }
          ]
        end
        it 'schedules meetings' do
          scheduled_meetings = schedule.schedule_meetings
          expect(scheduled_meetings.count).to eq(4)
          expect(scheduled_meetings[0]).to eq({ name: 'Meeting 1', start_time: '9:00', end_time: '12:00' })
          expect(scheduled_meetings[1]).to eq({ name: 'Meeting 4', start_time: '12:00', end_time: '12:30' })
          expect(scheduled_meetings[2]).to eq({ name: 'Meeting 2', start_time: '1:00', end_time: '3:00' })
          expect(scheduled_meetings[3]).to eq({ name: 'Meeting 3', start_time: '3:30', end_time: '4:30' })
        end
      end

      context 'given combination 2' do
        let(:meetings) do
          [
            { name: 'Meeting 1', duration: 1.5, type: :onsite },
            { name: 'Meeting 2', duration: 2, type: :offsite },
            { name: 'Meeting 3', duration: 1, type: :onsite },
            { name: 'Meeting 4', duration: 1, type: :offsite },
            { name: 'Meeting 5', duration: 1, type: :offsite }
          ]
        end
        it 'schedules meetings' do
          scheduled_meetings = schedule.schedule_meetings
          expect(scheduled_meetings.count).to eq(5)
          expect(scheduled_meetings[0]).to eq({ name: 'Meeting 1', start_time: '9:00', end_time: '10:30' })
          expect(scheduled_meetings[1]).to eq({ name: 'Meeting 3', start_time: '10:30', end_time: '11:30' })
          expect(scheduled_meetings[2]).to eq({ name: 'Meeting 2', start_time: '12:00', end_time: '2:00' })
          expect(scheduled_meetings[3]).to eq({ name: 'Meeting 4', start_time: '2:30', end_time: '3:30' })
          expect(scheduled_meetings[4]).to eq({ name: 'Meeting 5', start_time: '4:00', end_time: '5:00' })
        end
      end
    end

    context 'when meeting can\'t fit' do
      let(:meetings) do
        [
          { name: 'Meeting 1', duration: 4, type: :offsite },
          { name: 'Meeting 2', duration: 4, type: :offsite }
        ]
      end

      it 'do not schedule meetings' do
        scheduled_meetings = schedule.schedule_meetings
        expect(scheduled_meetings).to be_nil
      end
    end

    context 'when invalid meetings provided' do
      context 'when type is missing' do
        let(:meetings) do
          [
            { name: 'Meeting 1', duration: 4 }
          ]
        end

        it 'invalid meetings exception is raised' do
          expect { schedule.schedule_meetings }.to raise_error 'Invalid meetings'
        end
      end

      context 'when duration is missing' do
        let(:meetings) do
          [
            { name: 'Meeting 1', type: :onsite }
          ]
        end

        it 'invalid meetings exception is raised' do
          expect { schedule.schedule_meetings }.to raise_error 'Invalid meetings'
        end
      end
    end
  end
end
